import 'package:flutter/material.dart';
import 'package:pertemuan06/bottom_navbar.dart';
import 'package:pertemuan06/input_form.dart';
import 'package:pertemuan06/input_validation.dart';

bool lightOn = false;
bool agree = false;
String? language;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: false),
      home: MyInputForm(),
    );
  }
}

class MyInput extends StatefulWidget {
  const MyInput({super.key});

  @override
  State<MyInput> createState() => _MyInputState();
}

class _MyInputState extends State<MyInput> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Widget')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Write your name here...',
                labelText: 'Your Name',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text('Hello, ${_controller.text}!'),
                    );
                  },
                );
              },
            ),

            Switch(
              value: lightOn,
              onChanged: (bool value) {
                setState(() {
                  lightOn = value;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(lightOn ? 'Light is ON' : 'Light is OFF'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: const Text('Dart'),
                  value: 'Dart',
                  groupValue: language,
                  onChanged: (String? value) {
                    setState(() {
                      language = value;
                      showSnackbar();
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Kotlin'),
                  value: 'Kotlin',
                  groupValue: language,
                  onChanged: (String? value) {
                    setState(() {
                      language = value;
                      showSnackbar();
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Swift'),
                  value: 'Swift',
                  groupValue: language,
                  onChanged: (String? value) {
                    setState(() {
                      language = value;
                      showSnackbar();
                    });
                  },
                ),
              ],
            ),
            CheckboxListTile(title: const Text('Agree / Disagree'), 
            value: agree, 
            onChanged: (bool? value) {
              setState(() {
                agree = value!;
                
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(' ${agree ? 'Agree' : 'Disagree'}'),
                    duration: Duration(seconds: 1),
                  ),
                );
            },
            controlAffinity: ListTileControlAffinity.leading,
            
            ),
          ],
        ),
      ),
    );
  }

  void showSnackbar() {
    // Pastikan 'language' tidak null sebelum menampilkannya
    if (language != null) {
      // Hapus snackbar sebelumnya jika ada
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      // Tampilkan snackbar yang baru
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$language selected'),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              // Sembunyikan snackbar jika tombol OK ditekan
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }
}
  
