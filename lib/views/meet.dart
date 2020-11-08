import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/feature_flag/feature_flag_enum.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';

// void main() => runPage(MeetPage());

class MeetPage extends StatefulWidget {
  @override
  _MeetPageState createState() => _MeetPageState();
}

class _MeetPageState extends State<MeetPage> {
  final serverText = 'https://vps-83c84ae2.vps.ovh.ca/';
  final roomText = TextEditingController();
  final subjectText = TextEditingController();
  final nameText = TextEditingController();
  var isAudioOnly = false;
  var isAudioMuted = false;
  var isVideoMuted = false;
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

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

  String validateName(String value) {
    if (value.length < 8)
      return 'Must be more than 8 charater';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50.0,
              ),
              TextFormField(
                style: TextStyle(
                  color: Color.fromRGBO(125, 208, 230, 1),
                ),
                controller: roomText,
                validator: validateName,
                decoration: InputDecoration(
                  hintText: 'Enter a room name',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(125, 208, 230, 1),
                  ),
                  border: _bord(),
                  enabledBorder: _bord(),
                  focusedBorder: _bord(),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                style: TextStyle(
                  color: Color.fromRGBO(125, 208, 230, 1),
                ),
                controller: subjectText,
                validator: validateName,
                decoration: InputDecoration(
                  hintText: 'Room Subject',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(125, 208, 230, 1),
                  ),
                  border: _bord(),
                  enabledBorder: _bord(),
                  focusedBorder: _bord(),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                style: TextStyle(
                  color: Color.fromRGBO(125, 208, 230, 1),
                ),
                controller: nameText,
                validator: validateName,
                decoration: InputDecoration(
                  hintText: 'Enter Your name',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(125, 208, 230, 1),
                  ),
                  border: _bord(),
                  enabledBorder: _bord(),
                  focusedBorder: _bord(),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              SizedBox(
                width: double.maxFinite,
                child: _signUpBtn(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _bord() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(
        color: Color.fromRGBO(125, 208, 230, 1),
        width: 2,
      ),
    );
  }

  Widget _signUpBtn() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
      child: OutlineButton(
        disabledTextColor: Color.fromRGBO(125, 208, 230, 1),
        highlightedBorderColor: Color.fromRGBO(125, 208, 230, 1),
        borderSide: BorderSide(
          width: 2,
          color: Color.fromRGBO(125, 208, 230, 1),
        ),
        padding: EdgeInsets.all(10),
        splashColor: Color.fromRGBO(125, 208, 230, 0.3),
        onPressed: () {
          _joinMeeting();
        },
        child: Text(
          'Join e-meet',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w900,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
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

  _joinMeeting() async {
    String serverUrl = serverText;

    try {
      // Enable or disable any feature flag here
      // If feature flag are not provided, default values will be used
      // Full list of feature flags (and defaults) available in the README
      Map<FeatureFlagEnum, bool> featureFlags = {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
      };

      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }

      // Define meetings options here
      var options = JitsiMeetingOptions()
        ..room = roomText.text
        ..serverURL = serverUrl
        ..subject = subjectText.text
        ..userDisplayName = nameText.text
        // ..userEmail = emailText.text
        ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted
        ..featureFlags.addAll(featureFlags);

      debugPrint("JitsiMeetingOptions: $options");
      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(onConferenceWillJoin: ({message}) {
          debugPrint("${options.room} will join with message: $message");
        }, onConferenceJoined: ({message}) {
          debugPrint("${options.room} joined with message: $message");
        }, onConferenceTerminated: ({message}) {
          debugPrint("${options.room} terminated with message: $message");
        }),
        // by default, plugin default constraints are used
        //roomNameConstraints: new Map(), // to disable all constraints
        //roomNameConstraints: customContraints, // to use your own constraint(s)
      );
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  static final Map<RoomNameConstraintType, RoomNameConstraint>
      customContraints = {
    RoomNameConstraintType.MAX_LENGTH: new RoomNameConstraint((value) {
      return value.trim().length <= 50;
    }, "Maximum room name length should be 30."),
    RoomNameConstraintType.FORBIDDEN_CHARS: new RoomNameConstraint((value) {
      return RegExp(r"[$€£]+", caseSensitive: false, multiLine: false)
              .hasMatch(value) ==
          false;
    }, "Currencies characters aren't allowed in room names."),
  };

  void _onConferenceWillJoin({message}) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined({message}) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated({message}) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}
