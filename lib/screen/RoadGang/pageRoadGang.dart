import 'package:fyp/screen/MainPage.dart';
import 'package:fyp/screen/RoadGang/listOfLengkap.dart';
import 'package:fyp/screen/RoadGang/listOfPenambaikanSemula.dart';
import 'package:fyp/screen/RoadGang/listTaskFromSupervisor.dart';
import 'package:flutter/material.dart';
import 'package:fyp/service/authRoadGang.dart';
import 'package:google_fonts/google_fonts.dart';

class RoadGangHome extends StatefulWidget {
  @override
  _RoadGangHomeState createState() => _RoadGangHomeState();
}

class _RoadGangHomeState extends State<RoadGangHome> {
  final AuthRoadGang _authRoadGang = new AuthRoadGang();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buruh",style: GoogleFonts.andika(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor:  Colors.blue[800],
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed:() async{
                await _authRoadGang.signOut();
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => MainPage()));
              })
        ],
      ),
      body:GridView.count(
          mainAxisSpacing: 15.0,
          crossAxisSpacing: 15.0,
          primary: false,
          crossAxisCount: 2,
          children: [
            RaisedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ListTaskFromSupervisor()));
              },
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Icon(Icons.list_alt_sharp,  size: 110, color: Colors.black,),
                  Column(
                    children: [
                      new Text("Senarai Tugasan", style: GoogleFonts.andika(fontWeight: FontWeight.bold, fontSize: 15)),
                      new Text("Penyelia", style: GoogleFonts.andika(fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ListOfPenambaikanSemula()));
              },
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Icon(Icons.list_alt_sharp,  size: 110, color: Colors.red,),
                  Column(
                    children: [
                      new Text("Senarai Tugasan", style: GoogleFonts.andika(fontWeight: FontWeight.bold, fontSize: 15)),
                      new Text("Lengkap (TidakSah)", style: GoogleFonts.andika(fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ListOfLengkap()));
              },
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Icon(Icons.list_alt_sharp,  size: 110, color: Colors.green,),
                  Column(
                    children: [
                      new Text("Senarai Tugasan", style: GoogleFonts.andika(fontWeight: FontWeight.bold, fontSize: 15)),
                      new Text("Lengkap (Sah)", style: GoogleFonts.andika(fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                ],
              ),
            ),
      ]
    )
      );
  }
}