class Setting {
  final String title;
  final String sharedPreferenceKey;
  bool enabled;
  final bool defaultValue;

  Setting({
    this.title,
    this.sharedPreferenceKey,
    this.enabled,
    this.defaultValue
  });
}

class SettingGroup {
  final String title;
  final List<Setting> settings;

  SettingGroup({
    this.title,
    this.settings
  });
}