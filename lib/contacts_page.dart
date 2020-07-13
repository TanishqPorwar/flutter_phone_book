import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phone_book/constants.dart';
import 'package:phone_book/contact_details._page.dart';
import 'package:phone_book/new_contact_form.dart';

import 'models/contact.dart';

class ContactPage extends StatelessWidget {
  final contactsBox = Hive.box(CONTACTS);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: contactsBox.length == 0
          ? Container(
              child: Center(
                child: Text("No Contacts"),
              ),
            )
          : _buildContactList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewContactForm(),
              ));
        },
        child: Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildContactList() {
    return WatchBoxBuilder(
      box: Hive.box(CONTACTS),
      builder: (context, contactsBox) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: ListView.builder(
            itemCount: contactsBox.length,
            itemBuilder: (context, index) {
              final Contact contact = contactsBox.getAt(index) as Contact;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).accentColor,
                    child: Text(
                      "${contact.firstName[0]}",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  title: Text(
                    "${contact.firstName} ${contact.lastName}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  subtitle: Text("${contact.phoneNumber}"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactDetailPage(
                            index: index,
                            contact: contact,
                          ),
                        ));
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          contactsBox.deleteAt(index);
                          if (index == 0) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => ContactPage()),
                                (Route<dynamic> route) => false);
                          }
                        },
                      ),
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewContactForm(
                                    index: index,
                                    contact: contact,
                                  ),
                                ));
                          })
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
