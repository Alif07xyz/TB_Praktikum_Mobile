import 'dart:convert';

class Contact {
  String name;
  String contact;

  Contact({required this.name, required this.contact});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contact': contact,
    };
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      contact: json['contact'],
    );
  }
}
