import 'package:chatto/models/auth-model.dart';
import 'package:chatto/models/message-model.dart';
import 'package:chatto/screens/profile-screen.dart';
import 'package:chatto/services/snackbar-service.dart';
import 'package:chatto/widgets/chat/chat-message.dart';
import 'package:chatto/widgets/ui/loadable.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final UserData currentUser;
  final UserData talkingUser;

  ChatScreen({ this.currentUser, this.talkingUser });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with Loadable {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scheduledMessageFormKey = GlobalKey<FormState>();

  @override
  Future<void> loadData() async {}

  @override
  void initState() {
    super.initState();
    loading = false;
  }

  @override
  String getLoadingTitle() {
    return 'Cargando';
  }

  @override
  Widget getWidgetBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor
            ),
            child: ListView.builder(
              padding: EdgeInsets.only(top: 15.0),
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final Message message = messages[index];
                bool isMe = message.sender.id == widget.currentUser.id;
                return new ChatMessage(message: message, isMe: isMe);
              },
            )
          )
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0.0, -3.0)
              )
            ]
          ),
          padding: EdgeInsets.only(
            top: 10,
            right: 20,
            bottom: 10,
            left: 10
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.schedule),
                iconSize: 28.0,
                color: Colors.black45,
                onPressed: () => mostrarDialogoNuevoMensajeProgramado(),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.50,
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Escribe un mensaje...'
                  ),
                )
              ),
              Container(
                height: 50,
                width: 50,
                padding: EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(30.0)
                ),
                child: IconButton(
                  icon: Icon(Icons.send),
                  iconSize: 25.0,
                  color: Colors.white,
                  onPressed: () {},
                )
              )
            ]
          )
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor
        ),
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.talkingUser.name,
              style: TextStyle(
                fontSize: 24.0,
                fontFamily: 'GilroyBold',
                color: Colors.black
              )
            ),
            Text(
              'Hace 54 minutos',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700]
              )
            )
          ]
        ),
        elevation: 0.0,
        actions: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(
                  user: widget.talkingUser
                )
              )
            ),
            child: Container(
              padding: EdgeInsets.all(8),
              child: CircleAvatar(
                radius: 20.0,
                backgroundImage: AssetImage(widget.talkingUser.imageUrl),
              )
            )
          )
        ],
      ),
      body: getSreenBody()
    );
  }

  void mostrarDialogoNuevoMensajeProgramado() {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Programar mensaje',
            style: TextStyle(
              fontFamily: 'GilroyBold'
            )
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Introduce el mensaje, fecha y hora a la que quieres que se envíe.'),
                SizedBox(height: 10),
                Form(
                  key: _scheduledMessageFormKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Mensaje'
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Por favor, introduzca un valor';
                      }
                      return null;
                    }
                  )
                )
              ]
            )
          ),
          actions: <Widget>[
            FlatButton(
              highlightColor: Colors.blue[50],
              child: Text(
                'CANCELAR',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'GilroyBold'
                )
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }
            ),
            FlatButton(
              highlightColor: Colors.blue[50],
              child: Text(
                'AGREGAR',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'GilroyBold'
                )
              ),
              onPressed: () {
                if (_scheduledMessageFormKey.currentState.validate()) {
                  startLoading();
                  Navigator.of(context).pop();

                  Future.delayed(Duration(seconds: 2), () => throw Exception())
                    .then((val) {
                      SnackbarService.showInfoSnackbar(
                        key: _scaffoldKey,
                        content: 'Usuario agregado correctamente.'
                      );
                    })
                    .catchError((error) {
                      SnackbarService.showErrorSnackbar(
                        key: _scaffoldKey,
                        content: 'Se ha producido un error, por favor, inténtelo de nuevo.'
                      );
                    })
                    .whenComplete(() => stopLoading());
                }
              }
            )
          ]
        );
      }
    );
  }
}