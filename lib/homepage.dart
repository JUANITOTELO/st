import 'package:flutter/material.dart';
import 'page_auth.dart';
import 'add_contacts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController text_name = TextEditingController(text: "pr");
  final TextEditingController text_company = TextEditingController(text: "pr");
  final TextEditingController text_age = TextEditingController(text: "0");

  void doClear() {
    setState(() {
      text_name.text = null;
      text_age.text = null;
      text_age.text = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Helloo, please enter a user"),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Name',
                  ),
                  controller: text_name,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Company',
                  ),
                  controller: text_company,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Age',
                  ),
                  controller: text_age,
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 200.0,
                          child: UserInformation(),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AddUser(
                      text_name.text,
                      text_company.text,
                      text_age.text,
                    ),
                    ElevatedButton(
                      onPressed: doClear,
                      child: Text("Reload"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ServicioAutenticacion>().signOut();
                      },
                      child: Text("Sign Out"),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
