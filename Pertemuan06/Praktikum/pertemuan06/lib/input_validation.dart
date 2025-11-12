import 'package:flutter/material.dart';

String? _validateEmail(String? value) {
  const String expression = "[a-zA-Z0-9+._%-+]{1,256}" +
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

class MyFormValidation extends StatefulWidget {
  const MyFormValidation({super.key});

  @override
  State<MyFormValidation> createState() => _MyFormValidationState();
}

class _MyFormValidationState extends State<MyFormValidation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerNama = TextEditingController();

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerNama.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Validation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
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
                child: const Text('Submit'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Processing Data, Your form is valid!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Form is not valid! Please review and correct.'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                  }
                  showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text('Email: ${_controllerEmail.text}\nName: ${_controllerNama.text}'),
                    );
                  },
                );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
