import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:flutter_piano_pro/flutter_piano_pro.dart';
import 'package:flutter_piano_pro/note_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:piano/piano.dart';
import 'package:playwith_customer_app/features/physical_instrument/view/chords_test_page_model.dart';
import 'package:playwith_customer_app/features/physical_instrument/view/chords_test_page_notifier.dart';

class ChordsTestPage extends StatelessWidget {
  const ChordsTestPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Column(
          children: [
            Expanded(child: _PianoWidget()),
            _ControlRowWidget(),
          ],
        ),
      );
}

class _ControlRowWidget extends StatelessWidget {
  const _ControlRowWidget();

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 16;
    // An ambiguous number, will cause problems on small devices
    const double sidePanelWidth = 250;

    return const Row(
      children: [
        SizedBox(width: horizontalPadding),
        SizedBox(width: sidePanelWidth, child: _GameStatusWidget()),
        Spacer(),
        _RequestedChordWidget(),
        Spacer(),
        SizedBox(
          width: sidePanelWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(child: _DeviceSelectorWidget()),
              SizedBox(width: horizontalPadding),
              _TheButtonWidget(),
            ],
          ),
        ),
        SizedBox(width: horizontalPadding),
      ],
    );
  }
}

class _RequestedChordWidget extends ConsumerWidget {
  const _RequestedChordWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(chordsTestPageNotifierProvder);

    return Text(
      model.expectedChord?.name ?? 'Ready?',
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }
}

class _PianoWidget extends ConsumerWidget {
  const _PianoWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(chordsTestPageNotifierProvder);
    final notifier = ref.watch(chordsTestPageNotifierProvder.notifier);

    return InteractivePiano(
      highlightedNotes: model.playedNotes,
      naturalColor: Colors.white,
      accidentalColor: Colors.black,
      keyWidth: 50,
      noteRange: NoteRange.forClefs([Clef.Treble]),
      onNotePositionTapped: (position) =>
          notifier.onNotePositionTapped(position),
    );
    // return PianoPro(
    //   noteCount: 15,
    //   onTapDown: (NoteModel? note, int tapId) {
    //     if (note == null) return;
    //     notifier.onPlay(note.midiNoteNumber, velocity: volume.value);
    //     setState(() => pointerAndNote[tapId] = note);
    //     debugPrint(
    //         'DOWN: note= ${note.name + note.octave.toString() + (note.isFlat ? "♭" : '')}, tapId= $tapId');
    //   },
    //   onTapUpdate: (NoteModel? note, int tapId) {
    //     if (note == null) return;
    //     if (pointerAndNote[tapId] == note) return;
    //     notifier.onStop(midi: pointerAndNote[tapId]!.midiNoteNumber);
    //     notifier.onPlay(note.midiNoteNumber, velocity: volume.value);
    //     setState(() => pointerAndNote[tapId] = note);
    //     debugPrint(
    //         'UPDATE: note= ${note.name + note.octave.toString() + (note.isFlat ? "♭" : '')}, tapId= $tapId');
    //   },
    //   onTapUp: (int tapId) {
    //     notifier.onStop(midi: pointerAndNote[tapId]!.midiNoteNumber);
    //     setState(() => pointerAndNote.remove(tapId));
    //     debugPrint('UP: tapId= $tapId');
    //   },
    // );
  }
}

class _GameStatusWidget extends ConsumerWidget {
  const _GameStatusWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(chordsTestPageNotifierProvder);

    String text;
    Color color;
    switch (model.connectionStatus) {
      case ConnectionStatus.connected:
        final gameState = model.gameState!;
        final successRate = gameState.successRate.toStringAsFixed(2);

        text =
            '${gameState.successCount} / ${gameState.gamesCount} ($successRate%)';
        color = Colors.green;
        break;
      case ConnectionStatus.disconnected:
        text = 'Select device and start';
        color = Colors.red;
        break;
      case ConnectionStatus.loading:
        text = 'Connecting...';
        color = Colors.grey;
        break;
      case ConnectionStatus.noDevices:
        text = 'No devices';
        color = Colors.grey;
        break;
    }

    return Row(
      children: [
        Icon(Icons.circle, color: color),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}

class _TheButtonWidget extends ConsumerWidget {
  const _TheButtonWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(chordsTestPageNotifierProvder.notifier);
    final model = ref.watch(chordsTestPageNotifierProvder);

    String text;
    switch (model.connectionStatus) {
      case ConnectionStatus.connected:
        text = 'Stop';
        break;
      case ConnectionStatus.disconnected:
        text = 'Start';
        break;
      case ConnectionStatus.loading:
        text = '...';
        break;
      case ConnectionStatus.noDevices:
        text = 'Ups';
        break;
    }

    return ElevatedButton(
      child: Text(text),
      onPressed: () => notifier.onActionButtonPressed(),
    );
  }
}

class _DeviceSelectorWidget extends ConsumerWidget {
  const _DeviceSelectorWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(chordsTestPageNotifierProvder.notifier);
    final model = ref.watch(chordsTestPageNotifierProvder);

    return DropdownButton<MidiDevice?>(
      value: model.selectedDevice,
      isExpanded: true,
      items: model.devices.map(
        (device) {
          // The MidiConmmand library does not return the named assigned to
          // a virtual device. Ideally fix the package instead.
          final name = device.name == 'FlutterMidiCommand'
              ? 'Virtual piano'
              : device.name;

          return DropdownMenuItem<MidiDevice?>(
            value: device,
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ).toList(),
      onChanged: model.connectionStatus != ConnectionStatus.connected ||
              model.connectionStatus != ConnectionStatus.loading
          ? (device) => notifier.onDeviceSelected(device)
          : null,
    );
  }
}
