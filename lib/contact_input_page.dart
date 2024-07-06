import 'package:flutter/material.dart';
import 'package:contacts_app/contact.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ContactInputPage extends StatefulWidget {
  final int? index;
  final Contact? contact;

  const ContactInputPage({Key? key, this.index, this.contact}) : super(key: key);

  @override
  _ContactInputPageState createState() => _ContactInputPageState();
}

class _ContactInputPageState extends State<ContactInputPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      nameController.text = widget.contact!.name;
      contactController.text = widget.contact!.contact;
    }
  }

  Future<void> saveContact() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? contactsJson = prefs.getStringList('contacts') ?? [];
    List<Contact> contacts = contactsJson
        .map((contactJson) => Contact.fromJson(jsonDecode(contactJson) as Map<String, dynamic>))
        .toList();

    if (widget.index != null) {
      // Update existing contact
      contacts[widget.index!] = Contact(
        name: nameController.text,
        contact: contactController.text,
      );
    } else {
      // Add new contact
      contacts.add(Contact(
        name: nameController.text,
        contact: contactController.text,
      ));
    }

    List<String> updatedContactsJson = contacts.map((contact) => jsonEncode(contact.toJson())).toList();
    await prefs.setStringList('contacts', updatedContactsJson);

    // Return true to indicate that contact was saved
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.index != null ? 'Edit Contact' : 'Add Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: contactController,
              decoration: const InputDecoration(labelText: 'Contact'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await saveContact();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
