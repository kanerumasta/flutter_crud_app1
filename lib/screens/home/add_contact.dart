import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp1/DAO/contact_dao.dart';
import 'package:myapp1/models/contact.dart';
import 'package:email_validator/email_validator.dart';

class AddContact extends StatefulWidget {
  final VoidCallback onContactAdded;
  const AddContact({super.key, required this.onContactAdded});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final _formKey = GlobalKey<FormState>();
  bool isAdding = false;
  File? image;
  TextEditingController firstnameTextController = TextEditingController();
  TextEditingController lastnameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(
        () => this.image = imageTemp,
      );
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void printer() {
    print(firstnameTextController.text);
    print(lastnameTextController.text);
    print(emailTextController.text);
    print(phoneTextController.text);
    print(image.runtimeType);
  }

  @override
  void dispose() {
    firstnameTextController.dispose();
    lastnameTextController.dispose();
    emailTextController.dispose();
    phoneTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add New Contact'),
        ),
        body: isAdding
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: firstnameTextController,
                          decoration:
                              const InputDecoration(labelText: 'Firstname'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: lastnameTextController,
                          decoration:
                              const InputDecoration(labelText: 'Lastname'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: emailTextController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (email) {
                            if (email == null || email.isEmpty) {
                              return 'This field is required';
                            }
                            if (!EmailValidator.validate(email)) {
                              return 'Invalid email address';
                            }

                            return null;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: phoneTextController,
                          decoration: const InputDecoration(labelText: 'Phone'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required';
                            }

                            return null;
                          },
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              await pickImage();
                            },
                            child: const Text('Pick an Image')),
                        ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isAdding = true;
                                });
                                Contact newContact = Contact(
                                    firstname: firstnameTextController.text
                                        .toLowerCase(),
                                    lastname: lastnameTextController.text
                                        .toLowerCase(),
                                    email:
                                        emailTextController.text.toLowerCase(),
                                    phone: phoneTextController.text,
                                    image: image?.path);

                                try {
                                  final contactDao = ContactDAO();
                                  final res = await contactDao
                                      .insertContact(newContact);
                                  if (res > 0) {
                                    setState(() {
                                      isAdding = false;
                                    });
                                    Navigator.of(context).pop();
                                  }
                                  widget.onContactAdded();
                                } catch (e) {
                                  print(e);
                                }
                              }
                            },
                            child: const Text('print'))
                      ],
                    ))));
  }
}
