import 'package:flutter/material.dart';
import 'package:covid9ja/controllers/ngcovid_api.dart';
import 'package:covid9ja/custom_widgets/statistic_card.dart';
import 'package:covid9ja/custom_widgets/theme_switch.dart';
import 'package:covid9ja/custom_widgets/virus_loader.dart';
import 'package:covid9ja/models/state_model.dart';

import '../config.dart';

class StatesDetailPage extends StatefulWidget {
  final String stateName;

  StatesDetailPage({required this.stateName});

  @override
  _StatesDetailPageState createState() => _StatesDetailPageState();
}

class _StatesDetailPageState extends State<StatesDetailPage> {
  Statez? _stateInfo;
  double? deathPercentage;
  double? activePercentage;
  bool _isLoading = false;
  bool _isHome = false;
  NgCovidApi api = NgCovidApi();
  double? dischargedPercentage;
  bool _isSettingState = false;

  @override
  void initState() {
    super.initState();
    _initiateSharedPreferences();
    _fetchStatesDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.stateName,
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).accentColor,
          ),
        ),
        actions: <Widget>[
          ThemeSwitch(),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? VirusLoader()
            : _stateInfo == null
                ? buildErrorMessage()
                : ListView(
                    children: <Widget>[
                      if (!_isHome)
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: GestureDetector(
                                  onTap: _isSettingState
                                      ? null
                                      : () async {
                                          setState(() {
                                            _isSettingState = true;
                                          });
                                          await mySharedPreferences
                                              .setPreferredState(PreferredState(
                                            stateName: (_stateInfo!.stateName)!,
                                            stateCases:
                                                (_stateInfo!.casesConfirmed)!
                                                    .toString(),
                                            stateDeaths:
                                                (_stateInfo!.deathCases)!
                                                    .toString(),
                                          ));
                                          setState(() {
                                            _isHome = true;
                                            _isSettingState = false;
                                          });
                                        },
                                  child: Container(
                                    padding: const EdgeInsets.all(4.0),
                                    margin: const EdgeInsets.all(16.0),
                                    child: Text(
                                      _isSettingState
                                          ? '...'
                                          : 'Set as Preferred State',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      StatisticCard(
                        color: Colors.orange,
                        text: 'Cases Confirmed',
                        icon: Icons.timeline,
                        stats: _stateInfo!.casesConfirmed!,
                      ),
                      StatisticCard(
                        color: Colors.green,
                        text: 'Total Discharged',
                        icon: Icons.verified_user,
                        stats: _stateInfo!.casesDischarged!,
                      ),
                      StatisticCard(
                        color: Colors.blue,
                        text: 'Cases on admission',
                        icon: Icons.whatshot,
                        stats: (_stateInfo!.casesOnAdmission)!,
                      ),
                      // StatisticCard(
                      //   color: Colors.black,
                      //   text: 'Critical cases',
                      //   icon: Icons.battery_alert,
                      //   stats: (_stateInfo!.casesOnAdmission)!,
                      // ),
                      // StatisticCard(
                      //   color: Colors.blueGrey,
                      //   text: 'Total tests',
                      //   icon: Icons.youtube_searched_for,
                      //   stats: _stateInfo!.samplesTested ?? 0,
                      // ),
                      StatisticCard(
                        color: Colors.red,
                        text: 'Total deaths',
                        icon: Icons.airline_seat_individual_suite,
                        stats: (_stateInfo!.deathCases)!,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Card(
                          elevation: 4.0,
                          child: ListTile(
                            leading: Icon(
                              Icons.sentiment_very_dissatisfied,
                              color: Colors.red,
                            ),
                            title: Text('Death percentage'),
                            trailing: Text(
                              deathPercentage!.toStringAsFixed(2) + ' %',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Card(
                          elevation: 4.0,
                          child: ListTile(
                            leading: Icon(
                              Icons.sentiment_very_satisfied,
                              color: Colors.green,
                            ),
                            title: Text('Recovery percentage'),
                            trailing: Text(
                              dischargedPercentage!.toStringAsFixed(2) + ' %',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
      ),
    );
  }

  Center buildErrorMessage() {
    return Center(
      child: Text(
        'Unable to fetch data',
        style:
            Theme.of(context).textTheme.headline6?.copyWith(color: Colors.grey),
      ),
    );
  }

  void _fetchStatesDetails() async {
    setState(() => _isLoading = true);
    try {
      var stateInfo = await api.getStateByName(widget.stateName);
      deathPercentage =
          ((stateInfo.deathCases)! / (stateInfo.casesConfirmed)!) * 100;
      dischargedPercentage =
          ((stateInfo.casesDischarged)! / (stateInfo.casesConfirmed)!) * 100;
      activePercentage = 100 - (deathPercentage! + dischargedPercentage!);

      print(deathPercentage);
      print(dischargedPercentage);
      print(activePercentage);
      setState(() => _stateInfo = stateInfo);
    } catch (ex) {
      setState(() => _stateInfo = null);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _initiateSharedPreferences() async {
    var list = await mySharedPreferences.fetchPreferredState();
    if (list != null && list[0].compareTo(widget.stateName) == 0)
      setState(() {
        _isHome = true;
      });
  }
}
