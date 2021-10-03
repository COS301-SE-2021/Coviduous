import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as LocationManager;

import 'package:frontend/views/health/covid_info_center.dart';
import 'package:frontend/controllers/health/health_helpers.dart' as healthHelpers;
import 'package:frontend/views/global_widgets.dart' as globalWidgets;
import 'package:frontend/globals.dart' as globals;

class CovidTestingFacilities extends StatefulWidget {
  static const routeName = "/covid_testing_facilities";
  @override
  _CovidTestingFacilitiesState createState() => _CovidTestingFacilitiesState();
}

class _CovidTestingFacilitiesState extends State<CovidTestingFacilities> {
  GoogleMapController mapController;
  GoogleMap map;
  List<PlacesSearchResult> places = [];
  LocationManager.Location locationManager;
  StreamSubscription<LocationManager.LocationData> locationSubscription;
  bool isLoading = false;

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

  setUpMap() {
    map = GoogleMap(
      onMapCreated: _onMapCreated,
      myLocationEnabled: false,
      initialCameraPosition: CameraPosition(
          target: LatLng(globals.selectedLat, globals.selectedLong),
          zoom: 8,
      ),
    );
  }

  _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  Widget getList() {
    if (globals.testingFacilities.isEmpty) {
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        globalWidgets.notFoundMessage(context, 'No test facilities found', 'There are no test facilities nearby.'),
      ]);
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: globals.testingFacilities.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
            child: Card(
              color: Colors.white,
              child: InkWell(
                highlightColor: globals.firstColor,
                splashColor: globals.textFieldSelectedColor,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Text(
                          globals.testingFacilities[index].getAddress(),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2),
                        child: Text(
                          globals.testingFacilities[index].getCity(),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2),
                        child: Text(
                          globals.testingFacilities[index].getPhoneNumber(),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2),
                        child: Text(
                          globals.testingFacilities[index].getDaysOpen(),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2),
                        child: Text(
                          globals.testingFacilities[index].getCoordinates(),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(CovidInformationCenter.routeName);
    return (await true);
  }

  @override
  initState() {
    setUpMap();
    _dropdownMenuItems = buildDropdownMenuItems(_provinces);
    if (_selectedProvince == null) {
      _selectedProvince = _dropdownMenuItems[0].value;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: globals.secondColor,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Testing facilities near you"),
              elevation: 0,
              leading: BackButton( //Specify back button
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(CovidInformationCenter.routeName);
                },
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
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
                                        Navigator.pop(context);
                                        healthHelpers.getTestingFacilities(province).then((result) {
                                          setState(() {});
                                          setUpMap();
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
                      child: Text('Choose different location')
                  )
                ],
              ),
            ),
            body: Center(
              child: (isLoading == false) ? Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: SizedBox(
                          height: 200,
                          child: map,
                      ),
                    ),
                    Expanded(
                        child: getList()
                    ),
                  ],
                ),
              ) : CircularProgressIndicator(),
            )
        ),
      ),
    );
  }
}