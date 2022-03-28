import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'Person.dart';
import 'PersonDetailPage.dart';
import 'PersonRegisterPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isSearching = false;
  String searching_word = "";

  var refPerson = FirebaseDatabase.instance.ref().child("kisiler");


  Future<void> deletePerson(String person_id) async {
    refPerson.child(person_id).remove();
    setState(() {});

  }

  Future<bool> shutTheApp() async {
    await exit(0);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              shutTheApp();
            },
            icon: Icon(Icons.arrow_back)),
        title: isSearching
            ? TextField(
                decoration: InputDecoration(hintText: "Search"),
                onChanged: (result) {
                  setState(() {
                    searching_word = result;
                  });
                })
            : Text("Contacts App"),
        actions: [
          isSearching
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      searching_word = "";
                    });
                  },
                  icon: Icon(Icons.cancel))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                  icon: Icon(Icons.search)),
        ],
      ),
      body: WillPopScope(
        onWillPop: shutTheApp,
        child: StreamBuilder<DatabaseEvent>(
          stream: refPerson.onValue,
          builder: (context, event) {
            if (event.hasData) {
              var personList = <Person>[];
              var datas = event.data!.snapshot.value as dynamic;
              if(datas != null) {
                datas.forEach((key,object) {
                  var person = Person.fromJson(key, object);
                  if(isSearching) {
                    if(person.person_name.contains(searching_word))
                      personList.add(person);
                  }else {
                    personList.add(person);
                  }
                });
              }
              return ListView.builder(
                itemCount: personList!.length,
                itemBuilder: (context, index) {
                  var person = personList[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PersonDetailPage(person)));
                    },
                    child: Card(
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("${person.person_name}"),
                            Text("${person.person_tel}"),
                            IconButton(
                                onPressed: () {
                                  deletePerson(person.person_id);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                ))
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PersonRegisterPage()));
        },
        tooltip: 'Add Person',
        child: const Icon(Icons.add),
      ),
    );
  }
}
