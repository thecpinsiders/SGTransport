import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'about.dart';
import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Profile(),
      ),
    );
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

TextEditingController newpassController = new TextEditingController();
TextEditingController newpassController2 = new TextEditingController();
String _password, _cfmpassword, _error;

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                "Your Profile",
                style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.blueGrey,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Username: " +
                    FirebaseAuth.instance.currentUser.displayName.toString(),
                style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.blueGrey,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Email:" + FirebaseAuth.instance.currentUser.email,
                style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.blueGrey,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 25,
              ),
             Text(
                "Change Password",
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15),
                width: 600,
                height: 65,
                child: TextFormField(
                  controller: newpassController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter New Password',
                  ),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "* Required"),
                    MinLengthValidator(6,
                        errorText: "Password should be atleast 6 characters"),
                    MaxLengthValidator(15,
                        errorText:
                            "Password should not be greater than 15 characters")
                  ]),
                  onSaved: (input) => _password = input,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15),
                width: 600,
                height: 65,
                child: TextFormField(
                  controller: newpassController2,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm New Password',
                  ),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "* Required"),
                    MinLengthValidator(6,
                        errorText: "Password should be atleast 6 characters"),
                    MaxLengthValidator(15,
                        errorText:
                            "Password should not be greater than 15 characters")
                  ]),
                  onSaved: (input) => _cfmpassword = input,
                ),
              ),
              showAlert(),
              Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                child: FlatButton(
                  onPressed: () {
                    if (newpassController.text == newpassController2.text) {
                      FirebaseAuth.instance.currentUser
                          .updatePassword(newpassController.text);
                      setState(() {
                        _error = 'Success!';
                      });
                    } else {
                      setState(() {
                        _error = 'Please ensure the 2 password are matching';
                      });
                    }
                  },
                  child: Text(
                    'Change password',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(10)),
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => About()));
                  },
                  child: Text(
                    'About App',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: FlatButton(
                  onPressed: () {
                    _signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                LoginFormValidation()),
                        ModalRoute.withName('/'));
                  },
                  child: Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ));
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
