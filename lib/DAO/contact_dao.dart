import 'package:myapp1/models/contact.dart';
import 'package:myapp1/services/database_helper.dart';

class ContactDAO {
  final dbHelper = DBHelper();

  Future<int> insertContact(Contact contact) async {
    final db = await dbHelper.database;

    return await db.insert('contacts', contact.toMap());
  }

  Future<void> deleteContact(int id) async {
    final db = await dbHelper.database;
    var x = await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
    print(x);
  }

  Future<void> updateContact(int id, Contact contact) async {
    final db = await dbHelper.database;
    try {
      var res = await db.update('contacts', contact.toMap(),
          where: 'id = ?', whereArgs: [id]);
      print(res);
    } catch (e) {
      print(e);
    }
  }

  Future<void> changeImage(int id, String image) async {
    final db = await dbHelper.database;
    try {
      final res = await db
          .rawUpdate('UPDATE contacts SET image = ? WHERE id = ?', [image, id]);
      print(res);
    } catch (e) {
      print(e);
    }
  }

  Future<List<Contact>> contacts() async {
    List<Contact> contactsOut = [];
    final db = await dbHelper.database;
    try {
      final List<Map<String, dynamic>> contactsFromDb =
          await db.query('contacts');
      for (final contact in contactsFromDb) {
        Contact newContact = Contact(
            id: contact['id'],
            firstname: contact['firstname'],
            lastname: contact['lastname'],
            email: contact['email'],
            phone: contact['phone'],
            image: contact['image']);
        contactsOut.add(newContact);
      }
    } catch (e) {
      print(e);
    }
    return contactsOut;
  }
}
