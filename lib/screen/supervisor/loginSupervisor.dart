import 'package:fyp/screen/supervisor/PageSupervisor.dart';
import 'package:fyp/service/authSupervisor.dart';

import 'package:flutter/material.dart';




class LoginSupervisor extends StatefulWidget {
  @override
  _LoginSupervisorState createState() => _LoginSupervisorState();
}

class _LoginSupervisorState extends State<LoginSupervisor> {

  // text field state
  String email = '', uniqueID = '', error = '';
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool loading = false;
  final AuthSupervisor _auth = AuthSupervisor();

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
            padding: EdgeInsets.all(20),
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
                                  return 'E-mel tidak sah!';
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
                            validator: (value)
                            {
                              if(value.isEmpty || value.length<=6)
                              {
                                return 'Kata Laluan tidak sah!';
                              }
                              return null;
                            },
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
                                    dynamic result = await _auth.signInSupervisor(email, uniqueID);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Supervisor()));
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