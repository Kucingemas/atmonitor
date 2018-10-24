import 'package:atmonitor/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NeedHelpPage extends StatefulWidget {
  final int position;
  final List<DocumentSnapshot> jobs;

  NeedHelpPage(this.position, this.jobs);

  @override
  _NeedHelpPageState createState() => _NeedHelpPageState();
}

class _NeedHelpPageState extends State<NeedHelpPage> {
  final GlobalKey<FormState> formKeySolusi = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyMasalah = GlobalKey<FormState>();
  String solution = "";
  String problem = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minta Bantuan"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          ListTile(
            title: Form(
                key: formKeySolusi,
                child: TextFormField(
                  onSaved: (value) {
                    solution = value;
                  },
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      labelText: "Solusi Yang Dicoba",
                      border: OutlineInputBorder()),
                  initialValue: "",
                  validator: (value) => value.isEmpty || value == ""
                      ? "Isi solusi yang dicoba!"
                      : null,
                )),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          ListTile(
            title: Form(
                key: formKeyMasalah,
                child: TextFormField(
                  onSaved: (value) {
                    problem = value;
                  },
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      labelText: "Masalah Yang Dihadapi",
                      border: OutlineInputBorder()),
                  initialValue: "",
                  validator: (value) => value.isEmpty || value == ""
                      ? "Isi masalah yang dihadapi"
                      : null,
                )),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(
          Icons.person_add,
          color: aBlue800,
        ),
        label: Text("Minta Bantuan", style: TextStyle(color: aBlue800)),
        onPressed: () {
          if (formKeySolusi.currentState.validate() &&
              formKeyMasalah.currentState.validate()) {
            print("a");
          }
        },
      ),
    );
  }
}
