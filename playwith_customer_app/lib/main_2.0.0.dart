import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi_pro/flutter_midi_pro.dart';
import 'package:flutter_piano_pro/flutter_piano_pro.dart';
import 'package:flutter_piano_pro/note_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(primarySwatch: Colors.orange),
        home: const MainPage(),
      );
}

const _piano = 'YDP-GrandPiano-20160804.sf2';
const _midiFontAssetPath = 'assets/soundfonts/$_piano';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _midi = MidiPro();
  final instrumentIndex = ValueNotifier<int>(0);
  final volume = ValueNotifier<int>(127);
  Future loadSoundfont() async {
    await _midi.loadSoundfont(
        sf2Path: _midiFontAssetPath, instrumentIndex: instrumentIndex.value);
  }

  Future loadInstrument() async {
    await _midi.loadInstrument(instrumentIndex: instrumentIndex.value);
  }

  Map<int, NoteModel> pointerAndNote = {};

  void play(int midi, {int velocity = 127}) {
    _midi
        .playMidiNote(midi: midi, velocity: velocity)
        .then((value) => debugPrint('play: $midi'));
  }

  void stop({required int midi}) {
    _midi.stopMidiNote(midi: midi).then((value) => debugPrint('stop: $midi'));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _midi.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Midi Pro Example'),
      ),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ValueListenableBuilder(
              valueListenable: instrumentIndex,
              builder: (context, channelValue, child) {
                return DropdownButton<int>(
                    value: channelValue,
                    items: [
                      for (int i = 0; i < 128; i++)
                        DropdownMenuItem<int>(
                          value: i,
                          child: Text('Instrument $i'),
                        )
                    ],
                    onChanged: (int? value) {
                      if (value != null) {
                        instrumentIndex.value = value;
                      }
                    });
              }),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                loadSoundfont();
              },
              child: const Text(
                'Load Soundfont file\nMust be called before other methods',
                textAlign: TextAlign.center,
              )),
          const SizedBox(
            height: 10,
          ),
          ValueListenableBuilder(
              valueListenable: instrumentIndex,
              builder: (context, instrumentIndexValue, child) {
                return ElevatedButton(
                    onPressed: () {
                      loadInstrument();
                    },
                    child: Text('Load Instrument $instrumentIndexValue'));
              }),
          Padding(
              padding: const EdgeInsets.all(18),
              child: ValueListenableBuilder(
                  valueListenable: volume,
                  child: const Text('Volume: '),
                  builder: (context, value, child) {
                    return Row(
                      children: [
                        child!,
                        Expanded(
                            child: Slider(
                          value: value.toDouble(),
                          min: 0,
                          max: 127,
                          onChanged: (value) {
                            volume.value = value.toInt();
                          },
                        )),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('${volume.value}'),
                      ],
                    );
                  })),
          PianoPro(
            noteCount: 15,
            onTapDown: (NoteModel? note, int tapId) {
              if (note == null) return;
              play(note.midiNoteNumber, velocity: volume.value);
              setState(() => pointerAndNote[tapId] = note);
              debugPrint(
                  'DOWN: note= ${note.name + note.octave.toString() + (note.isFlat ? "♭" : '')}, tapId= $tapId');
            },
            onTapUpdate: (NoteModel? note, int tapId) {
              if (note == null) return;
              if (pointerAndNote[tapId] == note) return;
              stop(midi: pointerAndNote[tapId]!.midiNoteNumber);
              play(note.midiNoteNumber, velocity: volume.value);
              setState(() => pointerAndNote[tapId] = note);
              debugPrint(
                  'UPDATE: note= ${note.name + note.octave.toString() + (note.isFlat ? "♭" : '')}, tapId= $tapId');
            },
            onTapUp: (int tapId) {
              stop(midi: pointerAndNote[tapId]!.midiNoteNumber);
              setState(() => pointerAndNote.remove(tapId));
              debugPrint('UP: tapId= $tapId');
            },
          )
        ],
      )),
    );
  }
}
