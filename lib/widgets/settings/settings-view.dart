import 'package:chatto/models/settings-model.dart';
import 'package:chatto/screens/settings-screen.dart';
import 'package:chatto/services/settings-service.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => new _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {

  List<SettingGroup> settings = SettingsService.settings;

  @override
  void initState() {
    super.initState();

    SettingsScreen.of(context).loadSharedPreferences()
      .then((val) => setState(() => settings = SettingsService.settings))
      .catchError((error) {});
  }

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
                              value: setting.enabled,
                              onChanged: (newValue) =>
                                setState(() {
                                  SettingsScreen.of(context).updateSetting(setting, newValue)
                                    .then((val) => setState(() => setting.enabled = newValue))
                                    .catchError((error) {});
                                }),
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