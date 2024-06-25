import 'package:flutter_midi_pro/flutter_midi_pro.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final flutterMidiProvider = Provider.autoDispose(
  // (ref) => FlutterMidi(),
  (ref) => MidiPro(),
);
