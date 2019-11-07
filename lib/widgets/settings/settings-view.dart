import 'package:chatto/models/settings-model.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => new _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 10, bottom: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                itemCount: settings.length,
                itemBuilder: (BuildContext context, int index) {
                  final SettingGroup settingGroup = settings[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        settingGroup.title,
                        style: TextStyle(
                          fontFamily: 'GilroyBold'
                        ),
                      ),
                      Container(
                        child: ListView.builder(
                          itemCount: settingGroup.settings.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            final Setting setting = settingGroup.settings[index];
                            return SwitchListTile(
                              contentPadding: EdgeInsets.all(0),
                              value: setting.switched,
                              onChanged: (val) => setState(() => setting.switched = val),
                              title: Text(
                                setting.title,
                                style: TextStyle(
                                  color: Colors.black
                                )
                              ),
                              activeColor: Theme.of(context).primaryColor
                            );
                          }
                        )
                      )
                    ]
                  );
                }
              )
            )
          ]
        )
      )
    );
  }
}