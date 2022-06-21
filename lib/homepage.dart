import 'dart:convert';

import 'package:class_project/response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'constants.dart';


class MyHomePage extends StatefulWidget {

   final String title;

  const MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String value = '';

  @override
  void initState() {
    super.initState();
    // _getData(context,);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = new  TextEditingController();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Check Weather'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Search weather By City Name. \nExample: Kuala Lumpur', style: TextStyle(fontWeight: FontWeight.w700),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Kuala Lumpur",
                suffixIcon: IconButton(
                  onPressed: () {
                    showLoaderDialog(context);
                    _getData(context,_controller.text);},
                  icon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          SizedBox(height: 100,),
          Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  value,
                ),
                Text(
                  '',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
          ),
        ],),
      ),


    );
  }

  _getData(
      BuildContext context,String city,
      ) async {
    final uri = Constants.BASE_URL +city+
        '&APPID=5fcc1ed82149c74f4644a946551ded05';

    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    Response getResponse = await get(Uri.parse(uri), headers: headers);

    setState(() {
      Navigator.pop(context);
      int statusCode = getResponse.statusCode;
      String responseBody = getResponse.body;
      print('response----' + responseBody);
      var loginResponse = weatherResponeFromJson(responseBody);
      if (loginResponse.main != null) {
        print(" status 200");

        String city = loginResponse.name;
        String description = loginResponse.weather[0].description;
        double tempInCelcius = loginResponse.main.temp - 273.15;
        var temp= new Runes(tempInCelcius.toStringAsPrecision(3) +'\u00B0C\n');
        value = city + '\n' + new String.fromCharCodes(temp) + description;
      } else {
        _showAlert(context, "Some error occured, Try again!!!");
      }
    });
  }
  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
  void _showAlert(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Login"),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}