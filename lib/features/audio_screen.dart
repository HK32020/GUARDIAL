import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:guardial/utils/utils.dart';
import 'package:provider/provider.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({Key? key}) : super(key: key);

  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();

  loadAudioFile() async {
    final uri = await audioCache.load('audio/GDL.m4a');
    await audioPlayer.setUrl(uri.toString());
  }

  @override
  void initState() {
    loadAudioFile();
    if (Platform.isIOS) {
      if (audioCache.fixedPlayer != null) {
        //audioCache.fixedPlayer!.startHeadlessService();
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Duration>.value(
          initialData: const Duration(),
          value: audioPlayer.onAudioPositionChanged,
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: APP_BACKGROUND_GREY_COLOR,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: MAIN_BLUE_COLOR, //change your color here
            ),
            backgroundColor: Palette.guardialPurple,
            title: Text("AUDIO"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                color: MENU_BACKGROUND_COLOR,
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Column(
                    children: [
                      AudioPlayerWidget(advancedPlayer: audioPlayer),
                      SizedBox(height: 20),
                      SingleChildScrollView(
                        child: RichText(
                          overflow: TextOverflow.clip,
                          text: TextSpan(
                              //text: 'Hello ',
                              //style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 12,
                                      color: BODY_TEXT_BLACK_COLOR),
                                  text: '''Hello?
 
Yeah hey, it’s me.
 
I’ve been trying to reach you all day, so basically Mom and dad just arrived, and everyone else is here and ready to go so we’re just waiting on you and we really need you to speed up because we were supposed to leave like 15 minutes ago. I mean where even are you?

Oh wait actually I have your location pulled up right in front of me, one sec. Ok not gonna lie, I’m kind of glad dad made us get that tracking app, so I always know where you are. I mean at least it looks like you’re not too far away from us. Oh wow, this map is so detailed— like I can see exactly where you are. Wow - how much cooler can this app get?

Ok but anyways, everyone’s pretty impatient to start, so I really need you to hurry. If you don’t arrive soon, you know how dad is, he is probably going to take your car and come and get you and you know how he gets when he gets angry so don’t make him wait forever. So please don’t take any detours. He’s literally constantly refreshing your location.

I mean I guess I’ll keep you company until you get here, cause I don’t think we’ve talked in a while. So yeah just a little bit of storytime, bear with me. This past week I went on a really long walk, like a 2 hour walk I think, and the weather was really good. I don’t know if you would like it because it was a bit chilly, but I really did like that chilly weather, so my walk was extra nice. 

And you know I was going on the usual route, the one next to the park, and the next thing you know, I ran into Andrew the YouTuber, right, it’s pretty crazy, yeah, so I ran into him and he was filming something nearby I think, but I ran straight into his shoulder when he was vlogging on his phone and he was coming towards me, and I rain straight into his shoudler, so pretty sure I ruined his shot. So I felt super bad about that because he literally tripped over. But you know, it would be cool if I made it into the video. I highly doubt it, but that would be really cool. So yeah, I just felt really bad because I knocked him over, and, you know, I went up and apologized to him and he was really nice about it, so you know that was pretty sweet —wait one sec, (yeah?, okay I will). Ok sorry dad’s making me remind you that you need to pick up the pace some more ok? Unless you want him to come and get you, because he’s getting really impatient, like it’s not funny.

But yeah, anyways, what are the chances of running into Andrew right? Literally the one day he’s in town. I mean you really missed out because you could’ve met him too! That would’ve been really sick. Oh and even more important, you know Jimmy’s right? Yeah they’re actually closing down! Like I forgot to tell you, I wanted to tell you like a while ago, but I just forgot. They’ve been here for like 10 years right since we’ve been starting to go there, and they’re literally closing down so suddenly. I mean guess they just don’t have enough customers or something, but it feels kind of bad because they are a mom and pop business and I really wish they were successful, but yeah. I’m really going to miss their coconut cream pies they were so good! Actually do you think there’s anything we could do to help them? Yeah, I don’t know like, I don’t know what I’d do without their pies so maybe we could fundraise a little bit or find a way to get some funds for them so they can stay a float for a longer period of time? Yeah I’ve seen people do something similar on Facebook before, so I think it’s worth a shot you know? We can ask mom about it once you get here, because she probably knows more about these things than we do. Oh, that reminds me, Mom’s been asking where you got your taser from because she’s been looking on Amazon but she doesn’t know if they are good quality or not and she really like yours, so where’d you get yours from? Oh wait actually, you know it’s fine. Whenever you come here, you can just let her know yourself.

Ok cool, looks like you’re getting closer to us. I’m sorry this is just like the coolest app ever. It’s so cool, I can see everything. But yeah besides, I mean you never know what could happen right? Better safe than sorry. It’s good to be safe. Oh wait, did you also know that Megan got super sick recently. Yep, that Megan - Mom’s friend Megan. I feel really bad for her because now she can’t go on her trip to Hawaii and everything. She’s gonna cancel all her plans, which sucks because she can’t go scuba diving or snorkeling or whale watching. You know she had all those plans with her friends so, I mean, she was looking forward to it, but it’s just really unfortunate though, because I think this was meant to be her last trip before she moved to her new job in accounting so its honestly kind of sad that she can’t go. I have heard that she’s recovering quickly though - that’s good news.

But yeah, you better come quick right now ok? Mom and Dad are already worried about you for being so late, next time, just don’t give them anything else to worry about too ok?

Yeah, I really don’t want them to worry. I’ve been rambling for a really long time, but yeah, essentially I just need you to come here as soon as you can. It’s been a really long time and we are all really anxious to see you, so I’m going to let you go, but just remember, I have your location in case anything happens. So, try to hurry, try your best, stay safe, but I really don’t want to deal with dad’s anger right now so just really show up as soon as you can. Ok yeah I’m going to go. See you in a few, take care. Alright, bye.
              ''',
                                ),
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final AudioPlayer advancedPlayer;
  const AudioPlayerWidget({Key? key, required this.advancedPlayer})
      : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  bool? seekDone;
  bool isAudioPlaying = false;

  @override
  void initState() {
    widget.advancedPlayer.onSeekComplete
        .listen((event) => setState(() => seekDone = true));

    super.initState();
  }

  stop() {
    //assetsAudioPlayer.stop();
    widget.advancedPlayer.stop();
    widget.advancedPlayer.release();
    //await audioCache.clearAll();
  }

  @override
  dispose() {
    stop();
    super.dispose();
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    widget.advancedPlayer.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    final audioPosition = Provider.of<Duration>(context);
    return Container(
      color: MENU_HEADER_TEXT_COLOR,
      child: Row(
        children: [
          IconButton(
            icon: isAudioPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
            onPressed: () {
              if (isAudioPlaying) {
                widget.advancedPlayer.pause();
              } else {
                widget.advancedPlayer.resume();
              }
              setState(() {
                isAudioPlaying = !isAudioPlaying;
              });
            },
          ),
          Text(audioPosition.abs().toString()),
          Expanded(
            child: StreamBuilder(
              stream: widget.advancedPlayer.onDurationChanged,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (!snapshot.hasData) {
                  // while data is loading:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Slider(
                      value: audioPosition.inSeconds.toDouble(),
                      min: 0.0,
                      max: snapshot.data.inSeconds.toDouble(),
                      onChanged: (double value) {
                        setState(() {
                          seekToSecond(value.toInt());
                          value = value;
                        });
                      });
                }
              },
            ),
          ),
          /*ElevatedButton(
                child: Text('STOP'),
                onPressed: () => widget.advancedPlayer.stop(),
              ),*/
        ],
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
    );
  }
}
