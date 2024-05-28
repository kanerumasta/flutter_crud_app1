import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myapp1/DAO/contact_dao.dart';
import 'package:myapp1/helpers/converter.dart';
import 'package:myapp1/models/contact.dart';
import 'package:myapp1/screens/details/details.dart';

class ContactList extends StatelessWidget {
  final List<Contact> contacts;
  final VoidCallback refreshFired;
  ContactList({super.key, required this.contacts, required this.refreshFired});
  final contactDao = ContactDAO();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ContactDetails(
                        contact: contacts[index],
                        editFired: refreshFired,
                      )));
            },
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(280),
                child: Hero(
                    tag: contacts[index].id.toString(),
                    child: contacts[index].image != null
                        ? Image.file(
                            File(contacts[index].image!),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const CircleAvatar(
                            radius: 25.0,
                            backgroundColor: Colors.green,
                          ))),
            title: Text(
              convertToTitleCase(contacts[index].firstname),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              contacts[index].email.toString(),
            ),
            key: Key(contacts[index].id.toString()),
            trailing: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: const Text('Are you sure you want to delete?'),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                contactDao.deleteContact(contacts[index].id!);

                                Navigator.of(context).pop(true);
                              },
                              child: const Text('Yes')),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text('No')),
                        ],
                      );
                    }).then((result) {
                  if (result) {
                    refreshFired();
                  }
                });
              },
              icon: const Icon(Icons.delete),
            ),
          );
        });
  }
}
