import 'package:flutter/material.dart';
import 'home_page.dart'; // Import the HomePage file

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{
bool isSignUp = false;
bool _obscureTextPassword = true;
bool _obscureTextConfirmPassword = true;

@override
Widget build(BuildContext context) {
return Scaffold(

// Remove background color
backgroundColor: Colors.transparent,
body: Stack( // Use Stack to position the image behind the content
children: [
// Background image container
Container(
decoration: BoxDecoration(
image: DecorationImage(
image: AssetImage('assets/images/background4.jpg'), // Replace with your image path
fit: BoxFit.cover,

),
),
),
Center(
child: SingleChildScrollView(

child: Padding(
padding: const EdgeInsets.all(20.0),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,

children: <Widget>[
Container(
height: 200,
width: 200,
decoration: BoxDecoration(
shape: BoxShape.circle,
image: DecorationImage(
image: AssetImage('assets/images/logo.png'),
// Example image asset
fit: BoxFit.cover,
),
),
),
SizedBox(height: 20),
Card(
elevation: 8,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(10),
),
child: Padding(
padding: const EdgeInsets.all(20.0),

child: Column(
children: <Widget>[
Row(
mainAxisAlignment: MainAxisAlignment.center,
children:
[
GestureDetector(
onTap: () {
setState(() {
isSignUp = false;
});
},
child: Text(
"Sign in",
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
color: isSignUp ? Colors.black : Colors.orange,
),
),
),
SizedBox(width: 20),
GestureDetector(
onTap: () {
setState(() {
isSignUp = true;
});
},
child: Text(
"Sign up",
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
color: isSignUp ? Colors.orange : Colors.black,
),
),
),
],
),
SizedBox(height: 20),
isSignUp ? buildSignUpForm() : buildSignInForm(),
],
),
),
),
],
),
),
),
),
],
),
);
}
  Widget buildSignInForm() {
    return Column(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
            labelText: 'Username',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          obscureText: _obscureTextPassword,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureTextPassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.orange,
              ),
              onPressed: () {
                setState(() {
                  _obscureTextPassword = !_obscureTextPassword;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Checkbox(value: false, onChanged: (value) {}),
            Text('Remember me'),
            Spacer(),
            Text(
              'Forgot password?',
              style: TextStyle(color: Colors.orange),
            ),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Navigate to HomePage on successful login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          child: Text('Login'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text('Access with Touch ID', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget buildSignUpForm() {
    return Column(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
            labelText: 'Name',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'Phone number',
            prefixIcon: Icon(Icons.phone),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          obscureText: _obscureTextPassword,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureTextPassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.orange,
              ),
              onPressed: () {
                setState(() {
                  _obscureTextPassword = !_obscureTextPassword;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          obscureText: _obscureTextConfirmPassword,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureTextConfirmPassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.orange,
              ),
              onPressed: () {
                setState(() {
                  _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Checkbox(value: false, onChanged: (value) {}),
            Text('Remember me'),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Navigate to HomePage on successful sign-up
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          child: Text('Sign up'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
