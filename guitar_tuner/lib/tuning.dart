import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';
import 'styles.dart';

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
  var status = "Click on start";

  void onError(Object e) {
    print(e);
  }

  Future<void> startRecording() async {
    await _audioRecorder.start(listener, onError,
        sampleRate: 44100, bufferSize: 3000);
    setState(() {
      note = "";
      status = "Play something";
    });
  }

  Future<void> stopRecording() async {
    await _audioRecorder.stop();
    setState(() {
      note = "";
      status = "Click to start";
    });
  }

  void listener(dynamic object) {
    //Gets the audio sample
    var buffer = Float64List.fromList(object.cast<double>());
    final List<double> audioSample = buffer.toList();

    //Uses pitch_detector_dart library to detect a pitch from the audio sample
    final result = pitchDetectorDart.getPitch(audioSample);

    //If there is a pitch - evaluate it
    if (result.pitched) {
      //Uses the pitchupDart library to check a given pitch for a Guitar
      final handledPitchResult = pitchupDart.handlePitch(result.pitch);

      //Updates the state with the result
      setState(() {
        note = handledPitchResult.note;
        status = handledPitchResult.tuningStatus.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Text(
                  "Instrument in tuning", //widget.instrument,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white), // Set text color to white
                ),
                SizedBox(height: 10),
                Text(
                  "Tuning style", //widget.tuning,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white), // Set text color to white
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Wanted tone",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Current tone",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(color: Colors.white),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Tune up/ Tune down",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ));
  }
}
