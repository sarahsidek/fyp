import 'package:fyp/screen/homepage.dart';
import 'package:fyp/service/authRoadGang.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AddRoadGang extends StatefulWidget {
  @override
  _AddRoadGangState createState() => _AddRoadGangState();
}


class _AddRoadGangState extends State<AddRoadGang> {
  //text field
  String name = ' ';
  String password = ' ';
  final AuthRoadGang _authRoadGang = new AuthRoadGang();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ROAD GANG",style: GoogleFonts.andika(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor:  Colors.blue[800],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "E-MEL",
                    hintText: 'E-MEL',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                keyboardType: TextInputType.text,
                validator: (value) => value.isEmpty ? 'PASTIKAN E-MEL DILENGKAPKAN!': null,
                onChanged: (value) {
                  setState(() => name = value);
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "KATA LALUAN",
                    hintText: 'KATA LALUAN',
                    prefixIcon: Icon(Icons.vpn_key),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => value.isEmpty ? 'PASTIKAN KATA LALUAN DILENGKAPKAN!': null,
                onChanged: (value) {
                  setState(() => password = value);
                },
              ),
              const SizedBox(height: 20.0),
              RaisedButton(
                  color: Colors.blue[800],
                  textColor: Colors.white,
                  child: Text("SIMPAN"),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      _authRoadGang.registerRoadGang(name, password).then((value) async{
                        await alertDialog(context);
                        Navigator.pop(context);
                      });
                    }
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<bool> alertDialog( BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('TAHNIAH', style: GoogleFonts.asap(fontWeight: FontWeight.bold, color: Colors.green[900])),
            content: Text('BERJAYA HANTAR', style: GoogleFonts.asap(fontWeight: FontWeight.bold)),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Home()));
                },
              ),
            ],
          );
        });
  }
}
