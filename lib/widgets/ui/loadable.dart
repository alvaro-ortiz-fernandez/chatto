import 'package:chatto/models/auth-model.dart';
import 'package:chatto/services/users-service.dart';
import 'package:flutter/material.dart';

abstract class LoadableWidget {
  Widget getWidgetBody();

  String getLoadingTitle();
}


/// ------------------------------------------------------------
/// Clase de la que deben extender las pantallas que quieren mostrar la animación de cargando
/// ------------------------------------------------------------
mixin Loadable<T extends StatefulWidget> on State<T> implements LoadableWidget {
  bool loading = true;

  void startLoading() {
    setState(() {
      loading = true;
    });
  }

  void stopLoading() {
    setState((){
      loading = false;
    });
  }

  Widget getSreenBody() {
    return loading ? getProgressBody() : getWidgetBody();
  }

  Widget getProgressBody() {
    return new Container(
      child: new Stack(
        children: <Widget>[
          getWidgetBody(),
          new Container(
            alignment: AlignmentDirectional.center,
            decoration: new BoxDecoration(
              color: Colors.black12,
            ),
            child: new Container(
              decoration: new BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.8),
                borderRadius: new BorderRadius.circular(10.0)
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              height: 200.0,
              alignment: AlignmentDirectional.center,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Center(
                    child: new SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: new CircularProgressIndicator(
                        value: null,
                        strokeWidth: 7.0,
                      ),
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: new Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            getLoadingTitle(),
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'GilroyBold',
                              color: Colors.white
                            ),
                          ),
                          Text(
                            'Por favor, espere...',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white
                            ),
                          )
                        ],
                      )
                    )
                  )
                ]
              )
            )
          )
        ]
      )
    );
  }
}