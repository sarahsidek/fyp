import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screen/RecordOfficer/ListTask.dart';
import 'package:google_fonts/google_fonts.dart';


class EditTask extends StatefulWidget {

  DocumentSnapshot da;
 EditTask({Key key, this.da}) : super(key: key);

  @override
  _EditTaskState createState() => _EditTaskState(da);
}

class _EditTaskState extends State<EditTask> {
  DocumentSnapshot da;
  _EditTaskState(DocumentSnapshot da){
  this.da = da;
  }

 TextEditingController _sumberAduan;
 TextEditingController _kategori;
 DateTime myDateTime = DateTime.now();
  final GlobalKey<FormState> _formKey = GlobalKey();
 @override
 void initState(){
   super.initState();
   _sumberAduan =TextEditingController(text: widget.da.data['sumberAduan']);
   _kategori = TextEditingController(text: widget.da.data['kategori']);
}

  List <String> sumber = <String> ['SISTEM ADUAN MBPJ', 'SISTEM ADUAN WAZE', 'SISTEM ADUAN UTILITI'];
  List <String> kate = <String> ['SEGERA', 'PEMBAIKAN BIASA'];
  String kategori;
  String sumberAduan;
  String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("KEMASKINI TUGASAN",style: GoogleFonts.andika(fontWeight: FontWeight.bold, fontSize: 14)),
          backgroundColor:  Colors.blue[800],
        ),
    body: Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 10.0),
              DropdownButtonFormField(
                hint:Text(widget.da.data['sumberAduan']),
                decoration: InputDecoration(
                    labelText: "SUMBER ADUAN",
                    prefixIcon: Icon(Icons.perm_contact_calendar),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                isExpanded: true,
                value: sumberAduan,
                onChanged: (newValue) {
                  setState(() {
                    sumberAduan = newValue;
                    _sumberAduan.text = sumberAduan;
                  });
                },
                items: sumber.map((sum){
                  return DropdownMenuItem(
                    value: sum,
                    child: new Text(sum),
                  );
                }).toList(),
              ),
              SizedBox(height: 10.0),
              DropdownButtonFormField(
                hint:Text(widget.da.data['kategori']),
                decoration: InputDecoration(
                    labelText: "KATEGORI",
                    prefixIcon: Icon(Icons.perm_contact_calendar),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                isExpanded: true,
                value: kategori,
                onChanged: (newValue) {
                  setState(() {
                    kategori = newValue;
                    _kategori.text = kategori;
                  });
                },
                items: kate.map((ka){
                  return DropdownMenuItem(
                    value: ka,
                    child: new Text(ka),
                  );
                }).toList(),
              ),
              RaisedButton(
                  color:Colors.blue[800],
                  textColor:Colors.white,
                  child: Text("KEMASKINI"),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                     Firestore.instance.collection("Task").document(da.data['id']).updateData({
                       'kategori': _kategori.text,
                       'sumberAduan': _sumberAduan.text,
                       'comments':'Tiada catatan',
                       'verified': 'DALAM PROSES KELULUSAN'
                     }).then((value) async {
                        await alertDialog(context);
                        Navigator.pop(context);
                      });
                    }
                  }
              ),
            ]
        ),
      ),
      )
    );
  }
  Future<bool> alertDialog( BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('TAHNIAH', style: GoogleFonts.asap(fontWeight: FontWeight.bold, color: Colors.green[900])),
            content: Text('BERJAYA KEMASKINI', style: GoogleFonts.asap(fontWeight: FontWeight.bold)),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ListTask()));
                },
              ),
            ],
          );
        });
  }
}



