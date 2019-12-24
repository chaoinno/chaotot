import 'dart:io';
import 'dart:math';

import 'package:chaotot/utility/my_style.dart';
import 'package:chaotot/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Field
  File file;
  String name, email, password, avatar;
  final formKey = GlobalKey<FormState>();

  // Medthod
  Widget nameForm() {
    Color color = Colors.purple;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextFormField(
            onSaved: (String string) {
              name = string.trim();
            },
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

  Widget emailForm() {
    Color color = Colors.purple;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextFormField(
            onSaved: (String string) {
              email = string.trim();
            },
            decoration: InputDecoration(
                hintText: 'เมลแท้นะเว้ย',
                helperText: 'กรอกดิวะ',
                helperStyle: TextStyle(color: color),
                labelText: 'Email :',
                labelStyle: TextStyle(color: color),
                icon: Icon(
                  Icons.mail,
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
            onSaved: (String string) {
              password = string.trim();
            },
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
      onPressed: () {
        cameraAndGalleryThread(ImageSource.gallery);
      },
    );
  }

  Widget cameraButton() {
    return OutlineButton.icon(
      icon: Icon(Icons.add_a_photo),
      label: Text('Camera'),
      onPressed: () {
        cameraAndGalleryThread(ImageSource.camera);
      },
    );
  }

  Future<void> cameraAndGalleryThread(ImageSource imageSource) async {
    var object = await ImagePicker.pickImage(
      source: imageSource,
      maxWidth: 800.0,
      maxHeight: 600.0,
    );

    setState(() {
      file = object;
    });
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
      child: file == null
          ? Image.asset(
              'images/avatar.png',
              fit: BoxFit.contain,
            )
          : Image.file(file),
    );
  }

  Widget registerButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      tooltip: 'Upload to Server',
      onPressed: () {
        formKey.currentState.save();

        if (file == null) {
          print('Not choose Image');
          normalDialog(context, 'รูปอ่ะๆ', 'เลือกรูปดิว๊าาา');
        } else if (name.isEmpty) {
          normalDialog(context, 'ชื่ออ่ะๆ', 'กรอกดิว๊าาาาา');
        } else if (email.isEmpty) {
          normalDialog(context, 'เมลอ่ะๆ', 'กรอกดิว๊าาาาา');
        } else if (password.length < 6) {
          normalDialog(context, 'พาสเวร์ดอ่ะๆ', 'ตั้งยากๆดิว๊าาาาา');
        } else {
          uploadPictureToServer();
        }
      },
    );
  }

  Future<void> uploadPictureToServer() async {
    Random random = Random();
    int i = random.nextInt(100000);
    String namePicture = 'avatar$i.jpg';
    print('avatar' + i.toString());

    String urlApi = 'http://androidthai.in.th/tot/saveFileChao.php';
    avatar = namePicture;

    try {
      Map<String, dynamic> map = Map();
      map['file'] = UploadFileInfo(file, namePicture);
      FormData formData = FormData.from(map);
      Response response = await Dio().post(urlApi, data: formData);
      print('response = $response');

      var result = response.data;
      print('message = $result[\'message\']');

      if (result['message'] == 'File uploaded successfully') {
        print(result['message']);
        insertDataToDatabase();
      } else {
        print('Cannot upload');
        normalDialog(context, 'Failed', 'Cannot upload your picture');
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[registerButton()],
        backgroundColor: MyStyle().mainColor,
        title: Text('Register'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: <Widget>[
            showAvatar(),
            showButtons(),
            nameForm(),
            emailForm(),
            passwordForm(),
          ],
        ),
      ),
    );
  }

  Future<void> insertDataToDatabase()async{

    String url = 'http://androidthai.in.th/tot/addDataMaster.php?isAdd=true&Name=$name&User=$email&Password=$password&Avatar=$avatar';

    Response response = await Dio().get(url);
    if (response.data.toString() == 'true') {
      Navigator.of(context).pop();
    } else {
      normalDialog(context, 'Fail!!', 'ลงทะเบียนไม่สำเร็จเว่ย!');
    }

  }
}
