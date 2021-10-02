import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:uuid/uuid.dart';

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/health/user_home_health.dart';

import 'package:frontend/controllers/health/health_helpers.dart' as healthHelpers;
import 'package:frontend/views/global_widgets.dart' as globalWidgets;
import 'package:frontend/globals.dart' as globals;

class UserScanBluetooth extends StatefulWidget {
  static const routeName = "/user_scan_bluetooth";

  @override
  _UserScanBluetoothState createState() => _UserScanBluetoothState();
}

class _UserScanBluetoothState extends State<UserScanBluetooth> {
  int numberOfEmployees = 0;
  bool isLoading = false;
  final Strategy strategy = Strategy.P2P_STAR;
  BeaconBroadcast beaconBroadcast = BeaconBroadcast();

  advertise() async {
    beaconBroadcast.stop();
    BeaconStatus transmissionSupportStatus = await beaconBroadcast.checkTransmissionSupported();
    switch (transmissionSupportStatus) {
      case BeaconStatus.supported: {
        var uuid = Uuid();
        beaconBroadcast
            .setUUID(uuid.v4())
            .setMajorId(1)
            .setMinorId(100)
            .start();
        beaconBroadcast.getAdvertisingStateChange().listen((isAdvertising) {
          if (isAdvertising) {
            print("Device is advertising a beacon");
          } else {
            print("Device is not advertising a beacon");
          }
        });
      }
      break;

      case BeaconStatus.notSupportedMinSdk: {
        print('Android system version is too low (minimum is 21)');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Your Android system version is too low (minimum is 21).')));
      }
      break;

      case BeaconStatus.notSupportedBle: {
        print('Device does not support BLE');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Your device does not support BLE.')));
      }
      break;

      case BeaconStatus.notSupportedCannotGetAdvertiser: {
        print('Device chipset or driver is incompatible');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Your chipset or driver is incompatible.')));
      }
      break;
    }
  }

  Future<bool> discover() async {
    try {
      bool a = await Nearby().startDiscovery(globals.loggedInUserEmail, strategy,
          onEndpointFound: (id, name, serviceId) async {
            print('Detected $name (ID $id)');
            globals.currentBluetoothEmails.emails.add({"email": name});
          },
          onEndpointLost: (id) {
            print(id);
          });
      print('DISCOVERING: ${a.toString()}');
      return true;
    } catch(error) {
      print(error);
    }
    return false;
  }

  getPermissions() {
    Nearby().askLocationAndExternalStoragePermission();
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(UserHealth.routeName);
    return (await true);
  }

  @override
  void initState() {
    super.initState();
    getPermissions();
    healthHelpers.getBluetoothEmails(globals.loggedInUserId);
  }

  @override
  void dispose() {
    beaconBroadcast.stop();
    Nearby().stopAdvertising();
    Nearby().stopDiscovery();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (globals.loggedInUserType != 'USER') {
      if (globals.loggedInUserType == 'ADMIN') {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
        });
      } else {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        });
      }
      return Container();
    }

    //This page only works properly on mobile devices
    if (globals.getIfOnPC()) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context).pushReplacementNamed(UserHealth.routeName);
      });
    }

    if (globals.currentBluetoothEmails != null) {
      numberOfEmployees = globals.currentBluetoothEmails.getEmails().length;
    }

    Widget getList() {
      if (numberOfEmployees == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / (5 * globals.getWidgetScaling()),
              ),
              globalWidgets.notFoundMessage(context, 'No employees found yet', 'Please press the "scan" button.'),
            ]
        );
      } else {
        //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: numberOfEmployees,
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 6,
                            child: Image(
                              image: AssetImage('assets/images/placeholder-employee-image.png'),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('User ' + (index + 1).toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: (MediaQuery
                                            .of(context)
                                            .size
                                            .height * 0.01) * 2.5,
                                      )
                                  ),
                                ],
                              ),
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(globals.currentBluetoothEmails.getTimestamp()),
                                              SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Text(globals.currentBluetoothEmails.getEmails()[index])
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ]
                        ),
                      ),
                    ]
                ),
              );
            });
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        color: globals.secondColor,
        child: isLoading == false ? Scaffold(
          appBar: AppBar(
            title: Text('Scan for devices near you'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(UserHealth.routeName);
              },
            ),
          ),
          bottomNavigationBar: BottomAppBar(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container (
                        height: 50,
                        width: 200,
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom (
                            primary: Color(0xff03305A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Scan'),
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              bool a = await Nearby().startAdvertising(
                                globals.loggedInUserEmail,
                                strategy,
                                onConnectionInitiated: null,
                                onConnectionResult: (id, status) {
                                  print(status);
                                },
                                onDisconnected: (id) {
                                  print('Disconnected $id');
                                },
                              );
                              print('ADVERTISING: ${a.toString()}');
                            } catch (e) {
                              print(e);
                            }

                            advertise();

                            discover().then((result) {
                              setState(() {
                                isLoading = false;
                              });
                              if (result == false) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('No other nearby devices found.')));
                              }
                            });
                          },
                        )
                    ),
                  ]
              )
          ),
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Center(
                  child: getList(),
                ),
              ),
            ],
          ),
        ) : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}