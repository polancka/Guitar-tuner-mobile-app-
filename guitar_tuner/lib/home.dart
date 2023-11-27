import 'package:flutter/material.dart';
import 'tuning.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Instrument tuner",
          style: TextStyle(color: Colors.orange),
        ),
        centerTitle: true,
        backgroundColor: Colors.white.withOpacity(0.7),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
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
              const Text(
                'Choose Your Instrument:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white), // Set text color to white
              ),
              const SizedBox(height: 20),
              Container(
                  decoration: BoxDecoration(
                    color: Colors
                        .white, // Set the background color of the dropdown
                    borderRadius: BorderRadius.circular(
                        10.0), // Optional: Add border radius for a rounded appearance
                  ),
                  child: DropdownMenu<String>(
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: "guitar", label: "guitar"),
                      DropdownMenuEntry(value: "ukulele", label: "ukulele")
                    ],
                    // Set text color to white
                    onSelected: (value) {
                      setState(() {
                        selectedInstrument = value!;
                        selectedNote =
                            ""; // Reset the second dropdown when changing the first one
                        isButtonEnabled = false; // Disable the button
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
                  decoration: BoxDecoration(
                    color: Colors
                        .white, // Set the background color of the dropdown
                    borderRadius: BorderRadius.circular(
                        10.0), // Optional: Add border radius for a rounded appearance
                  ),
                  child: DropdownMenu<String>(
                    dropdownMenuEntries:
                        buildNoteDropdownItems(selectedInstrument),
                    // Set text color to white
                    onSelected: (value) {
                      setState(() {
                        selectedNote = value!;
                        isButtonEnabled =
                            selectedInstrument != "" && selectedNote != "";
                      });
                    },
                    // Disable the dropdown if no instrument is selected
                    //onChanged: selectedInstrument != null ? (value) => {} : null,
                  )),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Perform action when button is clicked
                  print('Button Clicked: $selectedInstrument, $selectedNote');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TuningPage(
                            instrument: selectedInstrument,
                            tuning: selectedNote)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // Set text color to black

                    Icon(Icons.check,
                        color: Colors.black), // Set icon color to black
                  ],
                ),
                // Set button color to white
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuEntry<String>> buildNoteDropdownItems(selectedInstrument) {
    if (selectedInstrument == "guitar") {
      return [
        DropdownMenuEntry(value: "A", label: "A"),
        DropdownMenuEntry(value: "B", label: "B")
      ];
    } else if (selectedInstrument == "ukulele") {
      return [
        DropdownMenuEntry(value: "AA", label: "AA"),
        DropdownMenuEntry(value: "BB", label: "BB")
      ];
    } else {
      return [
        DropdownMenuEntry(value: "AAA", label: "AAA"),
        DropdownMenuEntry(value: "BBB", label: "BBB")
      ];
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: MyHomePage(),
  ));
}
