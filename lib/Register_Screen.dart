import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

final _formKey = GlobalKey<FormState>();

class _RegisterScreenState extends State<RegisterScreen> {
  Future<void> sendPostRequest() async {
    // Define the URL of your API
    final url = Uri.parse(constructImageUrl('api/register'));

    // Define the headers
    final headers = {
      'Content-Type': 'application/json',
      // Ensures you're sending JSON
      'Authorization': 'Bearer your_token_here',
      // Replace with your actual token
    };

    // Define the body (if you're sending data)
    final body = jsonEncode({
      'first_name': firstController.text,
      'last_name': lastController.text,
      'location': locationController.text,
      'image': "",
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

  final firstController = TextEditingController();
  final lastController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final passwordController = TextEditingController();

  File? _selectedImage;

  // Future<void> _pickImage() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.image,
  //   );
  //
  //   if (result != null && result.files.single.path != null) {
  //     setState(() {
  //       _selectedImage = File(result.files.single.path!);
  //     });
  //     print("Image Path: ${_selectedImage!.path}"); // Debugging statement
  //   } else {
  //     print("No image selected");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFF950),
          title: const Center(
              child: Text(
            'login',
            style: TextStyle(
                color: Colors.grey, fontSize: 30.0, letterSpacing: 7.0),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // imageProfile(),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    controller: firstController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Name is required';
                      } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                        return 'Name must contain only letters and spaces';
                      }
                      return null; // Return null if validation passes
                    },
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
                      hintText: 'First name',
                      hintStyle: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    controller: lastController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Name is required';
                      } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                        return 'Name must contain only letters and spaces';
                      }
                      return null; // Return null if validation passes
                    },
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
                      hintText: 'Last name',
                      hintStyle: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      ),
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
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
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
                    height: 7.0,
                  ),
                  TextFormField(
                    controller: locationController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Location is required';
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
                      hintText: 'location',
                      hintStyle: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Password is required';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
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
                      hintText: 'password',
                      hintStyle: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey,
                        letterSpacing: 2.0,
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
                      child: const Text('Submit'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          sendPostRequest();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.yellow,
          child: Container(),
        ));
  }
// Widget imageProfile() {
//   return Center(
//     child: GestureDetector(
//       onTap: _pickImage, // Trigger image picking when tapped
//       child: Container(
//         width: 210, // Circle container width
//         height: 210, // Circle container height
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: Colors.black, // Border color
//             width: 1.0, // Border width
//           ),
//         ),
//         child: _selectedImage == null
//             ? CircleAvatar(
//           radius: 100, // CircleAvatar size
//           backgroundColor: Color(0xFFA4FDAA), // Green background
//           child: Icon(
//             Icons.person, // Default icon when no image is selected
//             size: 100, // Icon size
//             color: Colors.white, // Icon color
//           ),
//         )
//             : ClipOval(
//           child: Image.file(
//             _selectedImage!, // Ensure the selected file is loaded
//             width: 210, // Image width matches container
//             height: 210, // Image height matches container
//             fit: BoxFit.cover, // Ensures image covers the circle
//           ),
//         ),
//       ),
//     ),
//   );
// }
}
