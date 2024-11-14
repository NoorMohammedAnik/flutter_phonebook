import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_phonebook/views/home_page.dart';
import 'package:flutter_phonebook/widgets/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../api/api_service.dart';
import '../../model/contact.dart';

class UpdateContact extends StatefulWidget {
  final Contact contact;
  const UpdateContact({super.key,required this.contact});

  @override
  State<UpdateContact> createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {


  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  final GlobalKey<FormState> contactFormKey = GlobalKey();

  //function for update contact
  updateContact() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return const ProgressDialog();
        });

    try {
      var request = await http.post(Uri.parse(API.updateContact), body: {
        'contact_name': nameController.text.trim(),
        'contact_email': emailController.text.trim(),
        'contact_phone': phoneController.text.trim(),
        'contact_id': widget.contact.contactId.toString(),
      });

      if (request.statusCode == 200) {
        var response = jsonDecode(request.body);
        if (response['success'] == true) {
          Fluttertoast.showToast(msg: "Successfully updated");

          Get.offAll(const HomePage());
        } else {
          Fluttertoast.showToast(msg: "Error. Please try again");
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }


  //function for delete contact from server
  deleteContact() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return const ProgressDialog();
        });

    try {
      var request = await http.post(Uri.parse(API.deleteContact), body: {
        'contact_id': widget.contact.contactId.toString(),
      });

      if (request.statusCode == 200) {
        var response = jsonDecode(request.body);
        if (response['success'] == true) {
          Fluttertoast.showToast(msg: "Contact deleted");
          Get.offAll(const HomePage());
        } else {
          Fluttertoast.showToast(msg: "Error. Please try again");
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }


  @override
  void initState() {

    super.initState();

    //initially set data
    nameController.text=widget.contact.contactName.toString();
    phoneController.text=widget.contact.contactPhone.toString();
    emailController.text=widget.contact.contactEmail.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.redAccent,
        title: const Text(
          "Update Contact",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: contactFormKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [

              const Icon(
                Icons.person,
                size: 100,
              ),
              const SizedBox(
                height: 10,
              ),

              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Contact Name",
                  hintText: "Contact Name",
                  prefixIcon: const Icon(Icons.note_alt_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter contact name";
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Your email address",
                  hintText: "Your email address",
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null ||
                      !value.contains("@") ||
                      !value.contains(".")) {
                    return "Please enter a valid email address";
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  hintText: "Phone Number",
                  prefixIcon: const Icon(Icons.note_alt_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter phone number";
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  if (contactFormKey.currentState!.validate()) {
                    contactFormKey.currentState!.save();

                    updateContact();
                  }
                },
                child: const Text(
                  "Update Contact",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 10,),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  if (contactFormKey.currentState!.validate()) {
                    contactFormKey.currentState!.save();

                    deleteContact();
                  }
                },
                child: const Text(
                  "Delete Contact",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
