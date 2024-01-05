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
  var status = "";
  var current_note = "";
  var listeningStatus = "Not listening";
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    getMicPermission();
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
      setState(() {
        note = handledPitchresult.note;
        status = handledPitchresult.tuningStatus.toString();
      });
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
      status = "Pluck a string!";
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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                ),
                Text(
                  "Instrument in tuning: $show_instrument", //widget.instrument,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white), // Set text color to white
                ),
                SizedBox(height: 10),
                Text(
                  "Tuning style: $show_tuning", //widget.tuning,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white), // Set text color to white
                ),

                SizedBox(
                  height: 60,
                ),
                Text(
                  "Current tone",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  note,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  current_note,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 30,
                ),
                //add gif for listening
                SizedBox(
                  height: 40,
                ),
                Text(
                  status,
                  style: TextStyle(color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: isListening ? stopListening : startListening,
                  child: isListening
                      ? Text("Stop listening")
                      : Text("Start listening!"),
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white)),
                ),
                isListening
                    ? Image.asset('lib/utils/wave.gif')
                    : Image.asset('lib/utils/still.png')
              ],
            ),
          ),
        ));
  }
}
