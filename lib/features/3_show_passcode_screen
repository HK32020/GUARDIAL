import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guardial/core/WidgetUtils.dart';
import 'package:guardial/utils/constants.dart';
import 'package:guardial/home/guardial_home_page.dart';
import 'package:guardial/widgets/common_widgets/PassCode/Circle.dart';
import 'package:guardial/widgets/common_widgets/PassCode/KeyPad.dart';
import 'package:guardial/widgets/common_widgets/PassCode/PassCodeWIdget.dart';

import '../api/data_service.dart';
import '../api/data_service_sqflite_impl.dart';

class LockScreenArguments {
  bool isPasscodeScreen;
  //Widget resetButton;
  bool sendSafeMsg;
  String name;

  LockScreenArguments(
      {required this.isPasscodeScreen,
      required this.sendSafeMsg,
      required this.name});
}

class ShowLockScreen extends StatefulWidget {
  static String id = "ShowLockScreen";
  final List<String> digits = [];

  final LockScreenArguments args;
  ShowLockScreen(this.args);

  final DataService dataService = DataServiceImpl();

  @override
  _ShowLockScreenState createState() => _ShowLockScreenState();
}

class _ShowLockScreenState extends State<ShowLockScreen> {
  late List<String> phoneNumbers;
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();
  int passcodeRetryCount = 3;
  static int passcodeLength = 4;

  bool opaque = false;
  bool isAuthenticated = false;
  int passwordCount = 0;
  CircleUIConfig circleUIConfig = CircleUIConfig(
    borderColor: Colors.green,
  );
  late KeyboardUIConfig keyboardUIConfig = KeyboardUIConfig(digitSize: 60);

  Widget errorWidget = Container();

  late Timer _timer;
  int _start = 30;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            widget.args.sendSafeMsg = true;
            sendEmergencyMessage();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    getPhoneNumbers().then((value) {
      phoneNumbers = value;
      startTimer();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<List<String>> getPhoneNumbers() async {
    return await widget.dataService.getContactPhoneNumbers();
  }

  _onPasscodeEntered(String enteredPasscode) async {
    List<Details> listOfRows = await widget.dataService.getPersonDetails();

    if (listOfRows.isNotEmpty) {
      String savedPasscode = listOfRows
          .where((element) => element.key == PASSCODE_STRING)
          .toList()
          .first
          .value;
      if (widget.args.isPasscodeScreen) {
        bool isValid = savedPasscode == enteredPasscode;
        _verificationNotifier.add(isValid);
        passwordCount++;
        if (isValid) {
          _timer.cancel();
          setState(() {
            this.isAuthenticated = isValid;
          });
          if (widget.args.sendSafeMsg)
            WidgetUtils.sendSafeSMSToAllContacts(widget.args.name, phoneNumbers,
                () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Your alert has been sent",
                      style: TextStyle(color: Colors.green))));
            });
          Navigator.popAndPushNamed(context, HomePage.id);
        } else {
          setState(() {
            errorWidget =
                Text('Invalid PIN', style: TextStyle(color: Colors.red));
          });

          if (passcodeRetryCount == passwordCount) {
            //WidgetUtils.showPassCodeErrorMsg(passcodeScreenMsg, context);
          }
        }
      }
    }
  }

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  _onPasscodeReset() {
    //SharedPrefsUtil().removeValues("passcode");
    //AuthHelper().signOut(context);
  }

  _onPasscodeSave(String enteredPasscode) async {
    // Navigator.maybePop(context);
    widget.dataService.saveDetail(PASSCODE_STRING, enteredPasscode);
    final bool ifDefaultContactExists =
        await WidgetUtils.checkIfDefaultContactExists();
    if (ifDefaultContactExists == true) {
      WidgetUtils.navigateToHomeScreen(context);
    } else {
      WidgetUtils.navigateToContactsScreen(context, true);
    }
  }

  sendEmergencyMessage() async {
    await WidgetUtils.sendEmergencySMSToAllContacts(
        widget.args.name, phoneNumbers, () {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Your alert has been sent",
              style: TextStyle(color: RED_BUTTON_PRESSED))));
    });
  }

  @override
  Widget build(BuildContext context) {
/*    if(_start == 0){
      widget.args.sendSafeMsg=true;
      sendEmergencyMessage();
      */ /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Your alert has been sent",
              style: TextStyle(color: RED_BUTTON_PRESSED))));*/ /*
    }*/
    return PasscodeWidget(
      title: widget.args.isPasscodeScreen
          ? Column(
              children: [
                Text(
                  "$_start",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 35),
                ),
                errorWidget,
              ],
            )
          : Text(
              'Enter a 4-digit PIN',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
      circleUIConfig: circleUIConfig,
      keyboardUIConfig: keyboardUIConfig,
      passwordEnteredCallback: _onPasscodeEntered,
      //resetButton: widget.args.isPasscodeScreen ? Container() : widget.args.resetButton,
      resetButton: Container(),
      saveButton: widget.args.isPasscodeScreen
          ? Container()
          : Text(
              'Save',
              style: const TextStyle(fontSize: 16, color: Colors.black),
//          semanticsLabel: 'Save',
            ),
      shouldTriggerVerification: _verificationNotifier.stream,
      backgroundColor: Colors.white,
      resetCallback: _onPasscodeReset,
      saveCallback: _onPasscodeSave,
      digits: widget.digits,
      bottomWidget: Container(),
      isValidCallback: () {},
      passwordDigits: passcodeLength,
      key: Key('PasscodeScreen'),
    );
  }
}
