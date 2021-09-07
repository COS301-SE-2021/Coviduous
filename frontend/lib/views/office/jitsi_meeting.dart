import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:universal_html/html.dart' as html;

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/office/user_view_current_bookings.dart';

import 'package:frontend/globals.dart' as globals;

class UserJitsiMeeting extends StatefulWidget {
  static const routeName = "/user_jitsi_meeting";
  @override
  _UserJitsiMeetingState createState() => _UserJitsiMeetingState();
}

class _UserJitsiMeetingState extends State<UserJitsiMeeting> {
  bool isAudioOnly = true;
  bool isAudioMuted = true;
  bool isVideoMuted = true;

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(UserViewCurrentBookings.routeName);
    return (await true);
  }

  _joinMeeting() async {
    try {
      // Enable or disable any feature flag here
      // If feature flag are not provided, default values will be used
      Map<FeatureFlagEnum, bool> featureFlags = {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
      };

      final userAgent = html.window.navigator.userAgent.toString().toLowerCase();

      if (!kIsWeb) {
        // Here is an example, disabling features for each platform
        if (userAgent.contains("android")) {
          // Disable ConnectionService usage on Android to avoid issues
          featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
        } else if (userAgent.contains("iphone") || userAgent.contains("ipad")) {
          // Disable PIP on iOS as it looks weird
          featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
        }
      }

      var options = JitsiMeetingOptions(room: globals.currentBooking.getRoomNumber().substring(4,12) + '_' + globals.currentBooking.getTimestamp().substring(24,34).replaceAll('/', '-'))
        ..serverURL = "https://meet.jit.si"
        ..subject = "Virtual meeting for room " + globals.currentBooking.getRoomNumber()
        ..userDisplayName = globals.loggedInUser.getFirstName() + ' ' + globals.loggedInUser.getLastName()
        ..userEmail = globals.loggedInUserEmail
        ..userAvatarURL = "https://www.pngitem.com/pimgs/m/30-307416_profile-icon-png-image-free-download-searchpng-employee.png" // JPG or PNG
        ..iosAppBarRGBAColor = "#0080FF80"
        ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted
        ..featureFlags.addAll(featureFlags)
        ..webOptions = {
          "roomName": globals.currentBooking.getRoomNumber().substring(4,8) + globals.currentBooking.getTimestamp().substring(25).replaceAll('/', '-'),
          "width": "100%",
          "height": "100%",
          "enableWelcomePage": false,
          "chromeExtensionBanner": null,
          "userInfo": {"displayName": globals.loggedInUser.getUserName()}
        };

      debugPrint("JitsiMeetingOptions: $options");
      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(
            onConferenceWillJoin: (message) {
              debugPrint("${options.room} will join with message: $message");
            },
            onConferenceJoined: (message) {
              debugPrint("${options.room} joined with message: $message");
            },
            onConferenceTerminated: (message) {
              debugPrint("${options.room} terminated with message: $message");
            },
            genericListeners: [
              JitsiGenericListener(
                  eventName: 'readyToClose',
                  callback: (dynamic message) {
                    debugPrint("readyToClose callback");
                  }),
            ]),
      );
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  Widget meetConfig() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 14,
          ),
          CheckboxListTile(
            title: Text("Audio only"),
            value: isAudioOnly,
            onChanged: _onAudioOnlyChanged,
          ),
          SizedBox(
            height: 14,
          ),
          CheckboxListTile(
            title: Text("Audio muted"),
            value: isAudioMuted,
            onChanged: _onAudioMutedChanged,
          ),
          SizedBox(
            height: 14,
          ),
          CheckboxListTile(
            title: Text("Video muted"),
            value: isVideoMuted,
            onChanged: _onVideoMutedChanged,
          ),
          Divider(
            height: 48,
            thickness: 2,
          ),
          SizedBox(
            height: 64,
            width: double.maxFinite,
            child: ElevatedButton(
              child: Text("Join meeting"),
              onPressed: () {
                _joinMeeting();
              },
            ),
          ),
          SizedBox(
            height: 48.0,
          ),
        ],
      ),
    );
  }

  _onAudioOnlyChanged(bool value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  void _onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined(message) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated(message) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }

  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Jitsi meeting'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(UserViewCurrentBookings.routeName);
              },
            ),
          ),
        body: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              width: MediaQuery.of(context).size.width/1.2,
              child: kIsWeb ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: meetConfig(),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            color: Colors.white54,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6 * 0.7,
                              height: MediaQuery.of(context).size.width * 0.6 * 0.7,
                              child: JitsiMeetConferencing(
                                extraJS: [
                                  // extraJs setup example
                                  '<script>function echo(){console.log("echo!!!")};</script>',
                                  '<script src="https://code.jquery.com/jquery-3.5.1.slim.js" integrity="sha256-DrT5NfxfbHvMHux31Lkhxg42LY6of8TaYyK50jnxRnM=" crossorigin="anonymous"></script>'
                                ],
                              ),
                            )),
                      ))
                ],
              ) : meetConfig(),
            ),
          ),
        ),
      ),
    );
  }
}