import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class UserData {
  final String id;
  final String name;
  final String email;
  final String imageUrl;
  final List<String> contacts;
  final List<String> requests;
  final List<String> blocks;

  UserData({
    this.id,
    this.name,
    this.email,
    this.imageUrl,
    this.contacts,
    this.requests,
    this.blocks
  });

  factory UserData.emptyUser() {
    return UserData(
      id: '',
      name: '',
      email: '',
      imageUrl: '',
      contacts: List<String>(),
      requests: List<String>(),
      blocks: List<String>()
    );
  }

  factory UserData.fromDocument(DocumentSnapshot doc) {
    return UserData(
      id: doc['id'] ?? '',
      name: doc['name'] ?? '',
      email: doc['email'] ?? '',
      imageUrl: doc['imageUrl'] ?? '',
      contacts: doc['contacts'] != null ? List.from(doc['contacts']) : List<String>(),
      requests: doc['requests'] != null ? List.from(doc['requests']) : List<String>(),
      blocks: doc['blocks'] != null ? List.from(doc['blocks']) : List<String>()
    );
  }

  factory UserData.fromJson(String str) {
    Map<String, dynamic> jsonData = json.decode(str);
    return UserData(
      id: jsonData["id"],
      name: jsonData["name"],
      email: jsonData["email"],
      imageUrl: jsonData["imageUrl"],
      contacts: jsonData['contacts'] != null ? List.from(jsonData['contacts']) : List<String>(),
      requests: jsonData['requests'] != null ? List.from(jsonData['requests']) : List<String>(),
      blocks: jsonData['blocks'] != null ? List.from(jsonData['blocks']) : List<String>()
    );
  }

  String toJson() {
    Map<String, dynamic> map = {
      "id": id,
      "name": name,
      "email": email,
      "imageUrl": imageUrl,
      "contacts": contacts,
      "requests": requests,
      "blocks": blocks
    };
    return json.encode(map);
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
      case 'ERROR_USUARIO_EN_USO':       return 'El nombre de usuario introducido ya está en uso.';
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

final UserData greg = UserData(
  id: '3z73tMZnBaxfc8qPG37x',
  name: 'Greg',
  email: 'test@mail.com',
  imageUrl: 'assets/images/greg.jpg',
  contacts: List<String>(),
  requests: List<String>(),
  blocks: List<String>()
);

final UserData james = UserData(
  id: '3z73tMZnBaxfc8qPG37x',
  name: 'James',
  email: 'test@mail.com',
  imageUrl: 'assets/images/james.jpg',
  contacts: List<String>(),
  requests: List<String>(),
  blocks: List<String>()
);

final UserData john = UserData(
  id: '3z73tMZnBaxfc8qPG37x',
  name: 'John',
  email: 'test@mail.com',
  imageUrl: 'assets/images/john.jpg',
  contacts: List<String>(),
  requests: List<String>(),
  blocks: List<String>()
);

final UserData olivia = UserData(
  id: '3z73tMZnBaxfc8qPG37x',
  name: 'Olivia',
  email: 'test@mail.com',
  imageUrl: 'assets/images/olivia.jpg',
  contacts: List<String>(),
  requests: List<String>(),
  blocks: List<String>()
);

final UserData sam = UserData(
  id: '3z73tMZnBaxfc8qPG37x',
  name: 'Sam',
  email: 'test@mail.com',
  imageUrl: 'assets/images/sam.jpg',
  contacts: List<String>(),
  requests: List<String>(),
  blocks: List<String>()
);

final UserData sophia = UserData(
  id: '3z73tMZnBaxfc8qPG37x',
  name: 'Sophia',
  email: 'test@mail.com',
  imageUrl: 'assets/images/sophia.jpg',
  contacts: List<String>(),
  requests: List<String>(),
  blocks: List<String>()
);

final UserData steven = UserData(
  id: '3z73tMZnBaxfc8qPG37x',
  name: 'Steven',
  email: 'test@mail.com',
  imageUrl: 'assets/images/steven.jpg',
  contacts: List<String>(),
  requests: List<String>(),
  blocks: List<String>()
);