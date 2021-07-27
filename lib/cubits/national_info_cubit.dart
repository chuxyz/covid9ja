import 'package:covid9ja/base/base_cubit.dart';
import 'package:covid9ja/base/base_states.dart';
import 'package:covid9ja/controllers/ngcovid_api.dart';
import 'package:covid9ja/models/state_model.dart';
import 'package:covid9ja/models/national_info_model.dart';
import 'package:covid9ja/states/national_info_state.dart';

import '../config.dart';

class NationalInfoCubit extends BaseCubit<BaseState> {
  NgCovidApi api = NgCovidApi();

  fetchNationalStats() async {
    makeACall(
        function: () async {
          emit(NationalInfoLoadingState());

          var response = await api.getNationalInfo();
          var deathPercentage =
              (response.deaths! / response.confirmedCases!) * 100;
          var dischargedPercentage =
              (response.dischargedCases! / response.confirmedCases!) * 100;
          var model = NationalInfoPercentageModel(
            deathPercentage: deathPercentage,
            dischargedPercentage: dischargedPercentage,
            activePercentage: 100 - (deathPercentage + dischargedPercentage),
          );

          PreferredState? _preferredState;
          var list = await mySharedPreferences.fetchPreferredState();
          if (list != null) {
            _preferredState = PreferredState(
              stateName: list[0],
              stateCases: list[1],
              stateDeaths: list[2],
            );
          }

          emit(NationalInfoLoadedState(
            stats: model,
            preferredState: _preferredState,
            info: response,
          ));
        },
        onError: (state) => emit(state));
  }
}
