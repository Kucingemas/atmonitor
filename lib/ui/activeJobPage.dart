import 'package:atmonitor/ui/masterDrawer.dart';
import 'package:flutter/material.dart';

class ActiveJobPage extends StatefulWidget {
  @override
  _ActiveJobPageState createState() => _ActiveJobPageState();
}

class _ActiveJobPageState extends State<ActiveJobPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pekerjaan Aktif"),
        centerTitle: true,
      ),
      drawer: MasterDrawer(),
    );
  }
}
