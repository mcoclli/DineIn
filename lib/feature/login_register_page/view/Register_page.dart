import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({required Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Define controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Register',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // Add your register form components here, such as text fields for username, email, password, etc.
            TextFormField(
              controller: _usernameController, // Assign controller
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _emailController, // Assign controller
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _passwordController, // Assign controller
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement registration logic here
                String username = _usernameController.text;
                String email = _emailController.text;
                String password = _passwordController.text;
                   print("IS pressed");
                // Validate registration data (You might want to add more sophisticated validation)
                if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
                  // Registration successful
                  // You can now send this information to your backend for registration
                  print('Registration successful');
                } else {
                  // Show an error message if any field is empty
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please fill in all fields.'),
                    duration: Duration(seconds: 2),
                  ));
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed to avoid memory leaks
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
