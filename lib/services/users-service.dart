import 'dart:async';

import 'package:chatto/models/auth-model.dart';
import 'package:chatto/models/event-model.dart';
import 'package:chatto/services/auth-service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:optional/optional.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersService {
  static final _firestore = Firestore.instance;

  static final String _userPrefsKey     = 'chatto-user-';
  static final String _contactsPrefsKey = 'chatto-contacts-';
  static final String _requestsPrefsKey = 'chatto-requests-';
  static final String _blocksPrefsKey   = 'chatto-blocks-';

  static final String defaultAvatarPath = 'assets/images/user/default-avatar.png';

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
      UserData userData = await getUserData(firebaseUser.uid);
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
    List<UserData> contacts;

    // Obtenemos los contactos del almacenamiento local. Si no existen, lo buscamos en
    // FireBase y los guardamos en local para el próximo acceso
    List<String> contactsJson = prefs.getStringList(_contactsPrefsKey + user.id);
    if (contactsJson != null) {
      // Mapeamos cada contacto a nuestro objeto a partir de la cadena JSON almacenada
      contacts = contactsJson
        .map((contact) => UserData.fromJson(contact))
        .toList();
    } else {
      contacts = await _getContacts(user);
      await _storeContacts(user, contacts);
    }

    // Filtramos los contactos para no mostrar los que estén bloqueados
    contacts = contacts
      .where((contact) => !user.blocks.contains(contact.id))
      .toList();

    return contacts;
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
  /// Método que trae de FireBase la información de un usuario
  /// ------------------------------------------------------------
  static Future<UserData> getUserData(String uid) async {
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
  /// Método que obtiene un usuario por su numbre
  /// ------------------------------------------------------------
  static Future<Optional<UserData>> getUserByName(String contactName) async {
    // Buscamos al usuario en firebase
    QuerySnapshot data = await _firestore
      .collection('/users')
      .where('name', isEqualTo: contactName)
      .snapshots()
      .first;

    if (data.documents != null && data.documents.isNotEmpty) {
      // Lo mapeamos a nuestra clase y lo devolvemos
      UserData user = UserData.fromDocument(data.documents[0]);
      return Optional.of(user);
    } else {
      return Optional.ofNullable(null);
    }
  }


  /// ------------------------------------------------------------
  /// Método que elimina un usuario de la lista de contactos
  /// ------------------------------------------------------------
  static Future<void> deleteContact(String currentUserId, String contactId) async {
    // Eliminamos en FireBase el contacto
    await _firestore
      .collection('/users')
      .document(currentUserId)
      .updateData(<String, dynamic>{
        'contacts': FieldValue.arrayRemove([contactId])
      });

    // Reseteamos los contactos y el usuario en almacenamiento local
    await deleteUserLocal();

    // Volvemos a obtener los contactos refrescamos y lanzamos un evento
    // para avisar que se han actualizado los contactos
    UserData currentUser = await getUserLocal();

    List<UserData> contacts = await getUserContacts(currentUser);
    eventBus.fire(ContactsChangedEvent(contacts));
  }

  /// ------------------------------------------------------------
  /// Método que envía una petición de amistad
  /// ------------------------------------------------------------
  static Future<void> sendRequest(String currentUserId, String contactId) async {
    await _firestore
      .collection('/users')
      .document(contactId)
      .updateData(<String, dynamic>{
        'requests': FieldValue.arrayUnion([currentUserId])
      });
  }


  /// ------------------------------------------------------------
  /// Método que acepta una petición de amistad
  /// ------------------------------------------------------------
  static Future<void> acceptRequest(String currentUserId, String contactId) async {
    // Obtenemos la referencia al documento en firebase de nuestro usuario
    DocumentReference currentUserRef = _firestore
      .collection('/users')
      .document(currentUserId);

    // Usamos una transacción para asegurarnos de que sólo se aplican los cambios si ninguno falla
    await _firestore.runTransaction((Transaction tx) async {
      // Añadimos en Firebase al nuevo contacto
      await tx.update(currentUserRef, <String, dynamic>{
        'contacts': FieldValue.arrayUnion([contactId])
      });

      // Petición aceptada, la quitamos en Firebase de peticiones pendientes de aceptar/rechazar
      await tx.update(currentUserRef, <String, dynamic>{
        'requests': FieldValue.arrayRemove([contactId])
      });
    });

    // Reseteamos las peticiones de amistad y el usuario en almacenamiento local
    await deleteUserLocal();

    // Volvemos a obtener las las peticiones de amistad, refrescamos
    // y lanzamos un evento para avisar que se han actualizado ambos
    UserData currentUser = await getUserLocal();

    List<UserData> contacts = await getUserContacts(currentUser);
    eventBus.fire(ContactsChangedEvent(contacts));

    List<UserData> requests = await getUserRequests(currentUser);
    eventBus.fire(RequestsChangedEvent(requests));
  }


  /// ------------------------------------------------------------
  /// Método que rechaza una petición de amistad
  /// ------------------------------------------------------------
  static Future<void> denyRequest(String currentUserId, String contactId) async {
    // Eliminamos en firebase la petición de amistad
    await _firestore
      .collection('/users')
      .document(currentUserId)
      .updateData(<String, dynamic>{
        'requests': FieldValue.arrayRemove([contactId])
      });

    // Reseteamos las peticiones de amistad y el usuario en almacenamiento local
    await deleteUserLocal();

    // Volvemos a obtener las las peticiones de amistad, refrescamos
    // y lanzamos un evento para avisar que se han actualizado ambos
    UserData currentUser = await getUserLocal();

    List<UserData> requests = await getUserRequests(currentUser);
    eventBus.fire(RequestsChangedEvent(requests));
  }


  /// ------------------------------------------------------------
  /// Método que bloquea a un usuario
  /// ------------------------------------------------------------
  static Future<void> blockUser(String currentUserId, String contactId) async {
    // Añadimos en FireBase el contacto a la lista de bloqueados
    await _firestore
      .collection('/users')
      .document(currentUserId)
      .updateData(<String, dynamic>{
        'blocks': FieldValue.arrayUnion([contactId])
      });

    // Reseteamos los usuarios bloqueados, contactos y el usuario en almacenamiento local
    await deleteUserLocal();

    // Volvemos a obtener los contactos y los usuarios bloqueados, refrescamos
    // y lanzamos un evento para avisar que se han actualizado ambos
    UserData currentUser = await getUserLocal();

    List<UserData> contacts = await getUserContacts(currentUser);
    eventBus.fire(ContactsChangedEvent(contacts));

    List<UserData> blocks = await getUserBlocks(currentUser);
    eventBus.fire(BlocksChangedEvent(blocks));
  }


  /// ------------------------------------------------------------
  /// Método que desbloquea a un usuario
  /// ------------------------------------------------------------
  static Future<void> unlockUser(String currentUserId, String contactId) async {
    // Eliminamos en FireBase el contacto de la lista de bloqueados
    await _firestore
      .collection('/users')
      .document(currentUserId)
      .updateData(<String, dynamic>{
        'blocks': FieldValue.arrayRemove([contactId])
      });

    // Reseteamos los usuarios bloqueados, contactos y el usuario en almacenamiento local
    await deleteUserLocal();

    // Volvemos a obtener los contactos y los usuarios bloqueados, refrescamos
    // y lanzamos un evento para avisar que se han actualizado ambos
    UserData currentUser = await getUserLocal();

    List<UserData> contacts = await getUserContacts(currentUser);
    eventBus.fire(ContactsChangedEvent(contacts));

    List<UserData> blocks = await getUserBlocks(currentUser);
    eventBus.fire(BlocksChangedEvent(blocks));
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
      UserData contact = await getUserData(contactId);
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
      UserData request = await getUserData(requestId);
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
      UserData block = await getUserData(blockId);
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