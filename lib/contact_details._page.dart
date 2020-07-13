import 'package:flutter/material.dart';
import 'package:phone_book/models/contact.dart';
import 'package:phone_book/new_contact_form.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetailPage extends StatefulWidget {
  final Contact contact;
  final int index;

  const ContactDetailPage({Key key, this.contact, this.index})
      : super(key: key);
  @override
  _ContactDetailPageState createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewContactForm(
                        index: widget.index,
                        contact: widget.contact,
                      ),
                    ));
              })
        ],
      ),
      body: ListView(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            height: MediaQuery.of(context).size.height / 2 - kToolbarHeight,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  size: 200,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "${widget.contact.firstName} ${widget.contact.lastName}",
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontSize: 40),
                )
              ],
            ),
          ),
          _detailCard(Icons.phone, "${widget.contact.phoneNumber}",
              "Phone Number", "tel:${widget.contact.phoneNumber}"),
          _detailCard(Icons.mail, "${widget.contact.email}", "Email Id",
              "mailto:${widget.contact.email}"),
        ],
      ),
    );
  }

  Widget _detailCard(IconData icon, String title, String subtitle, String url) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: () {
          launch(url);
        },
      ),
    );
  }
}
