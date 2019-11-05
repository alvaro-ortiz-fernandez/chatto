class Setting {
  final String title;
  bool switched;

  Setting({
    this.title,
    this.switched
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

final List<SettingGroup> settings = [
  SettingGroup(
    title: 'Notificaciones',
    settings: [
      Setting(
        title: 'Nuevo mensaje (individual)',
        switched: true
      ),
      Setting(
        title: 'Nuevo mensaje (individual)',
        switched: true
      ),
      Setting(
        title: 'Usuario conectado',
        switched: false
      )
    ]
  ),
  SettingGroup(
    title: 'Seguridad',
    settings: [
      Setting(
        title: 'Cerrar sesión automáticamente al salir de la aplicación',
        switched: false
      )
    ]
  )
];