import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rich_alert/rich_alert.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: SpinKitRipple(
          color: Colors.lightBlueAccent,
          size: 100,
        ),
        color: Colors.white,
        opacity: 0.8,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecorationStyle.copyWith(
                    hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecorationStyle.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                buttonColor: Colors.lightBlueAccent,
                buttonText: 'Login',
                buttonCallback: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (user != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return RichAlertDialog(
                            //uses the custom alert dialog
                            alertTitle: richTitle("Success!"),
                            alertSubtitle:
                                richSubtitle("Signed in successfully"),
                            alertType: RichAlertType.SUCCESS,
                          );
                        });
                  } catch (e) {
                    print(e);
                    setState(() {
                      showSpinner = false;
                    });
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return RichAlertDialog(
                            //uses the custom alert dialog
                            alertTitle: richTitle("Error!"),
                            alertSubtitle: richSubtitle(
                                "Invalid username and/or password"),
                            alertType: RichAlertType.ERROR,
                          );
                        });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
