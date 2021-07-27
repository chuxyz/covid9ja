import 'package:http/http.dart';
import 'package:covid9ja/models/state_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'network/network_utils.dart';

final client = Client();

final netWorkUtils = NetworkUtils();

final mySharedPreferences = MySharedPreferences();

final RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
//final Function mathFunc = (Match match) => '${match[1]},';

String mathFunc(Match match) => '${match[1]},';

abstract class UrlConstants {
  static const String baseUrl = 'https://covid9ja.herokuapp.com';
  static const String nationalInfo = '$baseUrl/api/ngrec/?format=json';
  static const String allStates = '$baseUrl/api/strec/?format=json';
}

abstract class SharedPreferencesKeys {
  static const String isDarkTheme = 'isDarkTheme';
  static const String preferredStateDetails = 'preferredState';
}

class MySharedPreferences {
  Future<List<String>?> fetchPreferredState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList(SharedPreferencesKeys.preferredStateDetails);
    return list;
  }

  Future setPreferredState(PreferredState state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs
        .setStringList(SharedPreferencesKeys.preferredStateDetails, <String>[
      state.stateName,
      state.stateCases,
      state.stateDeaths,
    ]);
  }
}
