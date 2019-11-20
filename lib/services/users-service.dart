import 'dart:async';

import 'package:chatto/models/auth-model.dart';
import 'package:chatto/models/event-model.dart';
import 'package:chatto/services/auth-service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersService {
  static final _firestore = Firestore.instance;

  static final String _userPrefsKey     = 'chatto-user-';
  static final String _contactsPrefsKey = 'chatto-contacts-';
  static final String _requestsPrefsKey = 'chatto-requests-';
  static final String _blocksPrefsKey   = 'chatto-blocks-';

  /// ------------------------------------------------------------
  /// Método que extrae del almacenamiento local la información del usuario
  /// ------------------------------------------------------------
  static Future<UserData> getUserLocal() async {
    FirebaseUser firebaseUser = await AuthService.getCurrentUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Obtenemos el usuario del almacenamiento local. Si no existe, lo buscamos en
    // FireBase y lo guardamos en local para el próximo acceso
    String userJson = prefs.getString(_userPrefsKey + firebaseUser.uid);
    if (userJson != null) {
      return UserData.fromJson(userJson);
    } else {
      UserData userData = await _getAccountData(firebaseUser.uid);
      await _storeAccountData(userData, firebaseUser.uid);
      return userData;
    }
  }

  /// ------------------------------------------------------------
  /// Método que elimina del almacenamiento local la información del usuario
  /// ------------------------------------------------------------
  static Future<void> deleteUserLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// ------------------------------------------------------------
  /// Método que obtiene todos los contactos de un usuario
  /// ------------------------------------------------------------
  static Future<List<UserData>> getUserContacts(UserData user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Obtenemos los contactos del almacenamiento local. Si no existen, lo buscamos en
    // FireBase y los guardamos en local para el próximo acceso
    List<String> contactsJson = prefs.getStringList(_contactsPrefsKey + user.id);
    if (contactsJson != null) {
      // Mapeamos cada contacto a nuestro objeto a partir de la cadena JSON almacenada
      List<UserData> contacts = contactsJson
        .map((contact) => UserData.fromJson(contact))
        .toList();
      return contacts;
    } else {
      List<UserData> contacts = await _getContacts(user);
      await _storeContacts(user, contacts);
      return contacts;
    }
  }

  /// ------------------------------------------------------------
  /// Método que obtiene todas las peticiones de amistad de un usuario
  /// ------------------------------------------------------------
  static Future<List<UserData>> getUserRequests(UserData user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Obtenemos las peticiones de amistad del almacenamiento local. Si no existen,
    // las buscamos en FireBase y las guardamos en local para el próximo acceso
    List<String> requestsJson = prefs.getStringList(_requestsPrefsKey + user.id);
    if (requestsJson != null) {
      // Mapeamos cada petición de amistad a nuestro objeto a partir de la cadena JSON almacenada
      List<UserData> requests = requestsJson
        .map((request) => UserData.fromJson(request))
        .toList();
      return requests;
    } else {
      List<UserData> requests = await _getRequests(user);
      await _storeRequests(user, requests);
      return requests;
    }
  }

  /// ------------------------------------------------------------
  /// Método que obtiene todos los usuarios bloqueados por un usuario
  /// ------------------------------------------------------------
  static Future<List<UserData>> getUserBlocks(UserData user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Obtenemos los usuarios bloqueados del almacenamiento local. Si no existen,
    // las buscamos en FireBase y las guardamos en local para el próximo acceso
    List<String> blocksJson = prefs.getStringList(_blocksPrefsKey + user.id);
    if (blocksJson != null) {
      // Mapeamos cada usuario bloqueado a nuestro objeto a partir de la cadena JSON almacenada
      List<UserData> blocks = blocksJson
        .map((block) => UserData.fromJson(block))
        .toList();
      return blocks;
    } else {
      List<UserData> blocks = await _getBlocks(user);
      await _storeBlocks(user, blocks);
      return blocks;
    }
  }


  /// ------------------------------------------------------------
  /// Método que elimina un usuario de la lista de contactos
  /// ------------------------------------------------------------
  static Future<void> deleteContact(UserData currentUser, UserData contact) async {
    // Eliminamos en FireBase el contacto
    await _firestore
      .collection('/users')
      .document(contact.id)
      .updateData(<String, dynamic>{
        'contacts': FieldValue.arrayRemove([contact.id])
      });

    // Reseteamos los contactos en almacenamiento local
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_contactsPrefsKey);

    // Volvemos a obtener los contactos refrescamos y lanzamos un evento
    // para avisar que se han actualizado los contactos
    List<UserData> contacts = await getUserContacts(currentUser);
    eventBus.fire(ContactsChangedEvent(contacts));
  }


  /// ------------------------------------------------------------
  /// Método que acepta una petición de amistad
  /// ------------------------------------------------------------
  static Future<void> acceptRequest() {}


  /// ------------------------------------------------------------
  /// Método que rechaza una petición de amistad
  /// ------------------------------------------------------------
  static Future<void> denyRequest() {}


  /// ------------------------------------------------------------
  /// Método que bloquea a un usuario
  /// ------------------------------------------------------------
  static Future<void> blockUser() {}


  /// ------------------------------------------------------------
  /// Método que desbloquea a un usuario
  /// ------------------------------------------------------------
  static Future<void> unblockUser() {}


  /// ------------------------------------------------------------
  /// Método que trae de FireBase la información del usuario
  /// ------------------------------------------------------------
  static Future<UserData> _getAccountData(String uid) async {
    // Obtenemos la información del usuario en BBDD
    DocumentSnapshot userDoc = await _firestore
      .collection('/users')
      .document(uid)
      .get();

    // Lo mapeamos a nuestra clase y lo devolvemos
    UserData user = UserData.fromDocument(userDoc);
    return user;
  }

  /// ------------------------------------------------------------
  /// Método que guarda en almacenamiento local la información del usuario
  /// ------------------------------------------------------------
  static Future<void> _storeAccountData(UserData userData, String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userPrefsKey + uid, userData.toJson());
  }

  /// ------------------------------------------------------------
  /// Método que trae de FireBase los contactos de un usuario
  /// ------------------------------------------------------------
  static Future<List<UserData>> _getContacts(UserData user) async {
    List<UserData> contacts = [];

    // Recorremos cada idContacto del usuario recibido por parámetro
    for (final String contactId in user.contacts) {
      UserData contact = await _getAccountData(contactId);
      contacts.add(contact);
    }

    return contacts;
  }

  /// ------------------------------------------------------------
  /// Método que guarda en almacenamiento local los contactos de un usuario
  /// ------------------------------------------------------------
  static Future<void> _storeContacts(UserData user, List<UserData> contacts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Mapeamos cada contacto a String JSON para guardarlo en almacenamiento local
    List<String> contactsJson = contacts
      .map((contact) => contact.toJson())
      .toList();

    await prefs.setStringList(_contactsPrefsKey + user.id, contactsJson);
  }

  /// ------------------------------------------------------------
  /// Método que trae de FireBase las peticiones de amistad de un usuario
  /// ------------------------------------------------------------
  static Future<List<UserData>> _getRequests(UserData user) async {
    List<UserData> requests = [];

    // Recorremos los idUsuario de cada petición de amistad del usuario recibido por parámetro
    for (final String requestId in user.requests) {
      UserData request = await _getAccountData(requestId);
      requests.add(request);
    }

    return requests;
  }

  /// ------------------------------------------------------------
  /// Método que guarda en almacenamiento local las peticiones de amistad de un usuario
  /// ------------------------------------------------------------
  static Future<void> _storeRequests(UserData user, List<UserData> requests) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Mapeamos cada usuario de petición a String JSON para guardarlo en almacenamiento local
    List<String> requestsJson = requests
      .map((request) => request.toJson())
      .toList();

    await prefs.setStringList(_requestsPrefsKey + user.id, requestsJson);
  }

  /// ------------------------------------------------------------
  /// Método que trae de FireBase los usuarios bloqueados por un usuario
  /// ------------------------------------------------------------
  static Future<List<UserData>> _getBlocks(UserData user) async {
    List<UserData> blocks = [];

    // Recorremos los idUsuario de cada usuario bloqueado por el recibido por parámetro
    for (final String blockId in user.blocks) {
      UserData block = await _getAccountData(blockId);
      blocks.add(block);
    }

    return blocks;
  }

  /// ------------------------------------------------------------
  /// Método que guarda en almacenamiento local los usuarios bloqueados por un usuario
  /// ------------------------------------------------------------
  static Future<void> _storeBlocks(UserData user, List<UserData> blocks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Mapeamos cada usuario de petición a String JSON para guardarlo en almacenamiento local
    List<String> blocksJson = blocks
      .map((block) => block.toJson())
      .toList();

    await prefs.setStringList(_blocksPrefsKey + user.id, blocksJson);
  }
}