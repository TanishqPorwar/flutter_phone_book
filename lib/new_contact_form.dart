import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:phone_book/constants.dart';
import 'package:phone_book/contacts_page.dart';
import 'package:phone_book/models/contact.dart';

class NewContactForm extends StatefulWidget {
  final int index;
  final Contact contact;
  const NewContactForm({Key key, this.index, this.contact}) : super(key: key);
  @override
  _NewContactFormState createState() => _NewContactFormState();
}

class _NewContactFormState extends State<NewContactForm> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _firstName;
  String _lastName;
  String _email;
  int _phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => ContactPage()),
                  (Route<dynamic> route) => false);
            }),
        title: Text((widget.index != null) ? "Edit" : ""),
        actions: [
          FlatButton(
              onPressed: () {
                _validateInputs();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => ContactPage()),
                    (Route<dynamic> route) => false);
              },
              child: Text("Save"))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 35),
            child: Center(
              child: CircleAvatar(
                maxRadius: 50,
                backgroundColor: Theme.of(context).accentColor,
                child: Icon(
                  Icons.person,
                  size: 80,
                ),
              ),
            ),
          ),
          Flexible(
            child: Form(
              autovalidate: _autoValidate,
              key: _formKey,
              child: ListView(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                    child: TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: "First Name",
                      ),
                      initialValue: (widget.index != null)
                          ? "${widget.contact.firstName}"
                          : "",
                      validator: (String arg) {
                        if (arg.length < 3)
                          return 'Name must be more than 2 charater';
                        else
                          return null;
                      },
                      onSaved: (newValue) => _firstName = newValue,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                    child: TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.person_outline),
                        labelText: "Last Name",
                      ),
                      initialValue: (widget.index != null)
                          ? "${widget.contact.lastName}"
                          : "",
                      onSaved: (newValue) => _lastName = newValue,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                    child: TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.contact_phone),
                        labelText: "Phone Number",
                      ),
                      initialValue: (widget.index != null)
                          ? "${widget.contact.phoneNumber}"
                          : "",
                      validator: (String value) {
                        if (value.length != 10)
                          return 'Mobile Number must be of 10 digit';
                        else
                          return null;
                      },
                      keyboardType: TextInputType.phone,
                      onSaved: (newValue) => _phoneNumber = int.parse(newValue),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                    child: TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.mail),
                        labelText: "Email",
                      ),
                      initialValue: (widget.index != null)
                          ? "${widget.contact.email}"
                          : "",
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                      onSaved: (newValue) => _email = newValue,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) && value.length != 0)
      return 'Enter Valid Email';
    else
      return null;
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      final newContact = Contact(_firstName, _lastName, _email, _phoneNumber);
      bool update = widget.index != null;
      addContact(newContact, update);
    } else {
      //    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void addContact(Contact contact, bool update) {
    final contactsBox = Hive.box(CONTACTS);
    if (update) {
      contactsBox.putAt(widget.index, contact);
    } else {
      contactsBox.add(contact);
    }
  }
}
