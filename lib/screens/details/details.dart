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
      setState(
        () => this.editImage = imageTemp,
      );
    } catch (e) {
      print(e);
    }
  }

  DateTime selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController firstnameCont = TextEditingController();
  late TextEditingController lastnameCont = TextEditingController();
  late TextEditingController emailCont = TextEditingController();
  late TextEditingController phoneCont = TextEditingController();

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
                content: Form(
                    key: _formKey,
                    child: SizedBox(
                      height: 300,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: firstnameCont,
                          ),
                          TextFormField(
                            controller: lastnameCont,
                          ),
                          TextFormField(
                            controller: emailCont,
                          ),
                          TextFormField(
                            controller: phoneCont,
                          ),
                        ],
                      ),
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
      child: Column(
        children: [
          Hero(
              tag: widget.contact.id.toString(),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
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
                        height: 400,
                        child: Center(
                          child: Text(
                            widget.contact.firstname.substring(0, 1),
                            style: const TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              ElevatedButton(
                  onPressed: () async {
                    await pickImage();
                    if (editImage != null) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
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
                                              editImage!.path);
                                          Navigator.of(context).pop(true);
                                          widget.editFired();
                                          Navigator.of(context).pop(true);
                                        }
                                      },
                                      label: Text('Save'),
                                      icon: Icon(Icons.save)),
                                  TextButton.icon(
                                      onPressed: () {
                                        editImage = null;
                                        Navigator.of(context).pop(false);
                                      },
                                      label: Text('Cancel'),
                                      icon: Icon(Icons.cancel))
                                ],
                              ));
                    }
                  },
                  child: const Text('Edit Photo')),
              Container(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Name: ',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: Text(convertToTitleCase(
                        "${widget.contact.firstname} ${widget.contact.lastname}"
                            .toString())),
                  )
                ],
              )),
              Container(
                  child: Row(
                children: [
                  const Text(
                    'Email: ',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: Text(
                      widget.contact.email,
                    ),
                  )
                ],
              )),
              Container(
                  child: Row(
                children: [
                  const Text(
                    'Phone Number: ',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: Text(widget.contact.phone),
                  )
                ],
              )),
              Container(
                  child: Row(
                children: [
                  const Text(
                    'Date: ',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child:
                        Text(selectedDate.toLocal().toString().split(' ')[0]),
                  )
                ],
              )),
              Row(
                children: [
                  TextButton.icon(
                      icon: const Icon(Icons.edit),
                      onPressed: editBtnPressed,
                      label: const Text('Edit Details')),
                ],
              ),
            ]),
          )
        ],
      ),
    ));
  }
}
