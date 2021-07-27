import 'package:covid9ja/base/base_states.dart';
import 'package:covid9ja/models/state_model.dart';
import 'package:covid9ja/models/national_info_model.dart';

abstract class NationalInfoState extends BaseState {}

class NationalInfoLoadingState extends NationalInfoState {
  @override
  List<Object?> get props => [];
}

class NationalInfoLoadedState extends NationalInfoState {
  final NationalInfoPercentageModel? stats;
  final NationalInfo? info;
  final PreferredState? preferredState;

  NationalInfoLoadedState({this.stats, this.preferredState, this.info});

  @override
  List<Object?> get props => [stats, info, preferredState];
}
