import 'package:flutter/material.dart';
import 'tuning.dart';
import 'styles.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedInstrument = "guitar";
  String selectedNote = "A";
  bool isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Styles.deepgreen,
                      Styles.lightgreen,
                      Styles.offwhite
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        20, MediaQuery.of(context).size.height * 0.1, 20, 0),
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 30),
                          const Text(
                            'Choose Your Instrument:',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white), // Set text color to white
                          ),
                          const SizedBox(height: 20),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(
                                    0.3), // Set the background color of the dropdown
                                borderRadius: BorderRadius.circular(
                                    10.0), // Optional: Add border radius for a rounded appearance
                              ),
                              child: DropdownMenu<String>(
                                width: MediaQuery.of(context).size.width,

                                dropdownMenuEntries: const [
                                  DropdownMenuEntry(
                                      value: "guitar", label: "Guitar"),
                                  DropdownMenuEntry(
                                      value: "ukulele", label: "Ukulele")
                                ],
                                // Set text color to white
                                onSelected: (value) {
                                  setState(() {
                                    selectedInstrument = value!;
                                    selectedNote =
                                        ""; // Reset the second dropdown when changing the first one
                                    isButtonEnabled =
                                        false; // Disable the button
                                  });
                                },
                              )),
                          const SizedBox(height: 20),
                          const Text(
                            'Choose tuning:',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white), // Set text color to white
                          ),
                          const SizedBox(height: 10),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(
                                    0.3), // Set the background color of the dropdown
                                borderRadius: BorderRadius.circular(
                                    10.0), // Optional: Add border radius for a rounded appearance
                              ),
                              child: DropdownMenu<String>(
                                leadingIcon:
                                    Icon(Icons.music_note, color: Colors.white),
                                dropdownMenuEntries:
                                    buildNoteDropdownItems(selectedInstrument),
                                // Set text color to white
                                onSelected: (value) {
                                  setState(() {
                                    selectedNote = value!;
                                    isButtonEnabled =
                                        selectedInstrument != "" &&
                                            selectedNote != "";
                                  });
                                },
                                // Disable the dropdown if no instrument is selected
                                //onChanged: selectedInstrument != null ? (value) => {} : null,
                              )),
                          const SizedBox(height: 40),
                          logInButton(context, "Let's go!", selectedInstrument,
                              selectedNote)
                        ],
                      ),
                    ),
                  ),
                ))));
  }

  List<DropdownMenuEntry<String>> buildNoteDropdownItems(selectedInstrument) {
    if (selectedInstrument == "guitar") {
      return [
        DropdownMenuEntry(value: "EADGHE", label: "EADGHE"),
        DropdownMenuEntry(value: "drop D", label: "drop D")
      ];
    } else if (selectedInstrument == "ukulele") {
      return [
        DropdownMenuEntry(value: "GCEA", label: "GCEA"),
        DropdownMenuEntry(value: "drop D", label: "drop D")
      ];
    } else {
      return [
        DropdownMenuEntry(value: "AAA", label: "AAA"),
        DropdownMenuEntry(value: "BBB", label: "BBB")
      ];
    }
  }
}

SizedBox logInButton(
    BuildContext context, String text, String instrument, String tuning) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: 40,
    child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TuningPage(instrument: instrument, tuning: tuning)),
          );
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              return Colors.white;
            })),
        child: Text(text, style: TextStyle(color: Styles.deepgreen))),
  );
}

void main() {
  runApp(MaterialApp(
    home: MyHomePage(),
  ));
}
