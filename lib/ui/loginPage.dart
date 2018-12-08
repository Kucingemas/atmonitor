import 'package:atmonitor/handlers/authHandle.dart';
import 'package:atmonitor/utils/colors.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  TextEditingController _namaPenggunaController = TextEditingController();
  TextEditingController _kataSandiController = TextEditingController();
  final AuthHandle authHandle = AuthHandle();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        alignment: Alignment.center,
        child: ListView(
          padding: const EdgeInsets.all(25.0),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
            ),
            Image.asset(
              'images/logobagus.png',
              height: 250.0,
              width: 250.0,
            ),
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
                            onPressed: () => print("a "),
                            child: Text(
                              "LUPA PASSWORD",
                            )),
                        RaisedButton(
                          color: aOrange500,
                          onPressed: () {
                            authHandle.signIn(
                                _namaPenggunaController.text.toString(),
                                _kataSandiController.text.toString(),
                                context,
                                scaffoldKey);
                          },
                          child: Text(
                            "MASUK",
                            style: TextStyle(color: aBlue800),
                          ),
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
