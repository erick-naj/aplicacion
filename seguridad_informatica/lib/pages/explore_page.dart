import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encry;
import 'package:get/route_manager.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:seguridad_informatica/helpers/database_helper.dart';
import 'package:seguridad_informatica/models/students.dart';
import 'package:pointycastle/api.dart' as crypto;

List<String> groups = <String>[
  'Selecciona Grupo',
  '7TIDGSA',
  '7TIDGSB',
  '7TIEVNDA',
  '7TIEVNDB'
];

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});
  static const pageName = "explore-page";

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  bool _isLoading = false;

  set isLoading(bool val) {
    this._isLoading = val;
    setState(() {});
  }

  List<Student> students = [];
  Student student = Student();

  String dropdownValue = groups.first;

  String regisTag = "";
  @override
  void initState() {
    // TODO: implement initState
    getStudents();
    contra();
    super.initState();
  }

  getStudents() async {
    isLoading = true;
    students = await DatabaseHelper.instance.getStudentsList();

    setState(() {});
    isLoading = false;
  }

  //Future to hold our KeyPair
  Future<crypto.AsymmetricKeyPair>? futureKeyPair;

//to store the KeyPair once we get data from our future
  crypto.AsymmetricKeyPair? keyPair;

  Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>>
      getKeyPair() {
    var helper = RsaKeyHelper();

    return helper.computeRSAKeyPair(helper.getSecureRandom());
  }

  void contra() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenido"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        await _addStudent(context);
                      },
                      child: Center(child: Text("Agregar Alumno"))),
                ),
                if (students.isNotEmpty)
                  DataTable(columns: const [
                    DataColumn(label: Text('Matricula')),
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Apellido')),
                    DataColumn(label: Text('Grupo')),
                  ], rows: [
                    ...students.map((student) {
                      return DataRow(cells: [
                        DataCell(Text(getRegisTag(student.registrationTag!))),
                        DataCell(Text(student.name!)),
                        DataCell(Text(student.lastName!)),
                        DataCell(Text(student.group!))
                      ]);
                    })
                  ]),
              ],
            ),
    );
  }

  Future<dynamic> _addStudent(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Column(
                children: [
                  Text("Agregar Alumno"),
                  TextFormField(
                    initialValue: "",
                    onChanged: (value) {
                      student.name = value;
                    },
                    decoration: InputDecoration(hintText: "Nombre"),
                  ),
                  TextFormField(
                    initialValue: "",
                    onChanged: (value) {
                      student.lastName = value;
                    },
                    decoration: InputDecoration(hintText: "Apellido"),
                  ),
                  TextFormField(
                    initialValue: "",
                    onChanged: (value) {
                      regisTag = value;
                    },
                    decoration: InputDecoration(hintText: "Matricula"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Grupo"),
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.green,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          student.group = value;
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items: groups
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        registerStudent(regisTag);
                        Get.back();
                        getStudents();
                      },
                      child: const Text("Agregar"))
                ],
              ),
            );
          },
        );
      },
    );
  }

  void registerStudent(String password) async {
    //simetrico

    final key = encry.Key.fromUtf8('my32lengthsupersecretnooneknows1');

    final b64key =
        encry.Key.fromUtf8(base64Url.encode(key.bytes).substring(0, 32));

    final fernet = encry.Fernet(b64key);
    final encrypter = encry.Encrypter(fernet);

    final encrypted = encrypter.encrypt(password);

    //Campo que se envia a la base de datos
    student.registrationTag = base64Encode(encrypted.bytes);

    var response = await DatabaseHelper.instance.insertStudent(student);
    print(response);
  }

  String base64Encode(List<int> bytes) => base64.encode(bytes);

  String getRegisTag(String word) {
    String pass;
    final key = encry.Key.fromUtf8('my32lengthsupersecretnooneknows1');
    dynamic decrypted;

    final b64key =
        encry.Key.fromUtf8(base64Url.encode(key.bytes).substring(0, 32));

    final fernet = encry.Fernet(b64key);
    final encrypter = encry.Encrypter(fernet);

    //Para desencriptar la contraseña cuando viene de la base de datos se usa este codigo
    decrypted = encrypter.decrypt(encry.Encrypted.fromBase64(word));
    pass = decrypted.toString();
    return pass;
  }
}
