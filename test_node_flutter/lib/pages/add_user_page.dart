import 'package:flutter/material.dart';
import 'package:test_node_flutter/modules/http.dart';

class AddUserPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return AddUserPageState();
  }
}

class AddUserPageState extends State<AddUserPage>
{
  TextEditingController nameController = TextEditingController();
  String response = "";

  createUser() async {
    var result = await http_post("create-user", {
      "name": nameController.text,
    });

    if(result.ok)
    {
      setState(() {
        response = result.data['message'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add User"),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: nameController,
            decoration: InputDecoration(
                hintText: "Name"
            ),
          ),
          ElevatedButton(
            child: Text("Create"),
            onPressed: createUser,
          ),
          Text(response), // data received from http_post resp
        ],
      ),
    );
  }
}