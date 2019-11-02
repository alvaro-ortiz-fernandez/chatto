import 'package:flutter/material.dart';

class Stadistic {
  final String name;
  final IconData icon;
  final int count;

  Stadistic({
    this.name,
    this.icon,
    this.count
  });
}

List<Stadistic> stadistics = [ stadistic1, stadistic2, stadistic3 ];

final Stadistic stadistic1 = Stadistic(
  name: 'Mensajes',
  icon: Icons.chat_bubble,
  count: 612,
);

final Stadistic stadistic2 = Stadistic(
  name: 'Contactos',
  icon: Icons.supervisor_account,
  count: 1234,
);

final Stadistic stadistic3 = Stadistic(
  name: 'Días registrad@',
  icon: Icons.access_time,
  count: 79,
);