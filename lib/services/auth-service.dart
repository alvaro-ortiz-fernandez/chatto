import 'package:chatto/models/auth-model.dart';
import 'package:chatto/screens/home-screen.dart';
import 'package:chatto/screens/login-screen.dart';
import 'package:chatto/services/users-service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;

  /// ------------------------------------------------------------
  /// Método que devuelve la pantalla inicial de la aplicación
  /// ------------------------------------------------------------
  static Widget getAuthScreen() {
    return StreamBuilder<FirebaseUser>(
      stream: _auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // Si el usuario está logado lo mandamos al home,
        // si no, a la pantalla de login
        if (snapshot.hasData) {
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

      FirebaseUser firebaseUser = authResult.user;
      if (firebaseUser == null)
        return LoginAttemp(isError: true, resultCode: 'Error');

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
      // Cerramos sesión en firebase
      await _auth.signOut();

      // Borramos del almacenamiento local al usuario
      await UsersService.deleteUserLocal();

      Navigator.pushReplacementNamed(context, LoginScreen.id);
    } catch (e,  stackTrace) {
      print('Error al cerrar sesión: ' + e);
      print(stackTrace.toString());
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
      _firestore
        .collection("/users")
        .document(firebaseUser.uid)
        .setData({
          'id': firebaseUser.uid,
          'name': name,
          'email': email,
          'imageUrl': '',
          'contacts': List<String>(),
          'requests': List<String>(),
          'blocks': List<String>()
        });

      // Usuario creado correctamente, devolvemos respuesta
      return RegisterAttemp(isError: false);
    } on PlatformException catch (e) {
      return RegisterAttemp(isError: true, resultCode: e.code);
    } catch(e) {
      // Error de firestore al guardar al usuario
      return RegisterAttemp(isError: true, resultCode: e.toString());
    }
  }

  static Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser();
  }
}