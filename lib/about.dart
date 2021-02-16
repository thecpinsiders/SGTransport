import 'package:flutter/material.dart';
import 'package:project/services/emailphone.dart';

class About extends StatelessWidget {
  const About({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("About Page"),
        ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                "About SGTransport",
                style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.black,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w400),
              ),
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage("add you image URL here "),
                        fit: BoxFit.cover)),
              ),
              SizedBox(
                height: 60,
              ),
              // Text(
              //   "About",
              //   style: TextStyle(
              //       fontSize: 25.0,
              //       color: Colors.black,
              //       letterSpacing: 2.0,
              //       fontWeight: FontWeight.w400),
              // ),
              SizedBox(
                height: 10,
              ),
              Text(
                "SGTransport is an all in one SG Bus arrival app for all 4 bus company. It can also search for bus stop and show you where the bus stop is located via google maps. It also shows the operating hours of a bus service at a particular bus stop.",
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 140,
              ),
              Text(
                "Developed By: Jemond Lee",
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Version 1.0.0",
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w400),
              ),
              buildButton(
                text: 'Email Us!',
                onClicked: () => Utils.openEmail(
                  toEmail: '183472L@mymail.nyp.edu.sg',
                  subject: 'On SGTransport',
                  body: 'Enter your message here',
                ),
              ),
              buildButton(
                text: 'Call Us!',
                onClicked: () => Utils.openPhoneCall(phoneNumber: '97237381'),
              ),
            ],
          ),
        ));
  }
}

Widget buildButton({
  @required String text,
  @required VoidCallback onClicked,
}) =>
    Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: RaisedButton(
        shape: StadiumBorder(),
        onPressed: onClicked,
        color: Colors.blue,
        textColor: Colors.white,
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
