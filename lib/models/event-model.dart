import 'package:chatto/models/auth-model.dart';
import 'package:chatto/models/settings-model.dart';
import 'package:event_bus/event_bus.dart';

final EventBus eventBus = EventBus();

class ContactsChangedEvent {
  List<UserData> currentContacts;

  ContactsChangedEvent(this.currentContacts);
}

class RequestsChangedEvent {
  List<UserData> currentRequests;

  RequestsChangedEvent(this.currentRequests);
}

class BlocksChangedEvent {
  List<UserData> currentBlocks;

  BlocksChangedEvent(this.currentBlocks);
}

class SettingsChangedEvent {
  List<SettingGroup> settings;

  SettingsChangedEvent(this.settings);
}