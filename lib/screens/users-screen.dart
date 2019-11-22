import 'dart:async';

import 'package:chatto/models/auth-model.dart';
import 'package:chatto/models/event-model.dart';
import 'package:chatto/models/navigation-model.dart';
import 'package:chatto/services/snackbar-service.dart';
import 'package:chatto/services/users-service.dart';
import 'package:chatto/widgets/menu/menu-screen.dart';
import 'package:chatto/widgets/menu/navigation-view.dart';
import 'package:chatto/widgets/menu/zoom-scaffold.dart';
import 'package:chatto/widgets/ui/loadable.dart';
import 'package:chatto/widgets/users/blocks-view.dart';
import 'package:chatto/widgets/users/contacts-view.dart';
import 'package:chatto/widgets/users/requests-view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatefulWidget {
  static final String id = 'users_screen';
  final int currentIndex;

  UsersScreen({ this.currentIndex });

  @override
  UsersScreenState createState() => new UsersScreenState(this.currentIndex);

  static UsersScreenState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<UsersScreenState>());
}

class UsersScreenState extends State<UsersScreen> with TickerProviderStateMixin, Loadable {

  static UserData _currentUser = UserData.emptyUser();

  StreamSubscription contactsChangedSubscription;
  StreamSubscription requestsChangedSubscription;
  StreamSubscription blocksChangedSubscription;

  List<UserData> contacts = List<UserData>();
  List<UserData> requests = List<UserData>();
  List<UserData> blocks = List<UserData>();

  List<Navigation> usersNavigations = <Navigation>[
    Navigation(title: 'Contactos', icon: Icons.supervisor_account, view: ContactsView(currentUser: _currentUser), parent: UsersScreen(currentIndex: 0)),
    Navigation(title: 'Peticiones', icon: Icons.account_circle, view: RequestsView(), parent: UsersScreen(currentIndex: 1)),
    Navigation(title: 'Bloqueados', icon: Icons.block, view: BlocksView(), parent: UsersScreen(currentIndex: 2))
  ];

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  MenuController menuController;
  int currentIndex;
  bool loadError = false;

  UsersScreenState(this.currentIndex);

  @override
  void initState() {
    super.initState();

    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));

    contactsChangedSubscription = eventBus
      .on<ContactsChangedEvent>()
      .listen((ContactsChangedEvent event) {
        setState(() => contacts = event.currentContacts);
      });

    requestsChangedSubscription = eventBus
      .on<RequestsChangedEvent>()
      .listen((RequestsChangedEvent event) {
        setState(() => requests = event.currentRequests);
      });

    blocksChangedSubscription = eventBus
      .on<BlocksChangedEvent>()
      .listen((BlocksChangedEvent event) {
        setState(() => blocks = event.currentBlocks);
      });

    loadData();
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();

    if (contactsChangedSubscription != null)
      contactsChangedSubscription.cancel();

    if (requestsChangedSubscription != null)
      requestsChangedSubscription.cancel();

    if (blocksChangedSubscription != null)
      blocksChangedSubscription.cancel();
  }

  @override
  Future<void> loadData() async {
    startLoading();
    setState(() => loadError = false);

    try {
      UserData user = await UsersService.getUserLocal();
      setState(() => _currentUser = user);

      List<UserData> userContacts = await UsersService.getUserContacts(user);
      contacts = userContacts;

      List<UserData> userRequests = await UsersService.getUserRequests(user);
      requests = userRequests;

      List<UserData> userBlocks = await UsersService.getUserBlocks(user);
      blocks = userBlocks;

    } catch(e,  stackTrace) {
      setState(() => loadError = true);
      print('Error cargando los contactos del usuario: ' + e.toString());
      print(stackTrace.toString());
    } finally {
      stopLoading();
    }
  }

  @override
  String getLoadingTitle() {
    return 'Cargando información';
  }

  @override
  Widget getWidgetBody() {
    return SafeArea(
      top: false,
      child: IndexedStack(
        index: currentIndex,
        children: usersNavigations.map<Widget>((Navigation navigation) {
          return loadError
                  ? getLoadErrorBody()
                  : NavigationView(navigation: navigation);
        }).toList()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => menuController,
      child: ZoomScaffold(
        scaffoldKey: _scaffoldKey,
        title: usersNavigations[currentIndex].title,
        menuScreen: MenuScreen(currentUser: _currentUser),
        contentScreen: Layout(
          contentBuilder: (cc) => getSreenBody()
        ),
        floatingActionButton: !(loading || loadError) && currentIndex == 0
          ? FloatingActionButton(
          onPressed: () => mostrarDialogoNuevoContacto(),
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          )
          : null,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: usersNavigations.map((Navigation navigation) {
            return BottomNavigationBarItem(
              icon: Icon(navigation.icon),
              title: Text(navigation.title)
            );
          }).toList()
        )
      )
    );
  }

  void mostrarDialogoNuevoContacto() {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Añadir nuevo contacto',
            style: TextStyle(
              fontFamily: 'GilroyBold'
            )
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Introduce el nombre del usuario que quieres agregar.'),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Por favor, introduzca un valor';
                      }
                      return null;
                    }
                  )
                )
              ]
            )
          ),
          actions: <Widget>[
            FlatButton(
              highlightColor: Colors.blue[50],
              child: Text(
                'CANCELAR',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'GilroyBold'
                )
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }
            ),
            FlatButton(
              highlightColor: Colors.blue[50],
              child: Text(
                'AGREGAR',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'GilroyBold'
                )
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  startLoading();
                  Navigator.of(context).pop();

                  Future.delayed(Duration(seconds: 2), () => throw Exception())
                    .then((val) {
                      SnackbarService.showInfoSnackbar(
                        key: _scaffoldKey,
                        content: 'Usuario agregado correctamente.'
                      );
                    })
                    .catchError((error) {
                      SnackbarService.showErrorSnackbar(
                        key: _scaffoldKey,
                        content: 'Se ha producido un error, por favor, inténtelo de nuevo.'
                      );
                    })
                    .whenComplete(() => stopLoading());
                }
              }
            )
          ]
        );
      }
    );
  }

  Future<void> eliminarContacto(UserData contacto) async {
    startLoading();
    UsersService.deleteContact(_currentUser.id, contacto.id)
      .then((val) {
        SnackbarService.showInfoSnackbar(
          key: _scaffoldKey,
          content: 'Usuario eliminado correctamente.'
        );
      })
      .catchError((error) {
        SnackbarService.showErrorSnackbar(
          key: _scaffoldKey,
          content: 'Se ha producido un error, por favor, inténtelo de nuevo.'
        );
      })
      .whenComplete(() => stopLoading());
  }

  Future<void> aceptarPeticion(UserData contacto) async {
    startLoading();
    UsersService.acceptRequest(_currentUser.id, contacto.id)
      .then((val) {
        SnackbarService.showInfoSnackbar(
          key: _scaffoldKey,
          content: 'Petición aceptada correctamente.'
        );
      })
      .catchError((error) {
        SnackbarService.showErrorSnackbar(
          key: _scaffoldKey,
          content: 'Se ha producido un error, por favor, inténtelo de nuevo.'
        );
      })
      .whenComplete(() => stopLoading());
  }

  Future<void> rechazarPeticion(UserData contacto) async {
    startLoading();
    UsersService.denyRequest(_currentUser.id, contacto.id)
      .then((val) {
        SnackbarService.showInfoSnackbar(
          key: _scaffoldKey,
          content: 'Petición rechazada correctamente.'
        );
      })
      .catchError((error) {
        SnackbarService.showErrorSnackbar(
          key: _scaffoldKey,
          content: 'Se ha producido un error, por favor, inténtelo de nuevo.'
        );
      })
      .whenComplete(() => stopLoading());
  }

  Future<void> bloquearContacto(UserData contacto) async {
    startLoading();
    UsersService.blockUser(_currentUser.id, contacto.id)
      .then((val) {
        SnackbarService.showInfoSnackbar(
          key: _scaffoldKey,
          content: 'Usuario bloqueado correctamente.'
        );
      })
      .catchError((error) {
        SnackbarService.showErrorSnackbar(
          key: _scaffoldKey,
          content: 'Se ha producido un error, por favor, inténtelo de nuevo.'
        );
      })
      .whenComplete(() => stopLoading());
  }

  Future<void> desbloquearContacto(UserData contacto) async {
    startLoading();
    UsersService.unlockUser(_currentUser.id, contacto.id)
      .then((val) {
        SnackbarService.showInfoSnackbar(
          key: _scaffoldKey,
          content: 'Usuario desbloqueado correctamente.'
        );
      })
      .catchError((error) {
        SnackbarService.showErrorSnackbar(
          key: _scaffoldKey,
          content: 'Se ha producido un error, por favor, inténtelo de nuevo.'
        );
      })
      .whenComplete(() => stopLoading());
  }
}