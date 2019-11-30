import 'package:chatto/models/auth-model.dart';
import 'package:chatto/screens/chat-sreen.dart';
import 'package:chatto/services/dialog-service.dart';
import 'package:chatto/services/snackbar-service.dart';
import 'package:chatto/services/users-service.dart';
import 'package:chatto/widgets/profile/profile-stadistics.dart';
import 'package:chatto/widgets/ui/loadable.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final UserData currentUser;
  final UserData user;

  ProfileScreen({ this.currentUser, this.user });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with Loadable {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Future<void> loadData() async {}

  @override
  void initState() {
    super.initState();
    loading = false;
  }

  @override
  String getLoadingTitle() {
    return 'Actualizando información';
  }

  @override
  Widget getWidgetBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 200.0,
                  decoration: new BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xff454dff),
                        Colors.deepPurpleAccent[200]
                      ],
                    ),
                    borderRadius: new BorderRadius.vertical(
                      bottom: new Radius.elliptical(
                        MediaQuery.of(context).size.width, 150.0
                      )
                    )
                  )
                ),
                Container(
                  constraints: BoxConstraints.loose(Size.fromHeight(80)),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    overflow: Overflow.visible,
                    children: [
                      Positioned(
                        top: -80.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            border: Border.all(
                              color: Theme.of(context).accentColor,
                              width: 5
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(80.0)),
                          ),
                          child: CircleAvatar(
                            radius: 80.0,
                            backgroundImage: AssetImage(
                              widget.user.imageUrl != null && widget.user.imageUrl.isNotEmpty
                                ? widget.user.imageUrl
                                : UsersService.defaultAvatarPath
                            )
                          )
                        )
                      )
                    ]
                  )
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: <Widget>[
                      Text(
                        widget.user.name,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'GilroyBold',
                          color: Colors.black
                        )
                      ),
                      Text(
                        widget.user.email,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[700]
                        )
                      )
                    ]
                  )
                ),
                Row(
                  children: <Widget>[
                    ProfileStadistics(),
                  ]
                ),
                Container(
                  child: Text(
                    'Última conexión: Hace 54 minutos',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[700]
                    )
                  )
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 30),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 12,
                                spreadRadius: -5,
                                offset: Offset(0.0, 8.0),
                              )
                            ]
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                            child: MaterialButton(
                              onPressed: () {
                                if (isFriend()) {
                                  // Chatear
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChatScreen(
                                        talkingUser: widget.user
                                      )
                                    )
                                  );
                                } else if (isBloqued()) {
                                  // Desbloquear
                                  mostrarAlertaDesbloqueo(widget.user.name)
                                    .then((decision) {
                                    if (decision == true)
                                      desbloquearContacto(widget.user);
                                  });
                                } else {
                                  agregarUsuario(widget.user);
                                }
                              },
                              padding: EdgeInsets.only(
                                top: 14,
                                right: 35,
                                bottom: 14,
                                left: 25
                              ),
                              color: Theme.of(context).primaryColor,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    isFriend()
                                      ? Icons.send
                                      : isBloqued()
                                      ? Icons.report_off
                                      : Icons.add,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    isFriend()
                                      ? 'Mensaje'
                                      : isBloqued()
                                      ? 'Desbloquear'
                                      : 'Agregar',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontFamily: 'GilroyBold'
                                    )
                                  )
                                ]
                              ),
                            )
                          )
                        ),
                        SizedBox(width: (isContact() ? 20 : 0)),
                        !isContact()
                          ? Container()
                          : Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 25,
                                spreadRadius: -5,
                                offset: Offset(0.0, 15.0),
                              )
                            ]
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(40.0)),
                            child: MaterialButton(
                              onPressed: () {
                                // Eliminar
                                mostrarAlertaEliminacion(widget.user.name)
                                  .then((decision) {
                                  if (decision == true)
                                    eliminarContacto(widget.user);
                                });
                              },
                              padding: EdgeInsets.only(
                                top: 18,
                                right: 35,
                                bottom: 18,
                                left: 25
                              ),
                              color: Colors.red,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Eliminar',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontFamily: 'GilroyBold'
                                    )
                                  )
                                ]
                              ),
                            )
                          )
                        )
                      ]
                    )
                  )
                )
              ]
            )
          )
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: getSreenBody()
    );
  }

  Future<bool> mostrarAlertaDesbloqueo(String userName) async {
    return DialogService.showDefaultDialog(
      context: context,
      title: 'Desbloquear usuario',
      description: '¿Desea desbloquear a $userName?',
      action: 'Desbloquear'
    );
  }

  Future<bool> mostrarAlertaEliminacion(String userName) async {
    return DialogService.showDangerDialog(
      context: context,
      title: 'Eliminar contacto',
      description: '¿Desea eliminar a $userName?',
      action: 'ELIMINAR'
    );
  }

  Future<void> agregarUsuario(UserData contacto) async {
    startLoading();
    UsersService.sendRequest(widget.currentUser.id, contacto.id)
      .then((val) {
        SnackbarService.showInfoSnackbar(
          key: _scaffoldKey,
          content: 'Petición de amistad enviada correctamente.'
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

  Future<void> eliminarContacto(UserData contacto) async {
    startLoading();
    UsersService.deleteContact(widget.currentUser.id, contacto.id)
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

  Future<void> desbloquearContacto(UserData contacto) async {
    startLoading();
    UsersService.unlockUser(widget.currentUser.id, contacto.id)
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

  bool isContact() {
    return isFriend() || isBloqued();
  }

  bool isFriend() {
    return widget != null && widget.user != null
      && widget.currentUser != null
      && widget.currentUser.contacts != null
      && widget.currentUser.contacts.contains(widget.user.id);
  }

  bool isBloqued() {
    return widget != null && widget.user != null
      && widget.currentUser != null
      && widget.currentUser.contacts != null
      && widget.currentUser.contacts.contains(widget.user.id);
  }
}