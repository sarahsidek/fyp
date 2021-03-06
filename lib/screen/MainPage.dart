import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screen/RecordOfficer/loginRecordOfficer.dart';
import 'package:fyp/screen/RoadGang/loginRoadGang.dart';
import 'package:fyp/screen/login.dart';
import 'package:fyp/screen/searchTask.dart';
import 'package:fyp/screen/supervisor/loginSupervisor.dart';
import 'package:google_fonts/google_fonts.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              color: Colors.blue[800]
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black87,
              ),
              onPressed:() async{
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => SearchTask()));
              })
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.blue[800]
            ),
          ),
          Container(
              child: Column(
                  children: [
                  Image.asset('assets/mpbj2.png', height: 120, width: 450)
          ],
          )
          ),
          Container(
            margin: EdgeInsets.only(top: 130),
             child:  Center(
               child: Column(
                 children: [
                   new Text("PEMANTAUAN TUGASAN KERJA ", style: GoogleFonts.andika(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                   new Text("JABATAN KEJURUTERAAN ", style: GoogleFonts.andika(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                 ]
               ),
             ),
          ),
          Container(
            margin: EdgeInsets.only(top: 200),
            child: GridView.count(
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 10,
              primary: false,
              crossAxisCount: 2,
              children: [
                RaisedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/admin.png',height: 100, width: 100,),
                        Column(
                          children: [
                            new Text("ADMIN", style: GoogleFonts.andika(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginSupervisor()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/supervisor.png',height: 110, width: 100,),
                        Column(
                          children: [
                            new Text("PENYELIA", style: GoogleFonts.andika(fontWeight: FontWeight.bold, fontSize: 15)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginRecordOfficer()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/penyelia.png',height: 110, width: 100,),
                        Column(
                          children: [
                            new Text("PEG. MEREKOD", style: GoogleFonts.andika(fontWeight: FontWeight.bold, fontSize: 15)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginRoadGang()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/laborers.png',height: 110, width: 100,),
                        Column(
                          children: [
                            new Text("ROAD GANG", style: GoogleFonts.andika(fontWeight: FontWeight.bold, fontSize: 15)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
             ]
            )
          )
        ],
      ),
    );
  }
}
