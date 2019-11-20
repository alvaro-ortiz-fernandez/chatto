import 'package:chatto/models/auth-model.dart';
import 'package:event_bus/event_bus.dart';

final EventBus eventBus = EventBus();

class ContactsChangedEvent {
  List<UserData> currentContacts;

  ContactsChangedEvent(this.currentContacts);
}