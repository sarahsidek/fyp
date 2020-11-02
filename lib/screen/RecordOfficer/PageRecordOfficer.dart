import 'package:fyp/screen/RecordOfficer/addTask.dart';
import 'package:fyp/service/authRecordOfficer.dart';
import 'package:flutter/material.dart';

class RecordOfficer extends StatefulWidget {


  @override
  _RecordOfficerState createState() => _RecordOfficerState();
}
class _RecordOfficerState extends State<RecordOfficer> {

  final AuthRecordOfficer _officer = AuthRecordOfficer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:   FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.redAccent,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder:
                (context) => AddTask()));
          }
      ),
      appBar: AppBar(
        title: Text('Pegawai Merekod'),
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          FlatButton(
              child: Row(
                children: <Widget>[
                  Text("Keluar"),
                ],
              ),
              textColor: Colors.black87,
              onPressed: () async {
                await _officer.signOut();
                Navigator.pop(context);
              }
          )
        ],
      ),
    );
  }
}