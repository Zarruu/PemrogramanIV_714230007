import 'package:flutter/material.dart';
import 'package:p11_dio_714230007/data_service.dart';
import 'package:p11_dio_714230007/user.dart';
import 'package:p11_dio_714230007/user_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DataService _dataService = DataService();
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _jobCtl = TextEditingController();
  String _result = '-';
  List<User> _users = [];
  UserCreate? _usCreate;
  UserCreate? _usUpdate;

  @override
  void dispose() {
    _nameCtl.dispose();
    _jobCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('REST API (DIO)')),
      body: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameCtl,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Name',
                  suffixIcon: IconButton(
                    onPressed: _nameCtl.clear,
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _jobCtl,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Job',
                  suffixIcon: IconButton(
                    onPressed: _jobCtl.clear,
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final res = await _dataService.getUsers();
                        if (res != null) {
                          setState(() {
                            _result = res.toString();
                          });
                        } else {
                          displaySnackbar('Failed to get data');
                        }
                      },
                      child: const Text('GET'),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_nameCtl.text.isEmpty || _jobCtl.text.isEmpty) {
                          displaySnackbar('Semua field harus diisi');
                          return;
                        }
                        final userCreate = UserCreate(
                          name: _nameCtl.text,
                          job: _jobCtl.text,
                        );
                        var res = await _dataService.postUser(
                          userCreate,
                          'Creating user',
                        );
                        if (res != null) {
                          setState(() {
                            _result = res.toString();
                            _usCreate = UserCreate.fromJson(
                              res as Map<String, dynamic>,
                            );
                          });
                        }
                        _nameCtl.clear();
                        _jobCtl.clear();
                      },
                      child: const Text('POST'),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_nameCtl.text.isEmpty || _jobCtl.text.isEmpty) {
                          displaySnackbar('Semua field harus diisi');
                          return;
                        }
                        final res = await _dataService.putUser(
                          '3',
                          _nameCtl.text,
                          _jobCtl.text,
                        );
                        if (res != null) {
                          setState(() {
                            _result = res.toString();
                            _usUpdate = UserCreate.fromJson(
                              res as Map<String, dynamic>,
                            );
                          });
                        }
                        _nameCtl.clear();
                        _jobCtl.clear();
                      },
                      child: const Text('PUT'),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final res = await _dataService.deleteUser('4');
                        setState(() {
                          _result = res.toString();
                        });
                      },
                      child: const Text('DELETE'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final users = await _dataService.getUserModel();
                        if (users != null) {
                          setState(() {
                            _users = users.toList();
                          });
                        }
                      },
                      child: const Text('Model Class User Example'),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _result = '-';
                        _users.clear();
                        _usCreate = null;
                        _usUpdate = null;
                      });
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Result',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: _users.isEmpty ? Text(_result) : _buildListUser(),
              ),
              hasilCard(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListUser() {
    return ListView.separated(
      itemBuilder: (context, index) {
        final user = _users[index];
        return Card(
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(user.avatar),
            ),
            title: Text('${user.firstName} ${user.lastName}'),
            subtitle: Text(user.email),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10.0),
      itemCount: _users.length,
    );
  }

  Widget hasilCard(BuildContext context) {
    return Column(
      children: [
        if (_usCreate != null) ...[
          const Text(
            'POST Result',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
          UserCard(userCreate: _usCreate!),
          const SizedBox(height: 16.0),
        ],
        if (_usUpdate != null) ...[
          const Text(
            'PUT Result',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
          UserCard(userCreate: _usUpdate!, backgroundColor: Colors.orange[200]),
          const SizedBox(height: 16.0),
        ],
        if (_usCreate == null && _usUpdate == null) const Text('No Data'),
      ],
    );
  }

  dynamic displaySnackbar(String msg) {
    return ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg)));
  }
}
