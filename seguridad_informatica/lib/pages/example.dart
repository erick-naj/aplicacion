import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:pointycastle/asymmetric/api.dart';

import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/api.dart' as crypto;
import 'package:seguridad_informatica/helpers/prefs.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _loading = false;
  var helper = RsaKeyHelper();
  crypto.AsymmetricKeyPair? keyPair;

  Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>>
      getKeyPair() {
    return helper.computeRSAKeyPair(helper.getSecureRandom());
  }

  @override
  void initState() {
    super.initState();
    getKeys();
  }

  Future<void> getKeys() async {
    setState(() {
      _loading = true;
    });
    keyPair = await getKeyPair();

    var cipherText = encrypt("plaintext", keyPair!.publicKey as RSAPublicKey);

    print(cipherText);
    var plainText = decrypt(cipherText, keyPair!.privateKey as RSAPrivateKey);
    print(plainText);

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _keys(),
      ),
    );
  }

  Widget _keys() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: [
        Text("${keyPair?.publicKey.toString()}"),
      ],
    );
  }
}
