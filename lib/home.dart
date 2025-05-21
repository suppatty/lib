import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:apart/buttom.dart';

class SubscriptionPage extends StatefulWidget {
  final String unit;
  final String phone;
  final String name;
  final String email;
  final int id;

  const SubscriptionPage({
    super.key,
    required this.unit,
    required this.phone,
    required this.name,
    required this.email,
    required this.id, required String status, required String duedate,
  });

  @override
  SubscriptionPageState createState() => SubscriptionPageState();
}

class SubscriptionPageState extends State<SubscriptionPage> {
  late String status = '';
  late String duedate = '';

  @override
  void initState() {
    super.initState();
    _fetchTenantDetails();
  }

  Future<void> _fetchTenantDetails() async {
    final url = Uri.parse('http://192.168.100.79/Mbackend/home.php?tenant_id=${widget.id}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData.containsKey('status')) {
          setState(() {
            status = responseData['status'];
            duedate = responseData['duedate'];
          });
        } else {
          debugPrint('Failed to load data: ${responseData['error']}');
        }
      } else {
        debugPrint('Server error. Please try again later.');
      }
    } catch (error) {
      debugPrint('An error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.grey[300],
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyanAccent, Colors.blueAccent.shade100],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Main content box
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                // "Unit Number" label displayed at the top of the box
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Unit Number: ${widget.unit}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 0), // Space between label and box

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        infoRow('Status', status),
                        const SizedBox(height: 16),
                        infoRow('Due Date:', duedate),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'View Details',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        unit: widget.unit,
        name: widget.name,
        phone: widget.phone,
        email: widget.email,
        id: widget.id,
        status: status,
        duedate: duedate,
      ),
    );
  }

  Widget infoRow(String label, String value) {
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
