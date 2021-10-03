import 'package:flutter/material.dart';

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/health/covid_statistics.dart';
import 'package:frontend/views/health/covid_testing_facilities.dart';
import 'package:frontend/views/health/covid_vaccine_facilities.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/user_homepage.dart';

import 'package:frontend/controllers/health/health_helpers.dart' as healthHelpers;
import 'package:frontend/globals.dart' as globals;

class CovidInformationCenter extends StatefulWidget {
  static const routeName = "/covid_info";
  @override
  _CovidInformationCenterState createState() => _CovidInformationCenterState();
}

class _CovidInformationCenterState extends State<CovidInformationCenter> {
  //This function ensures that the app doesn't just close when you press a phone's physical back button
  Future<bool> _onWillPop() async {
    if (globals.previousPage != '' && globals.previousPage != null) {
      Navigator.of(context).pushReplacementNamed(globals.previousPage);
    } else {
      if (globals.loggedInUserType == 'ADMIN') {
        Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
      } else if (globals.loggedInUserType == 'USER') {
        Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      }
    }
    return (await true);
  }

  List<String> _provinces = ['Eastern Cape', 'Free State', 'Gauteng', 'KwaZulu-Natal', 'Limpopo', 'Mpumalanga', 'Northern Cape', 'North West', 'Western Cape'];
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  String _selectedProvince;

  List<DropdownMenuItem<String>> buildDropdownMenuItems(List provinces) {
    List<DropdownMenuItem<String>> items = [];
    for (String province in provinces) {
      items.add(
        DropdownMenuItem(
          value: province,
          child: Text(province),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems2(List centerTypes) {
    List<DropdownMenuItem<String>> items = [];
    for (String centerType in centerTypes) {
      items.add(
        DropdownMenuItem(
          value: centerType,
          child: Text(centerType),
        ),
      );
    }
    return items;
  }

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_provinces);
    if (_selectedProvince == null) {
      _selectedProvince = _dropdownMenuItems[0].value;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text("COVID-19 information center"),
            elevation: 0,
            leading: BackButton( //Specify back button
              onPressed: () {
                if (globals.previousPage != '' && globals.previousPage != null) {
                  Navigator.of(context).pushReplacementNamed(globals.previousPage);
                } else {
                  if (globals.loggedInUserType == 'ADMIN') {
                    Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
                  } else if (globals.loggedInUserType == 'USER') {
                    Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
                  } else {
                    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                  }
                }
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width/(2*globals.getWidgetWidthScaling()),
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                        Icons.medical_services,
                        color: Colors.white,
                        size: (globals.getIfOnPC())
                            ? MediaQuery.of(context).size.width/8
                            : MediaQuery.of(context).size.width/4
                    ),
                    SizedBox (
                      height: MediaQuery.of(context).size.height/30,
                      width: MediaQuery.of(context).size.width,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/14,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom (
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row (
                            children: <Widget>[
                              Expanded(child: Text('COVID-19 statistics')),
                              Icon(Icons.bar_chart)
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                            crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                        ),
                        onPressed: () {
                          healthHelpers.getAllCovidData().then((result) {
                            Navigator.of(context).pushReplacementNamed(CovidStatistics.routeName);
                          });
                        },
                      ),
                    ),
                    SizedBox (
                      height: MediaQuery.of(context).size.height/30,
                      width: MediaQuery.of(context).size.width,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/14,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom (
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row (
                            children: <Widget>[
                              Expanded(child: Text('Find testing facilities near you')),
                              Icon(Icons.map)
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                            crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title: Text('Select province'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setState) {
                                            return Theme(
                                              data: ThemeData.dark(),
                                              child: DropdownButton(
                                                isExpanded: true,
                                                value: _selectedProvince,
                                                items: _dropdownMenuItems,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedProvince = value;
                                                  });
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('Submit'),
                                        onPressed: () {
                                          globals.selectedProvince = _selectedProvince;
                                          globals.selectedLat = globals.getLat(_selectedProvince);
                                          globals.selectedLong = globals.getLong(_selectedProvince);
                                          String province = globals.getProvinceCode(_selectedProvince);
                                          healthHelpers.getTestingFacilities(province).then((result) {
                                            Navigator.of(context).pushReplacementNamed(CovidTestingFacilities.routeName);
                                          });
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ]);
                              });
                        },
                      ),
                    ),
                    SizedBox (
                      height: MediaQuery.of(context).size.height/30,
                      width: MediaQuery.of(context).size.width,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/14,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom (
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row (
                            children: <Widget>[
                              Expanded(child: Text('Find vaccination facilities near you')),
                              Icon(Icons.map)
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                            crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title: Text('Select province'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setState) {
                                            return Theme(
                                              data: ThemeData.dark(),
                                              child: DropdownButton(
                                                isExpanded: true,
                                                value: _selectedProvince,
                                                items: _dropdownMenuItems,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedProvince = value;
                                                  });
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('Submit'),
                                        onPressed: () {
                                          globals.selectedProvince = _selectedProvince;
                                          globals.selectedLat = globals.getLat(_selectedProvince);
                                          globals.selectedLong = globals.getLong(_selectedProvince);
                                          String province = globals.getProvinceCode(_selectedProvince);
                                          healthHelpers.getVaccineFacilities(province).then((result) {
                                            Navigator.of(context).pushReplacementNamed(CovidVaccineFacilities.routeName);
                                          });
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ]);
                              });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}