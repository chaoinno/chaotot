import 'package:chaotot/utility/my_style.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Field

  // Medthod
  Widget nameForm() {
    Color color = Colors.purple;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextFormField(
            decoration: InputDecoration(
                hintText: 'ชื่อเข้าโรงเรียนนะเว้ย',
                helperText: 'กรอกดิวะ ชื่ออ่ะ',
                helperStyle: TextStyle(color: color),
                labelText: 'Name :',
                labelStyle: TextStyle(color: color),
                icon: Icon(
                  Icons.account_box,
                  size: 36.0,
                  color: color,
                )),
          ),
        ),
      ],
    );
  }

  Widget userForm() {
    Color color = Colors.purple;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextFormField(
            decoration: InputDecoration(
                hintText: 'เมลแท้นะเว้ย',
                helperText: 'กรอกดิวะ',
                helperStyle: TextStyle(color: color),
                labelText: 'Email :',
                labelStyle: TextStyle(color: color),
                icon: Icon(
                  Icons.account_box,
                  size: 36.0,
                  color: color,
                )),
          ),
        ),
      ],
    );
  }

  Widget passwordForm() {
    Color color = Colors.purple;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextFormField(
            decoration: InputDecoration(
                hintText: 'อย่าให้คนเห็นนะเว้ย',
                helperText: 'กรอกดิวะ',
                helperStyle: TextStyle(color: color),
                labelText: 'password :',
                labelStyle: TextStyle(color: color),
                icon: Icon(
                  Icons.lock,
                  size: 36.0,
                  color: color,
                )),
          ),
        ),
      ],
    );
  }

  Widget galleryButton() {
    return OutlineButton.icon(
      icon: Icon(Icons.add_photo_alternate),
      label: Text('Gallery'),
      onPressed: () {},
    );
  }

  Widget cameraButton() {
    return OutlineButton.icon(
      icon: Icon(Icons.add_a_photo),
      label: Text('Camera'),
      onPressed: () {},
    );
  }

  Widget showButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[cameraButton(), galleryButton()],
    );
  }

  Widget showAvatar() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.height * 0.9,
      child: Image.asset(
        'images/avatar.png',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget registerButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      tooltip: 'Upload to Server',
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[registerButton()],
        backgroundColor: MyStyle().mainColor,
        title: Text('Register'),
      ),
      body: ListView(
        children: <Widget>[
          showAvatar(),
          showButtons(),
          nameForm(),
          userForm(),
          passwordForm(),
        ],
      ),
    );
  }
}
