import 'package:chatto/models/auth-model.dart';
import 'package:chatto/models/navigation-model.dart';
import 'package:chatto/services/users-service.dart';
import 'package:chatto/widgets/home/chats-view.dart';
import 'package:chatto/widgets/home/groups-view.dart';
import 'package:chatto/widgets/menu/menu-screen.dart';
import 'package:chatto/widgets/menu/navigation-view.dart';
import 'package:chatto/widgets/menu/zoom-scaffold.dart';
import 'package:chatto/widgets/ui/loadable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static final String id = 'home_screen';
  final int currentIndex;

  HomeScreen({ this.currentIndex });

  @override
  _HomeScreenState createState() => new _HomeScreenState(this.currentIndex);
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin, Loadable {

  static UserData _currentUser = UserData.emptyUser();
  final List<Navigation> homeNavigations = <Navigation>[
    Navigation(title: 'Chats', icon: Icons.chat_bubble, view: ChatsView(currentUser: _currentUser), parent: HomeScreen(currentIndex: 0)),
    Navigation(title: 'Grupos', icon: Icons.supervisor_account, view: GroupsView(currentUser: _currentUser), parent: HomeScreen(currentIndex: 1))
  ];

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  MenuController menuController;
  int currentIndex;
  bool loadError = false;

  _HomeScreenState(this.currentIndex);

  _loadUser() {
    startLoading();
    setState(() => loadError = false);

    UsersService.getUserLocal()
      .then((user) => setState(() => _currentUser = user))
      .catchError((error) => setState(() => loadError = true))
      .whenComplete(() => stopLoading());
  }

  @override
  void initState() {
    super.initState();

    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));

    _loadUser();
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
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
        children: homeNavigations.map<Widget>((Navigation navigation) {
          return loading
                  ? Container()
                  : loadError
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
        title: homeNavigations[currentIndex].title,
        menuScreen: MenuScreen(currentUser: _currentUser),
        contentScreen: Layout(
          contentBuilder: (cc) => getSreenBody()
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: homeNavigations.map((Navigation navigation) {
            return BottomNavigationBarItem(
              icon: Icon(navigation.icon),
              title: Text(navigation.title)
            );
          }).toList()
        )
      )
    );
  }

  Widget getLoadErrorBody() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('assets/images/error/error-exclamation.png'),
              height: 150,
              width: 150
            ),
            SizedBox(height: 30),
            Text(
              'Se ha producido un error',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'GilroyBold',
              )
            ),
            SizedBox(height: 15),
            Text(
              'Se produjo un error al cargar la información, por favor, pulse el botón para volver a intentarlo.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16
              )
            ),
            SizedBox(height: 30),
            MaterialButton(
              onPressed: () => _loadUser(),
              padding: EdgeInsets.only(
                top: 10,
                right: 18,
                bottom: 10,
                left: 12
              ),
              color: Theme.of(context).primaryColor,
              elevation: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Reintentar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'GilroyBold'
                    )
                  )
                ]
              ),
            )
          ]
        )
      )
    );
  }
}