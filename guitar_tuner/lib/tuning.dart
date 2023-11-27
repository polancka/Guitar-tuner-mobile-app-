import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TuningPage extends StatefulWidget {
  const TuningPage({super.key, required this.instrument, required this.tuning});

  final String instrument;
  final String tuning;

  @override
  State<TuningPage> createState() => _TuningPageState();
}

class _TuningPageState extends State<TuningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.orange,
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
          backgroundColor: Colors.white.withOpacity(0.7),
        ),
        backgroundColor: Colors.black,
        body: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Colors.white, Colors.orange, Colors.white],
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
