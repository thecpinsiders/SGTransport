import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BusStopData {
  final String url;
  final List<Value> value;

  BusStopData({this.url, this.value});

  factory BusStopData.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['value'] as List;
    print(list.runtimeType);
    List<Value> valueList = list.map((i) => Value.fromJson(i)).toList();

    return BusStopData(url: parsedJson['odata.metadata'], value: valueList);
  }
}

class Value {
  final String busstopcode;
  final String roadname;
  final String description;
  final double latitude;
  final double longitude;

  Value(
      {this.busstopcode,
      this.roadname,
      this.description,
      this.latitude,
      this.longitude});

  factory Value.fromJson(Map<String, dynamic> parsedJson) {
    return Value(
      busstopcode: parsedJson['BusStopCode'],
      roadname: parsedJson['RoadName'],
      description: parsedJson['Description'],
      latitude: parsedJson['Latitude'],
      longitude: parsedJson['Longitude'],
    );
  }
}

Future<String> _loadBusStopAsset() async {
  final response = await http.get(
      'http://datamall2.mytransport.sg/ltaodataservice/BusStops',
      headers: {
        //if your api require key then pass your key here as well e.g "key": "my-long-key"
        "AccountKey": "b+8pVHKwRkyLKABbXVxmpQ=="
      });
  print(response.body);
  return response.body;
}

Future loadBusstop() async {
  String jsonOperate = await _loadBusStopAsset();
  print("jsonoperate value " + jsonOperate);
  final jsonResponse = json.decode(jsonOperate);
  BusStopData busstop = new BusStopData.fromJson(jsonResponse);
  return busstop;
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
        body: SearchBusStop(),
      ),
    );
  }
}

TextEditingController bsnameController = new TextEditingController();

class SearchBusStop extends StatefulWidget {
  SearchBusStop({Key key}) : super(key: key);

  @override
  _SearchBusStopState createState() => _SearchBusStopState();
}

class _SearchBusStopState extends State<SearchBusStop> {
  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      // appBar: AppBar(
      //   title: Text('SGTransport'),
      // ),
      // body: Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Center(
              child: Container(
                width: 600,
                height: 70,
                child: TextField(
                  controller: bsnameController,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Bus Stop Name',
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
                  loadBusstop();
                });
              },
              child: Text(
                'Search',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
          FutureBuilder(
            future: loadBusstop(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      for (index = 0;
                          index < snapshot.data.value.length;
                          index++) {
                        final busstopname = bsnameController.text.toString();
                        if (snapshot.data.value[index].description ==
                            busstopname) {
                          return new Card(
                            child: new Column(
                              children: <Widget>[
                                new Text(
                                    "Bus Stop Name : " +
                                        snapshot.data.value[index].description,
                                    textAlign: TextAlign.left),
                                new Text(
                                    "Road Name: " +
                                        snapshot.data.value[index].roadname,
                                    textAlign: TextAlign.left),
                                new Text(
                                    "Bus Stop Code : " +
                                        snapshot.data.value[index].busstopcode,
                                    textAlign: TextAlign.left),
                                new InkWell(
                                  child: Text(
                                    "Click to view in google maps ",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.green),
                                  ),
                                  onTap: () => launch(
                                      'https://maps.google.com/?q=@' +
                                          snapshot.data.value[index].latitude
                                              .toString() +
                                          "," +
                                          snapshot.data.value[index].longitude
                                              .toString()),
                                ),
                              ].toList(),
                            ),
                          );
                        } else if (busstopname == "") {
                          new Text("Please enter a bus stop name",
                              textAlign: TextAlign.left);
                        }
                      }
                    });
              } else if (snapshot.data == null) {
                return Text(
                    "Please enter a valid bus stop name to see bus stop info");
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
