import 'package:async/async.dart';
import 'package:chatto/models/auth-model.dart';
import 'package:chatto/models/message-model.dart';
import 'package:chatto/services/auth-service.dart';
import 'package:chatto/services/users-service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessagesService {

  static final _firestore = Firestore.instance;
  static Stream<List<QuerySnapshot>> _userMessagesStream;

  /// ------------------------------------------------------------
  /// Método que obtiene los mensajes de un usuario en firebase
  /// ------------------------------------------------------------
  static Future<Stream<List<MessageView>>> getUserMessages() async {
    // En el primer acceso, cargamos la llamada a firebase para obtener
    // los mensajes. Guardamos en la variable de memoria la referencia,
    // y en el resto de accesos la devolvemos.
    if (_userMessagesStream == null)
      _userMessagesStream = await _loadUserMessagesStream();

    return _userMessagesStream.asyncMap((List<QuerySnapshot> snapshots) async {
      List<MessageView> messages = List<MessageView>();

      // Mapeamos los mensajes para convertir el id del emisor y receptor al objeto usuario
      Map<String, UserData> foundUsers = Map();

      print('getUserMessages(1)');
      for (final QuerySnapshot snapshot in snapshots) {
        print('getUserMessages(2) snapshots.length: ' + snapshots.length.toString());
        if (snapshot != null && snapshot.documents != null && snapshot.documents.isNotEmpty) {
          for (final DocumentSnapshot doc in snapshot.documents) {
            print('getUserMessages(3) snapshot.documents.length: ' + snapshot.documents.length.toString());
            Message message = Message.fromDocument(doc);

            UserData sender = await _getUserData(foundUsers, message.sender);
            UserData receiver = await _getUserData(foundUsers, message.receiver);

            MessageView messageView = MessageView(message.sender, message.receiver, message.time, message.content, message.unread, sender, receiver);
            messages.add(messageView);
          }
        }
      }

      print('getUserMessages(8) messages.length: ' + messages.length.toString());
      return messages;
    });
  }

  /// ------------------------------------------------------------
  /// Método que obtiene el primer mensaje con cada contacto de un usuario
  /// ------------------------------------------------------------
  static Future<Stream<List<MessageView>>> getChats() async {

    Stream<List<MessageView>> stream = await getUserMessages();
    UserData currentUser = await UsersService.getUserLocal();

    return stream.map((List<MessageView> messages) {
      print('getChats(1) messages.length: ' + messages.length.toString());
      Map<String, MessageView> lastMessages = Map();

      // Ordenamos los mensajes por fecha
      messages.sort((a, b) => a.time.compareTo(b.time));

      for (final MessageView message in messages) {

        // Guardamos sólo un mensaje por cada usuario
        if (message.sender == currentUser.id)
          lastMessages[message.receiver] = message;
        else if (message.receiver == currentUser.id)
          lastMessages[message.sender] = message;
      }

      print('getChats(2) lastMessages.values.length: ' + lastMessages.values.length.toString());
      return lastMessages.values;
    });
  }

  /// ------------------------------------------------------------
  /// Método que obtiene los mensajes entre dos usuarios
  /// ------------------------------------------------------------
  static Future<Stream<List<MessageView>>> getConversation(String user1Id, String user2Id) async {

    Stream<List<MessageView>> stream = await getUserMessages();

    return stream.map((List<MessageView> messages) {
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
  static Future<Stream<List<QuerySnapshot>>> _loadUserMessagesStream() async {
    FirebaseUser firebaseUser = await AuthService.getCurrentUser();

    // Obtenemos los mensajes enviados por nuestro usuario
    Stream<QuerySnapshot> stream1 = _firestore
      .collection('/userMessages')
      .where('sender', isEqualTo: firebaseUser.uid)
      .snapshots();

    // Ahora los mensajes enviados a nuestro usuario
    Stream<QuerySnapshot> stream2 = _firestore
      .collection('/userMessages')
      .where('receiver', isEqualTo: firebaseUser.uid)
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