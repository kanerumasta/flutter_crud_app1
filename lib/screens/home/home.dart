import 'package:flutter/material.dart';
import 'package:myapp1/DAO/contact_dao.dart';
import 'package:myapp1/helpers/filterer.dart';
import 'package:myapp1/models/contact.dart';
import 'package:myapp1/screens/home/add_contact.dart';
import 'package:myapp1/screens/home/contactsList.dart';
import 'package:myapp1/screens/home/search.dart';
// import 'package:myapp1/screens/home/contactsList.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final contactDao = ContactDAO();
  String filter = "";
  List<Contact> filteredContacts = [];
  late Future<List<Contact>> contactsFuture;

  void setFilter(String searchFilterText) {
    setState(() {
      filter = searchFilterText;
    });
  }

  void _refreshContacts() {
    setState(() {
      contactsFuture = contactDao.contacts();
    });
  }

  Future<void> _handleRefresh() async {
    _refreshContacts();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[600],
          title: const Text(
            'Frendfo',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 32.0),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddContact(
                        onContactAdded: _refreshContacts,
                      )));
              setState(() {});
            },
            child: Text('Add')),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: FutureBuilder<List<Contact>>(
            future: contactsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Error Occured'),
                );
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Friends List is Empty'),
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Search(
                      filterContacts: setFilter,
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: const Text('My Friends',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                    Expanded(
                      child: ContactList(
                        contacts: filterContacts(snapshot.data!, filter),
                        refreshFired: _refreshContacts,
                      ),
                    )
                  ],
                );
              }
            },
          ),
        ));
  }
}
