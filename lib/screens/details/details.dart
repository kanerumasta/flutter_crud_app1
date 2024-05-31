import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myapp1/DAO/contact_dao.dart';
import 'package:myapp1/helpers/converter.dart';
import 'package:myapp1/models/contact.dart';
import 'package:image_picker/image_picker.dart';

class ContactDetails extends StatefulWidget {
  final Contact contact;
  final VoidCallback editFired;

  const ContactDetails(
      {super.key, required this.contact, required this.editFired});

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  File? editImage;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.editImage = imageTemp);
    } catch (e) {
      print(e);
    }
  }

  DateTime selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController firstnameCont;
  late TextEditingController lastnameCont;
  late TextEditingController emailCont;
  late TextEditingController phoneCont;

  @override
  void initState() {
    super.initState();
    firstnameCont = TextEditingController(text: widget.contact.firstname);
    lastnameCont = TextEditingController(text: widget.contact.lastname);
    emailCont = TextEditingController(text: widget.contact.email);
    phoneCont = TextEditingController(text: widget.contact.phone);
  }

  final contactDao = ContactDAO();

  void editBtnPressed() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                content: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: firstnameCont,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: lastnameCont,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: emailCont,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: phoneCont,
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    )),
                actions: [
                  TextButton(
                    onPressed: () {
                      Contact updatedContact = Contact(
                          firstname: firstnameCont.text.toLowerCase(),
                          lastname: lastnameCont.text.toLowerCase(),
                          email: emailCont.text.toLowerCase(),
                          phone: phoneCont.text,
                          image: widget.contact.image);
                      contactDao.updateContact(
                          widget.contact.id!, updatedContact);
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Save'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              )).then((navi) {
        if (navi == true) {
          Navigator.of(context).pop();
        }
      });

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: widget.contact.id.toString(),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: widget.contact.image != null
                      ? Image.file(
                          File(widget.contact.image!),
                          height: queryData.size.height / 3,
                          width: queryData.size.width,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.blue,
                          width: queryData.size.width,
                          height: queryData.size.height / 3,
                          child: Center(
                            child: Text(
                              widget.contact.firstname.substring(0, 1),
                              style: const TextStyle(
                                  fontSize: 40.0, color: Colors.white),
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await pickImage();
                        if (editImage != null) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              content: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(File(editImage!.path)),
                              ),
                              actions: [
                                TextButton.icon(
                                  onPressed: () {
                                    if (editImage != null) {
                                      final res = contactDao.changeImage(
                                        widget.contact.id!,
                                        editImage!.path,
                                      );
                                      Navigator.of(context).pop(true);
                                      widget.editFired();
                                      Navigator.of(context).pop(true);
                                    }
                                  },
                                  icon: const Icon(Icons.save),
                                  label: const Text('Save'),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    editImage = null;
                                    Navigator.of(context).pop(false);
                                  },
                                  icon: const Icon(Icons.cancel),
                                  label: const Text('Cancel'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: const Text('Change Photo'),
                    ),
                    const SizedBox(height: 20),
                    buildInfoRow(
                        'Name:',
                        convertToTitleCase(
                            '${widget.contact.firstname} ${widget.contact.lastname}')),
                    const SizedBox(height: 10),
                    buildInfoRow('Email:', widget.contact.email),
                    const SizedBox(height: 10),
                    buildInfoRow('Phone Number:', widget.contact.phone),
                    const SizedBox(height: 10),
                    buildInfoRow('Date:',
                        selectedDate.toLocal().toString().split(' ')[0]),
                    const SizedBox(height: 20),
                    TextButton.icon(
                      icon: const Icon(Icons.edit),
                      onPressed: editBtnPressed,
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16.0),
                      ),
                      label: const Text('Edit Details'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label ',
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 18.0),
          ),
        ),
      ],
    );
  }
}
