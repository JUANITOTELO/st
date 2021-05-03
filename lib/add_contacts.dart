import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUser extends StatelessWidget {
  final String fullName;
  final String company;
  final String age;

  AddUser(this.fullName, this.company, this.age);
  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    DocumentReference users =
        FirebaseFirestore.instance.collection('Usuarios').doc('$fullName');
    int _age = int.parse(age);
    Future<void> addUser() {
      return users
          .set({
            'full_name': fullName, // John Doe
            'company': company, // Stokes and Sons
            'age': _age // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return ElevatedButton(
      onPressed: addUser,
      child: Text(
        "Add User",
      ),
    );
  }
}

class UserInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Usuarios');

    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Someting go wrong... :(');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loadiiing list...");
        }

        return new ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return new ListTile(
              title: new Text(document.data()['full_name']),
              subtitle: new Text(document.data()['company']),
            );
          }).toList(),
        );
      },
    );
  }
}
