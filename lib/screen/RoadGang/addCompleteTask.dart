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
import 'package:intl/intl.dart';
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
  List<String> barang = <String>['CAT KUNING (TIN)', 'CAT PUTIH (TIN)', 'COLDMIX (BAG) ', 'HOTMIX (TONNE)' ,'CRUSHERRUN(TONNE)'];
  List<String> selectBarang = [null];
  List<String> selectQuantity =[null];
  String quant;
  String jenis;
  int i = 1;
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
              barang: selectBarang,
              quantity: selectQuantity,
              verified: "DALAM PROSES KELULUSAN",
              catatan: "Tiada Catatan",
              kawasan: ra.data['kawasan'],
              jalan: ra.data['naJalan'],
              sumberAduan: ra.data['sumberAduan'],
              kategori: ra.data['kategori'],
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

  Widget _dropdown(List<String> barang, String quantity, int index){
    return Container(
      child: Column(
        children: [
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: 'JENIS PEBNAMBAIKAN',
                prefixIcon: Icon(Icons.folder),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
            ),
            value: selectBarang[index],
            onChanged: (value){
              setState(() {
                selectBarang[index] = value;
              });
            },
            items: barang.map((value){
              return DropdownMenuItem(
                  value: value,
                    child: new Text(value),
                    );
                }).toList(),
          ),
          SizedBox(height: 5.0),
          TextFormField(
            decoration: InputDecoration(
                labelText: "KUANTITI",
                prefixIcon: Icon(Icons.add),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5))),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() => selectQuantity[index] = value );
            },
          ),
        ],
      ),
    );
  }

  DocumentSnapshot ra;
  _AddCompleteTaskState(DocumentSnapshot ra) {
    this.ra = ra;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BORANG TUGASAN LENGKAP",style: GoogleFonts.andika(fontWeight: FontWeight.bold, fontSize: 14)),
        backgroundColor:  Colors.blue[800],
      ),
      body: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("SUMBER ADUAN: ",
                      style: GoogleFonts.asap(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(ra.data['sumberAduan'],
                      style: GoogleFonts.asap(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                children: [
                  Text("NOMBOR ADUAN: ",
                      style: GoogleFonts.asap(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(ra.data['noAduan'],
                      style: GoogleFonts.asap(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                children: [
                  Text("LOKASI: " + " ",
                      style: GoogleFonts.asap(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(ra.data['kawasan'],
                      style: GoogleFonts.asap(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(ra.data['naJalan'],
                      style: GoogleFonts.asap(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                children: [
                  Text("KEROSAKAN: ",
                      style: GoogleFonts.asap(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(ra.data['kerosakan'],
                      style: GoogleFonts.asap(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              SizedBox(height: 5.0),
              Container(
                  margin: EdgeInsets.only(right: 88),
                  child: Text("TARIKH: "+ DateFormat("dd-MM-yyyy").format(_dateTime), style: GoogleFonts.asap(fontWeight: FontWeight.bold, fontSize: 18))),
              SizedBox(height: 5.0),
              ListView.separated(
                shrinkWrap: true,
                itemCount: i,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: _dropdown(barang, quant, index),
                  );
                },
                separatorBuilder: (context, index) => Container(height: 10),
              ),
                SizedBox(height: 5.0,),
                InkWell(
                  child: SizedBox(
                    height: 40,
                    width: 180,
                    child: Container(
                        width: 100.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                            color: Colors.blue[800],
                          borderRadius: new BorderRadius.circular(2.0)
                        ),
                        child: Center(child: Text("TAMBAH", style: GoogleFonts.asap(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)))),
                  ),
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)
                    ),
                    onTap: () {
                  selectBarang.add(null);
                  selectQuantity.add(null);
                    i ++;
                    setState(() {
                      selectBarang;
                      selectQuantity;
                    });
                 }),
              SizedBox(height: 5.0),
              Container(
                  color: Colors.white38,
                  height: 400,
                  child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                          width: 180,
                          child: RaisedButton(
                            child: Text("MUAT NAIK GAMBAR", style: GoogleFonts.asap(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                            color: Colors.blue[800],
                            textColor: Colors.white,
                            onPressed: loadAssets,
                          ),
                        ),
                        Expanded(
                          child: buildGridView(),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 40,
                              width: 180,
                              child: RaisedButton(
                                child: Text("SIMPAN", style: GoogleFonts.asap(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                                color: Colors.blue[800],
                                textColor: Colors.white,
                                onPressed: () async {
                                  alertDialog(context);
                                },
                              ),
                            ),
                            SizedBox(height: 10.0),
                            SizedBox(
                              height: 40,
                              width: 180,
                              child: RaisedButton(
                                child: Text("DAPATKAN LOKASI ANDA", style: GoogleFonts.asap(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                                color: Colors.blue[800],
                                textColor: Colors.white,
                                onPressed: () async {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => GoogleMaps(ctk: ct)));
                                },
                              ),
                            )
                          ],
                        ),
                      ]
                  )
              )
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
            title: Text('TAHNIAH', style: GoogleFonts.asap(fontWeight: FontWeight.bold, color: Colors.green[900])),
            content: Text('BERJAYA SIMPAN', style: GoogleFonts.asap(fontWeight: FontWeight.bold)),
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




