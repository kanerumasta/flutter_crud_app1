import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;
      final imageTemp = File(pickedFile.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print(e);
    }
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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.redAccent,
                        backgroundImage:
                            image != null ? FileImage(image!) : null,
                        child: image == null
                            ? const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 40,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: firstnameTextController,
                      decoration: InputDecoration(
                        labelText: 'Firstname',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: lastnameTextController,
                      decoration: InputDecoration(
                        labelText: 'Lastname',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailTextController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
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
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: phoneTextController,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // bool isEmailDuplicate = await ContactDAO()
                          //     .isDuplicate(emailTextController.text);
                          // if (isEmailDuplicate) {
                          //   showDialog(
                          //       context: context,
                          //       builder: (context) => AlertDialog(
                          //             content: Text('Duplicate Email!'),
                          //             actions: [
                          //               TextButton(
                          //                   onPressed: () {
                          //                     Navigator.of(context).pop();
                          //                   },
                          //                   child: const Text('Close'))
                          //             ],
                          //           ));
                          // }
                          setState(() {
                            isAdding = true;
                          });
                          Contact newContact = Contact(
                            firstname:
                                firstnameTextController.text.toLowerCase(),
                            lastname: lastnameTextController.text.toLowerCase(),
                            email: emailTextController.text.toLowerCase(),
                            phone: phoneTextController.text,
                            image: image?.path,
                          );

                          try {
                            final contactDao = ContactDAO();
                            final res =
                                await contactDao.insertContact(newContact);
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
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Add Contact'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
