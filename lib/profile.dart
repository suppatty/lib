import 'package:apart/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:apart/buttom.dart'; 

class ProfilePage extends StatefulWidget {
  final String unit;
  final String name;
  final String phone;
  final String email;
  final String status;
  final String duedate;
  final int id;

  const ProfilePage({
    super.key,
    required this.unit,
    required this.name,
    required this.phone,
    required this.email,
    required this.status,
    required this.duedate,
    required this.id,
  });

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late String fetchedName = widget.name;
  late String fetchedPhone = widget.phone;
  late String fetchedEmail = widget.email;
  late String fetchedStatus = widget.status;
  late String fetchedDueDate = widget.duedate;
  late String fetchedUnit = widget.unit;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

 Future<void> _fetchUserProfile() async {
  final url = Uri.parse('http://192.168.100.79/Mbackend/profile.php?id=${widget.id}');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        setState(() {
          fetchedName = responseData['name'] ?? fetchedName;
          fetchedPhone = responseData['phone'] ?? fetchedPhone;
          fetchedEmail = responseData['email'] ?? fetchedEmail;
          fetchedUnit = responseData['unit'] ?? fetchedUnit;
        });
      } else {
        _showErrorDialog('Error', responseData['message']);
      }
    } else {
      _showErrorDialog('Error', 'Server error. Please try again later.');
    }
  } catch (error) {
    _showErrorDialog('Error', 'An error occurred: $error');
  }
}
  void _showErrorDialog(String title, String message) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.grey[300],
        elevation: 0,
      ),
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
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.0),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Unit No. $fetchedUnit',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildProfileRow('Name:', fetchedName),
                  const Divider(color: Colors.blueAccent),
                  _buildProfileRow('Phone:', fetchedPhone),
                  const Divider(color: Colors.blueAccent),
                  _buildProfileRow('Email:', fetchedEmail),
                  const Divider(color: Colors.blueAccent),
                  _buildProfileRow('Unit:', fetchedUnit),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        unit: fetchedUnit,
        status: fetchedStatus,
        name: fetchedName,
        phone: fetchedPhone,
        duedate: fetchedDueDate,
        email: fetchedEmail,
        id: widget.id,
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.blueAccent,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.blueAccent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}