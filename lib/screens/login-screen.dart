import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 180.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40.0),
                bottomRight: Radius.circular(40.0)
              ),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.blue,
                  Colors.deepPurpleAccent[400]
                ],
              ),
            )
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 50.0,
                        right: 30.0,
                        bottom: 30.0,
                        left: 30.0
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Chatto!'
                          ),
                          Text(
                            'Inicia sesión en tu cuenta'
                          )
                        ]
                      )
                    )
                  )
                ],
              ),
            )
          )
        ],
      )
    );
  }
}