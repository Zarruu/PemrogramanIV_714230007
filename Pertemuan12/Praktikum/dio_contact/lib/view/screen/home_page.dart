import 'package:dio_contact/view/widget/contact_card.dart';
import 'package:flutter/material.dart';
import 'package:dio_contact/model/contact_model.dart';
import 'package:dio_contact/services/api_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _numberCtl = TextEditingController();
  String _result = '-';
  final ApiServices _dataService = ApiServices();
  List<ContactsModel> _contactMdl = [];
  ContactResponse? ctRes;
  bool isEdit = false;
  String idContact = '';

  Future<void> refreshContactList() async {
    final users = await _dataService.getAllContact();
    setState(() {
      if (_contactMdl.isNotEmpty) _contactMdl.clear();
      if (users != null) {
        _contactMdl.addAll(users.toList().reversed);
      }
    });
  }

  String? _validateName(String? value) {
    if (value != null && value.length < 4) {
      return 'Masukkan minimal 4 karakter';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (!RegExp(r'^[0-9]+$').hasMatch(value!)) {
      return 'Nomor HP harus berisi angka';
    }
    return null;
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _numberCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts API')),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameCtl,
                validator: _validateName,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Nama',
                  suffixIcon: IconButton(
                    onPressed: _nameCtl.clear,
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _numberCtl,
                validator: _validatePhoneNumber,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Nomor HP',
                  suffixIcon: IconButton(
                    onPressed: _numberCtl.clear,
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.0,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final isValidForm = _formKey.currentState!.validate();

                          if (_nameCtl.text.isEmpty ||
                              _numberCtl.text.isEmpty) {
                            displaySnackbar('Semua field harus diisi!');
                            return;
                          } else if (!isValidForm) {
                            displaySnackbar("Isi form dengan benar!");
                            return;
                          }
                          final postModel = ContactInput(
                            namaKontak: _nameCtl.text,
                            nomorHp: _numberCtl.text,
                          );

                          ContactResponse? res;
                          if (isEdit) {
                            res = await _dataService.putContact(
                              idContact,
                              postModel,
                            );
                          } else {
                            res = await _dataService.postContact(postModel);
                          }

                          setState(() {
                            ctRes = res;
                            isEdit = false;
                          });
                          _nameCtl.clear();
                          _numberCtl.clear();
                          await refreshContactList();
                        },
                        child: Text(isEdit ? 'UPDATE' : 'POST'),
                      ),
                      if (isEdit)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          onPressed: () {
                            _nameCtl.clear();
                            _numberCtl.clear();
                            setState(() {
                              isEdit = false;
                            });
                          },
                          child: const Text('Cancel Update'),
                        ),
                    ],
                  ),
                ],
              ),
              hasilCard(context),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await refreshContactList();
                        setState(() {});
                      },
                      child: const Text('Refresh Data'),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _result = '-';
                        _contactMdl.clear();
                        ctRes = null;
                      });
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const Text(
                'List Contact',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: _contactMdl.isEmpty
                    ? Text(_result)
                    : _buildListContact(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListContact() {
    return ListView.separated(
      itemBuilder: (context, index) {
        final ctList = _contactMdl[index];
        return Card(
          child: ListTile(
            title: Text(ctList.namaKontak),
            subtitle: Text(ctList.nomorHp),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    final contacts = await _dataService.getSingleContact(
                      ctList.id,
                    );
                    if (contacts != null) {
                      setState(() {
                        _nameCtl.text = contacts.namaKontak;
                        _numberCtl.text = contacts.nomorHp;
                        isEdit = true;
                        idContact = contacts.id;
                      });
                    }
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(onPressed: () {
                  _showDeleteConfirmationDialog(ctList.id, ctList.namaKontak);
                }, icon: const Icon(Icons.delete)),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10.0),
      itemCount: _contactMdl.length,
    );
  }

  Widget hasilCard(BuildContext context) {
    return Column(
      children: [
        if (ctRes != null)
          ContactCard(
            ctRes: ctRes!,
            onDismissed: () {
              setState(() {
                ctRes = null;
              });
            },
          )
        else
          const Text(''),
      ],
    );
  }

  void _showDeleteConfirmationDialog(String id, String nama) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus kontak $nama?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                ContactResponse? res = await _dataService.deleteContact(id);
                setState(() {
                  ctRes = res;
                });
                Navigator.of(context).pop();
                await refreshContactList();
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
  }

  dynamic displaySnackbar(String msg) {
    return ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg)));
  }
}
