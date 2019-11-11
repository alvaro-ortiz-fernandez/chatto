import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String name;
  final String email;
  final String imageUrl;

  UserData({
    this.name,
    this.email,
    this.imageUrl
  });

  factory UserData.fromDocument(DocumentSnapshot doc) {
    return UserData(
      name: doc['name'] ?? '',
      email: doc['email'] ?? '',
      imageUrl: doc['imageUrl'] ?? ''
    );
  }
}

class RegisterAttemp {
  final bool isError;
  final String resultCode;

  RegisterAttemp({
    this.isError,
    this.resultCode
  });

  String getErrorMessage() {
    switch (resultCode) {
      case 'ERROR_INVALID_EMAIL':        return 'Formato del email inválido.';
      case 'ERROR_EMAIL_ALREADY_IN_USE': return 'El email introducido ya está en uso.';
      case 'ERROR_WEAK_PASSWORD':        return 'La contraseña introducida no es segura.';
      default:                           return 'Se ha producido un error, por favor, inténtelo de nuevo.';
    }
  }
}

class LoginAttemp {
  final bool isError;
  final String resultCode;

  LoginAttemp({
    this.isError,
    this.resultCode
  });

  String getErrorMessage() {
    switch (resultCode) {
      case 'ERROR_INVALID_EMAIL':     return 'Formato del email inválido.';
      case 'ERROR_WRONG_PASSWORD':
      case 'ERROR_USER_NOT_FOUND':    return 'Usuario y/o contraseña incorrecta.';
      case 'ERROR_USER_DISABLED':     return 'El usuario se encuentra deshabilitado.';
      case 'ERROR_TOO_MANY_REQUESTS': return 'Acceso bloqueado: Ha sobrepasado el límite de intentos erróneos.';
      default:                        return 'Se ha producido un error, por favor, inténtelo de nuevo.';
    }
  }
}