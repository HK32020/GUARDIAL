import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guardial/utils/utils.dart';
import 'package:guardial/widgets/guardial_logo_widget.dart';
import 'package:nexgen_location_utility/location_permissions_util.dart';
import 'package:nexgen_sms_and_phone/sms_and_phone_permissions_util.dart';
import 'core/WidgetUtils.dart';
import 'features/api/data_service.dart';
import 'features/api/data_service_sqflite_impl.dart';

class SplashScreen extends StatefulWidget {
  static String id = "SplashScreen";
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  Future<void> appSetupAndNavigateToHome() async {
    DataService dataService = DataServiceImpl();
    List<Details> listOfRows = await dataService.getPersonDetails();
    if (listOfRows.isNotEmpty) {
      return WidgetUtils.navigateToHomeScreen(context);
    }

    print('CHECKING PERMISSIONS ON STARTUP');
    bool? phonePermissionsGranted = false;
    bool? smsPermissionsGranted = false;
    bool isLocationEnabled = false;
    bool locationPermissionsGranted = false;
    if (Platform.isAndroid) {
      try {
        //first set of permissions
        phonePermissionsGranted =
            await SMSAndPhonePermissionsUtil.requestPhonePermissions();
      } catch (e) {
        print(e.toString());
        phonePermissionsGranted = false;
      }

      try {
        //first set of permissions
        smsPermissionsGranted =
            await SMSAndPhonePermissionsUtil.requestSmsPermissions();
      } catch (e) {
        print(e.toString());
        smsPermissionsGranted = false;
      }
    }

    try {
      //second set of permissions
      locationPermissionsGranted =
          await LocationPermissionUtil.checkLocationPermissions();
      //get location after getting location permission
      isLocationEnabled =
          await LocationPermissionUtil.checkAndRequestLocationService();
    } catch (e) {
      print(e.toString());
    }

    print('phonePermissionsGranted $phonePermissionsGranted');
    print('smsPermissionsGranted $smsPermissionsGranted');
    print('isLocationEnabled $isLocationEnabled');
    print('locationPermissionsGranted $locationPermissionsGranted');
    if ((Platform.isIOS || (Platform.isAndroid && phonePermissionsGranted!)) &&
        (Platform.isIOS || (Platform.isAndroid && smsPermissionsGranted!)) &&
        isLocationEnabled &&
        locationPermissionsGranted) {
      if (listOfRows.isEmpty ||
          (listOfRows
              .where((element) => element.key == PASSCODE_STRING)
              .isEmpty) ||
          (listOfRows.where((element) => element.key == NAME_STRING).isEmpty) ||
          (listOfRows
              .where((element) => element.key == TERMS_CONDITIONS_STRING)
              .isEmpty)) {
        Navigator.popAndPushNamed(context, welcomeScreenViewRoute);
      } else {
        print('PASSCODE');
        print(listOfRows
            .where((element) => element.key == PASSCODE_STRING)
            .toList()
            .first
            .value);
        final bool ifDefaultContactExists =
            await WidgetUtils.checkIfDefaultContactExists();
        if (ifDefaultContactExists == true) {
          WidgetUtils.navigateToHomeScreen(context);
        } else {
          WidgetUtils.navigateToContactsScreen(context, true);
        }
      }
    } else {
      WidgetUtils.navigateToPermissionsScreen(context
          //, [e.toString()]
          );
    }
  }

  startTime() async {
    var _duration = new Duration(seconds: 0);
    return new Timer(_duration, appSetupAndNavigateToHome);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print('inside: splash scren initstate');
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 3));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();
    print('after animation');
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          color: Palette.guardialPurple,
        ),
        Align(
            alignment: Alignment.center,
            child: GuardialLogoWidget(
                width: MediaQuery.of(context).size.width / 3 * 2)),
      ],
    ));
  }
}
