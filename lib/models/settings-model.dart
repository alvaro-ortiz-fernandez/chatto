import 'package:cloud_firestore/cloud_firestore.dart';

class SettingGroupModel {
  final String title;
  final List<SettingModel> settings;

  SettingGroupModel({
    this.title,
    this.settings
  });
}

class SettingGroup {
  final String title;
  final List<UserSetting> settings;

  SettingGroup({
    this.title,
    this.settings
  });
}

class SettingModel {
  final String key;
  final String title;
  final bool defaultValue;

  SettingModel({
    this.key,
    this.title,
    this.defaultValue
  });
}

class UserSetting {
  final String userId;
  final String key;
  bool enabled;

  UserSetting({
    this.userId,
    this.key,
    this.enabled
  });

  factory UserSetting.fromDocument(DocumentSnapshot doc) {
    return UserSetting(
      userId: doc['userId'] ?? '',
      key: doc['key'] ?? '',
      enabled: doc['enabled'] ?? false
    );
  }
}