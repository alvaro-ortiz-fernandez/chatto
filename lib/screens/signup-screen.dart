import 'package:chatto/screens/login-screen.dart';
import 'package:chatto/services/auth-service.dart';
import 'package:chatto/widgets/auth/password-input.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {

  static final String id = 'signup_screen';

  @override
  _SignupScreenState createState() => new _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 180.0,
            decoration: new BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.blue,
                  Colors.deepPurpleAccent[400]
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
                            'Crea una cuenta',
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
                                    child: PasswordInput(),
                                  ),
                                  SizedBox(height: 40.0),
                                  Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width * 0.50,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Color(0xFF17EAD9),
                                        Color(0xFF6078EA)
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
                                              //AuthService.signup(context, name, email, password)
                                            },
                                            child: Text(
                                              'Crear',
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
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    '¿Ya tienes una cuenta?',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'GilroyRegular',
                                      color: Colors.grey[600]
                                    )
                                  ),
                                  SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: () => Navigator.pushNamed(context, LoginScreen.id),
                                    child: Text(
                                      'Inicia sesión aquí',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: 'GilroyBold',
                                        color: Theme.of(context).primaryColor
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
              )
            )
          )
        ]
      )
    );
  }
}