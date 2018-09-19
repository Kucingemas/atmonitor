import 'package:atmonitor/ui/masterDrawer.dart';
import 'package:flutter/material.dart';

class HistoryAtmPage extends StatefulWidget {
  @override
  _HistoryAtmPageState createState() => _HistoryAtmPageState();
}

class _HistoryAtmPageState extends State<HistoryAtmPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Historik"),
        centerTitle: true,
      ),
      drawer: MasterDrawer(),
    );
  }
}
