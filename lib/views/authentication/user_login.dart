import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_phonebook/views/authentication/user_signup.dart';
import 'package:flutter_phonebook/views/home_page.dart';
import 'package:flutter_phonebook/widgets/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../api/api_service.dart';
import '../../model/user.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  //Form controllers for email and password
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  //Storage for saving user information
  GetStorage box = GetStorage();

  //form state variables
  final GlobalKey<FormState> loginFormKey = GlobalKey();

  //variable for obscuring and revealing password
  bool obscurePassword = true;

  //function for user login
  userLogin() async {

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext c) {
            return const ProgressDialog();
          });

      try {
        //calling the API to authenticate user
        var request = await http.post(
          Uri.parse(API.userLogin),

          body: {
            "user_email": emailController.text.trim(),
            "user_password": passwordController.text.trim(),
          },
        );

        if (request.statusCode == 200) {
          var responseData = jsonDecode(request.body);
          if (responseData['success'] == true) {
            MyUser userInfo = MyUser.fromJson(responseData["userData"]);

            String userId = userInfo.userId.toString();

            //user id saved in local storage
            box.write("user_id", userId);

            Get.offAll(const HomePage());
            Fluttertoast.showToast(msg: "Login successful");

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
        backgroundColor: Colors.redAccent,
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: loginFormKey,
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
                "Login to your account",
                style:
                    GoogleFonts.acme(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 20),
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
                        if (loginFormKey.currentState!.validate()) {
                          loginFormKey.currentState!.save();

                          //Check internet connection
                         bool isConnected = await InternetConnectionChecker().hasConnection;

                          if (!isConnected) {
                            Fluttertoast.showToast(msg: "No internet connection");
                            return;
                          }
                          else
                            {
                              // call login function
                              userLogin();
                            }


                        }
                      },
                      child: Text(
                        "Login",
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
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          loginFormKey.currentState?.reset();

                          Get.to(() => const UserSignup());
                        },
                        child: const Text(
                          "Register now",
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
