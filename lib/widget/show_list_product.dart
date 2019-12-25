import 'dart:convert';

import 'package:chaotot/models/product_model.dart';
import 'package:chaotot/models/user_model.dart';
import 'package:chaotot/scaffold/add_new_product.dart';
import 'package:chaotot/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ShowListProduct extends StatefulWidget {
  final UserModel userModel;
  ShowListProduct({Key key, this.userModel}) : super(key: key);
  @override
  _ShowListProductState createState() => _ShowListProductState();
}

class _ShowListProductState extends State<ShowListProduct> {
  // Field
  UserModel myUserModel;
  List<ProductModel> productModels = List();

  // Method

  Widget addProductButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  MaterialPageRoute materialPageRoute =
                      MaterialPageRoute(builder: (BuildContext context) {
                    return AddNewProduct(
                      userModel: myUserModel,
                    );
                  });
                  Navigator.of(context).push(materialPageRoute);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    // myUserModel = this.myUserModel;
    myUserModel = widget.userModel;
    print('test model ===>>> ${myUserModel.name}');
    readAllProductTread();
  }

  Future<void> readAllProductTread() async {
    String url = 'https://www.androidthai.in.th/tot/getAllProductMaster.php';

    Response response = await Dio().get(url);
    var results = json.decode(response.data);
    print(results);

    for (var map in results) {
      ProductModel productModel = ProductModel.fromJson(map);
      setState(() {
        productModels.add(productModel);
      });
    }
  }

  Widget showPicture(int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.5,
      child: CircleAvatar(
        backgroundImage: NetworkImage(productModels[index].path),
      ),
    );
  }

  Widget showProduct(int index) {
    return Text(
      productModels[index].product,
      style: MyStyle().h2Style,
    );
  }

  Widget showDetail(int index) {
    String detail = productModels[index].detail;
    if (detail.length >= 20) {
      detail = detail.substring(0, 39);
      detail = '$detail ...';
    }

    return Text(detail);
  }

  Widget showText(int index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          showProduct(index),
          showDetail(index),
        ],
      ),
    );
  }

  Widget showListView() {
    return ListView.builder(
      itemCount: productModels.length,
      itemBuilder: (BuildContext buildContext, int index) {
        return Row(children: <Widget>[
          showPicture(index),
          showText(index),
        ]);
      },
    );
  }

  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          showListView(),
          addProductButton(),
        ],
      ),
    );
  }
}
