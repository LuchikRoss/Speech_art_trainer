import 'dart:ui';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'graph/draw.dart';

import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speach Articulation Trainer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Speach Articulation Trainer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum TtsState { playing, stopped, paused, continued }

class _MyHomePageState extends State<MyHomePage> {
  final vowelSelected = <bool>[true, false, false];
  double sliderValue1 = 0;
  double sliderValue2 = 0;
  
  FlutterTts flutterTts;
  dynamic languages;
  // String separatedElement='Velum';
  // dynamic separatedElements = ['Velum', 'Glottis'];
  String language;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;

  String _newVoiceText;
  TtsState ttsState = TtsState.stopped;
  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  @override
  void initState() {
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();

    _getLanguages();

    language = 'en-GB';
    flutterTts.setLanguage(language);

//    if (!kIsWeb) {
//      if (Platform.isAndroid) {
//        _getEngines();
//      }
//    }

    flutterTts.setStartHandler(() {
      setState(() {
        // print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        // print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    // flutterTts.setCancelHandler(() {
    //   setState(() {
    //     print("Cancel");
    //     ttsState = TtsState.stopped;
    //   });
    // });

    // if (kIsWeb || Platform.isIOS) {
    //   flutterTts.setPauseHandler(() {
    //     setState(() {
    //       print("Paused");
    //       ttsState = TtsState.paused;
    //     });
    //   });

    //   flutterTts.setContinueHandler(() {
    //     setState(() {
    //       print("Continued");
    //       ttsState = TtsState.continued;
    //     });
    //   });
    // }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    // print(languages);
    if (languages != null) setState(() => languages);
  }

//  Future _getEngines() async {
//    var engines = await flutterTts.getEngines;
//    if (engines != null) {
//      for (dynamic engine in engines) {
//        // print(engine);
//      }
//    }
//  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(_newVoiceText);
      }
    }
  }

  // Future _stop() async {
  //   var result = await flutterTts.stop();
  //   if (result == 1) setState(() => ttsState = TtsState.stopped);
  // }

  // Future _pause() async {
  //   var result = await flutterTts.pause();
  //   if (result == 1) setState(() => ttsState = TtsState.paused);
  // }

  // _setSeparatedElement(separatedElement) {
  // }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems() {
    var items = List<DropdownMenuItem<String>>();
    for (dynamic type in languages) {
      items.add(
          DropdownMenuItem(value: type as String, child: Text(type as String)));
    }
    return items;
  }
  
  // List<DropdownMenuItem<String>> getSeparatedElements() {
  //   var items = List<DropdownMenuItem<String>>();
  //   for (dynamic type in separatedElements) {
  //     items.add(
  //         DropdownMenuItem(value: type as String, child: Text(type as String)));
  //   }
  //   return items;
  // }

  void changedLanguageDropDownItem(String selectedType) {
    setState(() {
      language = selectedType;
      flutterTts.setLanguage(language);
      _speak();
    });
  }

  // void changedSeparatedElement(String selectedType) {
  //   setState(() {
  //     separatedElement = selectedType;
  //     _setSeparatedElement(separatedElement);
  //   });
  // }

  void _onChangeText(String text) {
    setState(() {
      _newVoiceText = text;
      _speak();
    });
  }

  Widget _languageDropDownSection() => Container(
      // padding: EdgeInsets.only(top: 50.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton(
              value: language,
              items: getLanguageDropDownMenuItems(),
              onChanged: changedLanguageDropDownItem,
            )
          ]));
  
  // Widget _separatedGraph() => Container(
  //     // padding: EdgeInsets.only(top: 50.0),
  //     child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
  //       DropdownButton(
  //         value: separatedElement,
  //         items: getSeparatedElements(),
  //         onChanged: _setSeparatedElement(separatedElement),
  //       )
  //     ]));

  @override
  Widget build(BuildContext context) {

   return DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.hearing), text: 'Vowels',),
            Tab(icon: Icon(Icons.insights), text: 'Sliders',),
          ],
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          //FOWELS TAB
          Stack( 
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  SpeachPainter(speachContour: 'Upper Lips', 
                                vowelContour: 'ii')
                ]
              )),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: const EdgeInsets.all(10.0), 
                  child: ToggleButtons(
                    children: <Widget> [
                      Text(
                        'ii',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'aa',
                        textAlign: TextAlign.center
                      ),
                      Text(
                        'uu',
                        textAlign: TextAlign.center
                      ),
                    ],
                    onPressed: (index) {
                      setState(() {
                        vowelSelected[index] = true;
                        index == 0 ? _onChangeText('i') : vowelSelected[0]=false;
                        index == 1 ? _onChangeText('a') : vowelSelected[1]=false;
                        index == 2 ? _onChangeText('u') : vowelSelected[2]=false;
                        // _onChangeText('u');
                        // print(vowelSelected[index]);
                      });
                    },
                    isSelected: vowelSelected,
                  )),
            ),
//            Align(
//              alignment: Alignment.bottomCenter,
//              child: _languageDropDownSection(),
//            ),
            // Align(alignment: Alignment.bottomLeft,
            //   child: Expanded(child: _separatedGraph()))
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(padding: const EdgeInsets.all(15.0),
                child: Text('Upper Lips')))
            ],
          ),
          //SLIDERS TAB
          Stack( 
            children: <Widget> [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  SpeachPainter(speachContour: 'Upper Lips', 
                                vowelContour: 'ii')
                ]
              ),
              Container(padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget> [
                    //1st slider
                    Row(children: [
                      Text(
                        '    High Low',
                        textAlign: TextAlign.left),
                      Expanded(child:
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.blue[700],
                            inactiveTrackColor: Colors.blue[100],
                            trackShape: RectangularSliderTrackShape(),
                            trackHeight: 2.0,
                            thumbColor: Colors.blueAccent,
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
                            overlayColor: Colors.blue.withAlpha(32),
                            overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                          ),
                          child: Slider(
                            value: sliderValue1,
                            min: 0.0,
                            max: 1000.0,
                            onChanged: (double value) {
                              setState(() {
                                sliderValue1 = value;
                              });
                            },
                          ),
                    ))]),
                    //2st slider
                    Row(children: [
                      Text(
                        '    Right Left',
                        textAlign: TextAlign.left),
                      Expanded(child:
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.blue[700],
                            inactiveTrackColor: Colors.blue[100],
                            trackShape: RectangularSliderTrackShape(),
                            trackHeight: 2.0,
                            thumbColor: Colors.blueAccent,
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
                            overlayColor: Colors.blue.withAlpha(32),
                            overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                          ),
                          child: Slider(
                            value: sliderValue2,
                            min: 0.0,
                            max: 1000.0,
                            onChanged: (double value) {
                              setState(() {
                                sliderValue2 = value;
                              });
                            },
                          ),
                    ))]),
              
              ]))
          ]),
        
      ]),
    ));
  }
}

class SpeachPainter extends StatelessWidget {
  SpeachPainter({Key key, 
                 this.speachContour, 
                 this.vowelContour}) 
                 : super(key: key);
  final String speachContour;
  final String vowelContour;
  @override
  Widget build(BuildContext context) {
   return CustomPaint(
                    painter: ShapePainter(
                      speachContour: speachContour, 
                      vowelContour: vowelContour),
                    child: Container(),
                  );
  }
}

class ShapePainter extends CustomPainter {
  String speachContour;
  String vowelContour;
  ShapePainter({this.speachContour, this.vowelContour});

  @override
  void paint(Canvas canvas, Size size) {

    //vowel&speach contour options
    vowelCont(vowelContour, speachContour, canvas);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


