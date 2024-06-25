import 'dart:io';

import 'package:dart_midi_pro/dart_midi_pro.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi_pro/flutter_midi_pro.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter MIDI Demo',
      home: MyHomePage(),
    );
  }
}

const _piano = 'UprightPianoKW-small-20190703.sf2';
const _soundFontAssetPath = 'assets/soundfonts/$_piano';
const _midi = 'super_mario_64_medley.mid';
const _midiDataAssetPath = 'assets/midi/$_midi';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MidiPro midiPro = MidiPro();
  final MidiParser parser = MidiParser();
  final ValueNotifier<int?> selectedSfId = ValueNotifier<int?>(null);
  final ValueNotifier<int> microsecondsPerBeat =
      ValueNotifier<int>(428756); // equals 140bpm
  final ValueNotifier<int> ticksPerBeat = ValueNotifier<int>(1024);

  @override
  void initState() {
    super.initState();
    loadSoundFont();
  }

  void loadSoundFont() async {
    selectedSfId.value = await midiPro.loadSoundfont(
        path: _soundFontAssetPath, bank: 0, program: 0);
  }

  void playMidiNotes(MidiFile midiData) async {
    for (var track in midiData.tracks) {
      for (var event in track) {
        if (event is NoteOnEvent) {
          int delay = calculateDelayInMicroseconds(
              event.deltaTime, microsecondsPerBeat.value, ticksPerBeat.value);

          await Future.delayed(Duration(microseconds: delay));

          await midiPro.playNote(
            channel: 0,
            key: event.noteNumber,
            velocity: 127,
            sfId: selectedSfId.value ?? 0,
          );
        } else if (event is NoteOffEvent) {
          int delay = calculateDelayInMicroseconds(
              event.deltaTime, microsecondsPerBeat.value, ticksPerBeat.value);

          await Future.delayed(Duration(microseconds: delay));

          // await midiPro.stopNote(
          //   channel: 0,
          //   key: event.noteNumber,
          //   sfId: selectedSfId.value ?? 0,
          // );
        }
      }
    }
  }

  // double convertDeltaTimeToSeconds(int ticksPerBeat, int microsecondsPerBeat) {
  //   double secondsPerTick = (microsecondsPerBeat / 1000000) / ticksPerBeat;
  //   return deltaTime * secondsPerTick;
  // }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter MIDI Demo"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: pickAndPlayMidiFromFile,
            child: const Text("Pick and Play MIDI from File"),
          ),
          ElevatedButton(
            // onPressed: pickMidiFile,
            onPressed: () => playMidiFromAsset(_midiDataAssetPath),
            child: const Text("Pick and Play MIDI from path"),
          ),
        ],
      )),
    );
  }
}
