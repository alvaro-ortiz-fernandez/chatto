import 'dart:async';

import 'package:chatto/models/event-model.dart';
import 'package:chatto/models/settings-model.dart';
import 'package:chatto/screens/settings-screen.dart';
import 'package:chatto/services/settings-service.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => new _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {

  StreamSubscription settingsChangedSubscription;
  List<SettingGroup> settings = List<SettingGroup>();

  @override
  void initState() {
    super.initState();
    setState(() {
      settings = SettingsScreen.of(context).settings;
    });

    settingsChangedSubscription = eventBus
      .on<SettingsChangedEvent>()
      .listen((SettingsChangedEvent event) {
        setState(() => settings = event.settings);
      });
  }

  @override
  void dispose() {
    super.dispose();

    if (settingsChangedSubscription != null)
      settingsChangedSubscription.cancel();
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
                            final UserSetting setting = settingGroup.settings[index];
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
                                SettingsService.getSettingTitle(setting.key),
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