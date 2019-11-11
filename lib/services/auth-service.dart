import 'package:chatto/models/auth-model.dart';
import 'package:chatto/screens/home-screen.dart';
import 'package:chatto/screens/login-screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;
  static UserData loggedUser;

  /// ------------------------------------------------------------
  /// Método que devuelve la pantalla inicial de la aplicación
  /// ------------------------------------------------------------
  static Widget getAuthScreen() {
    return StreamBuilder<FirebaseUser>(
      stream: _auth.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        // Si el usuario está logado lo mandamos al home,
        // si no, a la pantalla de login
        if (snapshot.hasData) {
          loggedUser = null;
          return HomeScreen(currentIndex: 0);
        } else {
          return LoginScreen();
        }
      }
    );
  }

  /// ------------------------------------------------------------
  /// Método que autentica al usuario en la aplicación
  /// ------------------------------------------------------------
  static Future<LoginAttemp> login(String email, String password) async {
    try {
      // Mandamos la petición de login a FireBase
      AuthResult authResult = await _auth
        .signInWithEmailAndPassword(
          email: email,
          password: password
        );

      FirebaseUser user = authResult.user;
      if (user == null)
        return LoginAttemp(isError: true, resultCode: 'Error');

      // A continuación, obtenemos la información del usuario en BBDD
      DocumentSnapshot userDoc = await _firestore
        .collection('/users')
        .document(user.uid)
        .get();

      // Lo mapeamos a nuestra clase y lo guardamos en la variable en memoria
      loggedUser = UserData.fromDocument(userDoc);

      // Usuario obtenido correctamente, devolvemos respuesta
      return LoginAttemp(isError: false);
    } catch(e) {
      // Error de firestore al obtener el usuario
      return LoginAttemp(isError: true, resultCode: e.toString());
    }
  }

  /// ------------------------------------------------------------
  /// Método que cierra la sesión activa y fuerza la redirección a la pantalla de login
  /// ------------------------------------------------------------
  static void logout(BuildContext context) async {
    try {
      await _auth.signOut();
      loggedUser = null;
      Navigator.pushReplacementNamed(context, LoginScreen.id);
    } catch (e) {
      print('Error al cerrar sesión: ' + e);
    }
  }

  /// ------------------------------------------------------------
  /// Método que da de alta un usuario
  /// ------------------------------------------------------------
  static Future<RegisterAttemp> signup(String name, String email, String password) async {
    try {
      // Creamos una cuenta en FireBase
      AuthResult authResult = await _auth
        .createUserWithEmailAndPassword(
          email: email,
          password: password
        );

      FirebaseUser firebaseUser = authResult.user;
      if (firebaseUser == null)
        return RegisterAttemp(isError: true, resultCode: 'Error');

      // A continuación, guardamos el usuario en BBDD. En firebase no es obligatorio para autenticarse,
      // pero de este modo podemos guardar información relacionada a su cuenta (contactos, foto, etc)
      UserData userData = UserData(
        name: name,
        email: email
      );

      _firestore
        .collection("/users")
        .document(firebaseUser.uid)
        .setData({
          'name': userData.name,
          'email': userData.email,
          'imageUrl': userData.imageUrl
        });

      // Usuario creado correctamente, devolvemos respuesta
      loggedUser = userData;
      return RegisterAttemp(isError: false);
    } on PlatformException catch (e) {
      return RegisterAttemp(isError: true, resultCode: e.code);
    } catch(e) {
      // Error de firestore al guardar al usuario
      return RegisterAttemp(isError: true, resultCode: e.toString());
    }
  }

  static Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    return user;
  }
}