import 'package:app_bus_tesis/Modelos/conductor.dart';
import 'package:app_bus_tesis/conductorPreferences/conductor_preferences.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CurrentUserConductor extends GetxController{

  Rx<Conductor> _currentConductor = Conductor(0,'','','','','','','','').obs;

  Conductor get user => _currentConductor.value;

  obtenerInfoUser() async{
    Conductor? ObtenerInfoFromLocalStorage = await RecordarConductorrPref.LeerUserInfo();
    _currentConductor.value = ObtenerInfoFromLocalStorage!;
  }
}