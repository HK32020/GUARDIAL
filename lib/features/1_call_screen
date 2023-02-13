import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:guardial/core/WidgetUtils.dart';
import 'package:guardial/widgets/common_widgets/RoundButtonWidget.dart';
import 'package:nexgen_ringtone_player/ringtone_player_util.dart';

import '../2_call_interface_screen/2_CallInterfaceScreen.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({Key? key}) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();

  loadAudioFile() async {
    final uri = await audioCache.load('audio/iphone_7_ringtone.mp3');
    await audioPlayer.setUrl(uri.toString());
    audioPlayer.resume();
  }

  @override
  void initState() {
    if (Platform.isIOS) {
      loadAudioFile();
    }
    if (Platform.isAndroid){
      RingtonePlayerUtil().playRingtone();
    }
    super.initState();
  }
  stopRingtone() async{
    if (Platform.isIOS) {
      audioPlayer.stop();
      audioPlayer.release();
      await audioCache.clearAll();
    }
    if (Platform.isAndroid){
      RingtonePlayerUtil().stopRingtone();
    }
  }

  @override
  Widget build(BuildContext context) {
    //RingtonePlayerUtil().playRingtone();
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
                      child: Text('John'
                          , style: TextStyle(color: Colors.white, fontSize: 35),),
                    ),
                    Text('Mobile', style: TextStyle(color: Colors.white, fontSize: 18),),
                  ],
                ),
                Spacer(flex: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.access_alarm,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Remind me',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RoundButtonWidget(
                          func: (){
                            //RingtonePlayerUtil().stopRingtone();
                            stopRingtone();
                            WidgetUtils.navigateToHomeScreen(context);
                          },
                          name: 'Decline',
                          icon: Icons.call_end,
                          buttonColor: Colors.red,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.message,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Message',
                          style: TextStyle(
                            fontSize: 13,
                              color: Colors.white
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RoundButtonWidget(
                            func: (){
                              //RingtonePlayerUtil().stopRingtone();
                              stopRingtone();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => CallInterfaceScreen()), (route) => false);//if you want to disable back feature set to false),
                            },
                            name: 'Accept',
                            icon: Icons.call,
                            buttonColor: Colors.green,
                        ),
                      ],
                    )
                  ],
                ),
                Spacer(
                )
              ],
            ),
          ),
    ));
  }
}
