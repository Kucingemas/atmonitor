import 'dart:io';

import 'package:atmonitor/handlers/jobsHandle.dart';
import 'package:atmonitor/ui/partSearchDelegatesPage.dart';
import 'package:atmonitor/utils/colors.dart';
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
  final GlobalKey<FormState> formKeySolusi = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final jobsHandle = JobsHandle();
  bool isPictureValidated = false;
  String pictureEmpty = "tidak ada gambar";
  File pictureTaken;
  List<String> changedPartsSelected = List<String>();
  String solution = "";

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
                validator: (value) => value.isEmpty || value == ""
                    ? "Isi solusi yang dikerjakan"
                    : null,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    labelText: "Solusi Yang Dikerjakan:",
                    border: OutlineInputBorder()),
                initialValue: "",
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Divider(),
          ListTile(
            title: Text("Suku Cadang Yang Diganti"),
            subtitle: Text("daftar suku cadang: "),
            trailing: IconButton(
              icon: Icon(
                Icons.add_circle,
                color: aBlue800,
              ),
              onPressed: () async {
                showSearch(
                        context: context, delegate: PartsSearchDelegatesPage())
                    .then((part) {
                  part == null
                      ? debugPrint("part kosong tidak terlempar")
                      : changedPartsSelected.add(part.toString());
                });
              },
            ),
          ),
          changedPartsSelected.isEmpty
              ? Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "tidak ada suku cadang yang diganti",
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                    )
                  ],
                )
              : ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: changedPartsSelected.length,
                  itemBuilder: (BuildContext context, int position) {
                    return ListTile(
                        title: Text(changedPartsSelected[position].toString()),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.remove_circle,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            setState(() {
                              changedPartsSelected.removeAt(position);
                            });
                          },
                        ));
                  },
                ),
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
            Icons.check,
            color: aBlue800,
          ),
          label: Text("Konfirmasi", style: TextStyle(color: aBlue800)),
          onPressed: () {
            if (formKeySolusi.currentState.validate() && pictureTaken != null) {
              formKeySolusi.currentState.save();
              jobsHandle.finishJob(
                  widget.jobs, widget.position, pictureTaken, solution);
              formKeySolusi.currentState.reset();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/acceptedjobs");
            }
            if (pictureTaken == null) {
              setState(() {
                isPictureValidated = true;
                pictureEmpty = "ambil gambar bukti terlebih dahulu";
              });
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
