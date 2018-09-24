import 'package:atmonitor/authHandle.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  var _namaPenggunaController = TextEditingController();
  var _kataSandiController = TextEditingController();
  final authHandle = AuthHandle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ATMonitor"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: ListView(
          padding: const EdgeInsets.all(25.0),
          children: <Widget>[
            Padding(padding: EdgeInsets.all(20.0)),
            Image.asset(
              'images/radar-chart.png',
              color: Colors.blue,
              height: 133.0,
              width: 200.0,
            ),
            Padding(padding: EdgeInsets.all(30.0)),
            Container(
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        //icon: Icon(Icons.face),
                        labelText: "Nama Pengguna: ",
                        border: OutlineInputBorder()),
                    controller: _namaPenggunaController,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        //icon: Icon(Icons.lock),
                        labelText: "Kata Sandi: ",
                        border: OutlineInputBorder()),
                    controller: _kataSandiController,
                    obscureText: true,
                  ),
                  Padding(padding: const EdgeInsets.all(10.0)),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                            onPressed: () => null,
                            child: Text(
                              "LUPA PASSWORD",
                              style: TextStyle(color: Colors.blue),
                            )),
                        RaisedButton(
                          onPressed: () {
                            authHandle.signIn(
                                _namaPenggunaController.text.toString(),
                                _kataSandiController.text.toString(),
                                context);
                          },
                          child: Text(
                            "MASUK",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
