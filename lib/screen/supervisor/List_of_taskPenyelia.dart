

import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fyp/shared/Loading.dart';



class List_ofTask extends StatefulWidget {
  @override
  _List_ofTaskState createState() => _List_ofTaskState();
}


String id;
List<NetworkImage> _listOfImages = <NetworkImage>[];
class _List_ofTaskState extends State<List_ofTask> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance.collection("Task").where('verified', isEqualTo:'Dalam proses kelulusan').snapshots(),
        builder: (context, snapshot){
          if(snapshot.hasError || !snapshot.hasData){
            return Loading();
          } else {
            final List<DocumentSnapshot> document = snapshot.data.documents;
            return ListView.builder(
              itemCount: document.length,
              itemBuilder: (BuildContext context, int index){
                _listOfImages =[];
                for(int i =0; i <snapshot.data.documents[index].data['urls'].length; i++){
                  _listOfImages.add(NetworkImage(snapshot.data.documents[index].data['urls'][i]));
                }
                return Card(
                    child:ListTile(
                      title: Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 5.0),
                            Container(alignment: Alignment.centerLeft,
                              child: Text(document[index].data['sumberAduan']),
                            ),
                            SizedBox(height: 5.0),
                            Container(alignment: Alignment.centerLeft,
                              child: Text(document[index].data['noAduan']),
                            ),
                            SizedBox(height: 5.0),
                            Container(alignment: Alignment.centerLeft,
                              child: Text(document[index].data['kategori']),
                            ),
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10.0),
                                  height: 200,
                                  decoration: BoxDecoration(
                                      color: Colors.white
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  child: Carousel(
                                    boxFit: BoxFit.cover,
                                    images: _listOfImages,
                                    autoplay: false,
                                    indicatorBgPadding: 5.0,
                                    dotPosition: DotPosition.bottomCenter,
                                    animationCurve: Curves.fastLinearToSlowEaseIn,
                                    animationDuration: Duration(milliseconds: 2000),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      subtitle: Container(
                        child: Row(
                          children: [
                            SizedBox(height: 5.0),
                            Container(alignment: Alignment.centerLeft,
                              child: Text(document[index].data['email']),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {verifyTask(document[index].data['id']);}
                    )
                );
              }
            );
          }
        }
      ),
    );
  }

  void verifyTask(String id){
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0)
            )
        ),
        context: context,
        builder: (builder){
          return StreamBuilder(
              stream: Firestore.instance.collection('Task').document(id).snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Loading();
                }
                return new Container(
                  height: 250.0,
                  child: new Container(
                    padding: EdgeInsets.fromLTRB(20.0, 3, 30.0, 5.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    width: 220,
                                    margin: EdgeInsets.only(top:26, left: 14),
                                    child: Text(snapshot.data['noAduan'], textAlign: TextAlign.left,style: TextStyle( fontSize: 24, fontFamily: 'Poppins')),
                                  ),
                                  Container(
                                    width: 220,
                                    margin: EdgeInsets.only(top:4, left: 15),
                                    child: Text(snapshot.data['kategori'], style: TextStyle( fontSize: 16)),
                                  ),
                                  Container(
                                    width: 220,
                                    margin: EdgeInsets.only(top:3, left: 15),
                                    child: Text(snapshot.data['sumberAduan'], style: TextStyle( fontSize: 16)),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20.0,),
                        Visibility(
                          visible: (snapshot.data['verified'].toString() == 'Dalam proses kelulusan')? true : false,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                  height: 55.0,
                                  width: 300.0,
                                  child: RaisedButton(
                                    elevation: 0.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2.0)
                                    ),
                                    color: Colors.redAccent,
                                    child: Text("Lengkap", style: TextStyle(fontFamily: "Poppins", fontSize: 20.0, color: Colors.white),),
                                    onPressed: () async {
                                      Firestore.instance.collection('Task').document(id).updateData({
                                        'verified': 'Lengkap'
                                      }).whenComplete((){
                                        Navigator.pop(context);
                                      });
                                    },
                                  )
                              )],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
          );
        }
    );
  }
}