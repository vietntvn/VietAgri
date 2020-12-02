import 'package:flutter/material.dart';
import 'package:vietagri/pages/auth/login.dart';
import 'package:vietagri/pages/auth/signup.dart';
import 'package:vietagri/widgets/raised-button.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/mask_group.png'),
                fit: BoxFit.cover
              ),
            )
          ),
          Positioned(
            top: 100.0,
            left: MediaQuery.of(context).size.width / 2 - 90.0,
            child: Text('VietAgri', style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 50.0,
              fontWeight: FontWeight.bold
            ))
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: raisedButton(
                    label: Text('Sign up', style: TextStyle(fontSize: 16.0)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Signup()
                        )
                      );
                    },
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                  ),
                  width: 250.0,
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                SizedBox(
                  child: raisedButton(
                    label: Text('Login', style: TextStyle(fontSize: 16.0)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login()
                        )
                      );
                    },
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                  ),
                  width: 250.0,
                )
              ],
            )
          )
        ],
      ),
    );
  }
}