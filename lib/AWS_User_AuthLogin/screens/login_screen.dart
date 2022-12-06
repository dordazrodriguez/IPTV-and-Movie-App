import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import 'package:flutter/material.dart';

import 'package:tvapp/globals.dart' as gb;
import 'package:tvapp/AWS_User_AuthLogin/screens/confirmation_screen.dart';
import 'package:tvapp/AWS_User_AuthLogin/secrets.dart';
import 'package:tvapp/AWS_User_AuthLogin/user.dart';
import 'package:tvapp/AWS_User_AuthLogin/user_service.dart';
import 'package:tvapp/src/movies/movies.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.email}) : super(key: key);

  final String email;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _userService = UserService(userPool);
  User _user = User();
  bool _isAuthenticated = false;

  Future<UserService> _getValues() async {
    await _userService.init();
    _isAuthenticated = await _userService.checkAuthenticated();
    return _userService;
  }

  submit(BuildContext context) async {
    _formKey.currentState.save();
    String message;
    try {
      _user = await _userService.login(_user.email, _user.password);
      message = 'User sucessfully logged in!';
      if (!_user.confirmed) {
        message = 'Please confirm user account';
      }
    } on CognitoClientException catch (e) {
      if (e.code == 'InvalidParameterException' ||
          e.code == 'NotAuthorizedException' ||
          e.code == 'UserNotFoundException' ||
          e.code == 'ResourceNotFoundException') {
        message = e.message;
      } else {
        message = 'An unknown client error occured';
      }
    } catch (e) {
      message = e.code; //'An unknown error occurred';
    }
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () async {
          setState(() {
            gb.currentUsersName = _user.name;
          });
          if (_user.hasAccess) {
            Navigator.pop(context);
            if (!_user.confirmed) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ConfirmationScreen(email: _user.email)),
              );
            } else {
              await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Movies(mode: 'movie')
                      //MainAppPage()
                      ));
            }
          }
        },
      ),
      duration: Duration(seconds: 30),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getValues(),
        builder: (context, AsyncSnapshot<UserService> snapshot) {
          print('userService hasData ${snapshot.hasData}');
          if (snapshot.hasData) {
            if (_isAuthenticated) {
              print('isAuthenticated $_isAuthenticated');
              //return SecureCounterScreen();
              //return MainAppPage();
            }
            final Size screenSize = MediaQuery.of(context).size;
            return Scaffold(
              appBar: AppBar(
                title: Text('Login'),
              ),
              body: Builder(
                builder: (BuildContext context) {
                  return Container(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.email),
                            title: TextFormField(
                              initialValue: widget.email,
                              decoration: InputDecoration(
                                  hintText: 'example@inspire.my',
                                  labelText: 'Email'),
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (String email) {
                                _user.email = email;
                              },
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.lock),
                            title: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Password'),
                              obscureText: true,
                              onSaved: (String password) {
                                _user.password = password;
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(20.0),
                            width: screenSize.width,
                            child: ElevatedButton(
                              child: Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                submit(context);
                              },
                            ),
                            margin: EdgeInsets.only(
                              top: 10.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return Scaffold(appBar: AppBar(title: Text('Loading...')));
        });
  }
}
