import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';  // Import SubscriptionPage

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // Function to login and get tenant details
Future<void> login() async {
  final url = Uri.parse('http://192.168.100.79/Mbackend/login.php');

  // Show a loading indicator
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  try {
    // HTTP request
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": emailController.text,
        "password": passwordController.text,
      }),
    );

    // Ensure the context is still valid
    if (!mounted) return;

    // Close the loading indicator
    Navigator.pop(context);

    // Handle the response
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

    if (responseData['success']) {
  // Retrieve necessary data (user ID and unit)
  String unit = responseData['unit'] ?? ''; 
  int id = responseData['id'] ?? 0; 

  // Navigate to the home page
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => SubscriptionPage(
        unit: unit, 
        status: '', 
        duedate: '', 
        phone: '', 
        name: '', 
        email: '', 
        id: id, // Pass the fetched id here
      ),
    ),
  );


      } else {
        // Show an error message for unsuccessful login
        showErrorDialog('Login Failed', responseData['message']);
      }
    } else {
      showErrorDialog('Error', 'Server error. Please try again later.');
    }
  } catch (error) {
    // Display error dialog on request failure
    if (mounted) {
      showErrorDialog('Error', 'An error occurred: $error');
    }
  }
}


  void showErrorDialog(String title, String message) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyanAccent, Colors.blueAccent.shade100],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.home,
                size: 80,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 10),
              const Text(
                'Apartment for User',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Added "Unit Number" title
             
              const SizedBox(height: 10), // Space between title and input box
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: login,
                child: const Text(
                  'Log In',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}