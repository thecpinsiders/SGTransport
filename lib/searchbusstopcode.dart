import 'package:flutter/material.dart';
 
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
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}

//this is temporary not in use

class SearchBusStopCode extends StatelessWidget {
  const SearchBusStopCode({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Container(
                      width: 200,
                      height: 125,
                      child: Text("Search By Bus Stop Code", style: TextStyle(color: Colors.black, fontSize: 20))
                      ),
                ),
              ),
            ],
       ),
     );
  }
}