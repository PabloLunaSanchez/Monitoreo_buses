import 'package:app_bus_tesis/Modelos/user.dart';
import 'package:app_bus_tesis/userPreferences/user_preferences.dart';
import 'package:get/get.dart';

class CurrentUser extends GetxController{

  Rx<User> _currentUser = User(0,'','','','','','','').obs;

  User get user => _currentUser.value;

  obtenerInfoUser() async{
    User? ObtenerInfoFromLocalStorage = await RecordarUserPref.LeerUserInfo();
    _currentUser.value = ObtenerInfoFromLocalStorage!;
  }
}