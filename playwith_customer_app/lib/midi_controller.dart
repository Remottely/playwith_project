import 'dart:io';

import 'package:dart_midi_pro/dart_midi_pro.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playwith_customer_app/piano_class_view.dart';

final ValueNotifier<NoteOnEvent?> currentNoteEvent =
    ValueNotifier<NoteOnEvent?>(null);
const _midi = 'super_mario_64_medley.mid';
// const _midi = 'Under-The-Sea-(From-The-Little-Mermaid)-1.mid';
// const _midi = 'Pirates of the Caribbean - He is a Pirate.mid';
// const _midi = 'Queen - Bohemian Rhapsody.mid';
// const _midi = 'mario.mid';
// const _midi = 'havai.mid';

// const _midi = 'test.mid';
// const _midi = 'untitled.mid';
const midiDataAssetPath = 'assets/midi/$_midi';

final MidiParser parser = MidiParser();
final ValueNotifier<int> microsecondsPerBeat =
    ValueNotifier<int>(428756); // equals 140bpm
// ValueNotifier<int>(1200000); // equals 200bpm
final ValueNotifier<int> ticksPerBeat = ValueNotifier<int>(1024);

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
