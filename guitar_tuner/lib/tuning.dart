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

  @override
  void initState() {
    super.initState();
    checkTuning();
    getMicPermission();
  }

  checkTuning() {
    if (widget.tuning == "drop D") {
      setState(() {
        dropD = true;
      });
    }
  }

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

  void listener(dynamic obj) {
    //Gets the audio sample
    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();

    final pitch = pitchDetectorDart.getPitch(audioSample);
    if (pitch.pitched) {
      final handledPitchresult = pitchupDart.handlePitch(pitch.pitch);
      if (handledPitchresult.tuningStatus.toString() == "TuningStatus.tuned") {
        curr_status = "Tuned! Next string!";
      } else if (handledPitchresult.tuningStatus.toString() ==
              "TuningStatus.toolow" ||
          handledPitchresult.tuningStatus.toString() ==
              "TuningStatus.waytoolow") {
        curr_status = "Too low! Tune up!";
      } else if (handledPitchresult.tuningStatus.toString() ==
              "TuningStatus.toohigh" ||
          handledPitchresult.tuningStatus.toString() ==
              "TuningStatus.waytoohigh") {
        curr_status = "Too high! Tune down!";
      } else if (handledPitchresult.tuningStatus.toString() ==
          "TuningStatus.undefined") {
        curr_status = "The pitch is not close to any expected guitar note!";
      }
      setState(() {
        note = handledPitchresult.note;
        status = curr_status;
        wantednote = handledPitchresult.expectedFrequency;
        current_freq = wantednote + handledPitchresult.diffFrequency;
      });
    }
  }

  Row rowOfNotes() {
    if (!dropD) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("E", style: TextStyle(color: Colors.white)),
          SizedBox(
            width: 30,
          ),
          Text("A", style: TextStyle(color: Colors.white)),
          SizedBox(
            width: 30,
          ),
          Text("D", style: TextStyle(color: Colors.white)),
          SizedBox(
            width: 30,
          ),
          Text("G", style: TextStyle(color: Colors.white)),
          SizedBox(
            width: 30,
          ),
          Text("B", style: TextStyle(color: Colors.white)),
          SizedBox(
            width: 30,
          ),
          Text("E", style: TextStyle(color: Colors.white))
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("D", style: TextStyle(color: Colors.white)),
          SizedBox(
            width: 30,
          ),
          Text("A", style: TextStyle(color: Colors.white)),
          SizedBox(
            width: 30,
          ),
          Text("D", style: TextStyle(color: Colors.white)),
          SizedBox(
            width: 30,
          ),
          Text("G", style: TextStyle(color: Colors.white)),
          SizedBox(
            width: 30,
          ),
          Text("H", style: TextStyle(color: Colors.white)),
          SizedBox(
            width: 30,
          ),
          Text("E", style: TextStyle(color: Colors.white))
        ],
      );
    }
  }

  void onError(Object e) {
    print(e);
  }

  startListening() async {
    print("starting listening");
    setState(() {
      isListening = true;
    });
    // do audio capturing
    await _audioRecorder.start(listener, onError,
        sampleRate: 44100, bufferSize: 3000);
    setState(() {
      note = "";
      status = "";
    });
  }

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

  @override
  void dispose() {
    _audioRecorder.stop();
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
                    Text("6th", style: TextStyle(color: Colors.white)),
                    SizedBox(
                      width: 15,
                    ),
                    Text("5th", style: TextStyle(color: Colors.white)),
                    SizedBox(
                      width: 15,
                    ),
                    Text("4th", style: TextStyle(color: Colors.white)),
                    SizedBox(
                      width: 15,
                    ),
                    Text("3rd", style: TextStyle(color: Colors.white)),
                    SizedBox(
                      width: 15,
                    ),
                    Text("2nd", style: TextStyle(color: Colors.white)),
                    SizedBox(
                      width: 15,
                    ),
                    Text("1st", style: TextStyle(color: Colors.white)),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                rowOfNotes(),
                SizedBox(height: 30),
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
                  wantednote.toString(),
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
