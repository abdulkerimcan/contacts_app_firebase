# Contacs App 

An application that you can add contacts.

## About The Project

In this application you can add contacts,delete contacts,search contacts, or update the contact that has been registered.

This contact data is registered on the Internet. Thanks to the firebase Realtime, I can receive contacts. Or I can delete it.

Thanks to the following code, I can access the table in the database by creating a reference.
```dart
var refWords = FirebaseDatabase.instance.ref().child("kisiler");
```

<br> <br>
![image](https://user-images.githubusercontent.com/79968953/160259434-1d1a025f-0932-40eb-af99-54d7fcab83fd.png) <br>
 <br> <br>
 
I use that method to get all persons from firebase. <br>
```dart
child: StreamBuilder<DatabaseEvent>(
          stream: refPerson.onValue,
          builder: (context, event) {
            if (event.hasData) {
              var personList = <Person>[];
              var datas = event.data!.snapshot.value as dynamic;
              if(datas != null) {
                datas.forEach((key,object) {
                  var person = Person.fromJson(key, object);
                  .
                  .
                  .
                  .
                  
```

We can search the persons.<br>
![image](https://user-images.githubusercontent.com/79968953/160259497-704c8a39-9e68-4899-b187-01b9c26c6df5.png)
 <br> <br>


We can update the person's information.

![image](https://user-images.githubusercontent.com/79968953/160259621-3cbeff44-7633-425f-9a47-e97f7d986cc2.png)

If we click on the person on the list, it will take us to the PersonDetailPage.
You can click TextFields to update their information.


I used this method to do this.
```dart
Future<void> update(String person_id,String person_name, String person_tel) async {
    var info = HashMap<String,dynamic>();
    info["kisi_ad"] = person_name;
    info["kisi_tel"] = person_tel;

    refPerson.child(person_id).update(info);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }
```

We can delete the person.

![image](https://user-images.githubusercontent.com/79968953/160259677-80d36016-e05c-4f7a-8574-be76bfb17953.png)
```dart
Future<void> deletePerson(String person_id) async {
    refPerson.child(person_id).remove();
    setState(() {});
  }
```

We can insert a person

![image](https://user-images.githubusercontent.com/79968953/160259713-51d3ff9e-73f3-4a13-96aa-9373a4294c09.png)
```dart
Future<void> register(String person_name, String person_tel) async {

    var info = HashMap<String,dynamic>();
    info["kisi_ad"] = person_name;
    info["kisi_tel"] = person_tel;

    refPerson.push().set(info);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }
```
