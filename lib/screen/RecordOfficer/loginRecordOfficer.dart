import 'package:fyp/screen/RecordOfficer/PageRecordOfficer.dart';
import 'package:fyp/service/authRecordOfficer.dart';
import 'package:flutter/material.dart';

class LoginRecordOfficer extends StatefulWidget {
  @override
  _LoginRecordOfficerState createState() => _LoginRecordOfficerState();
}

class _LoginRecordOfficerState extends State<LoginRecordOfficer> {
  // text field state
  String email = '', uniqueID = '', error = '';
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool loading = false;
  final AuthRecordOfficer _officer = new AuthRecordOfficer();


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.redAccent,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.redAccent,
            ),
          ),
          Image.asset('assets/mpbj2.png', height: 150, width: 450),
          Center(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: Container(
                height: 240,
                width: 300,
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          //email
                          TextFormField(
                              decoration: InputDecoration(labelText: 'E-mel',
                                  prefixIcon: Icon(Icons.person)),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value)
                              {
                                if(value.isEmpty || !value.contains('@'))
                                {
                                  return 'Pastikan e-mel anda sah!';
                                }
                                return null;
                              },
                              onChanged: (value)
                              {
                                setState(() => email = value);
                              }
                          ),
                          //password
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Kata Laluan',
                                prefixIcon: Icon(Icons.vpn_key)),
                            obscureText: true,
                            validator: (value) => value.isEmpty ? 'Kata Laluan tidak sah!': null,
                            onChanged: (value)
                            {
                              setState(() => uniqueID = value);
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: <Widget>[
                              RaisedButton(
                                child: Text(
                                    'Log Masuk'
                                ),
                                onPressed: () async {
                                  if( _formKey.currentState.validate()){
                                    setState(() => loading = true);
                                    dynamic result = await _officer.signInRecordOfficer(email, uniqueID);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RecordOfficer()));
                                    if (result == null){
                                      setState(() {
                                        error = 'Pastikan e-mel anda sah!';
                                        loading = false;
                                      });
                                    }
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                color: Colors.redAccent,
                                textColor: Colors.white,
                              ),
                            ],
                          )
                        ],
                      )
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
