import 'dart:convert';

import 'package:app_bus_tesis/Modelos/conductor.dart';
import 'package:app_bus_tesis/Modelos/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordarConductorrPref{
  static Future<void> AlmacenaminetoInfoUser(Conductor conductorInfo) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String conductorJsonData = jsonEncode(conductorInfo.toJson());
    await preferences.setString("currentUser", conductorJsonData);
  }  
 
  static Future<Conductor?> LeerUserInfo() async{
    Conductor? currentConductorrInfo;
    SharedPreferences preferences = await SharedPreferences.getInstance();
   String? conductorInfo = preferences.getString("currentUser");
   if(conductorInfo != null){
    Map<String, dynamic> userDataMap  = jsonDecode(conductorInfo); 
    currentConductorrInfo = Conductor.fromJson(userDataMap);
   }
   return currentConductorrInfo;
  }

static Future<void> removerUserInfo() async{
SharedPreferences preferences = await SharedPreferences.getInstance();
await preferences.remove("currentUser");
}
}