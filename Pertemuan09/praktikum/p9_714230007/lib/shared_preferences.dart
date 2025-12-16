import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyShared extends StatefulWidget {
  const MyShared({super.key});
  @override
  State<MyShared> createState() {
    return _MySharedState();
  }
}

class _MySharedState extends State<MyShared> {
  late SharedPreferences prefs;
  final TextEditingController _dataAja = TextEditingController();
  String name = "";

  @override
  void dispose() {
    _dataAja.dispose();
    super.dispose();
  }

  save() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('iniData', _dataAja.text.toString());
    _dataAja.text = "";
  }

  retrieve() async {
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString('iniData').toString();
    setState(() {});
  }

  delete() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove('iniData');
    name = "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shared Preferences")),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _dataAja,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            ElevatedButton(
              child: const Text("Save"),
              onPressed: () {
                save();
              },
            ),
            const SizedBox(height: 20),
            TextField(
              readOnly: true,
              decoration: InputDecoration(border: const OutlineInputBorder(), hintText: name),
              
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Get Value"),
              onPressed: () {
                retrieve();
              },
            ),
            ElevatedButton(child: const Text("Delete Value"), onPressed: () {
              delete();
            }),
          ],
        ),
      ),
    );
  }
}
