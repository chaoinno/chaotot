import 'package:chaotot/models/user_model.dart';
import 'package:chaotot/utility/my_style.dart';
import 'package:chaotot/widget/show_infomation.dart';
import 'package:chaotot/widget/show_list_product.dart';
import 'package:flutter/material.dart';

class MyService extends StatefulWidget {
  final UserModel userModel;
  MyService({Key key, this.userModel}) : super(key: key);

  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  // Field
  UserModel myUserModel;
  Widget currentWidget = ShowListProduct();

  // Medthod
  @override
  void initState() {
    super.initState();
    myUserModel = widget.userModel;
    print('TestName: ${myUserModel.name}');
    currentWidget = ShowListProduct(userModel: myUserModel,);
  }

  Widget menuShowList() {
    return ListTile(
      onTap: () {
        setState(() {
          currentWidget = ShowListProduct();
        });
        Navigator.of(context).pop();
      },
      leading: Icon(Icons.filter_1),
      title: Text('Show List Product'),
      subtitle: Text('Sho de'),
    );
  }

  Widget menuShowInfo() {
    return ListTile(
      onTap: () {
        setState(() {
          currentWidget = ShowInfomation();
        });
        Navigator.of(context).pop();
      },
      leading: Icon(Icons.filter_2),
      title: Text('Show Infomation'),
      subtitle: Text('Sho de'),
    );
  }

  Widget menuShowQRCode() {
    return ListTile(
      leading: Icon(Icons.filter_3),
      title: Text('Show QR Code'),
      subtitle: Text('Sho de'),
    );
  }

  Widget showNameLogIn() {
    return Text(
      'Welcome ${myUserModel.name}',
      style: MyStyle().h2Style,
    );
  }

  Widget showAvatar() {
    String url = 'http://androidthai.in.th/tot/Chao/${myUserModel.avatar}';
    print(url);
    return Container(
      width: 100.0,
      height: 100.0,
      child: ClipOval(
        child: Image.network(
          url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget showHeaderDrawer() {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          showAvatar(),
          showNameLogIn(),
        ],
      ),
    );
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          showHeaderDrawer(),
          menuShowList(),
          menuShowInfo(),
          menuShowQRCode(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: showDrawer(),
      appBar: AppBar(
        title: Text('My Service'),
      ),
      body: currentWidget,
    );
  }
}
