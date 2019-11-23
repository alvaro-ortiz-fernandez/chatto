import 'package:chatto/models/event-model.dart';
import 'package:chatto/models/settings-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:optional/optional_internal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {

  static final _firestore = Firestore.instance;

  static List<SettingGroupModel> settings = [
    SettingGroupModel(
      title: 'Notificaciones',
      settings: [
        SettingModel(
          title: 'Nuevo mensaje (individual)',
          key: 'contact-messages',
          defaultValue: true
        ),
        SettingModel(
          key: 'group-messages',
          title: 'Nuevo mensaje (grupo)',
          defaultValue: true
        ),
        SettingModel(
          key: 'user-connected',
          title: 'Usuario conectado',
          defaultValue: false
        )
      ]
    ),
    SettingGroupModel(
      title: 'Seguridad',
      settings: [
        SettingModel(
          key: 'auto-logout',
          title: 'Cerrar sesión automáticamente al salir de la aplicación',
          defaultValue: false
        )
      ]
    )
  ];


  /// ------------------------------------------------------------
  /// Método que obtiene todas las preferencias de un usuario
  /// ------------------------------------------------------------
  static Future<List<SettingGroup>> loadSettings(String userId) async {
    List<SettingGroup> userSettings = List<SettingGroup>();

    for (final SettingGroupModel settingGroup in settings) {
      SettingGroup userSettingGroup = SettingGroup(
        title: settingGroup.title,
        settings: List<UserSetting>()
      );

      for (final SettingModel settingModel in settingGroup.settings) {
        UserSetting userSetting = UserSetting(
          userId: userId,
          key: settingModel.key,
          enabled: await getSetting(userId, settingModel.key)
        );

        userSettingGroup.settings.add(userSetting);
      }

      userSettings.add(userSettingGroup);
    }

    return userSettings;
  }

  /// ------------------------------------------------------------
  /// Método que obtiene el valor de una preferencia
  /// ------------------------------------------------------------
  static Future<bool> getSetting(String userId, String key) async {
    // Obtenemos la preferencia del almacenamiento local
    Optional<UserSetting> optSetting = await _getLocalSetting(userId, key);
    if (optSetting.isPresent) {
      return optSetting.value.enabled;
    } else {
      // Si no existe en local, la vamos a buscar en firebase
      optSetting = await _getFiresbaseSetting(userId, key);

      if (optSetting.isPresent) {
        return optSetting.value.enabled;
      } else {
        // Si tampoco está en firebase, la guardamos para el
        // próximo acceso con el valor por defecto y lo devolvemos
        bool newValue = _getSettingDefaultValue(key);
        setSetting(userId, key, newValue);

        return newValue;
      }
    }
  }

  /// ------------------------------------------------------------
  /// Método que guarda el valor de una preferencia en firebase
  /// ------------------------------------------------------------
  static Future<void> setSetting(String userId, String key, bool newValue) async {
    // Guardamos el nuevo valor en firebase
    _setFiresbaseSetting(userId, key, newValue);

    // Y en almacenamiento local, para acceso más rápido
    _setLocalSetting(userId, key, newValue);

    // Lanzamos evento para avisar de que las preferencias han sido cambiadas
    eventBus.fire(SettingsChangedEvent(await loadSettings(userId)));
  }

  /// ------------------------------------------------------------
  /// Método que devuelve el título de una preferencia
  /// ------------------------------------------------------------
  static String getSettingTitle(String key) {
    String title = '';

    for (final SettingGroupModel settingGroup in settings) {
      for (final SettingModel setting in settingGroup.settings) {
        if (setting.key == key) {
          title = setting.title;
        }
      }
    }

    return title;
  }

  /// ------------------------------------------------------------
  /// Método que obtiene el valor de una preferencia de firebase
  /// ------------------------------------------------------------
  static Future<Optional<UserSetting>> _getFiresbaseSetting(String userId, String key) async {
    // Obtenemos la preferencia de FireBase
    QuerySnapshot data = await _firestore
      .collection('/settings')
        .where('userId', isEqualTo: userId)
        .where('key', isEqualTo: key)
      .snapshots()
      .first;

    if (data.documents != null && data.documents.isNotEmpty) {
      // Lo mapeamos a nuestra clase y lo devolvemos
      UserSetting userSetting = UserSetting.fromDocument(data.documents[0]);
      return Optional.of(userSetting);
    } else {
      return Optional.ofNullable(null);
    }
  }

  /// ------------------------------------------------------------
  /// Método que obtiene el valor de una preferencia del almacenamiento local
  /// ------------------------------------------------------------
  static Future<Optional<UserSetting>> _getLocalSetting(String userId, String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String prefsKey = _buildSettingPrefKey(userId, key);
    if (prefs.containsKey(prefsKey)) {
      bool value = prefs.getBool(prefsKey);

      UserSetting userSetting = UserSetting(
        userId: userId,
        key: key,
        enabled: value
      );
      return Optional.of(userSetting);
    } else {
      return Optional.ofNullable(null);
    }

  }

  /// ------------------------------------------------------------
  /// Método que guarda el valor de una preferencia en firebase
  /// ------------------------------------------------------------
  static Future<void> _setFiresbaseSetting(String userId, String key, bool newValue) async {
    // Buscamos la preferencia en firebase
    QuerySnapshot data = await _firestore
      .collection('/settings')
        .where('userId', isEqualTo: userId)
        .where('key', isEqualTo: key)
      .snapshots()
      .first;

    // Si ya existe, la actualizamos
    if (data.documents != null && data.documents.isNotEmpty) {
      await data.documents[0].reference
        .updateData({
          'enabled': newValue
        });
    } else {
      // Si no existe, la creamos
      await _firestore
        .collection('/settings')
        .add({
          'userId': userId,
          'key': key,
          'enabled': newValue
        });
    }
  }

  /// ------------------------------------------------------------
  /// Método que guarda el valor de una preferencia en el almacenamiento local
  /// ------------------------------------------------------------
  static Future<void> _setLocalSetting(String userId, String key, bool newValue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_buildSettingPrefKey(userId, key), newValue);
  }

  /// ------------------------------------------------------------
  /// Método que guarda el valor por defecto de una preferencia
  /// ------------------------------------------------------------
  static bool _getSettingDefaultValue(String key) {
    bool defaultValue = false;

    for (final SettingGroupModel settingGroup in settings) {
      for (final SettingModel setting in settingGroup.settings) {
        if (setting.key == key) {
          defaultValue = setting.defaultValue;
        }
      }
    }

    return defaultValue;
  }

  /// ------------------------------------------------------------
  /// Método que construye el id de una preferencia en el almacenamiento local
  /// ------------------------------------------------------------
  static String _buildSettingPrefKey(String userId, String key) {
    return ('chatto-setting-' + userId + '-' + key);
  }
}