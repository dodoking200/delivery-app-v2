import 'package:flutter/material.dart';
import 'Register_Screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final _formKey = GlobalKey<FormState>();

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  Future<void> sendPostRequest() async {
    // Define the URL of your API
    final url = Uri.parse('http://192.168.201.103:8000/api/login');

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
    print(body);
    try {
      // Send POST request
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      // Check the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Success: ${response.body}');
      } else {
        print('Failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFF950),
        title: Center(
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
                Center(
                  child: Text(
                    'Welcome',
                    style: TextStyle(fontSize: 30.0, letterSpacing: 7.0),
                  ),
                ),
                SizedBox(
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
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
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
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscureText,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
                    fillColor: Color(0xFFA4FDAA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(
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
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  height: 40.0,

                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                  child: MaterialButton(
                    child: Text('Sign in'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        sendPostRequest();
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  child: Row(
                    children: [
                      Text('Don\'t have an account? '),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                        child: Text('Register now'),
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
        color: Color(0xFFFFF950),
        child: Container(height: 50.0, ),
      ),
    );
  }
}
