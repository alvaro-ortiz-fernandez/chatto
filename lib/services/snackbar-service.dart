import 'package:flutter/material.dart';

class SnackbarService {
  static void showInfoSnackbar({ GlobalKey<ScaffoldState> key, String content }) {
    _showSnackbar(
      key: key,
      content: Text(content),
      backgroundColor: Color(0xff454dff),
      closeColor: Colors.lightBlueAccent[100]
    );
  }

  static void showSuccessSnackbar({ GlobalKey<ScaffoldState> key, String content }) {
    _showSnackbar(
      key: key,
      content: Text(content),
      backgroundColor: Colors.green,
      closeColor: Colors.green[100]
    );
  }

  static void showErrorSnackbar({ GlobalKey<ScaffoldState> key, String content }) {
    _showSnackbar(
      key: key,
      content: Text(content),
      backgroundColor: Colors.red,
      closeColor: Colors.red[100]
    );
  }

  static void _showSnackbar({ GlobalKey<ScaffoldState> key, Widget content,
      Color backgroundColor, Color closeColor }) {

    SnackBar snackBar = SnackBar(
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      elevation: 3,
      duration: Duration(seconds: 3),
      content: content,
      action: SnackBarAction(
        label: 'OK',
        textColor: closeColor,
        onPressed: () => key.currentState.hideCurrentSnackBar(),
      ),
    );

    key.currentState.showSnackBar(snackBar);
  }
}