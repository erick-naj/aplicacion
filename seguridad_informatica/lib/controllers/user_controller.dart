import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:seguridad_informatica/models/users.dart';

class UserController extends GetxController {
  RxList<User> users = List<User>.empty().obs;
}
