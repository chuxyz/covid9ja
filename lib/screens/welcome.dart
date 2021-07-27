import 'package:flutter/material.dart';
import 'package:covid9ja/custom_widgets/theme_switch.dart';
import 'package:covid9ja/screens/personal_info.dart';
import 'state_list.dart';
import 'national_info.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  String _currentAppBarTitle = 'Nigeria';
  int _currentIndex = 0;

  List<Widget> _widgets = <Widget>[
    NationalInfoPage(),
    StateListPage(),
    PersonalInfoScreen(),
  ];

  bool _showNavigationRail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentAppBarTitle,
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.coronavirus),
          color: Theme.of(context).accentColor,
          onPressed: () {
            setState(() {
              _showNavigationRail = !_showNavigationRail;
            });
          },
        ),
        actions: <Widget>[
          ThemeSwitch(),
        ],
      ),
      body: Row(
        children: [
          AnimatedCrossFade(
            crossFadeState: _showNavigationRail
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 300),
            firstChild: Container(),
            secondChild: NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (int index) {
                _currentIndex = index;
                switch (index) {
                  case 0:
                    _currentAppBarTitle = 'Nigeria';
                    break;
                  case 1:
                    _currentAppBarTitle = 'States';
                    break;
                  case 2:
                    _currentAppBarTitle = 'About';
                    break;
                }
                setState(() {});
              },
              labelType: NavigationRailLabelType.selected,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.public),
                  selectedIcon: Icon(
                    Icons.public,
                    color: Theme.of(context).accentColor,
                  ),
                  label: Text(
                    'Nigeria',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.list),
                  selectedIcon: Icon(
                    Icons.list,
                    color: Theme.of(context).accentColor,
                  ),
                  label: Text(
                    'States',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.info),
                  selectedIcon: Icon(
                    Icons.info,
                    color: Theme.of(context).accentColor,
                  ),
                  label: Text(
                    'About',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _widgets.elementAt(_currentIndex)),
        ],
      ),
    );
  }
}
