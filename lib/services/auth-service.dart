import 'package:chatto/models/auth-model.dart';
import 'package:chatto/screens/home-screen.dart';
import 'package:chatto/screens/login-screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;

  /// Método que devuelve la pantalla inicial de la aplicación
  static Widget getAuthScreen() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        // Si el usuario está logado lo mandamos al home,
        // si no, a la pantalla de login
        if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      }
    );
  }

  /// Método que da de alta un usuario
  static Future<RegisterAttemp> signup(BuildContext context, String name, String email, String password) async {
    AuthResult authResult;
    try {
      // Creamos una cuenta en FireBase
      authResult = await _auth
        .createUserWithEmailAndPassword(
          email: email,
          password: password
        );
    } catch(e) {
      // Error de firebase al registrar al usuario
      return RegisterAttemp(isError: true, resultCode: e.toString());
    }

    FirebaseUser user = authResult.user;
    if (user == null)
      return RegisterAttemp(isError: true, resultCode: 'Error');

    try {
      // A continuación, guardamos el usuario en BBDD. En firebase no es obligatorio para autenticarse,
      // pero de este modo podemos guardar información relacionada a su cuenta (contactos, foto, etc)
      _firestore
        .collection("/users")
        .document(user.uid)
        .setData({
          'name': name,
          'email': email,
          'imageUrl': null
        });

      // Usuario creado correctamente, devolvemos respuesta
      return RegisterAttemp(isError: false);
    } catch(e) {
      // Error de firestore al guardar al usuario
      return RegisterAttemp(isError: true, resultCode: e.toString());
    }
  }
}