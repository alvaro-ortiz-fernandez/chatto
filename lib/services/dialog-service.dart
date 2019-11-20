import 'package:flutter/material.dart';

class DialogService {
  static Future<bool> showDefaultDialog({ BuildContext context, String title, String description, String action }) async {
    return _showAlertDialog(
      context: context,
      title: title,
      description: description,
      action: action.toUpperCase(),
      actionColor: Colors.black54,
      highlightColor: Colors.grey[300]
    );
  }

  static Future<bool> showInfoDialog({ BuildContext context, String title, String description, String action }) async {
    return _showAlertDialog(
      context: context,
      title: title,
      description: description,
      action: action.toUpperCase(),
      actionColor: Theme.of(context).primaryColor,
      highlightColor: Colors.blue[50]
    );
  }

  static Future<bool> showSuccessDialog({ BuildContext context, String title, String description, String action }) async {
    return _showAlertDialog(
      context: context,
      title: title,
      description: description,
      action: action.toUpperCase(),
      actionColor: Colors.green,
      highlightColor: Colors.green[50]
    );
  }

  static Future<bool> showDangerDialog({ BuildContext context, String title, String description, String action }) async {
    return _showAlertDialog(
      context: context,
      title: title,
      description: description,
      action: action.toUpperCase(),
      actionColor: Colors.red,
      highlightColor: Colors.red[50]
    );
  }

  /// ------------------------------------------------------------
  /// Método que muestra un diálogo de alerta
  /// ------------------------------------------------------------
  static Future<bool> _showAlertDialog({ BuildContext context, String title, String description, String action, Color highlightColor, Color actionColor }) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'GilroyBold'
            )
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(description)
              ]
            )
          ),
          actions: <Widget>[
            FlatButton(
              highlightColor: highlightColor,
              child: Text(
                'CANCELAR',
                style: TextStyle(
                  color: actionColor,
                  fontFamily: 'GilroyBold'
                )
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              }
            ),
            FlatButton(
              highlightColor: highlightColor,
              child: Text(
                action,
                style: TextStyle(
                  color: actionColor,
                  fontFamily: 'GilroyBold'
                )
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              }
            )
          ]
        );
      }
    );
  }
}