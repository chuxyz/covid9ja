import 'dart:convert';
import 'package:covid9ja/models/state_model.dart';
import 'package:covid9ja/models/national_info_model.dart';
import '../config.dart';

class NgCovidApi {
  Future<NationalInfo> getNationalInfo() async {
    String response = await netWorkUtils.get(UrlConstants.nationalInfo);
    return NationalInfo.fromJson(jsonDecode(response)[0]);
  }

  Future<List<Statez>> getAllStateInfo() async {
    var response = await netWorkUtils.get(UrlConstants.allStates);
    var list = jsonDecode(response) as List;
    return list
        .map((item) => Statez.fromJson(item))
        .toList(); // list of state objects
  }

  Future<Statez> getStateByName(String stateName) async {
    Map<String, dynamic> result = {};
    var response = await netWorkUtils.get('${UrlConstants.allStates}');
    var list = jsonDecode(response) as List;
    for (Map<String, dynamic> map in list) {
      if (map['State'] == stateName) {
        result = map;
        break;
      }
    }
    return Statez.fromJson(result);
  }
}
