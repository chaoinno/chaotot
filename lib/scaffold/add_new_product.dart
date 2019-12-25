import 'dart:io';
import 'dart:math';

import 'package:chaotot/models/user_model.dart';
import 'package:chaotot/utility/my_style.dart';
import 'package:chaotot/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNewProduct extends StatefulWidget {
  final UserModel userModel;
  AddNewProduct({Key key, this.userModel}) : super(key: key);
  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  // Field
  File file;
  String code, name, detail, path, post;
  final formKey = GlobalKey<FormState>();
  UserModel myUserModel;

  // Method
  Widget nameForm() {
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
                hintText: 'ชื่อสินค้านะเว้ย',
              )),
        ),
      ],
    );
  }

  Widget detailForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextFormField(
              onSaved: (String string) {
                detail = string.trim();
              },
              decoration: InputDecoration(
                hintText: 'รายละเอียดสินค้านะเว้ย',
              )),
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

  Widget showPicture() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.5,
      child: file == null
          ? Image.asset(
              'images/avatar.png',
              fit: BoxFit.contain,
            )
          : Image.file(file),
    );
  }

  Widget uploadButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            child: Text('Save'),
            onPressed: () {
              formKey.currentState.save();
            },
          ),
        )
      ],
    );
  }

  Widget mainContent() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: SingleChildScrollView(
              child: Column(
          children: <Widget>[
            showPicture(),
            showButtons(),
            nameForm(),
            detailForm(),
            uploadButton(),
          ],
        ),
      ),
    );
  }

  Future<void> uploadPictureToServer() async {
    Random random = Random();
    int i = random.nextInt(100000);
    String namePicture = 'product$i.jpg';
    print('product' + i.toString());

    String urlApi = 'http://androidthai.in.th/tot/savePicture.php';
    path = namePicture;
    code = 'code$i';

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

  Future<void> insertDataToDatabase() async {
    String url = 'https://www.androidthai.in.th/tot/addProductPak.php?isAdd=true&Product=$name&Detail=$detail&Path=$path&Post=$post&Code=$code';

    Response response = await Dio().get(url);
    if (response.data.toString() == 'true') {
      Navigator.of(context).pop();
    } else {
      normalDialog(context, 'Fail!!', 'ไม่สำเร็จเว่ย!');
    }
  }

  @override
  void initState() {
    super.initState();
    myUserModel = widget.userModel;
    post = myUserModel.name;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().mainColor,
        title: Text('Add New Product'),
      ),
      body: mainContent(),
    );
  }
}
