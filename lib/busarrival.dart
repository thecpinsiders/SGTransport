import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ArrivalData {
  final String url;
  final String busstopcode;
  final List<Services> service;

  ArrivalData({this.url, this.busstopcode, this.service});

  factory ArrivalData.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['Services'] as List;
    print(list.runtimeType);
    List<Services> serviceList = list.map((i) => Services.fromJson(i)).toList();

    return ArrivalData(
        url: parsedJson['odata.metadata'],
        busstopcode: parsedJson['BusStopCode'],
        service: serviceList);
  }
}

class Services {
  final String serviceno;
  final String operators;
  final NextBus nextbus;
  final NextBus2 nextbus2;
  final NextBus3 nextbus3;

  Services(
      {this.serviceno,
      this.operators,
      this.nextbus,
      this.nextbus2,
      this.nextbus3});

  factory Services.fromJson(Map<String, dynamic> parsedJson) {
    // var list = parsedJson['NextBus'] as List;
    // print(list.runtimeType);
    // List<NextBus> nextbusList = list.map((i) => NextBus.fromJson(i)).toList();

    // var list2 = parsedJson['NextBus2'] as List;
    // print(list2.runtimeType);
    // List<NextBus2> nextbus2List = list2.map((i) => NextBus2.fromJson(i)).toList();

    // var list3 = parsedJson['NextBus3'] as List;
    // print(list3.runtimeType);
    // List<NextBus3> nextbus3List = list3.map((i) => NextBus3.fromJson(i)).toList();

    return Services(
      serviceno: parsedJson['ServiceNo'],
      operators: parsedJson['Operator'],
      nextbus: parsedJson['NextBus'] == null
          ? null
          : NextBus.fromJson(parsedJson["NextBus"]),
      nextbus2: parsedJson['NextBus2'] == null
          ? null
          : NextBus2.fromJson(parsedJson["NextBus2"]),
      nextbus3: parsedJson['NextBus3'] == null
          ? null
          : NextBus3.fromJson(parsedJson["NextBus3"]),
    );
  }
}

class NextBus {
  final String origincode;
  final String destinationcode;
  final String estimatedarrival;
  final String latitude;
  final String longitude;
  final String visitNumber;
  final String load;
  final String feature;
  final String type;

  NextBus(
      {this.origincode,
      this.destinationcode,
      this.estimatedarrival,
      this.latitude,
      this.longitude,
      this.visitNumber,
      this.load,
      this.feature,
      this.type});

  factory NextBus.fromJson(Map<String, dynamic> parsedJson) {
    return NextBus(
        origincode: parsedJson['OriginCode'],
        destinationcode: parsedJson['DestinationCode '],
        estimatedarrival: parsedJson['EstimatedArrival'],
        latitude: parsedJson['Latitude'],
        longitude: parsedJson['Longitude'],
        visitNumber: parsedJson['VisitNumber'],
        load: parsedJson['Load'],
        feature: parsedJson['Feature'],
        type: parsedJson['Type']);
  }
}

class NextBus2 {
  final String origincode;
  final String destinationcode;
  final String estimatedarrival;
  final String latitude;
  final String longitude;
  final String visitNumber;
  final String load;
  final String feature;
  final String type;

  NextBus2(
      {this.origincode,
      this.destinationcode,
      this.estimatedarrival,
      this.latitude,
      this.longitude,
      this.visitNumber,
      this.load,
      this.feature,
      this.type});

  factory NextBus2.fromJson(Map<String, dynamic> parsedJson) {
    return NextBus2(
        origincode: parsedJson['OriginCode'],
        destinationcode: parsedJson['DestinationCode '],
        estimatedarrival: parsedJson['EstimatedArrival'],
        latitude: parsedJson['Latitude'],
        longitude: parsedJson['Longitude'],
        visitNumber: parsedJson['VisitNumber'],
        load: parsedJson['Load'],
        feature: parsedJson['Feature'],
        type: parsedJson['Type']);
  }
}

class NextBus3 {
  final String origincode;
  final String destinationcode;
  final String estimatedarrival;
  final String latitude;
  final String longitude;
  final String visitNumber;
  final String load;
  final String feature;
  final String type;

  NextBus3(
      {this.origincode,
      this.destinationcode,
      this.estimatedarrival,
      this.latitude,
      this.longitude,
      this.visitNumber,
      this.load,
      this.feature,
      this.type});

  factory NextBus3.fromJson(Map<String, dynamic> parsedJson) {
    return NextBus3(
        origincode: parsedJson['OriginCode'],
        destinationcode: parsedJson['DestinationCode '],
        estimatedarrival: parsedJson['EstimatedArrival'],
        latitude: parsedJson['Latitude'],
        longitude: parsedJson['Longitude'],
        visitNumber: parsedJson['VisitNumber'],
        load: parsedJson['Load'],
        feature: parsedJson['Feature'],
        type: parsedJson['Type']);
  }
}

Future<String> _loadArrivingAsset() async {
  final busstopcode = bscodeController.text;
  final response = await http.get(
      'http://datamall2.mytransport.sg/ltaodataservice/BusArrivalv2?BusStopCode=' +
          busstopcode,
      headers: {
        //if your api require key then pass your key here as well e.g "key": "my-long-key"
        "AccountKey": "b+8pVHKwRkyLKABbXVxmpQ=="
      });
  print(response.body);
  return response.body;
}

Future loadArriving() async {
  String jsonOperate = await _loadArrivingAsset();
  print("jsonoperate value " + jsonOperate);
  final jsonResponse = json.decode(jsonOperate);
  ArrivalData arrival = new ArrivalData.fromJson(jsonResponse);
  return arrival;
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: BusArrival(),
      ),
    );
  }
}

TextEditingController bscodeController = new TextEditingController();

class BusArrival extends StatefulWidget {
  BusArrival({Key key}) : super(key: key);

  @override
  _BusArrivalState createState() => _BusArrivalState();
}

class _BusArrivalState extends State<BusArrival> {
  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Center(
              child: Container(
                width: 600,
                height: 70,
                child: TextField(
                  controller: bscodeController,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Bus Stop Code',
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 40,
            width: 200,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            child: FlatButton(
              onPressed: () {
                setState(() {
                  loadArriving();
                });
                // Navigator.push(context, MaterialPageRoute(builder: (_) => MyApp()));
              },
              child: Text(
                'Search',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
          FutureBuilder(
            future: loadArriving(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.service.length,
                    itemBuilder: (BuildContext contect, int index) {
                      String formattedtime = "";
                      DateTime now = DateTime.parse(snapshot
                              .data.service[index].nextbus.estimatedarrival)
                          .toLocal();
                      final format = DateFormat('HH:mm');
                      formattedtime = format.format(now);

                      String load;
                       if(snapshot.data.service[index].nextbus.load == "SEA"){
                         load = "Seats Available";
                       } else if(snapshot.data.service[index].nextbus.load == "SDA"){
                         load = "Standing Available";
                       } else if(snapshot.data.service[index].nextbus.load == "LSD") {
                         load = "Limited Standing";
                       }
                      return new Card(
                        child: new Column(
                          children: <Widget>[
                            new Text(
                                "Bus Stop Code : " + snapshot.data.busstopcode,
                                textAlign: TextAlign.left),
                            new Text(
                                "Service : " +
                                    snapshot.data.service[index].serviceno,
                                textAlign: TextAlign.left),

                            new Text("Arrival time : " + formattedtime,
                                textAlign: TextAlign.left),
                            new Text(
                                "Load : " + load,
                                textAlign: TextAlign.left),
                            new Text(
                                "WAB / NWAB : " +
                                    snapshot
                                        .data.service[index].nextbus.feature,
                                textAlign: TextAlign.left),
                            new Text(
                                "Bus Type: " +
                                    snapshot.data.service[index].nextbus.type,
                                textAlign: TextAlign.left),
                          ],
                        ),
                      );
                    }
                  );
              } else if (snapshot.data == null) {
                return Text(
                    "Please enter a valid bus stop code to see arrival timings");
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}" + "${snapshot.data}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}

