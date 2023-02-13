import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:guardial/core/WidgetUtils.dart';
import 'package:guardial/utils/constants.dart';
import 'package:guardial/features/api/data_service.dart';
import 'package:guardial/features/api/data_service_sqflite_impl.dart';
import 'package:guardial/widgets/common_widgets/RoundButtonWidget.dart';
import 'package:nexgen_sms_and_phone/sms_and_phone_permissions_util.dart';
import 'package:permission_handler/permission_handler.dart';

class CallInterfaceScreen extends StatefulWidget {
  CallInterfaceScreen({Key? key}) : super(key: key);
  final DataService dataService = DataServiceImpl();

  @override
  _CallInterfaceScreenState createState() => _CallInterfaceScreenState();
}

class _CallInterfaceScreenState extends State<CallInterfaceScreen>
    with SingleTickerProviderStateMixin {
  late List<String> phoneNumbers;
  late String starredContact;

  late AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();
  bool helpButtonPressed = false;
  bool warnButtonPressed = false;
  bool speakerOn = false;
  late AnimationController _controller;

  loadAudioFile() async {
    final uri = await audioCache.load('audio/GDL.m4a');
    await audioPlayer.setUrl(uri.toString());
  }

  play() async {
    try {
      Uri uri = await audioCache.load('audio/GDL.m4a');
      await audioPlayer.setUrl(uri.toString());

      //audioPlayer.playingRouteState = PlayingRoute.EARPIECE;
      /*setState(() {
        toggleSpeaker();
      });*/

      //await audioPlayer.play(uri.path, isLocal: true);
      audioPlayer.resume();
    } on Exception catch (e) {
      print("EXCEPTIONNNNNNNNNNNNNNNNNNNN $e");
    }
  }

  toggleSpeaker() async {
    audioPlayer.pause();
    int result = await audioPlayer.earpieceOrSpeakersToggle();
    print('TOGGLE $result');
    audioPlayer.resume();
    setState(() {
      speakerOn = !speakerOn;
      /*if(speakerOn)
        audioPlayer.setVolume(10);*/
    });
  }

  stop() async {
    audioPlayer.stop();
    audioPlayer.release();
    await audioCache.clearAll();
  }

  @override
  void initState() {
    getPhoneNumbers().then((value) {
      phoneNumbers = value;
      /*if (Platform.isIOS) {
        if (audioCache.fixedPlayer != null) {
           audioCache.fixedPlayer!.startHeadlessService();
        }
      }*/
      play();
    });
    getStarredContact().then((value) => starredContact = value);
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(minutes: 5));
    if (mounted) {
      _controller.forward();
    }
  }

  @override
  void didChangeDependencies() {
    if (_controller.isCompleted == true) stop();
    super.didChangeDependencies();
  }

  @override
  dispose() {
    stop();
    _controller.dispose();
    super.dispose();
  }

  DataService dataService = DataServiceImpl();

  Future<String> getName() async {
    return (await dataService.getPersonDetails())
        .where((element) => element.key == NAME_STRING)
        .first
        .value;
  }

  Future<List<String>> getPhoneNumbers() async {
    return await widget.dataService.getContactPhoneNumbers();
  }

  Future<String> getStarredContact() async {
    return await widget.dataService.getStarredContact();
  }

  Future<String> getLocationStatus(Permission permission) async =>
      (await (permission.status)).toString().split('.')[1].toUpperCase();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getName(),
      builder: (BuildContext context1, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          // while data is loading:
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          // data loaded:
          var name = snapshot.data;
          return SafeArea(
              child: Scaffold(
            body: Container(
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Spacer(),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'John',
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ),
                      Countdown(
                          animation: StepTween(
                            begin: 5 * 60,
                            end: 0,
                          ).animate(_controller),
                          key: Key('timer-interface-screen'),
                          func: () {
                            stop();
                            WidgetUtils.navigateToPINScreen(context, true, name,
                                (helpButtonPressed || warnButtonPressed));
                          })
                    ],
                  ),
                  Spacer(flex: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FutureBuilder<List<String>>(
                          future: Future.wait(Platform.isIOS
                              ? [
                                  getLocationStatus(Permission.location),
                                  getLocationStatus(Permission.locationAlways),
                                  getLocationStatus(
                                      Permission.locationWhenInUse),
                                ]
                              : [
                                  getLocationStatus(Permission.sms),
                                  getLocationStatus(Permission.phone),
                                  getLocationStatus(Permission.location),
                                ]),
                          builder: (context2, snapshot2) {
                            if (snapshot2.connectionState ==
                                ConnectionState.done) {
                              if (snapshot2.data != null &&
                                  snapshot2.data!.firstWhere(
                                          (element) => element != 'GRANTED',
                                          orElse: () => 'GRANTED') !=
                                      'GRANTED') {
                                return RoundButtonWidget(
                                  func: () {},
                                  name: 'help',
                                  icon: Icons.priority_high,
                                  buttonColor: Colors.grey,
                                );
                              } else {
                                return FutureBuilder<String>(
                                  future:
                                      widget.dataService.getStarredContact(),
                                  builder: (context4, snapshot4) {
                                    if (snapshot4.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot4.data != null &&
                                          snapshot4.data!.isNotEmpty) {
                                        return RoundButtonWidget(
                                          func: () async {
                                            if (!helpButtonPressed) {
                                              await helpButtonAction(name,
                                                  context, snapshot4.data!);
                                            }
                                          },
                                          name: 'help',
                                          icon: Icons.priority_high,
                                          buttonColor: helpButtonPressed
                                              ? RED_BUTTON_PRESSED
                                              : RED_BUTTON,
                                        );
                                      }
                                      return RoundButtonWidget(
                                        func: () {},
                                        name: 'help',
                                        icon: Icons.priority_high,
                                        buttonColor: Colors.grey,
                                      );
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                );
                              }
                            }
                            return RoundButtonWidget(
                              func: () {},
                              name: 'help',
                              icon: Icons.priority_high,
                              buttonColor: Colors.grey,
                            );
                          }),
                      RoundButtonWidget(
                        func: () {},
                        name: 'keypad',
                        //icon: Icons.dialpad,
                        buttonColor: Colors.grey,
                      ),
                      RoundButtonWidget(
                        func: () {
                          toggleSpeaker();
                        },
                        name: 'audio',
                        icon: Icons.volume_up,
                        buttonColor: speakerOn ? Colors.green : Colors.grey,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FutureBuilder<List<String>>(
                          future: Future.wait(Platform.isIOS
                              ? [
                                  getLocationStatus(Permission.location),
                                  getLocationStatus(Permission.locationAlways),
                                  getLocationStatus(
                                      Permission.locationWhenInUse),
                                ]
                              : [
                                  getLocationStatus(Permission.sms),
                                  getLocationStatus(Permission.phone),
                                  getLocationStatus(Permission.location),
                                ]),
                          builder: (context5, snapshot5) {
                            if (snapshot5.connectionState ==
                                ConnectionState.done) {
                              if (snapshot5.data != null &&
                                  snapshot5.data!.firstWhere(
                                          (element) => element != 'GRANTED',
                                          orElse: () => 'GRANTED') !=
                                      'GRANTED') {
                                return RoundButtonWidget(
                                  func: () {},
                                  name: 'warn',
                                  icon: Icons.location_on,
                                  buttonColor: Colors.grey,
                                );
                              } else {
                                return FutureBuilder<String>(
                                  future:
                                      widget.dataService.getStarredContact(),
                                  builder: (context3, snapshot3) {
                                    if (snapshot3.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot3.data != null &&
                                          snapshot3.data!.isNotEmpty) {
                                        return RoundButtonWidget(
                                          func: () async {
                                            if (!warnButtonPressed) {
                                              await WidgetUtils
                                                  .sendWarnSMSToAllContacts(
                                                      name, phoneNumbers,
                                                      () async {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "Your alert has been sent",
                                                            style: TextStyle(
                                                                color:
                                                                    YELLOW_BUTTON_PRESSED))));
                                              });
                                              setState(() {
                                                warnButtonPressed = true;
                                              });
                                            }
                                          },
                                          name: 'warn',
                                          icon: Icons.location_on,
                                          buttonColor: warnButtonPressed
                                              ? YELLOW_BUTTON_PRESSED
                                              : YELLOW_BUTTON,
                                        );
                                      }
                                      return RoundButtonWidget(
                                        func: () {},
                                        name: 'warn',
                                        icon: Icons.location_on,
                                        buttonColor: Colors.grey,
                                      );
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                );
                              }
                            }
                            return RoundButtonWidget(
                              func: () {},
                              name: 'warn',
                              icon: Icons.location_on,
                              buttonColor: Colors.grey,
                            );
                          }),
                      RoundButtonWidget(
                        func: () {},
                        name: 'FaceTime',
                        //icon: Icons.videocam_rounded,
                        buttonColor: Colors.grey,
                      ),
                      RoundButtonWidget(
                        func: () {},
                        name: 'contacts',
                        //icon: Icons.contacts,
                        buttonColor: Colors.grey,
                      ),
                    ],
                  ),
                  Spacer(flex: 3),
                  RoundButtonWidget(
                    func: () {
                      stop();
                      WidgetUtils.navigateToPINScreen(context, true, name,
                          (helpButtonPressed || warnButtonPressed));
                    },
                    name: 'end',
                    icon: Icons.check_outlined,
                    buttonColor: Colors.green,
                  ),
                  Spacer()
                ],
              ),
            ),
          ));
        }
      },
    );
  }

  Future<void> helpButtonAction(
      name, BuildContext context, String starredContact) async {
    await WidgetUtils.sendEmergencySMSToAllContacts(name, phoneNumbers,
        () async {
      /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Your alert has been sent",
              style: TextStyle(color: RED_BUTTON_PRESSED))));*/
      await stop();
      WidgetUtils.navigateToHomeScreen(context);
      await SMSAndPhonePermissionsUtil.callAPhoneNumber(starredContact);
      //TO-DO handle if above line throws error
    });
    setState(() {
      helpButtonPressed = true;
    });
  }
}

class Countdown extends AnimatedWidget {
  Countdown({required Key key, required this.animation, required this.func})
      : super(key: key, listenable: animation);
  final Animation<int> animation;
  final Function func;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';
    //print(timerText);
    if (timerText == '0:00') {
      func();
    }
    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 13,
        color: Colors.white,
      ),
    );
  }
}
