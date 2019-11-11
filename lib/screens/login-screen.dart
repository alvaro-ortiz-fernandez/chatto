import 'package:chatto/models/auth-model.dart';
import 'package:chatto/screens/home-screen.dart';
import 'package:chatto/screens/signup-screen.dart';
import 'package:chatto/services/auth-service.dart';
import 'package:chatto/services/snackbar-service.dart';
import 'package:chatto/widgets/auth/password-input.dart';
import 'package:chatto/widgets/ui/loadable.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {

  static final String id = 'login_screen';

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Loadable {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String _name, _password;

  @override
  String getLoadingTitle() {
    return 'Autenticando';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: getSreenBody()
    );
  }

  @override
  Widget getWidgetBody() {
    return Column(
      children: <Widget>[
        Container(
          height: 180.0,
          decoration: new BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xff454dff),
                Colors.deepPurpleAccent[200]
              ],
            ),
            boxShadow: [
              new BoxShadow(
                blurRadius: 5.0
              )
            ],
            borderRadius: new BorderRadius.vertical(
              bottom: new Radius.elliptical(
                MediaQuery.of(context).size.width, 150.0
              )
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 50.0,
                      right: 30.0,
                      bottom: 30.0,
                      left: 30.0
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Chatto!',
                          style: TextStyle(
                            fontSize: 60.0,
                            fontFamily: 'GilroyBold'
                          )
                        ),
                        Text(
                          'Inicia sesión en tu cuenta',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'GilroyRegular',
                            color: Colors.grey[600]
                          )
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 50.0,
                            right: 20.0,
                            left: 20.0
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 12,
                                        offset: Offset(0.0, 4.0)
                                      )
                                    ]
                                  ),
                                  child: TextFormField(
                                    onSaved: (input) => _name = input,
                                    decoration: InputDecoration(
                                      hintText: 'Usuario',
                                      prefixIcon: const Icon(
                                        Icons.person,
                                        color: Color(0xFF424242)
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(top: 16.0)
                                    )
                                  )
                                ),
                                SizedBox(height: 15.0),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 12,
                                        offset: Offset(0.0, 4.0)
                                      )
                                    ]
                                  ),
                                  child: PasswordInput(
                                    onSaved: (input) => _password = input
                                  ),
                                ),
                                SizedBox(height: 40.0),
                                Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width * 0.50,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Color(0xff454dff),
                                      Colors.deepPurpleAccent[200]
                                    ]),
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 12,
                                        offset: Offset(0.0, 4.0)
                                      )
                                    ]
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      child: Center(
                                        child:MaterialButton(
                                          onPressed: () {
                                            _formKey.currentState.save();

                                            if (!validForm()) {
                                              SnackbarService.showInfoSnackbar(key: _scaffoldKey,
                                                content: 'Por favor, rellene todos los campos.');
                                            } else {
                                              startLoading();
                                              AuthService
                                                .login(_name, _password)
                                                .then((LoginAttemp attemp) {
                                                  stopLoading();
                                                  if (attemp.isError) {
                                                    SnackbarService.showErrorSnackbar(key: _scaffoldKey,
                                                      content: attemp.getErrorMessage());
                                                  } else {
                                                    Navigator.pushNamed(context, HomeScreen.id);
                                                  }
                                                });
                                            }
                                          },
                                          child: Text(
                                            'Entrar',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'GilroyBold',
                                              fontSize: 18
                                            )
                                          )
                                        )
                                      )
                                    )
                                  )
                                )
                              ]
                            )
                          )
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '¿No tienes cuenta?',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: 'GilroyRegular',
                                        color: Colors.grey[600]
                                      )
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.pushNamed(context, SignupScreen.id),
                                      child: Text(
                                        'Crea una aquí',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontFamily: 'GilroyBold',
                                          color: Theme.of(context).primaryColor
                                        )
                                      )
                                    )
                                  ]
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
            )
          )
        )
      ]
    );
  }

  bool validForm() {
    if (_name == null || _name.isEmpty
      || _password == null || _password.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}