import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_phonebook/views/authentication/user_login.dart';
import 'package:flutter_phonebook/widgets/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../api/api_service.dart';

class UserSignup extends StatefulWidget {
  const UserSignup({super.key});

  @override
  State<UserSignup> createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {

  //Form controllers
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();


  // Form state variables
  final GlobalKey<FormState> registrationFormKey = GlobalKey();

  // for password icon state
  bool obscurePassword = true;

  //function for user sign up
  userRegistration() async {



        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext c) {
              return const ProgressDialog();
            });


      try {
        //api call to register user
        var request = await http.post(
          Uri.parse(API.userSignup),
          body: {
            "user_name": nameController.text.trim(),
            "user_email": emailController.text.trim(),
            "user_password": passwordController.text.trim(),
          },
        );

        if (request.statusCode == 200) {
          var responseData = jsonDecode(request.body);
          if (responseData['success'] == true) {
            Get.offAll(() => const UserLogin());
            Fluttertoast.showToast(msg: "Signup Successful");
          } else if (responseData['success'] == "exists") {
            Fluttertoast.showToast(msg: "User already exists!");
            Get.back();
          } else {
            Fluttertoast.showToast(msg: "Wrong email or password");
            Get.back();
          }
        }
      } catch (e) {
        log(e.toString());
      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.redAccent,
        title: const Text(
          'Signup',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: registrationFormKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 35),
              const Icon(
                Icons.person,
                size: 100,
              ),
              const SizedBox(height: 10),
              Text(
                "User Registration",
                style:
                    GoogleFonts.acme(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Your name",
                  hintText: "Your name",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Your password",
                  hintText: "Your password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      icon: obscurePassword
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter password";
                  } else if (value.length < 4) {
                    return "Password should be at least 4 characters long";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 60),
              Column(
                children: [
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        if (registrationFormKey.currentState!.validate()) {
                          registrationFormKey.currentState!.save();

                          //check internet connection
                         bool isConnected = await InternetConnectionChecker().hasConnection;

                          if (!isConnected) {
                            Fluttertoast.showToast(
                                msg: "No internet connection. Please try again.");
                            return;
                          }
                          else

                            {
                              // call signup function
                              userRegistration();
                            }

                        }
                      },
                      child: Text(
                        "Signup",
                        style: GoogleFonts.acme(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          registrationFormKey.currentState?.reset();
                          Get.offAll(const UserLogin());
                        },
                        child: const Text(
                          "Login now",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
