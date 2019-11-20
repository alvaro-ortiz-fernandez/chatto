import 'package:chatto/models/settings-model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {

  static List<SettingGroup> settings = [
    SettingGroup(
      title: 'Notificaciones',
      settings: [
        Setting(
          title: 'Nuevo mensaje (individual)',
          sharedPreferenceKey: 'contactMessages',
          enabled: true,
          defaultValue: true
        ),
        Setting(
          title: 'Nuevo mensaje (grupo)',
          sharedPreferenceKey: 'groupMessages',
          enabled: true,
          defaultValue: true
        ),
        Setting(
          title: 'Usuario conectado',
          sharedPreferenceKey: 'userConnected',
          enabled: false,
          defaultValue: false
        )
      ]
    ),
    SettingGroup(
      title: 'Seguridad',
      settings: [
        Setting(
          title: 'Cerrar sesión automáticamente al salir de la aplicación',
          sharedPreferenceKey: 'autoLogout',
          enabled: false,
          defaultValue: false
        )
      ]
    )
  ];


  static Future<void> loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    for (final SettingGroup settingGroup in settings) {
      for (final Setting setting in settingGroup.settings) {
        setting.enabled = (_getSetting(prefs, setting));
      }
    }
  }

  static Future<bool> getSetting(Setting setting) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return _getSetting(prefs, setting);
  }

  static bool _getSetting(SharedPreferences prefs, Setting setting) {
    return prefs.getBool(setting.sharedPreferenceKey) ?? setting.defaultValue;
  }

  static Future<bool> setSetting(Setting setting, bool newValue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await _setSetting(prefs, setting, newValue);
  }

  static Future<bool> _setSetting(SharedPreferences prefs, Setting setting, bool newValue) async {
    bool completed =  await prefs.setBool(setting.sharedPreferenceKey, newValue);
    setting.enabled = newValue;
    return completed;
  }
}