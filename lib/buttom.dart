import 'package:flutter/material.dart';
import 'package:apart/home.dart';
import 'package:apart/profile.dart';
import 'package:apart/message.dart';

class CustomBottomNavigationBar extends StatelessWidget {
final String unit; // The unit number passed from the previous page
  final String name;
  final String phone;
  final String email;
  final String status;
  final String duedate;
  final int id;





  const CustomBottomNavigationBar({super.key,
  
  required this.unit,
  required this.status,
  required this.name,
  required this.phone,
  required this.duedate,
  required this.email,
  required this.id,
  
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.grey[300],
      selectedItemColor: Colors.grey,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.support_agent),
          label: 'Support',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  SubscriptionPage(unit: unit, status: status, duedate: duedate, phone: phone, name: name, email: email, id: id,)), // Ensure SubscriptionPage is imported
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MessagePage (id: id, name: name, email: email, )), // Ensure SubscriptionPage is imported
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  ProfilePage(unit: unit, name: name, phone: phone, email: email, id: id, status: status, duedate: duedate,)), // Ensure ProfilePage is imported
            );
            break;
        }
      },
    );
  }
}