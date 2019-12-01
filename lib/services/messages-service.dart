import 'package:async/async.dart';
import 'package:chatto/models/auth-model.dart';
import 'package:chatto/models/message-model.dart';
import 'package:chatto/services/auth-service.dart';
import 'package:chatto/services/users-service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessagesService {

  static final _firestore = Firestore.instance;
  static Stream<Iterable<QuerySnapshot>> _userMessagesStream;

  /// ------------------------------------------------------------
  /// Método que obtiene los mensajes de un usuario en firebase
  /// ------------------------------------------------------------
  static Future<Stream<Iterable<MessageView>>> getUserMessages() async {
    // En el primer acceso, cargamos la llamada a firebase para obtener
    // los mensajes. Guardamos en la variable de memoria la referencia,
    // y en el resto de accesos la devolvemos.
    if (_userMessagesStream == null)
      _userMessagesStream = await _loadUserMessagesStream();

    return _userMessagesStream.asyncMap((Iterable<QuerySnapshot> snapshots) async {
      List<MessageView> messages = List<MessageView>();

      // Mapeamos los mensajes para convertir el id del emisor y receptor al objeto usuario
      Map<String, UserData> foundUsers = Map();

      for (final QuerySnapshot snapshot in snapshots) {
        if (snapshot != null && snapshot.documents != null && snapshot.documents.isNotEmpty) {
          for (final DocumentSnapshot doc in snapshot.documents) {
            Message message = Message.fromDocument(doc);

            UserData sender = await _getUserData(foundUsers, message.sender);
            UserData receiver = await _getUserData(foundUsers, message.receiver);

            MessageView messageView = MessageView(message.sender, message.receiver, message.time, message.content, message.unread, sender, receiver);
            messages.add(messageView);
          }
        }
      }

      // Ordenamos los mensajes por fecha
      return messages;
    });
  }

  /// ------------------------------------------------------------
  /// Método que obtiene el primer mensaje con cada contacto de un usuario
  /// ------------------------------------------------------------
  static Future<Stream<Iterable<MessageView>>> getChats() async {

    UserData currentUser = await UsersService.getUserLocal();

    return (await getUserMessages()).map((Iterable<MessageView> messages) {
      Map<String, MessageView> lastMessages = Map();

      for (final MessageView message in messages) {
        // Guardamos sólo un mensaje por cada usuario
        if (message.sender == currentUser.id)
          lastMessages[message.receiver] = message;
        else if (message.receiver == currentUser.id)
          lastMessages[message.sender] = message;
      }

      return lastMessages.values;
    });
  }

  /// ------------------------------------------------------------
  /// Método que obtiene los mensajes entre dos usuarios
  /// ------------------------------------------------------------
  static Future<Stream<Iterable<MessageView>>> getConversation(String user1Id, String user2Id) async {

    return (await getUserMessages()).map((Iterable<MessageView> messages) {
      List<MessageView> messages = List<MessageView>();

      for (final MessageView message in messages) {
        // Sólo añadimos los mensajes que sean entre los dos usuarios pasados por parámetro
        if ((message.sender == user1Id && message.receiver == user2Id)
            || (message.receiver == user1Id && message.sender == user2Id)) {
          messages.add(message);
        }
      }

      return messages;
    });
  }

  /// ------------------------------------------------------------
  /// Método que obtiene los mensajes de un usuario en firebase
  /// ------------------------------------------------------------
  static Future<Stream<Iterable<QuerySnapshot>>> _loadUserMessagesStream() async {
    FirebaseUser firebaseUser = await AuthService.getCurrentUser();

    // Obtenemos los mensajes enviados por nuestro usuario
    Stream<QuerySnapshot> stream1 = _firestore
      .collection('/userMessages')
      .where('sender', isEqualTo: firebaseUser.uid)
      .orderBy('time', descending: true)
      .snapshots();

    // Ahora los mensajes enviados a nuestro usuario
    Stream<QuerySnapshot> stream2 = _firestore
      .collection('/userMessages')
      .where('receiver', isEqualTo: firebaseUser.uid)
      .orderBy('time', descending: true)
      .snapshots();

    // Y devolvemos la unión de ambas colecciones
    return StreamZip([stream1, stream2]).asBroadcastStream();
  }

  /// ------------------------------------------------------------
  /// Método que obtiene un usuario del mapa en memoria o de firebase
  /// (en memoria si ya está, si no, de firebase y lo guarda en memoria
  /// para un próximo acceso)
  /// ------------------------------------------------------------
  static Future<UserData> _getUserData(Map<String, UserData> foundUsers, String idUser) async {
    if (foundUsers.containsKey(idUser)) {
      return foundUsers[idUser];
    } else {
      UserData user = await UsersService.getUserData(idUser);
      foundUsers[idUser] = user;
      return user;
    }
  }
}