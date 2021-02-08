import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login.dart';

class RegisterFormValidation extends StatefulWidget {
  RegisterFormValidation({Key key}) : super(key: key);

  @override
  _RegisterFormValidationState createState() => _RegisterFormValidationState();
}

class _RegisterFormValidationState extends State<RegisterFormValidation> {
  String _email, _password, _cfmpassword, _username, _error;

  TextEditingController passController = new TextEditingController();
  TextEditingController newpassController2 = new TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String validatePassword(String value) {
    if (value.isEmpty) {
      return "* Required";
    } else if (value.length < 6) {
      return "Password should be atleast 6 characters";
    } else if (value.length > 15) {
      return "Password should not be greater than 15 characters";
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Register For An Account"),
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidate: true, //check for validation while typing
          key: formkey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Center(
                  child: Container(
                      width: 200,
                      height: 125,
                      child: Text("SGTransport",
                          style: TextStyle(color: Colors.black, fontSize: 35))),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15),
                child: TextFormField(
                  onChanged: (text) {
                    _username = text;
                    print(_username);
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      hintText: 'Enter Username'),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "* Required"),
                  ]),
                  onSaved: (input) => _username = input,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter valid email id as abc@gmail.com'),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "* Required"),
                    EmailValidator(errorText: "Enter valid email id"),
                  ]),
                  onSaved: (input) => _email = input,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15),
                child: TextFormField(
                  obscureText: true,
                  controller: passController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password'),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "* Required"),
                    MinLengthValidator(6,
                        errorText: "Password should be atleast 6 characters"),
                    MaxLengthValidator(15,
                        errorText:
                            "Password should not be greater than 15 characters")
                  ]),
                  onSaved: (input) => _password = input,
                  //validatePassword,        //Function to check validation
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15),
                child: TextFormField(
                  controller: newpassController2,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                      hintText: 'Enter secure password'),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "* Required"),
                    MinLengthValidator(6,
                        errorText: "Password should be atleast 6 characters"),
                    MaxLengthValidator(15,
                        errorText:
                            "Password should not be greater than 15 characters")
                  ]),
                  onSaved: (input) => _cfmpassword = input,
                  //validatePassword,        //Function to check validation
                ),
              ),
              showAlert(),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: FlatButton(
                  onPressed: signUp,
                  // () {
                  //   if (formkey.currentState.validate()) {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (_) => LoginFormValidation()));
                  //     print("Validated");
                  //   } else {
                  //     print("Not Validated");
                  //   }
                  // },
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp() async {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      try {
        print(passController.text);
        print(newpassController2.text);
        if (passController.text == newpassController2.text) {
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _email, password: _password)
              .then((input) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginFormValidation()));
            return input.user.updateProfile(displayName: _username.toString());
          });
        } else {
          setState(() {
            _error = 'Please ensure the 2 password are matching';
          });
        }
      } catch (e) {
        print(e.message);
      }
    }
  }

  Widget showAlert() {
    if (_error != null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Icon(Icons.error_outline),
            Expanded(
              child: Text(
                _error,
                maxLines: 3,
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox(height: 0);
  }
}
