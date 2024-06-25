import 'dart:io';

import 'package:dart_midi_pro/dart_midi_pro.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playwith_customer_app/main.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.landscapeLeft,
//     // DeviceOrientation.landscapeRight,
//   ]);

//   runApp(
//     const MyApp(),
//   );
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    loadSoundFont(sf2Paths[0], bankIndex.value, instrumentIndex.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder(
              valueListenable: currentNoteEvent,
              builder: (context, currentNoteEventValue, child) {
                return Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: LessonCanvas(
                          selectedIndex: currentNoteEventValue?.noteNumber),
                    ),
                  ],
                );
              }),
          FittedBox(
            child: Row(
              children: [
                const ElevatedButton(
                  onPressed: pickAndPlayMidiFromFile,
                  child: Text("Pick and Play MIDI from File"),
                ),
                ElevatedButton(
                  onPressed: () => playMidiFromAsset(midiDataAssetPath),
                  child: const Text("Pick and Play MIDI from path"),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}

class LessonCanvas extends StatelessWidget {
  final int? selectedIndex;
  final int noteCount; // Number of natural notes
  final int firstOctave;

  const LessonCanvas({
    super.key,
    required this.selectedIndex,
    this.noteCount = 12,
    this.firstOctave = 4,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double containerHeight = screenSize.height / 2;

    // Total number of notes in an octave (natural + accidental)
    const int totalNotesInOctave = 12;

    // lista 1: 2, 3, 5, 6, 7, 9, 10, 12, 13, 14, 16, 17, 19, 20, 21, 23, 24, 26, 27, 28, 30, 31
    // lista 2: 4, 8, 11, 15, 18, 22, 25, 29, 32 ... 128

    List<String> notes = [
      'C', // 13, 26
      'C#', // 2, 14,
      'D', // 3,
      'D#', // 16,
      'E', // 5, 17,
      'F', // 6, 19,
      'F#', // 7, 20,
      'G', // 21,
      'G#', // 9,
      'A', // 10, 23
      'A#', // 11, 24
      'B', // 12,
    ];

    // Define the sets for different categories
    Set<String> notesX = {'C', 'E', 'F', 'B'};
    Set<String> notesY = {'D', 'G', 'A'};
    // Set<String> notesZ = {'C#', 'D#', 'F#', 'G#', 'A#'};

    // Calculate the total number of notes to be displayed
    int totalNotesToShow = noteCount + (noteCount * 5 ~/ 7);

    bool isNoteCountPattern = getIsNoteCountPattern(noteCount);

    return Row(
      children: List.generate(totalNotesToShow, (index) {
        int octave = (index ~/ totalNotesInOctave) + firstOctave;
        String note = notes[index % totalNotesInOctave];
        bool isAccidental = note.contains('#');
        bool isX = notesX.contains(note);
        bool isY = notesY.contains(note);
        // bool isZ = notesZ.contains(note);
        bool isLastNote = index == totalNotesToShow - 1;

        return Flexible(
          flex: isLastNote
              ? (isNoteCountPattern ? 21 : 16)
              : isX
                  ? 16
                  : isY
                      ? 11
                      : 10,
          child: Container(
            height: containerHeight,
            margin: const EdgeInsets.all(0.5),
            decoration: BoxDecoration(
              // color: index == selectedIndex ? Colors.red : Colors.blue,
              color: isAccidental
                  ? Colors.grey.shade900
                  : const Color.fromARGB(255, 45, 45, 45),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  '$note$octave',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

final ValueNotifier<NoteOnEvent?> currentNoteEvent =
    ValueNotifier<NoteOnEvent?>(null);
const _midi = 'super_mario_64_medley.mid';
const midiDataAssetPath = 'assets/midi/$_midi';

final MidiParser parser = MidiParser();
final ValueNotifier<int> microsecondsPerBeat =
    ValueNotifier<int>(428756); // equals 140bpm
final ValueNotifier<int> ticksPerBeat = ValueNotifier<int>(1024);

bool getIsNoteCountPattern(int noteCount) {
  List<int> patternList = [];
  int currentValue = 4;
  bool addThree = false;

  while (currentValue <= 128) {
    patternList.add(currentValue);
    currentValue += addThree ? 3 : 4;
    addThree = !addThree;
  }

  // false: [2, 3, 5, 6, 7, 9, 10, 12, 13, 14, 16, 17, 19, 20, 21, 23, 24, 26, 27, 28, 30, 31, ..., 128]
  // true: [4, 8, 11, 15, 18, 22, 25, 29, 32 ..., 128]
  return patternList.contains(noteCount);
}

void playMidiNotes(MidiFile midiData) async {
  for (var track in midiData.tracks) {
    for (var event in track) {
      if (event is NoteOnEvent) {
        int delay = calculateDelayInMicroseconds(
            event.deltaTime, microsecondsPerBeat.value, ticksPerBeat.value);

        await Future.delayed(Duration(microseconds: delay));

        currentNoteEvent.value = event;

        await playNote(
          channel: 0,
          key: event.noteNumber,
          velocity: event.velocity,
          sfId: selectedSfId.value ?? 0,
        );
      } else if (event is NoteOffEvent) {
        int delay = calculateDelayInMicroseconds(
            event.deltaTime, microsecondsPerBeat.value, ticksPerBeat.value);

        await Future.delayed(Duration(microseconds: delay));

        currentNoteEvent.value = null;

        stopNote(
          channel: 0,
          key: event.noteNumber,
          sfId: selectedSfId.value ?? 0,
        );
      }
    }
  }
}

int calculateDelayInMicroseconds(
    int deltaTime, int microsecondsPerBeat, int ticksPerBeat) {
  // Calcula a duração de um tick em microsegundos.
  double microsecondsPerTick = microsecondsPerBeat / ticksPerBeat;

  // Calcula o delay total em microsegundos.
  int delayInMicroseconds = (deltaTime * microsecondsPerTick).toInt();

  return delayInMicroseconds;
}

void pickAndPlayMidiFromFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['mid', 'midi'],
  );

  if (result != null) {
    File file = File(result.files.single.path!);
    final midiData = parser.parseMidiFromFile(file);
    playMidiNotes(midiData);
  }
}

Future<void> playMidiFromAsset(String assetPath) async {
  final ByteData data = await rootBundle.load(assetPath);
  final List<int> bytes = data.buffer.asUint8List();
  final MidiFile midiData = parser.parseMidiFromBuffer(bytes);
  playMidiNotes(midiData);
}
