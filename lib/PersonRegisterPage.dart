import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class PersonRegisterPage extends StatefulWidget {
  const PersonRegisterPage({Key? key}) : super(key: key);

  @override
  _PersonRegisterPageState createState() => _PersonRegisterPageState();
}

class _PersonRegisterPageState extends State<PersonRegisterPage> {
  var tfPersonName = TextEditingController();
  var tfTel = TextEditingController();
  var refPerson = FirebaseDatabase.instance.ref().child("kisiler");

  Future<void> register(String person_name, String person_tel) async {

    var info = HashMap<String,dynamic>();
    info["kisi_ad"] = person_name;
    info["kisi_tel"] = person_tel;

    refPerson.push().set(info);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Person"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 50.0,left: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextField(
                  controller: tfPersonName,
                  decoration: InputDecoration(hintText: "Name")),
              TextField(
                  controller: tfTel,
                  decoration: InputDecoration(hintText: "Phone")),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          register(tfPersonName.text, tfTel.text);
        },
        tooltip: 'RegisterPerson',
        icon: const Icon(Icons.save),
        label: Text("Register"),
      ),
    );
  }
}
