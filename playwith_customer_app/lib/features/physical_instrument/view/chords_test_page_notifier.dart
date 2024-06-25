import 'dart:async';

import 'package:flutter/foundation.dart';
// import 'package:flutter_midi/flutter_midi.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:flutter_midi_pro/flutter_midi_pro.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piano/piano.dart';
import 'package:playwith_customer_app/features/physical_instrument/data/chord_repository.dart';
import 'package:playwith_customer_app/features/physical_instrument/data/midi_pro.dart';
import 'package:playwith_customer_app/features/physical_instrument/data/midi_repository.dart';
import 'package:playwith_customer_app/features/physical_instrument/domain/chord.dart';
import 'package:playwith_customer_app/features/physical_instrument/domain/match_chord_use_case.dart';
import 'package:playwith_customer_app/features/physical_instrument/view/chords_test_page_model.dart';
import 'package:playwith_customer_app/features/physical_instrument/view/game_state.dart';
import 'package:time/time.dart';

enum MidiSetUpChangeEvent { deviceFound, deviceLost }

// const _piano = 'UprightPianoKW-small-20190703.sf2';
const _piano = 'YDP-GrandPiano-20160804.sf2';
const _midiFontAssetPath = 'assets/soundfonts/$_piano';

final chordsTestPageNotifierProvder =
    StateNotifierProvider<ChordsTestPageNotifier, ChordsTestPageModel>(
  (ref) => ChordsTestPageNotifier(
    ref.read(midiRepositoryProvider),
    ref.read(chordRepositoryProvider),
    ref.read(matchChordUseCaseProvider),
    ref.read(flutterMidiProvider),
  ),
);

class ChordsTestPageNotifier extends StateNotifier<ChordsTestPageModel> {
  ChordsTestPageNotifier(
    this._midiRepository,
    this._chordRepository,
    this._matchChordUseCase,
    this._midi,
  ) : super(
          const ChordsTestPageModel(
            devices: [],
            connectionStatus: ConnectionStatus.noDevices,
            selectedDevice: null,
            expectedChord: null,
            playedNotes: [],
            gameState: null,
          ),
        ) {
    onInit();
  }

  final MidiRepository _midiRepository;
  final ChordRepository _chordRepository;
  final MatchChordUseCase _matchChordUseCase;
  // final FlutterMidi _flutterMidi;
  final MidiPro _midi;

  int soundfontId = 0;

  late final StreamSubscription? _midiSetupChangeSub;
  late final StreamSubscription? _midiDataReceiverSub;

  Future<void> onInit() async {
    _listenToMidiCommands();
    await _initDevices();
    await _loadFlutterMidi();
  }

  @override
  void dispose() {
    _midiSetupChangeSub?.cancel();
    _midiDataReceiverSub?.cancel();
    super.dispose();
  }

  void _listenToMidiCommands() {
    _midiSetupChangeSub =
        _midiRepository.midiSetupChangeStream?.listen((event) {
      if (event == MidiSetUpChangeEvent.deviceFound.name ||
          event == MidiSetUpChangeEvent.deviceLost.name) {
        onDevicesUpdated();
      }
    });

    _midiDataReceiverSub = _midiRepository.notesStream?.listen(
      (note) => _onNoteReceived(note),
    )?..onError((e) => debugPrint('Error: $e'));
  }

  Future<void> _loadFlutterMidi() async {
    // ByteData byte = await rootBundle.load(_midiFontAssetPath);
    // not awaited since awaits forever due to poorly done plugin
    // _flutterMidi.prepare(
    //   sf2: byte,
    //   name: _piano,
    // );
    // soundfontId = await _flutterMidi.loadSoundfont(
    //   path: _midiFontAssetPath,
    //   bank: 0,
    //   program: 0,
    // );

    await _midi.loadSoundfont(
      sf2Path: _midiFontAssetPath,
      instrumentIndex: 0,
    );
    await _midi.loadInstrument(instrumentIndex: 0);
  }

  @visibleForTesting
  Future<void> onDevicesUpdated() async {
    final devices = await _midiRepository.devices;
    ConnectionStatus connectionStatus;
    MidiDevice? selectedDevice;

    try {
      selectedDevice = devices.firstWhere(
        (device) => device.name == state.selectedDevice!.name,
      );
    } catch (e) {
      selectedDevice == null;
    }

    if (devices.isEmpty) {
      connectionStatus = ConnectionStatus.noDevices;
    } else if (selectedDevice != null &&
        state.connectionStatus == ConnectionStatus.connected) {
      connectionStatus = ConnectionStatus.connected;
    } else {
      connectionStatus = ConnectionStatus.disconnected;
    }

    state = state.copyWith(
      devices: devices,
      connectionStatus: connectionStatus,
      selectedDevice: selectedDevice,
    );
  }

  Future<void> _onNoteReceived(NotePosition note) async {
    if (state.connectionStatus != ConnectionStatus.connected) {
      debugPrint('Not connected, then why are we getting notes?');

      return;
    }

    debugPrint('Note received: ${note.name}');

    Chord chord = state.expectedChord!;
    List<NotePosition> playedNotes = [note, ...state.playedNotes];
    GameState gameState = state.gameState!;

    final chordMatch = _matchChordUseCase(
      chord: chord,
      notes: playedNotes,
    );

    debugPrint('Chord matched with $chordMatch');

    // Delay used to display all of the played notes for a while
    // before piano is cleared
    Future delay200() => Future.delayed(200.milliseconds);

    switch (chordMatch) {
      case ChordMatch.matched:
        state = state.copyWith(playedNotes: playedNotes);
        await delay200();

        chord = _chordRepository.random;
        playedNotes.clear();
        gameState = gameState.addSuccess();
        break;
      case ChordMatch.partial:
        break;
      case ChordMatch.failed:
        state = state.copyWith(playedNotes: playedNotes);
        await delay200();

        playedNotes.clear();
        gameState = gameState.addFailure();
        break;
    }

    state = state.copyWith(
      expectedChord: chord,
      playedNotes: playedNotes,
      gameState: gameState,
    );
  }

  Future<void> _initDevices() async {
    _midiRepository.addVirtualDevice();

    final devices = await _midiRepository.devices;
    final status = devices.isEmpty
        ? ConnectionStatus.noDevices
        : ConnectionStatus.disconnected;

    state = state.copyWith(
      devices: devices,
      connectionStatus: status,
    );
  }

  void onDeviceSelected(MidiDevice? device) {
    state = state.copyWith(selectedDevice: device);
  }

  Future<void> onActionButtonPressed() async {
    if (state.selectedDevice != null) {
      switch (state.connectionStatus) {
        case ConnectionStatus.loading:
        case ConnectionStatus.noDevices:
          break;
        case ConnectionStatus.disconnected:
          await _start();
          break;
        case ConnectionStatus.connected:
          _stop();
          break;
      }
    }
  }

  Future<void> _start() async {
    state = state.copyWith(connectionStatus: ConnectionStatus.loading);

    await _midiRepository.connect(state.selectedDevice!);

    state = state.copyWith(
      connectionStatus: ConnectionStatus.connected,
      expectedChord: _chordRepository.random,
      playedNotes: [],
      gameState: GameState.newGame(),
    );
  }

  void _stop() {
    state = state.copyWith(
      connectionStatus: ConnectionStatus.disconnected,
      expectedChord: null,
      playedNotes: [],
      gameState: null,
    );
  }

  Future<void> onNotePositionTapped(NotePosition note) async {
    await _onNoteReceived(note);

    // awaiting causes the note to be played since Android channel returns no result
    // _flutterMidi.playMidiNote(midi: note.pitch);
    // _flutterMidi.playNote(
    //   // key: note.pitch,
    //   key: 60,
    //   velocity: 127,
    //   sfId: soundfontId,
    // );
    _midi
        .playMidiNote(
          // midi: note.pitch,
          midi: 60,
          velocity: 127,
        )
        .then((value) => debugPrint('play: 60'));

    // The piano package provides no callback onNotePositionReleased etc.
    // also if not stopped then keeps playing a note forever
    await Future.delayed(10.milliseconds);
    // _flutterMidi.stopMidiNote(midi: note.pitch);
    // _flutterMidi.stopNote(
    //   // key: note.pitch,
    //   key: 60,
    //   sfId: soundfontId,
    //   channel: 0,
    // );
    _midi.stopMidiNote(
      // key: note.pitch,
      midi: 60,
    );
  }

  /// NEW
  void onPlay(int midi, {int velocity = 127}) {
    _midi
        .playMidiNote(midi: midi, velocity: velocity)
        .then((value) => debugPrint('play: $midi'));
  }

  void onStop({required int midi}) {
    _midi.stopMidiNote(midi: midi).then((value) => debugPrint('stop: $midi'));
  }
}
