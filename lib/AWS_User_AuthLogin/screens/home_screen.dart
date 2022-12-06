import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tvapp/AWS_User_AuthLogin/screens/confirmation_screen.dart';
import 'package:tvapp/AWS_User_AuthLogin/screens/login_screen.dart';
import 'package:tvapp/AWS_User_AuthLogin/screens/signup_screen.dart';
import 'package:tvapp/globals.dart' as gb;
import 'package:path/path.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        //backgroundColor: Colors.grey,
        //appBar: AppBar(title: Text(widget.title),),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(bottom: 80.0),
                  child: Center(
                      child: Text(
                    gb.appName,
                    style: GoogleFonts.orbitron(
                        fontSize: 90,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ))),
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                width: screenSize.width * .5,
                child: ElevatedButton(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                ),
              ),
              /*   Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                width: screenSize.width * .5,
                child: ElevatedButton(
                  child: Text(
                    'Confirm Account',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConfirmationScreen()),
                    );
                  },
                ),
              ),   */
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                width: screenSize.width * .5,
                child: ElevatedButton(
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                width: screenSize.width * .5,
                child: ElevatedButton(
                  child: Text(
                    'Secure Counter',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    /*    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SecureCounterScreen()),
                    );   */
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
