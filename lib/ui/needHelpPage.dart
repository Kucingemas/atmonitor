import 'dart:io';

import 'package:atmonitor/handlers/jobsHandle.dart';
import 'package:atmonitor/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  final JobsHandle jobsHandle = JobsHandle();
  bool isPictureValidated = false;
  File pictureTaken;
  String solution = "";
  String problem = "";
  String kodeProblem = "";
  String placeHolderKodeProblem = "Pilih Kode Problem";
  String pictureEmpty = "tidak ada gambar";

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
                      ? "Isi solusi yang dicoba"
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
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Divider(),
          //test
          ListTile(
            title: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: Text(placeHolderKodeProblem),
                items: <String>['A', 'B', 'C', 'D'].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (selectedVal) {
                  setState(() {
                    placeHolderKodeProblem = selectedVal;
                    kodeProblem = selectedVal;
                  });
                },
              ),
            ),
          ),
          //end test
          Divider(),
          ListTile(
            title: Text("Unggah Bukti Gambar"),
            trailing: IconButton(
              icon: Icon(
                Icons.camera_alt,
                color: aBlue800,
              ),
              onPressed: () {
                takePicture(context, ImageSource.camera);
              },
            ),
            subtitle: Text("pratinjau: "),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          pictureTaken == null
              ? Text(pictureEmpty,
                  textAlign: TextAlign.center,
                  style: isPictureValidated
                      ? TextStyle(color: kShrineErrorRed)
                      : TextStyle(color: aBlue800))
              : Image.file(
                  pictureTaken,
                  height: 300.0,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topCenter,
                ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
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
              formKeyMasalah.currentState.validate() &&
              pictureTaken != null) {
            jobsHandle.helpJob(widget.jobs, widget.position);
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed("/acceptedjobs");
          }
          if (pictureTaken == null) {
            setState(() {
              isPictureValidated = true;
              pictureEmpty = "ambil gambar bukti terlebih dahulu";
            });
          }
        },
      ),
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
