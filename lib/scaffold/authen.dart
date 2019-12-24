import 'dart:convert';

import 'package:chaotot/models/user_model.dart';
import 'package:chaotot/scaffold/my_service.dart';
import 'package:chaotot/scaffold/register.dart';
import 'package:chaotot/utility/my_style.dart';
import 'package:chaotot/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  // Feild
  String username, password;
  final formKey = GlobalKey<FormState>();

  // Method
  Widget mySizeBox() {
    return SizedBox(
      width: 5.0,
      height: 5.0,
    );
  }

  Widget signInButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(120.0)),
      color: MyStyle().mainColor,
      child: Text(
        'Sign In',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        formKey.currentState.save();
        if (username.isEmpty || password.isEmpty) {
          normalDialog(context, 'Worning!', 'เฮ่ย! ลืมกรอกไรป่าว');
        } else {
          checkAuthen();
        }
      },
    );
  }

  Future<void> checkAuthen() async {
    String url =
        'http://androidthai.in.th/tot/getUserWhereUserMaster.php?isAdd=true&User=$username&Password=$password';

    Response response = await Dio().get(url);
    var results = json.decode(response.data);

    if (results.toString() == 'null') {
      normalDialog(context, 'Fail!!', 'ไม่พบข้อมูลเว่ย!');
    } else {
      for (var map in results) {
        UserModel userModel = UserModel.fromJSON(map);
        if (password == userModel.password) {
          print('Welcome ${userModel.name}');

          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (BuildContext buildContext) {
            return MyService();
          });
          Navigator.of(context).pushAndRemoveUntil(materialPageRoute,
              (Route<dynamic> route) {
            return false;
          });
        } else {
          normalDialog(context, 'Fail!!', 'รหัสผ่านผิด ไองามไส้');
        }
      }
    }
  }

  Widget signUpButton() {
    return OutlineButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(120.0)),
      child: Text('Sign Up'),
      onPressed: () {
        print('You Print Sign Up');

        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext buildContext) {
          return Register();
        });
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget showButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        signInButton(),
        mySizeBox(),
        signUpButton(),
      ],
    );
  }

  Widget userForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextFormField(
        onSaved: (String string) {
          username = string.trim();
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().textButtonColor)),
          hintText: 'User :',
        ),
      ),
    );
  }

  Widget passwordForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextFormField(
        onSaved: (String string) {
          password = string.trim();
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().textButtonColor)),
          hintText: 'Password :',
        ),
        obscureText: true,
      ),
    );
  }

  Widget showLogo() {
    return Container(
      width: 120.0,
      height: 120.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showAppName() {
    return Text(
      'CHAO',
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        color: Colors.green[900],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
              colors: <Color>[Colors.white, Colors.blue[700]], radius: 1.0),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  showLogo(),
                  mySizeBox(),
                  showAppName(),
                  mySizeBox(),
                  userForm(),
                  mySizeBox(),
                  passwordForm(),
                  mySizeBox(),
                  showButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
