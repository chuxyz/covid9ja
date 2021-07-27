import 'package:flutter/material.dart';
import 'package:covid9ja/controllers/ngcovid_api.dart';
import 'package:covid9ja/custom_widgets/virus_loader.dart';
import 'package:covid9ja/config.dart';
import 'package:covid9ja/models/state_model.dart';
import 'package:covid9ja/screens/state_details.dart';

class StateListPage extends StatefulWidget {
  @override
  _StateListPageState createState() => _StateListPageState();
}

class _StateListPageState extends State<StateListPage> {
  bool _isLoading = false;
  NgCovidApi api = NgCovidApi();
  List<Statez> dynamicStateDataList = <Statez>[];
  FocusNode _focusNode = FocusNode();
  List<Statez>? _stateDataList = <Statez>[];
  TextEditingController _textEditingController = TextEditingController();

  PreferredState? _preferredState;

  @override
  void initState() {
    super.initState();
    _fetchStates();
  }

  void filterSearchResults(String searchQuery) {
    List<Statez> allStateDataList = <Statez>[];
    allStateDataList.addAll(_stateDataList!);
    if (searchQuery.isNotEmpty) {
      List<Statez> searchedStateDataList = <Statez>[];
      allStateDataList.forEach((item) {
        if ((item.stateName)!
            .toLowerCase()
            .contains(searchQuery.toLowerCase())) {
          searchedStateDataList.add(item);
        }
      });
      setState(() {
        dynamicStateDataList.clear();
        dynamicStateDataList.addAll(searchedStateDataList);
      });
      return;
    } else {
      setState(() {
        dynamicStateDataList.clear();
        dynamicStateDataList.addAll(_stateDataList!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? VirusLoader()
          : _stateDataList == null
              ? buildErrorMessage()
              : Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        child: TextFormField(
                          focusNode: _focusNode,
                          controller: _textEditingController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Theme.of(context).accentColor,
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor)),
                              labelText: 'Search',
                              labelStyle: TextStyle(
                                  color: Theme.of(context).accentColor),
                              hintText: 'Enter name of state'),
                          onChanged: filterSearchResults,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: dynamicStateDataList.length,
                        itemBuilder: (context, index) {
                          var stateDataItem = dynamicStateDataList[index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Card(
                              elevation: 4.0,
                              child: ListTile(
                                onTap: () {
                                  _textEditingController.clear();
                                  filterSearchResults('');
                                  _focusNode.unfocus();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => StatesDetailPage(
                                          stateName:
                                              stateDataItem.stateName ?? ''),
                                    ),
                                  );
                                },
                                title: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(
                                            stateDataItem.stateName!.trim())),
                                    if (_preferredState != null &&
                                        _preferredState?.stateName.compareTo(
                                                stateDataItem.stateName!) ==
                                            0)
                                      Icon(
                                        Icons.home,
                                        size: 16.0,
                                      )
                                  ],
                                ),
                                subtitle: Text('Cases: ' +
                                    stateDataItem.casesConfirmed.toString()),
                                trailing:
                                    Icon(Icons.keyboard_arrow_right_rounded),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Center buildErrorMessage() {
    return Center(
      child: Text(
        'Unable to fetch data',
        style:
            Theme.of(context).textTheme.headline6!.copyWith(color: Colors.grey),
      ),
    );
  }

  void _fetchStates() async {
    try {
      setState(() => _isLoading = true);
      var preferredStateData = await mySharedPreferences.fetchPreferredState();
      List<Statez> states = await api.getAllStateInfo();
      setState(() {
        _stateDataList = states;
        dynamicStateDataList.addAll(_stateDataList!);
        if (preferredStateData != null)
          setState(() {
            _preferredState = PreferredState(
              stateName: preferredStateData[0],
              stateCases: preferredStateData[1],
              stateDeaths: preferredStateData[2],
            );
          });
      });
    } catch (ex) {
      setState(() => _stateDataList = null);
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
