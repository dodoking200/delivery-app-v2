import 'package:flutter/material.dart';
import 'Register_Screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Token_Secure_Storage.dart';
import '../main.dart';
import '../MAIN/main_screen.dart';

final _formKey = GlobalKey<FormState>();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});


  @override
  _LoginScreenState createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  Future<void> sendPostRequest() async {
    // Define the URL of your API
    final url = Uri.parse(constructImageUrl('api/login'));

    // Define the headers
    final headers = {
      'Content-Type': 'application/json', // Ensures you're sending JSON
      'Authorization': 'Bearer your_token_here', // Replace with your actual token
    };

    // Define the body (if you're sending data)
    final body = jsonEncode({
      'mobile_number': phoneController.text,
      'password': passwordController.text,
    });

    try {
      // Send POST request
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      // Check the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Navigate to the main screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen()),
              (Route<dynamic> route) => false,
        );

        // Save the token securely using the static method
        String token = jsonDecode(response.body)['token'].toString(); // Ensure token is a string
        await TokenSecureStorage.saveToken(token);
        print('Success: $token');
      } else {
        // Show an alert with the error message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Failed with status: ${response.statusCode}\nResponse: ${response.body}'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );

        print('Failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      // Show an alert for the exception
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('An error occurred: $e'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      print('Error occurred: $e');
    }
  }



  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Center(
          child: Text(
            'Login',
            style: TextStyle(
                color: Colors.grey, fontSize: 30.0, letterSpacing: 7.0),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0,40.0,20.0,40.0),
          child: Form(
            key: _formKey,  // Use the form key here
            child: Column(
              children: [
                const Center(
                  child: Text(
                    'Welcome',
                    style: TextStyle(fontSize: 30.0, letterSpacing: 7.0),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                TextFormField(
                  controller: phoneController,
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.center,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Phone number is required';
                    } else if (value.length != 10) {
                      return 'Phone number should be 10 digits';
                    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                      return 'Phone number should only contain digits';
                    }
                    return null; // Return null if validation passes
                  },
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFA4FDAA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    hintText: 'Phone Number',
                    hintStyle: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscureText,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Password is required';
                    } else if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    return null; // Return null if validation passes
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFA4FDAA),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    hintText: 'Password',
                    hintStyle: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
                      letterSpacing: 2.0,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.visibility ,
                        color: _obscureText ? Colors.grey : Colors.green,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                          print(_obscureText);
                        });
                      },
                    ),
                  ),

                ),
                const SizedBox(
                  height: 30.0,
                ),
                Container(
                  height: 40.0,

                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                  child: MaterialButton(
                    child: const Text('Sign in'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        sendPostRequest();

                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Container(
                  child: Row(
                    children: [
                      const Text('Don\'t have an account? '),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text('Register now'),
                      ),TextButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const MainScreen()),
                                (Route<dynamic> route) => false,
                          );
                        },
                        child: const Text('Skip'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color:  Colors.yellow,
        child: Container()
      ),
    );
  }
}
