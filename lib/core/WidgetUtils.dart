
import 'package:flutter/material.dart';
import 'package:guardial/features/1_call_screen/1_CallScreen.dart';
import 'package:guardial/features/3_show_passcode_screen/3_ShowLockScreen.dart';
import 'package:guardial/features/api/data_service.dart';
import 'package:guardial/features/api/data_service_sqflite_impl.dart';
import 'package:guardial/features/contacts/contacts_screen.dart';
import 'package:guardial/features/setup_screen/setup.dart';
import 'package:guardial/home/home_page.dart';
import 'package:guardial/home/permissions_screen.dart';
import 'package:guardial/splash.dart';
import 'package:nexgen_location_utility/location_permissions_util.dart';
import 'package:nexgen_location_utility/position.dart';
import 'package:nexgen_sms_and_phone/sms_and_phone_permissions_util.dart';

import '../features/audio_screen/audio_screen.dart';

class WidgetUtils {

  static void navigateToSplashScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
            (route) => false); //if you want to disable back feature set to false);
  }

  static void navigateToSetupScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => SetupScreen()), (route) => false);//if you want to disable back feature set to false),
  }

  static void navigateToHomeScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (route) => false); //if you want to disable back feature set to false);
  }

  static void navigateToContactsScreen(BuildContext context, bool pushAndRemove) {
    pushAndRemove?
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ContactsScreen()),
            (route) => false):
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContactsScreen())); //if you want to disable back feature set to false);
  }

  static void navigateToAudioScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AudioScreen())); //if you want to disable back feature set to false);
  }

  static void navigateToCallScreen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CallScreen()));
  }

  static void navigateToPermissionsScreen(BuildContext context
      //, List<String> errorStrings
      ) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PermissionsScreen()));
  }

  static void navigateToPINScreen(BuildContext context, bool isPasscodeScreen,
      String name, bool sendSafeMsg) {
    LockScreenArguments args =
    LockScreenArguments(
        isPasscodeScreen: isPasscodeScreen, name: name, sendSafeMsg: sendSafeMsg);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ShowLockScreen(args)),
        (route) => false); //if you want to disable back feature set to false),
  }

  static Future<bool> checkIfDefaultContactExists() async {
    DataService dataService = DataServiceImpl();
    final List<Contact> contacts = await dataService.getContacts();
    //var isFav = contacts.any((element) => element.isFav);

    return contacts.isNotEmpty &&
        contacts[0].phoneNumber.length == 10; //isFav;
  }

  static Future<void> sendEmergencySMSToAllContacts(String name, List<String> phoneNumbers, Function() callBack) async {
    await sendSMSWithLocationToAllContacts(
        '$name needs your help right now! Here is their location: ',
        //'needs your help ',
        phoneNumbers, callBack);
  }

  static Future<void> sendWarnSMSToAllContacts(String name, List<String> phoneNumbers, Function() callBack) async {
    await sendSMSWithLocationToAllContacts(
        '$name is feeling unsafe right now. Watch out for their location here: ',
        phoneNumbers, callBack);
  }

  static Future<void> sendSafeSMSToAllContacts(String name, List<String> phoneNumbers, Function() callBack) async {
    await SMSAndPhonePermissionsUtil.sendSMSToAllContacts(
        '$name is safe now. Thank you for the assistance.', phoneNumbers, callBack);
  }
  static Future<void> sendSMSWithLocationToAllContacts(String message, List<String> phoneNumbers, Function() callBack) async {
    print('MESSAGE TO BE SENT without location: $message');
    //get user location
    final PositionOnMap currentMapPosition = await LocationPermissionUtil.determinePosition();
    message = message +
        "https://maps.google.com/?q=" +
        currentMapPosition.position.latitude.toString() +
        "," +
        currentMapPosition.position.longitude.toString();

    await SMSAndPhonePermissionsUtil.sendSMSToAllContacts(message, phoneNumbers, callBack);
  }

  static void showAlertDialog(String msg, BuildContext context){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder:  (BuildContext context) {
          return new AlertDialog(
            title: new Text("Alert!!", style: TextStyle(color: Colors.orangeAccent)),
            //content: new Text("Hello World"),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text(msg),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          );});
  }
}
