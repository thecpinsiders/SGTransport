import 'package:flutter/material.dart';

import 'busarrival.dart';
import 'operatinghours.dart';
import 'searchbusstop.dart';
import 'profile.dart';

class homepage extends StatefulWidget {
  homepage({Key key}) : super(key: key);

  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
              appBar: AppBar(
                title: Text('SGTransport'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.account_circle_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                       Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Profile()));
                   },
                  )
                ],
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'Bus Arrival'),
                    Tab(text: 'Operating Hours'),
                    Tab(text: 'Bus Stops'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  BusArrival(),
                  OperatingHoursPage(),
                  SearchBusStop(),
                ],
              )),
        ));
  }
}
