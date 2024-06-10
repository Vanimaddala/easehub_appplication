import 'dart:convert';
import 'package:flutter/material.dart';
import 'hod_page.dart';
import http.dart
import 'security.dart';
import 'faculty.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _token;
  bool _isLoading = false;
  bool _loginFailed = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _login(String username, String password) async {
    setState(() {
      _isLoading = true;
      _loginFailed = false;
    });

    try {
      final url =
          'https://easehub-production.up.railway.app/api/v1/auth/authenticate';
      final map = {
        'username': username,
        'password': password,
      };

      final response = await http.post(
        Uri.parse(url),
        body: json.encode(map),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        _token = jsonResponse['accessToken'];
        _loginSuccess(jsonResponse);
        print('Login successful');
      } else if (response.statusCode == 403) {
        setState(() {
          _loginFailed = true;
          _isLoading = false;
        });
        print('Authorization failed: ${response.statusCode}');
      } else {
        setState(() {
          _loginFailed = true;
        });
      }
    } catch (e) {
      setState(() {
        _loginFailed = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loginSuccess(Map<String, dynamic> jsonResponse) {
    final role = jsonResponse['role'] as String?;
    final branch = jsonResponse['branch'] as String?;
    final name = jsonResponse['name'] as String?;

    print('Name: $name, Role: $role, Branch: $branch');

    if (_token != null) {
      // Route based on role and branch
      if (role == 'security') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SecurityPage(name: name!),
          ),
        );
      } else if (role == 'HOD') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HodPage(
              name: name!,
              role: role!,
              branch: branch!,
            ),
          ),
        );
      } 
        else if (role != 'HOD' && role != 'SECURITY') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FacultyPage(
              name: name!,
              role: role!,
              branch: branch!,
            ),
          ),
        );
      }
    } else {
      // Handle the case when token is null
      print('Token not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();
    return FadeTransition(
      opacity: _animation,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          backgroundColor: Colors.blue[900],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(Icons.person, color: Colors.black),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(Icons.lock, color: Colors.black),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        _login(
                          _usernameController.text,
                          _passwordController.text,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[900],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
              if (_loginFailed)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Login failed. Please try again.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}