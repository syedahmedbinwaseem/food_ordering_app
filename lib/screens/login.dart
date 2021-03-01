import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/utils/colors.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Container(
      height: height * 0.75,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Form(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: width * 0.05,
              ),
              Text(
                'Login to account',
                style: TextStyle(
                  fontSize: width * 0.07,
                  fontFamily: 'Sofia',
                ),
              ),
              SizedBox(
                height: width * 0.05,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style: TextStyle(fontFamily: 'Sofia'),
                validator: (value) {
                  return value.isEmpty
                      ? 'Email is required'
                      : validateEmail(value) == 1
                          ? 'Invalid email'
                          : null;
                },
                controller: email,
                decoration: InputDecoration(
                  errorStyle: TextStyle(
                      fontFamily: 'Sofia', color: Colors.red, fontSize: 14),
                  labelText: 'Email',
                  labelStyle: TextStyle(
                      fontFamily: 'Sofia', color: Colors.black, fontSize: 14),
                ),
              ),
              TextFormField(
                obscureText: true,
                style: TextStyle(fontFamily: 'Sofia'),
                validator: (value) {
                  return value.isEmpty ? 'Password is required' : null;
                },
                controller: password,
                decoration: InputDecoration(
                  errorStyle: TextStyle(
                      fontFamily: 'Sofia', color: Colors.red, fontSize: 14),
                  labelText: 'Password',
                  labelStyle: TextStyle(
                      fontFamily: 'Sofia', color: Colors.black, fontSize: 14),
                ),
              ),
              SizedBox(
                height: width * 0.05,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot password?',
                  style: TextStyle(color: primaryGreen, fontFamily: 'Sofia'),
                ),
              ),
              SizedBox(
                height: width * 0.08,
              ),
              FlatButton(
                onPressed: () {
                  // FocusScope.of(context).unfocus();
                  if (fKey.currentState.validate()) {
                    print(email.text);
                    FocusScope.of(context).unfocus();

                    // logIn();
                  }
                },
                height: 40,
                color: primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                        fontFamily: 'Sofia',
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

int validateEmail(String value) {
  if (value.isEmpty) return 2;

  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regex = new RegExp(pattern);

  if (!regex.hasMatch(value.trim())) {
    return 1;
  }
  return 0;
}
