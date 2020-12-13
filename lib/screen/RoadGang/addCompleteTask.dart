import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp/maps/google_maps_address.dart';
import 'package:fyp/model/CompleteTask.dart';
import 'package:fyp/service/database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AddCompleteTask extends StatefulWidget {

  final DocumentSnapshot ra;

  AddCompleteTask({Key key, this.ra}) : super(key: key);

  @override
  _AddCompleteTaskState createState() => _AddCompleteTaskState(ra);
}

class _AddCompleteTaskState extends State<AddCompleteTask> {
  File image;
  List<Asset> images = List<Asset>();
  List<String> imageUrls = <String>[];
  String coldmix;
  String crusherRun;
  String hotmix;
  String pasir;
  String catKuning;
  String catPutih;
  DateTime _dateTime = DateTime.now();
  String imageUrl;
  CompleteTask ct;

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Container(
          child: AssetThumb(
            asset: asset,
            width: 100,
            height: 100,
          ),
        );
      }),
    );
  }


  loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 20,
        enableCamera: true,
        selectedAssets: images,
      );
      print(resultList.length);
      print((await resultList[0].getThumbByteData(122, 100)));
      print((await resultList[0].getByteData()));
      print((await resultList[0].metadata));
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    setState(() {
      images = resultList;
      error = error;
    });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final String id = Firestore.instance
      .collection("CompleteTask")
      .id;

  uploadCompleteImage(DateTime dateTime, String uid) {
    for (var imageFile in images) {
      postImage(imageFile).then((downloadUrl) async {
        imageUrls.add(downloadUrl.toString());
        if (imageUrls.length == images.length) {
          final FirebaseUser rd = await auth.currentUser();
          final String email = rd.email;
          String id = Firestore.instance
              .collection("CompleteTask")
              .document()
              .documentID;
          ct = CompleteTask(
              id: id,
              CompeleteimageUrls: imageUrls,
              time: _dateTime,
              noAduan: ra.data['noAduan'],
              email: email,
              verified: "Dalam Proses Kelulusan",
              catatan: "Lengkap",
              kawasan: ra.data['kawasan'],
              jalan: ra.data['naJalan'],
              sumberAduan: ra.data['sumberAduan'],
              kategori: ra.data['kategori'],
              pasir: pasir,
              coldmix: coldmix,
              crusherRun: crusherRun,
              hotmix: hotmix,
              catKuning: catKuning,
              catPutih: catPutih
          );
          await DatabaseService().addCompleteAdd(ct);
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  postImage(Asset imageFile) async {
    String fileName = DateTime.now()
        .millisecondsSinceEpoch
        .toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(
        "uploadCompleteTask/$fileName");
    StorageUploadTask uploadTask = reference.putData(
        (await imageFile.getByteData()).buffer.asUint8List());
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    print(storageTaskSnapshot.ref.getDownloadURL());
    return storageTaskSnapshot.ref.getDownloadURL();
  }

  DocumentSnapshot ra;

  _AddCompleteTaskState(DocumentSnapshot ra) {
    this.ra = ra;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aduan Lengkap"),
        backgroundColor: Colors.redAccent,
      ),
      body: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5.0),
              Row(
                children: [
                  Text("Sumber Aduan: ",
                      style: GoogleFonts.asap(fontWeight: FontWeight.bold)),
                  Text(ra.data['sumberAduan'],
                      style: GoogleFonts.asap(fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                children: [
                  Text("Nombor Aduan: ",
                      style: GoogleFonts.asap(fontWeight: FontWeight.bold)),
                  Text(ra.data['noAduan'],
                      style: GoogleFonts.asap(fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                children: [
                  Text("Lokasi: " + " ",
                      style: GoogleFonts.asap(fontWeight: FontWeight.bold)),
                  Text(ra.data['kawasan'],
                      style: GoogleFonts.asap(fontWeight: FontWeight.bold)),
                  Text(ra.data['naJalan'],
                      style: GoogleFonts.asap(fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                children: [
                  Text("Kerosakan ",
                      style: GoogleFonts.asap(fontWeight: FontWeight.bold)),
                  Text(ra.data['kerosakan'],
                      style: GoogleFonts.asap(fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 5.0),
              TextFormField(
                decoration: InputDecoration(
                    labelText: "Pilih Tarikh Penambaikan : ",
                    prefixIcon: Icon(Icons.calendar_today),
                    hintText: _dateTime.toString(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
                keyboardType: TextInputType.datetime,
                onChanged: (value) {
                  setState(() {
                    _dateTime = value as DateTime;
                  });
                },
              ),
              SizedBox(height: 5.0),
              Container(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text("Jenis Bahan Penambaikan", style: GoogleFonts.asap(fontWeight: FontWeight.bold)),
                     Text("ColdMix:", style: GoogleFonts.asap(fontWeight: FontWeight.bold)),
                     TextField(decoration: InputDecoration(
                        hintText: "Jumlah:"
                       ),
                       onChanged: (value){
                       setState(() {
                         coldmix = value;
                         });
                       },
                     ),
                     SizedBox(height: 5.0),
                     Text("Crusher Run:", style: GoogleFonts.asap(fontWeight: FontWeight.bold)),
                     TextField(decoration: InputDecoration(
                         hintText: "Jumlah:"
                     ),
                       onChanged: (value){
                         setState(() {
                           crusherRun = value;
                         });
                       },
                     ),
                     SizedBox(height: 5.0),
                     Text("Hotmix:", style: GoogleFonts.asap(fontWeight: FontWeight.bold)),
                     TextField(decoration: InputDecoration(
                         hintText: "Jumlah:"
                     ),
                       onChanged: (value){
                         setState(() {
                           hotmix = value;
                         });
                       },
                     ),
                     SizedBox(height: 5.0),
                     Text("Pasir:", style: GoogleFonts.asap(fontWeight: FontWeight.bold)),
                     TextField(decoration: InputDecoration(
                         hintText: "Jumlah:"
                     ),
                       onChanged: (value){
                         setState(() {
                           pasir = value;
                         });
                       },
                     ),
                     SizedBox(height: 5.0),
                     Text("Cat Kuning:", style: GoogleFonts.asap(fontWeight: FontWeight.bold)),
                     TextField(decoration: InputDecoration(
                         hintText: "Jumlah:"
                     ),
                       onChanged: (value){
                         setState(() {
                           catKuning = value;
                         });
                       },
                     ),
                     Text("Cat Putih:", style: GoogleFonts.asap(fontWeight: FontWeight.bold)),
                     TextField(decoration: InputDecoration(
                         hintText: "Jumlah:"
                     ),
                       onChanged: (value){
                         setState(() {
                           catPutih = value;
                         });
                       },
                     ),
                   ],
                 ),
                ),
              SizedBox(height: 5.0),
              Container(
                  color: Colors.white,
                  height: 400,
                  child: Column(
                      children: <Widget>[
                        RaisedButton(
                          child: Text("Pilih Gambar"),
                          color: Colors.redAccent,
                          textColor: Colors.black,
                          onPressed: loadAssets,
                        ),
                        Expanded(
                          child: buildGridView(),
                        ),
                        Column(
                          children: [
                            RaisedButton(
                              child: Text("Simpan"),
                              color: Colors.redAccent,
                              textColor: Colors.black,
                              onPressed: () async {
                                alertDialog(context);
                              },
                            ),
                            SizedBox(height: 10.0),
                            RaisedButton(
                              child: Text("Dapatkan lokasi anda"),
                              color: Colors.redAccent,
                              textColor: Colors.black87,
                              onPressed: () async {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => GoogleMaps(ctk: ct)));
                              },
                            )
                          ],
                        ),
                      ]
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> alertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tahniah'),
            content: Text('Berjaya Kemaskini'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () async {
                  uploadCompleteImage(_dateTime, id);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}