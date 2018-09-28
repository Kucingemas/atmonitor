import 'dart:io';

import 'package:atmonitor/colors.dart';
import 'package:atmonitor/handlers/jobsHandle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class JobDoneConfirmationPage extends StatefulWidget {
  final List<DocumentSnapshot> jobs;
  final int position;

  JobDoneConfirmationPage(this.jobs, this.position);

  @override
  _JobDoneConfirmationPageState createState() =>
      _JobDoneConfirmationPageState();
}

class _JobDoneConfirmationPageState extends State<JobDoneConfirmationPage> {
  String solusi = "";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final jobsHandle = JobsHandle();
  File pictureTaken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Konfirmasi"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              ListTile(
                title: Form(
                  key: formKey,
                  child: TextFormField(
                    onSaved: (value) {
                      solusi = value;
                    },
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        labelText: "Solusi Yang Dikerjakan:",
                        border: OutlineInputBorder()),
                    initialValue: "",
                    validator: (value) => value.isEmpty || value == ""
                        ? "Isi solusi yang dikerjakan"
                        : null,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Divider(),
          ListTile(
            title: Text("Unggah Bukti Gambar"),
            trailing: InkWell(
              child: Icon(
                Icons.camera_alt,
                color: aBlue800,
              ),
              onTap: () {
                takePicture(context, ImageSource.camera);
              },
            ),
            subtitle: Text("pratinjau: "),
          ),
          SizedBox(
            height: 10.0,
          ),
          pictureTaken == null
              ? Text(
                  "tidak ada gambar",
                  textAlign: TextAlign.center,
                )
              : Image.file(
                  pictureTaken,
                  height: 300.0,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topCenter,
                )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(
            Icons.check,
            color: aBlue800,
          ),
          label: Text("Konfirmasi", style: TextStyle(color: aBlue800)),
          onPressed: () {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              jobsHandle.finishJob(
                  widget.jobs, widget.position, pictureTaken, solusi);
              formKey.currentState.reset();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/acceptedjobs");
            }
          }),
    );
  }

  void takePicture(BuildContext context, ImageSource imageSource) {
    ImagePicker.pickImage(
      source: imageSource,
      maxWidth: 400.0,
    ).then((File image) {
      setState(() {
        pictureTaken = image;
      });
    });
  }
}
