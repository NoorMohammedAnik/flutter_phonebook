import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_phonebook/views/contacts/add_contact.dart';
import 'package:flutter_phonebook/views/contacts/update_contact.dart';
import 'package:flutter_phonebook/views/authentication/user_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../api/api_service.dart';
import '../model/contact.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GetStorage box = GetStorage();
  String get userId => box.read("user_id");

  var searchController= TextEditingController();

  Future<List<Contact>> getAllContacts() async {
    List<Contact> contactList = [];
    String searchText=searchController.text;

    try {
      final url = Uri.parse("${API.getContact}?user_id=$userId&search=$searchText");
      var response = await http.get(url);



      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        for (var eachRecord in (responseData["userData"] as List)) {
          contactList.add(Contact.fromJson(eachRecord));
        }
      }

    } catch (errorMsg) {
      print(errorMsg.toString());
    }

    return contactList;
  }

  // Function to make a phone call
  Future makePhoneCall(String phoneNumber) async {
    Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  //for search contact
  onSearch(String search) {
    setState(() {
      searchController.text = search;
      getAllContacts();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text(
          "Contact List",
          style: TextStyle(color: Colors.white),
        ),

        actions: [
          IconButton(
            tooltip: "Logout",
            color: Colors.white,
            onPressed: () {


              box.erase(); //for deleting locally store data when logout
              Get.offAll(() => const UserLogin());

            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 10,),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => onSearch(value),
              style: const TextStyle(color: Colors.black, decorationThickness: 0),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black12,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: BorderSide.none),
                  hintText: "Search here",
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: Colors.white),
            ),
          ),

          FutureBuilder(
              future: getAllContacts(),
              builder: (context, AsyncSnapshot<List<Contact>> dataSnapShot) {
                if (dataSnapShot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (dataSnapShot.data == null) {
                  return const Center(
                    child: Text(
                      "Empty. No data found!",
                    ),
                  );
                }
                if (dataSnapShot.data!.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: dataSnapShot.data!.length,
                      itemBuilder: (context, index) {
                        Contact eachContact = dataSnapShot.data![index];
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.redAccent, width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            onTap: () {
                              Get.to(UpdateContact(contact: eachContact));
                            },
                            // for clickable list item
                            title: Text(
                              eachContact.contactName!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(eachContact.contactEmail! +
                                '\n' +
                                eachContact.contactPhone!),
                            leading: const Icon(
                              Icons.person,
                              size: 60,
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.call,
                                color: Colors.redAccent,
                                size: 30,
                              ),
                              onPressed: () {
                                makePhoneCall(
                                    eachContact.contactPhone.toString());
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: Text("Empty. No data found!"),
                  );
                }
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        //for making circle shape
        backgroundColor: Colors.redAccent,
        tooltip: "Add Contact",
        mini: false,
        onPressed: () {
          Get.to(const AddContact());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
