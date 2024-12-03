
import 'package:flutter/material.dart';
import '../database.dart';
import '../models.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  late List<Contact> _contacts;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    _contacts = await _dbHelper.getContacts();
    setState(() {});
  }

  void _addContact() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ContactForm(
      onSubmit: (newContact) async {
        await _dbHelper.insertContact(newContact);
        _loadContacts();
      },
    )));
  }

  void _editContact(Contact contact) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ContactForm(
      contact: contact,
      onSubmit: (updatedContact) async {
        await _dbHelper.updateContact(updatedContact);
        _loadContacts();
      },
    )));
  }

  void _deleteContact(int id) async {
    await _dbHelper.deleteContact(id);
    _loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addContact,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          return ListTile(
            title: Text(contact.name),
            subtitle: Text(contact.phone),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteContact(contact.id),
            ),
            onTap: () => _editContact(contact),
          );
        },
      ),
    );
  }
}

class ContactForm extends StatefulWidget {
  final Contact? contact;
  final Function(Contact) onSubmit;

  const ContactForm({super.key, this.contact, required this.onSubmit});

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _nameController.text = widget.contact!.name;
      _phoneController.text = widget.contact!.phone;
      _emailController.text = widget.contact!.email;
    }
  }

  void _submit() {
    if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
      final newContact = Contact(
        id: widget.contact?.id ?? 0,
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
      );
      widget.onSubmit(newContact);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact == null ? 'New Contact' : 'Edit Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
