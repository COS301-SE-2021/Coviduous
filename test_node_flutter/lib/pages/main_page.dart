import 'package:flutter/material.dart';
import 'package:test_node_flutter/modules/http.dart';
import 'package:test_node_flutter/pages/add_user_page.dart';

class MainPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class User
{
  String id;
  String name;
  User(this.id, this.name);
}

class MainPageState extends State<MainPage>
{
  //List<User> users = [];
  String response = "";

  Future<void> refreshUsers() async {
    var result = await http_get('users');
    
    if(result.ok)
    {
      setState(() {
        response = result.data['message'].toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context){
                    return AddUserPage();
                  }
              ));
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshUsers,
        child: ListView.separated(
          itemCount: 1,
          itemBuilder: (context, i) => ListTile(
            leading: Icon(Icons.person),
            title: Text(response),
          ),
          separatorBuilder: (context, i) => Divider(),
        ),
      ),
    );
  }
}