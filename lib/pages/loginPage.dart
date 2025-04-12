import 'package:ecalibre/pages/homePage.dart';
import 'package:ecalibre/pages/signupPage.dart';
import 'package:ecalibre/utils/myTextField.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    Future<void> loginUser() async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text, password: password.text);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(height: 200, width: 200),
              ),
              Text(
                'Get Started',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 24),
              ),
              Text('Day to Day Sales analysis in a single touch',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontStyle: FontStyle.italic)),
              SizedBox(height: 30),
              MyTextfield(
                textValueController: email,
                hintText: 'Email',
                labelText: 'Email',
                fieldIcon: Icon(Icons.email),
              ),
              SizedBox(height: 20),
              MyTextfield(
                textValueController: password,
                hintText: 'Password',
                labelText: ' Password',
                fieldIcon: Icon(Icons.password_rounded),
              ),
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: MaterialButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    loginUser();
                  },
                  child: Container(
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.all(0),
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        gradient: LinearGradient(
                            colors: [Colors.purpleAccent, Colors.blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight)),
                    child: Center(
                      child: const Text(
                        'L O G I N',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an Account ?",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Signuppage()));
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
