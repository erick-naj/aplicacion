import 'dart:convert';
import 'dart:math';

import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:seguridad_informatica/controllers/user_controller.dart';
import 'package:seguridad_informatica/helpers/database_helper.dart';
import 'package:seguridad_informatica/models/users.dart';
import 'package:seguridad_informatica/pages/explore_page.dart';
import 'package:seguridad_informatica/pages/registrer_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static const pageName = "login-page";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  UserController _userController = Get.find();
  //List<encrypt.Encrypted> users = [];
  List<User> users = [];

  String userName = "";
  String password = "";
  bool correctPass = false;
  bool _isLoading = false;
  bool result = false;

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Aplicacion"),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      initialValue: userName,
                      onChanged: (value) {
                        userName = value;
                        setState(() {});
                      },
                      decoration:
                          const InputDecoration(hintText: "Nombre de Usuario"),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      initialValue: password,
                      onChanged: (value) {
                        password = value;
                        setState(() {});
                      },
                      decoration: const InputDecoration(hintText: "Contraseña"),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        login();
                      },
                      child: Text("Iniciar Sesion")),
                  ElevatedButton(
                      onPressed: () async {
                        var result = await Get.toNamed(RegistrerPage.pageName);
                        if (result == null || result == true) {
                          getUsers();
                        }
                      },
                      child: Text("Registrarse"))
                ],
              ),
      ),
    );
  }

  void login() async {
    users.forEach((element) {
      if (element.userName == userName) {
        correctPass = BCrypt.checkpw(password, element.password!);
        if (correctPass) {
          print("Puede pasar");
          Get.toNamed(ExplorePage.pageName);
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Column(
                  children: [
                    Text("Contraseña Incorrecta"),
                    ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text("Entendido"))
                  ],
                ),
              );
            },
          );
        }
      }
    });
  }
}
