import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';
import 'styles.dart';
import 'package:permission_handler/permission_handler.dart';

class TuningPage extends StatefulWidget {
  const TuningPage({super.key, required this.instrument, required this.tuning});

  final String instrument;
  final String tuning;

  @override
  State<TuningPage> createState() => _TuningPageState();
}

class _TuningPageState extends State<TuningPage> {
  //defining the variables that will be calculated with or shown on the screen
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  final pitchupDart = PitchHandler(InstrumentType.guitar);

  var note = "";
  var wantednote = 0.0;
  var current_freq = 0.0;
  var status = "";
  var current_note = "";
  var listeningStatus = "Not listening";
  var curr_status = "";
  bool isListening = false;
  bool dropD = false;
  var standardFreq = [330.00, 247.00, 196.00, 147.00, 110.00, 82.00];
  var dropDFreq = [330.00, 247.00, 196.00, 147.00, 110.00, 73.00];
  var freqs = [];
  var stringCounter = 6;
  var boldStyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20);
  var normalStyle = TextStyle(color: Colors.white);
  var colorButton = MaterialStatePropertyAll(Colors.white);

  @override
  void initState() {
    super.initState();
    checkTuning();
    getMicPermission();
    // startListening();
  }

  //checking which tuning was picked
  checkTuning() {
    if (widget.tuning == "drop D") {
      setState(() {
        dropD = true;
        freqs = dropDFreq;
      });
    } else {
      setState(() {
        dropD = false;
        freqs = standardFreq;
      });
    }
    print(freqs);
  }

  //getting permission to access the microphone
  getMicPermission() async {
    var status = await Permission.microphone.status;
    // Permission hasn't been requested yet
    if (status.isDenied) {
      // Permission has been denied by the user
      // You might want to display a message or navigate to settings
      print("PERMISSION DENIED");
      await Permission.microphone.request();
    } else if (status.isGranted) {
      // Permission has already been granted
      print("PERMISSION GRANTED");
    } else {
      await Permission.microphone.request();
      print("ASKING PERMISSION");
    }
  }

  //function for getting the audio input and managing it
  void listener(dynamic obj) {
    //Gets the audio sample
    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();

    final pitch = pitchDetectorDart.getPitch(audioSample);

    if (pitch.pitched) {
      final handledPitchresult = pitchupDart.handlePitch(pitch.pitch);
      print(pitch.pitch);
      var wantedfreq = freqs[stringCounter - 1];
      if ((wantedfreq - pitch.pitch).abs() < 1) {
        setState(() {
          status = "Tuned! Next string!";
          note = handledPitchresult.note;
          colorButton = MaterialStatePropertyAll(Colors.green[200]!);
        });
      } else if ((wantedfreq - pitch.pitch) <= -1) {
        setState(() {
          status = "Tune DOWN!";
          note = handledPitchresult.note;
        });
      } else if ((wantedfreq - pitch.pitch) > 1) {
        setState(() {
          status = "Tune UP!";
          note = handledPitchresult.note;
        });
      }
      setState(() {
        current_freq = pitch.pitch;
      });
    }
  }

  //grafic element
  Row rowOfNotes() {
    if (!dropD) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("E", style: stringCounter == 6 ? boldStyle : normalStyle),
          SizedBox(
            width: 30,
          ),
          Text("A", style: stringCounter == 5 ? boldStyle : normalStyle),
          SizedBox(
            width: 30,
          ),
          Text("D", style: stringCounter == 4 ? boldStyle : normalStyle),
          SizedBox(
            width: 30,
          ),
          Text("G", style: stringCounter == 3 ? boldStyle : normalStyle),
          SizedBox(
            width: 30,
          ),
          Text("B", style: stringCounter == 2 ? boldStyle : normalStyle),
          SizedBox(
            width: 30,
          ),
          Text("E", style: stringCounter == 1 ? boldStyle : normalStyle)
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("D", style: stringCounter == 6 ? boldStyle : normalStyle),
          SizedBox(
            width: 30,
          ),
          Text("A", style: stringCounter == 5 ? boldStyle : normalStyle),
          SizedBox(
            width: 30,
          ),
          Text("D", style: stringCounter == 4 ? boldStyle : normalStyle),
          SizedBox(
            width: 30,
          ),
          Text("G", style: stringCounter == 3 ? boldStyle : normalStyle),
          SizedBox(
            width: 30,
          ),
          Text("H", style: stringCounter == 2 ? boldStyle : normalStyle),
          SizedBox(
            width: 30,
          ),
          Text("E", style: stringCounter == 1 ? boldStyle : normalStyle)
        ],
      );
    }
  }

  //error function for listener
  void onError(Object e) {
    print(e);
  }

  //function for starting the listener
  startListening() async {
    print("starting listening");
    setState(() {
      isListening = true;
    });
    // do audio capturing
    await _audioRecorder.start(listener, onError,
        firstDataTimeout: Duration(seconds: 1),
        sampleRate: 44100,
        bufferSize: 3000000);
    setState(() {
      note = "";
      status = "";
    });
  }

  //stoping listening ang clearing the values
  stopListening() async {
    print("stop listening");
    setState(() {
      isListening = false;
    });
    await _audioRecorder.stop();

    setState(() {
      note = "";
      status = "";
      current_freq = 0.0;
      wantednote = 0.0;
    });

    // save the audio, obdelaj
    // izpiši pitch
  }

  //switch strings from higher to lower
  leftButton() {
    if (stringCounter < 6) {
      setState(() {
        stringCounter += 1;
        colorButton = MaterialStatePropertyAll(Colors.white);
      });
    }
    print(stringCounter);
  }

  //switch strings from lower to higher
  rightButton() {
    if (stringCounter > 1) {
      setState(() {
        stringCounter -= 1;
        colorButton = MaterialStatePropertyAll(Colors.white);
      });
    }
    print(stringCounter);
  }

  @override
  void dispose() {
    _audioRecorder.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var show_instrument = widget.instrument;
    var show_tuning = widget.tuning;

    return Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          title: Text(
            "$show_instrument : $show_tuning",
            style: TextStyle(color: Colors.green[900]),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Styles.deepgreen,
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
          backgroundColor: Colors.white.withOpacity(0.7),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Styles.deepgreen, Styles.lightgreen, Styles.offwhite],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Text("6th",
                        style: stringCounter == 6 ? boldStyle : normalStyle),
                    SizedBox(
                      width: 15,
                    ),
                    Text("5th",
                        style: stringCounter == 5 ? boldStyle : normalStyle),
                    SizedBox(
                      width: 15,
                    ),
                    Text("4th",
                        style: stringCounter == 4 ? boldStyle : normalStyle),
                    SizedBox(
                      width: 15,
                    ),
                    Text("3rd",
                        style: stringCounter == 3 ? boldStyle : normalStyle),
                    SizedBox(
                      width: 15,
                    ),
                    Text("2nd",
                        style: stringCounter == 2 ? boldStyle : normalStyle),
                    SizedBox(
                      width: 15,
                    ),
                    Text("1st",
                        style: stringCounter == 1 ? boldStyle : normalStyle),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                rowOfNotes(),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: leftButton,
                        child: Icon(Icons.arrow_left),
                        style: ButtonStyle(backgroundColor: colorButton)),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        onPressed: rightButton,
                        child: Icon(Icons.arrow_right),
                        style: ButtonStyle(backgroundColor: colorButton))
                  ],
                ),
                Text(
                  "Current tone",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  note,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                Text(
                  "Current frequency",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  current_freq
                      .toString()
                      .substring(0, current_freq.toString().indexOf('.') + 2),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                Text(
                  "Expected frequency",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  freqs[stringCounter - 1].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                Text(
                  current_note,
                  style: TextStyle(color: Colors.white),
                ),
                isListening
                    ? Image.asset('lib/utils/wave.gif')
                    : Image.asset('lib/utils/still.png'),
                SizedBox(
                  height: 25,
                ),
                Text(
                  status,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: isListening ? stopListening : startListening,
                  child: isListening
                      ? Text("Stop listening")
                      : Text("Start listening!"),
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white)),
                ),
              ],
            ),
          ),
        ));
  }
}
