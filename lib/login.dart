import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'homepage.dart';
import 'register.dart';
import 'about.dart';

class LoginFormValidation extends StatefulWidget {
  @override
  _LoginFormValidationState createState() => _LoginFormValidationState();
}

class _LoginFormValidationState extends State<LoginFormValidation> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String _email, _password,_error;

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
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidate: true, //check for validation while typing
          key: formkey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Container(
                      width: 200,
                      height: 125,
                      child: Text("SGTransport", style: TextStyle(color: Colors.black, fontSize: 35))
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Enter your email address'),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "* Required"),
                      EmailValidator(errorText: "Enter valid email id"),
                    ]),
                    onSaved: (input) => _email = input,
                    ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 15),
                child: TextFormField(
                    obscureText: true,
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
              showAlert(),
              // FlatButton(
              //   onPressed: () {
              //     //TODO FORGOT PASSWORD SCREEN GOES HERE
              //   },
                // child: Text(
                //   'Forgot Password',
                //   style: TextStyle(color: Colors.blue, fontSize: 15),
                // ),
              //),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: FlatButton(
                  onPressed: signIn,
                  // () {
                  //   if (formkey.currentState.validate()) {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (_) => homepage()));
                  //     print("Validated");
                  //   } else {
                  //     print("Not Validated");
                  //   }
                  // },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              
               Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10)),
                child: FlatButton(
                  onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => RegisterFormValidation()));
                  },
                  child: Text(
                    'New User? Create Account',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
                            SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(10)),
                child: FlatButton(
                  onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => About()));
                  },
                  child: Text(
                    'About',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
    Future<void> signIn() async {
       final formState = formkey.currentState;
       if(formState.validate()){
         formState.save();
         try {
           User user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)).user;
           Navigator.push(context, MaterialPageRoute(builder: (context) => homepage()));
         } catch(e){
          setState(() {
          _error = 'Please enter correct email and password';
           });
    return SizedBox(height: 0);
  }
         }
        
       }
    

Widget showAlert(){
    if(_error != null){
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Icon(Icons.error_outline),
            Expanded(
              child: Text(
                _error, maxLines: 3,
                ),
              ),
          ],
        ),
      );
    }
    return SizedBox(height: 0);
  }
}