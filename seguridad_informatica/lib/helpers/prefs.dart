import 'package:pointycastle/asymmetric/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static SharedPreferences? prefs;

  static Future<void> configurePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  static void setUserPublicKey(dynamic publicKey) {
    prefs?.setString('public_key', publicKey);
  }

  static dynamic get userPublicKey {
    return prefs?.getString("public_key");
  }

  static void setUserPrivateKey(dynamic privateKey) {
    prefs?.setString("private_key", privateKey);
  }

  static dynamic get userProfile {
    return prefs?.getString("private_key");
  }

  static clearPrefs() {
    prefs?.clear();
  }
}
