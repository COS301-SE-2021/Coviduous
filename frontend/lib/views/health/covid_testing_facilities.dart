import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as LocationManager;

import 'package:frontend/views/health/covid_info_center.dart';
import 'package:frontend/globals.dart' as globals;

class CovidTestingFacilities extends StatefulWidget {
  static const routeName = "/covid_testing_facilities";
  @override
  _CovidTestingFacilitiesState createState() => _CovidTestingFacilitiesState();
}

const googleApiKey = "AIzaSyDRvPZC7hHO7KZN4L6_K0siuDxsjlPqARs";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: googleApiKey);

class _CovidTestingFacilitiesState extends State<CovidTestingFacilities> {
  GoogleMapController mapController;
  GoogleMap map;
  List<PlacesSearchResult> places = [];
  LocationManager.Location locationManager;
  StreamSubscription<LocationManager.LocationData> locationSubscription;
  bool isLoading = false;

  setUpMap() {
    map = GoogleMap(
      onMapCreated: _onMapCreated,
      myLocationEnabled: false,
      initialCameraPosition: CameraPosition(
          target: LatLng(globals.selectedLat, globals.selectedLong),
          zoom: 8,
      ),
    );
    refresh();
  }

  void _onMapCreated(GoogleMapController controller) async {
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
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    refresh();
                  },
                ),
              ],
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