class Contact {
  int? id;
  final String firstname;
  final String lastname;
  final String email;
  final String phone;
  String? image;

  Contact(
      {this.id,
      required this.firstname,
      required this.lastname,
      required this.email,
      required this.phone,
      this.image});

  Contact.fromMap(Map<String, dynamic> map)
      : firstname = map['firstname'],
        lastname = map['lastaname'],
        email = map['email'],
        phone = map['phone'],
        image = map['image'];

  Map<String, dynamic> toMap() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'phone': phone,
      'image': image,
    };
  }
}

class UpdateContact {
  final String firstname;
  final String lastname;
  final String email;
  final String phone;

  UpdateContact({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'phone': phone
    };
  }
}
