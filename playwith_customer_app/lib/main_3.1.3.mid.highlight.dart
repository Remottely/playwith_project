import 'dart:io';

import 'package:dart_midi_pro/dart_midi_pro.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playwith_customer_app/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    // DeviceOrientation.landscapeRight,
  ]);

  runApp(
    const MyApp(),
  );
}

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
              valueListenable: currentNote,
              builder: (context, value, child) {
                return Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: RowOfContainers(selectedIndex: currentNote.value),
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

class RowOfContainers extends StatelessWidget {
  final int? selectedIndex;

  const RowOfContainers({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double containerWidth = 16;
    double containerHeight = screenSize.height / 2;

    return Row(
      children: List.generate(128, (index) {
        return Container(
          width: containerWidth,
          height: containerHeight,
          color: index == selectedIndex ? Colors.red : Colors.blue,
          margin: const EdgeInsets.all(1),
          child: Center(
            child: Text(
              index.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
              ),
            ),
          ),
        );
      }),
    );
  }
}

final ValueNotifier<int?> currentNote = ValueNotifier<int?>(null);
const _midi = 'super_mario_64_medley.mid';
const midiDataAssetPath = 'assets/midi/$_midi';

final MidiParser parser = MidiParser();
final ValueNotifier<int> microsecondsPerBeat =
    ValueNotifier<int>(428756); // equals 140bpm
final ValueNotifier<int> ticksPerBeat = ValueNotifier<int>(1024);

void playMidiNotes(MidiFile midiData) async {
  for (var track in midiData.tracks) {
    for (var event in track) {
      if (event is NoteOnEvent) {
        currentNote.value = null;

        int delay = calculateDelayInMicroseconds(
            event.deltaTime, microsecondsPerBeat.value, ticksPerBeat.value);

        await Future.delayed(Duration(microseconds: delay));

        await playNote(
          channel: 0,
          key: event.noteNumber,
          velocity: event.velocity,
          sfId: selectedSfId.value ?? 0,
        );
      } else if (event is NoteOffEvent) {
        currentNote.value = event.noteNumber;

        int delay = calculateDelayInMicroseconds(
            event.deltaTime, microsecondsPerBeat.value, ticksPerBeat.value);

        await Future.delayed(Duration(microseconds: delay));

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
