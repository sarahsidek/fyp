import 'package:fyp/screen/crud/listRoadGang.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screen/crud/AddRoadGang.dart';

class HomeRoadGang extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('Buruh Kakitangan'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddRoadGang()));
              })
        ],
      ),
      body: ListRoadGang(),
    );
  }
}


