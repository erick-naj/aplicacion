import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';

import 'package:seguridad_informatica/controllers/user_controller.dart';
import 'package:seguridad_informatica/helpers/database_helper.dart';
import 'package:seguridad_informatica/models/users.dart';

class RegistrerPage extends StatefulWidget {
  const RegistrerPage({super.key});
  static const pageName = "registrer-page";

  @override
  State<RegistrerPage> createState() => _RegistrerPageState();
}

class _RegistrerPageState extends State<RegistrerPage> {
  UserController _userController = Get.find();
  String userName = "";
  String password = "";
  String name = "";
  User user = User();
  List<User> users = [];
  bool _isLoading = false;

  set isLoading(bool val) {
    this._isLoading = val;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getUsers();

    super.initState();
  }

  getUsers() async {
    isLoading = true;
    users = await DatabaseHelper.instance.getUserList();

    setState(() {});
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrarse"),
      ),
      body: Column(
        children: [
          SizedBox(
              width: 300,
              child: TextFormField(
                initialValue: name,
                onChanged: (value) {
                  user.name = value;
                },
                decoration: InputDecoration(hintText: "Nombre"),
              )),
          SizedBox(
              width: 300,
              child: TextFormField(
                initialValue: userName,
                onChanged: (value) {
                  user.userName = value;
                },
                decoration: InputDecoration(hintText: "Usuario"),
              )),
          SizedBox(
              width: 300,
              child: TextFormField(
                initialValue: password,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(hintText: "Contraseña"),
              )),
          ElevatedButton(
              onPressed: () {
                register();
              },
              child: Text("Registrar"))
        ],
      ),
    );
  }

  void register() async {
    if (users.isNotEmpty) {
      User exist = users.firstWhere(
        (element) => element.userName == user.userName,
        orElse: () => User(name: ""),
      );
      if (exist.name != "") {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: SizedBox(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Usuario ya registrado"),
                    ElevatedButton(
                        onPressed: () {
                          exist = User();
                          Get.back();
                        },
                        child: const Text("Entendido"))
                  ],
                ),
              ),
            );
          },
        );
      } else {
        user.password = BCrypt.hashpw(password, BCrypt.gensalt());
        print(user.password);
        var response = await DatabaseHelper.instance.insertUser(user);
        print(response);

        Get.back(result: true);
      }
    } else {
      user.password = BCrypt.hashpw(password, BCrypt.gensalt());
      print(user.password);
      var response = await DatabaseHelper.instance.insertUser(user);
      print(response);

      Get.back(result: true);
    }
  }
}
