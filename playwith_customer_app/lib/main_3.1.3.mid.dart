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

  @override
  void initState() {
    super.initState();
    loadSoundFont();
  }

  void loadSoundFont() async {
    selectedSfId.value = await midiPro.loadSoundfont(
        path: _soundFontAssetPath, bank: 0, program: 0);
  }

  void playMidiNotes(List<int> midiNotes) async {
    for (int note in midiNotes) {
      // midiPro.playMidiNote(midi: note, velocity: 127);
      await midiPro.playNote(
        channel: 0, key: note, velocity: 127, sfId: selectedSfId.value ?? 0);
      await Future.delayed(
          const Duration(milliseconds: 200)); // Ajuste o tempo de acordo
    }
  }

  void pickAndPlayMidiFromFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mid', 'midi'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      final midiData = parser.parseMidiFromFile(file);

      // Obter as notas MIDI do arquivo
      List<int> midiNotes = [];
      for (var track in midiData.tracks) {
        for (var event in track) {
          if (event is NoteOnEvent && event.velocity > 0) {
            midiNotes.add(event.noteNumber);
          }
        }
      }

      playMidiNotes(midiNotes);
    }
  }

  Future<void> playMidiFromAsset(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final List<int> bytes = data.buffer.asUint8List();

    final MidiFile midiData = parser.parseMidiFromBuffer(bytes);

    // Obter as notas MIDI do arquivo
    List<int> midiNotes = [];
    for (var track in midiData.tracks) {
      for (var event in track) {
        if (event is NoteOnEvent && event.velocity > 0) {
          midiNotes.add(event.noteNumber);
        }
      }
    }

    playMidiNotes(midiNotes);
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
