import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as LocationManager;

import 'package:frontend/views/health/covid_info_center.dart';
import 'package:frontend/globals.dart' as globals;

class CovidVaccineFacilities extends StatefulWidget {
  static const routeName = "/covid_vaccine_facilities";
  @override
  _CovidVaccineFacilitiesState createState() => _CovidVaccineFacilitiesState();
}

const googleApiKey = "AIzaSyDRvPZC7hHO7KZN4L6_K0siuDxsjlPqARs";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: googleApiKey);

class _CovidVaccineFacilitiesState extends State<CovidVaccineFacilities> {
  GoogleMapController mapController;
  GoogleMap map;
  List<PlacesSearchResult> places = [];
  LocationManager.Location locationManager;
  StreamSubscription<LocationManager.LocationData> locationSubscription;
  bool isLoading = false;

  List<String> _provinces = ['Eastern Cape', 'Free State', 'Gauteng', 'KwaZulu-Natal', 'Limpopo', 'Mpumalanga', 'Northern Cape', 'North West', 'Western Cape'];
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  String _selectedProvince;

  List<String> _centerTypes = ['Private', 'Public'];
  List<DropdownMenuItem<String>> _dropdownMenuItems2;
  String _selectedCenterType;

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

  refresh() async {
    final center = LatLng(globals.selectedLat, globals.selectedLong);
    getNearbyPlaces(center);
  }

  getNearbyPlaces(LatLng center) async {
    setState(() {
      isLoading = true;
    });

    final location = Location(lat: center.latitude, lng: center.longitude);
    final result = await _places.searchNearbyWithRadius(location, 2500);
    setState(() {
      isLoading = false;
      if (result.status == "OK") {
        this.places = result.results;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No nearby places found. Please try again later.")));
      }
    });
  }

  Widget getList() {
    final placesWidget = places.map((f) {
      List<Widget> list = [
        Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Text(
            f.name,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        )
      ];
      if (f.formattedAddress != null) {
        list.add(Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            f.formattedAddress,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ));
      }

      if (f.vicinity != null) {
        list.add(Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            f.vicinity,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ));
      }

      if (f.types?.first != null) {
        list.add(Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            f.types.first,
            style: Theme.of(context).textTheme.caption,
          ),
        ));
      }

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
                children: list,
              ),
            ),
          ),
        ),
      );
    }).toList();

    return ListView(shrinkWrap: true, children: placesWidget);
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(CovidInformationCenter.routeName);
    return (await true);
  }

  @override
  initState() {
    setUpMap();
    refresh();
    _dropdownMenuItems = buildDropdownMenuItems(_provinces);
    _dropdownMenuItems2 = buildDropdownMenuItems2(_centerTypes);
    if (_selectedProvince == null) {
      _selectedProvince = _dropdownMenuItems[0].value;
    }
    if (_selectedCenterType == null) {
      _selectedCenterType = _dropdownMenuItems2[0].value;
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
              title: Text("Vaccination facilities near you"),
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
                                  title: Text('Select province and center type'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        color: globals.appBarColor,
                                        padding: EdgeInsets.all(10),
                                        width: MediaQuery.of(context).size.width,
                                        child: Text(
                                          'Province',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
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
                                      Container(
                                        color: globals.appBarColor,
                                        padding: EdgeInsets.all(10),
                                        width: MediaQuery.of(context).size.width,
                                        child: Text(
                                          'Center type',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      StatefulBuilder(
                                        builder: (BuildContext context, StateSetter setState) {
                                          return Theme(
                                            data: ThemeData.dark(),
                                            child: DropdownButton(
                                              isExpanded: true,
                                              value: _selectedCenterType,
                                              items: _dropdownMenuItems2,
                                              onChanged: (value) {
                                                setState(() {
                                                  _selectedCenterType = value;
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
                                        globals.selectedCenterType = _selectedCenterType;
                                        globals.selectedLat = globals.getLat(_selectedProvince);
                                        globals.selectedLong = globals.getLong(_selectedProvince);
                                        Navigator.pop(context);
                                        setState(() {});
                                        setUpMap();
                                        refresh();
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