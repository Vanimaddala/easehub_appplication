import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'grant_event_permissions.dart';
import 'grant_outpass_permissions.dart';
import 'todays_permission_dashboard.dart';
import 'analytics.dart';
import 'login.dart';
import 'outpass_permission_list.dart';

class HodPage extends StatefulWidget {
  final String? name;
  final String? role;
  final String? branch;
  final String? token; // Add token variable

  const HodPage({Key? key, this.name, this.role, this.branch, this.token})
      : super(key: key);

  @override
  _CseHodPageState createState() => _CseHodPageState();
}

class _CseHodPageState extends State<HodPage> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CSE HOD'),
        backgroundColor: Colors.blue[900],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[900],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Department of Computer Science and Engineering',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Innovation and Excellence',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'HOD: ${widget.name}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Role: ${widget.role}'),
              subtitle: Text('Branch: ${widget.branch}'),
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/hod_image.jpg'),
              ),
            ),
            // Logout option
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.logout),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: <Widget>[
          GrantEventPermissions(),
          GrantOutpassPermissions(
              hodDepartment: widget.branch,
              token: widget.token!), // Pass token here
          TodaysPermissionDashboard(),
          Analytics(),
          OutpassPermissionListPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Event Permissions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_membership),
            label: 'Outpass Permissions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Outpass List',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[900],
        unselectedItemColor: Colors.black,
        onTap: (index) {
          if (index == 4) {
            _pageController.jumpToPage(index);
          } else {
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          }
        },
      ),
    );
  }
}