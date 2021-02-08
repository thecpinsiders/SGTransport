import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

 class OperateData {
        final List<Value> value;

        OperateData({this.value});

        factory OperateData.fromJson(Map<String, dynamic> parsedJson){

            var list = parsedJson['value'] as List;
            print(list.runtimeType);
            List<Value> valueList = list.map((i) => Value.fromJson(i)).toList();


            return OperateData(
                value: valueList
            );
        }
        }

        class Value {
        final String serviceno;
        final String operators;
               int direction;
               int stopSequence;
        final String busStopCode;
        final String distance;
        final String wd_FirstBus;
        final String wd_LastBus;
        final String sat_FirstBus;
        final String sat_LastBus;
        final String sun_FirstBus;
        final String sun_LastBus;

        Value({this.serviceno,this.operators,this.direction,this.stopSequence,this.busStopCode,this.distance,this.wd_FirstBus,this.wd_LastBus,this.sat_FirstBus,this.sat_LastBus,this.sun_FirstBus,this.sun_LastBus});

        factory Value.fromJson(Map<String, dynamic> parsedJson){
            return Value(
                serviceno:parsedJson['ServiceNo'],
                operators:parsedJson['Operator'],
                direction:parsedJson['Direction'],
                stopSequence:parsedJson['StopSequence'],
                busStopCode:parsedJson['BusStopCode'],
                distance:parsedJson['distance'],
                wd_FirstBus:parsedJson['WD_FirstBus'],
                wd_LastBus:parsedJson['WD_LastBus'],
                sat_FirstBus:parsedJson['SAT_FirstBus'],
                sat_LastBus:parsedJson['SAT_LastBus'],
                sun_FirstBus:parsedJson['SUN_FirstBus'],
                sun_LastBus:parsedJson['SUN_LastBus']
            );
        }
        }

 Future<String> _loadOperatingAsset() async {
 final response =
      await http.get('http://datamall2.mytransport.sg/ltaodataservice/BusRoutes',      
      headers: {
        //if your api require key then pass your key here as well e.g "key": "my-long-key"
       "AccountKey": "b+8pVHKwRkyLKABbXVxmpQ==" 
      }
      );
      print(response.body);
      return response.body;
}

    Future loadOperating() async {
    String jsonOperate = await _loadOperatingAsset();
    print("jsonoperate value " + jsonOperate);
    final jsonResponse = json.decode(jsonOperate);
    OperateData operate = new OperateData.fromJson(jsonResponse);
    //print(operate);
    print(operate.value[1].serviceno);
    print(operate.value[1].operators);
    return operate;
    }


void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        body: OperatingHoursPage(),
      ),
    );
  }
}

class OperatingHoursPage extends StatefulWidget {
  OperatingHoursPage({Key key}) : super(key: key);

  @override
  _OperatingHoursPageState createState() => _OperatingHoursPageState();
}

class _OperatingHoursPageState extends State<OperatingHoursPage> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
 body: Center(
          child: FutureBuilder(
            future: loadOperating(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                  return
               ListView.builder(
                 itemCount: snapshot.data.value.length,
                 itemBuilder: (BuildContext contect, int index){
                   return new Card(
                     //child: new Text("Service "+snapshot.data.value[index].serviceno + "  BusStopCode " + snapshot.data.value[index].busStopCode + "  Weekday First bus " + snapshot.data.value[index].wd_FirstBus +"  Weekday Last bus " + snapshot.data.value[index].wd_LastBus ),
                      child: new Column (
                      children: <Widget>[
                new Text ("Bus Service Number : " + snapshot.data.value[index].serviceno, textAlign: TextAlign.left),
                new Text ("BusStopCode : " + snapshot.data.value[index].busStopCode, textAlign: TextAlign.left),
                new Text ("First Bus Timing On Weekdays At This Bus Stop : " + snapshot.data.value[index].wd_FirstBus, textAlign: TextAlign.left),
                new Text ("Last Bus Timing On Weekdays At This Bus Stop : " + snapshot.data.value[index].wd_LastBus, textAlign: TextAlign.left),
                new Text ("First Bus Timing On Saturday At This Bus Stop : " + snapshot.data.value[index].sat_FirstBus, textAlign: TextAlign.left),
                new Text ("Last Bus Timing On Saturday At This Bus Stop : " + snapshot.data.value[index].sat_LastBus, textAlign: TextAlign.left),
                new Text ("First Bus Timing On Sunday At This Bus Stop : " + snapshot.data.value[index].sun_FirstBus, textAlign: TextAlign.left),
                new Text ("Last Bus Timing On Sunday At This Bus Stop : " + snapshot.data.value[index].sun_LastBus, textAlign: TextAlign.left),
        ],
      ),
                   );
                 }
               );
            //  Text(snapshot.data.value[1].serviceno),
            //  Text(snapshot.data.value[1].serviceno)
                //Text(snapshot.data.operator);
                //Text(snapshot.data.category);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      );
  }
}
