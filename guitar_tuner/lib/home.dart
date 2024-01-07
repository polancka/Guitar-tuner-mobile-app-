import 'package:flutter/material.dart';
import 'tuning.dart';
import 'styles.dart';

//TO FIX: when chosing another instrument , rebuild the second dropdown button --> Currently not working MUST FIX

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? selectedInstrument = "Guitar";
  String? selectedNote = "Standard";
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
                Styles.offwhite,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).size.height * 0.1,
                20,
                0,
              ),
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
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // first dropdown
                    DropdownButton(
                      value: selectedInstrument,
                      dropdownColor: Styles.deepgreen,
                      items: [
                        DropdownMenuItem(
                          child: Center(
                              child: Text(
                            "Guitar",
                            style: TextStyle(color: Colors.white),
                          )),
                          value: "Guitar",
                        ),
                        // DropdownMenuItem(
                        //   child: Center(
                        //       child: Text(
                        //     "Ukulele",
                        //     style: TextStyle(color: Colors.white),
                        //   )),
                        //   value: "Ukulele",
                        // ),
                        // DropdownMenuItem(
                        //   child: Center(
                        //       child: Text(
                        //     "Violin",
                        //     style: TextStyle(color: Colors.white),
                        //   )),
                        //   value: "Violin",
                        // )
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedInstrument = newValue!;
                        });
                      },
                      iconEnabledColor: Styles.deepgreen,
                      isExpanded: true,
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      'Choose tuning:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    //second dropdown

                    DropdownButton(
                      dropdownColor: Styles.deepgreen,
                      value: selectedNote,
                      items: [
                        DropdownMenuItem(
                            value: "Standard",
                            child: Center(
                                child: Text("Standard",
                                    style: TextStyle(color: Colors.white)))),
                        DropdownMenuItem(
                            value: "drop D",
                            child: Center(
                                child: Text("drop D",
                                    style: TextStyle(color: Colors.white)))),
                      ],
                      onChanged: dropdownTuningCallback,
                      iconEnabledColor: Styles.deepgreen,
                      isExpanded: true,
                    ),

                    const SizedBox(height: 40),
                    nextButton(context, "Let's go!", selectedInstrument,
                        selectedNote, isButtonEnabled),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void dropdownInstrumentCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        selectedInstrument = selectedValue;
        selectedNote = "";
        updateButtonEnabled();
      });
    }
  }

  void dropdownTuningCallback(String? selectedTone) {
    if (selectedTone is String) {
      setState(() {
        selectedNote = selectedTone;
        updateButtonEnabled();
      });
    }
  }

  List<DropdownMenuItem<String>>? buildNoteDropdownItems(
      String? selectedInstrument) {
    if (selectedInstrument == null) {
      return [];
    }
    if (selectedInstrument == "Guitar") {
      return [
        DropdownMenuItem(
            value: "EADGBE",
            child: Center(
                child: Text("EADGBE", style: TextStyle(color: Colors.white)))),
        DropdownMenuItem(
            value: "drop D",
            child: Center(
                child: Text("drop D", style: TextStyle(color: Colors.white)))),
      ];
    } else if (selectedInstrument == "Ukulele") {
      return [
        DropdownMenuItem(
            value: "GCEA",
            child: Center(
                child: Text("GCEA", style: TextStyle(color: Colors.white)))),
        DropdownMenuItem(
            value: "drop D",
            child: Center(
                child: Text("drop D", style: TextStyle(color: Colors.white)))),
      ];
    } else if (selectedInstrument == "Violin") {
      return [
        DropdownMenuItem(
            value: "CGDA",
            child: Center(
                child: Text("CGDA", style: TextStyle(color: Colors.white)))),
        DropdownMenuItem(
            value: "GDAE",
            child: Center(
                child: Text("GDAE", style: TextStyle(color: Colors.white)))),
        DropdownMenuItem(
            value: "halfstep",
            child: Center(
                child:
                    Text("halfstep", style: TextStyle(color: Colors.white)))),
      ];
    } else {
      return null;
    }
  }

  void updateButtonEnabled() {
    setState(() {
      isButtonEnabled = selectedInstrument != null && selectedNote != null;
    });
  }
}

SizedBox nextButton(BuildContext context, String text, String? instrument,
    String? tuning, bool isButtonEnabled) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: 40,
    child: ElevatedButton(
      onPressed: () {
        (instrument != null && tuning != null)
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TuningPage(instrument: instrument!, tuning: tuning!),
                ),
              )
            : null;
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          return Colors.white;
        }),
      ),
      child: Text(text, style: TextStyle(color: Styles.deepgreen)),
    ),
  );
}

void main() {
  runApp(MaterialApp(
    home: MyHomePage(),
  ));
}
