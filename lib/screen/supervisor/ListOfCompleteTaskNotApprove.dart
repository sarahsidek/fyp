import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp/shared/Loading.dart';

class ListOfCompleteTaskNotApprove extends StatefulWidget {
  @override
  _ListOfCompleteTaskNotApproveState createState() => _ListOfCompleteTaskNotApproveState();
}

class _ListOfCompleteTaskNotApproveState extends State<ListOfCompleteTaskNotApprove> {
  List<NetworkImage> _listOfImages = <NetworkImage>[];
  String catatan;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Senarai Aduan Tidak Diluluskan"),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        child: StreamBuilder(
            stream:Firestore.instance.collection("CompleteTask").where('verified', isEqualTo:'TidakSah').snapshots(),
            builder: (context, snapshot){
              if (snapshot.hasError || !snapshot.hasData) {
                return Loading();
              } else{

                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index){
                      DocumentSnapshot ba = snapshot.data.documents[index];
                      _listOfImages =[];
                      for(int i =0; i <ba['url'].length; i++){
                        _listOfImages.add(NetworkImage(ba['completeTask'][i]));
                      }
                      return Card(
                          child:ListTile(
                              title: Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 5.0),
                                    Container(alignment: Alignment.centerLeft,
                                      child: Text(ba['sumberAduan']),
                                    ),
                                    SizedBox(height: 5.0),
                                    Container(alignment: Alignment.centerLeft,
                                      child: Text(ba['noAduan']),
                                    ),
                                    SizedBox(height: 5.0),
                                    Container(alignment: Alignment.centerLeft,
                                      child: Text(ba['kategori']),
                                    ),
                                    SizedBox(height: 5.0),
                                    Container(alignment: Alignment.centerLeft,
                                      child: Text(ba['verified']),
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
                                      child: Text(ba['comments']),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {updateComments(ba['id']);}
                          )
                      );
                    });
              }
            }),
      ),
    );
  }
  void updateComments(String id) {
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
              stream: Firestore.instance.collection('CompleteTask').document(id).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Loading();
                }
                return new Container(
                  height: 500,
                  padding: EdgeInsets.all(10),
                  child: Visibility(
                    visible: (snapshot.data['catatan'].toString() == 'Tiada catatan')? true:false,
                    child: Column(
                      children: [
                        SizedBox(height: 25.0),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Catatan',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                          maxLines: 5,
                          minLines: 3,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() => catatan = value);
                          },
                        ),
                        RaisedButton(
                            color: Colors.redAccent,
                            textColor: Colors.black,
                            child: Text("Hantar"),
                            onPressed: () async {
                              Firestore.instance.collection('Task').document(id).updateData({
                                'catatan':catatan
                              }).whenComplete((){
                                Navigator.pop(context);
                              });
                            }
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
