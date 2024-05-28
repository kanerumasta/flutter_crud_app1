import 'package:myapp1/models/contact.dart';

List<Contact> filterContacts(List<Contact> contacts, String filtertext) {
  return contacts.where((contact) {
    return contact.firstname.contains(filtertext);
  }).toList();
}
