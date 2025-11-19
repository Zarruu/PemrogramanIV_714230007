import 'package:flutter/material.dart';

final List<Map<String, dynamic>> _myDataList = [];
Map<String, dynamic>? editedData;

class MyInputForm extends StatefulWidget {
  const MyInputForm({super.key});

  @override
  State<MyInputForm> createState() => _MyInputFormState();
}

class _MyInputFormState extends State<MyInputForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerNama = TextEditingController();

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerNama.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    const String expression =
        "[a-zA-Z0-9+._%-+]{1,256}" +
        "@" +
        "[a-zA-Z0-9][a-zA-Z0-9-]{0,64}" +
        "(" +
        "." +
        "[a-zA-Z0-9][a-zA-Z0-9-]{0,25}" +
        ")+";
    final RegExp regExp = RegExp(expression);

    if (value!.isEmpty) {
      return 'Email wajib diisi';
    }

    if (!regExp.hasMatch(value)) {
      return 'Tolong inputkan email yang valid!';
    }

    return null;
  }

  String? _validateName(String? value) {
    if (value!.length < 3) {
      return 'Masukkan setidaknya 3 karakter';
    }

    return null;
  }

  void _addData(String name, String email) {
    final data = {'name': _controllerNama.text, 'email': _controllerEmail.text
    };
    setState(() {
     if (editedData != null) {
      editedData!['name'] = data['name'];
      editedData!['email'] = data['email'];

      editedData = null;
     } else {
      _myDataList.add(data);
     
     _controllerEmail.clear();
     _controllerNama.clear();}
    });
  }

  void _editData(Map<String, dynamic> data) {
    setState(() {
      _controllerEmail.text = data['email'];
      _controllerNama.text = data['name'];
      editedData = data;
    });
  }

  void _deleteData(Map<String, dynamic> data) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this entry?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _myDataList.remove(data);
              });
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Delete'),
          ),
        ],
      );
    });
    
    setState(() {
      _myDataList.remove(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Input')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _controllerEmail,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                decoration: const InputDecoration(
                  hintText: 'Write your email here...',
                  labelText: 'Your Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  fillColor: Color.fromARGB(255, 255, 249, 222),
                  filled: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _controllerNama,
                validator: _validateName,
                decoration: const InputDecoration(
                  hintText: 'Write your name here...',
                  labelText: 'Your Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  fillColor: Color.fromARGB(255, 255, 249, 222),
                  filled: true,
                ),
              ),
            ),
            ElevatedButton(
              child: Text(editedData != null ? 'Update' : 'Submit'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addData(_controllerNama.text, _controllerEmail.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Processing Data, Your form is valid!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Form is not valid! Please review and correct.',
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(
                        'Email: ${_controllerEmail.text}\nName: ${_controllerNama.text}',
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'List Data',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _myDataList.length,
                itemBuilder: (context, index) {
                  final data = _myDataList[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Text(
                            'ULBI',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['name'] ?? ''),
                              Text(data['email'] ?? ''),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _editData(data);
                            });
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _deleteData(data);
                            });
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
