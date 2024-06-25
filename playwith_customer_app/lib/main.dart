import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi_pro/flutter_midi_pro.dart';
import 'package:flutter_piano_pro/flutter_piano_pro.dart';
import 'package:flutter_piano_pro/note_model.dart';
import 'package:playwith_customer_app/main_3.1.3.mid.highlight.dart';

// List<int> generatePatternList() {
//   List<int> patternList = [];
//   int currentValue = 4;
//   bool addThree = false;

//   while (currentValue <= 128) {
//     patternList.add(currentValue);
//     currentValue += addThree ? 3 : 4;
//     addThree = !addThree;
//   }

//   return patternList;
// }

// void main() {
//   List<int> predefinedList = generatePatternList();
//   List<int> inputValues = [];

//   print('Por favor, insira 128 valores de 1 a 128:');
//   for (int i = 0; i < 128; i++) {
//     int? value = int.tryParse(stdin.readLineSync()!);
//     if (value != null && value >= 1 && value <= 128) {
//       inputValues.add(value);
//     } else {
//       print('Valor inválido. Insira um número entre 1 e 128.');
//       i--; // Repetir iteração para valor inválido
//     }
//   }

//   List<int> matchingValues =
//       inputValues.where((value) => predefinedList.contains(value)).toList();

//   print('Valores correspondentes da lista:');
//   print(matchingValues);
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    // DeviceOrientation.landscapeRight,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.amber,
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          sf2Paths.length,
                          (index) => ElevatedButton(
                            onPressed: () => loadSoundFont(sf2Paths[index],
                                bankIndex.value, instrumentIndex.value),
                            child: Text('Load Soundfont ${sf2Paths[index]}'),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ValueListenableBuilder(
                      valueListenable: loadedSoundfonts,
                      builder: (context, value, child) {
                        if (value.isEmpty) {
                          return const Text('No soundfont file loaded');
                        }
                        return Column(
                          children: [
                            const Text('Loaded Soundfont files:'),
                            for (final entry in value.entries)
                              ListTile(
                                title: Text(entry.value),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ValueListenableBuilder(
                                        valueListenable: selectedSfId,
                                        builder: (context, selectedSfIdValue,
                                            child) {
                                          return ElevatedButton(
                                            onPressed:
                                                selectedSfIdValue == entry.key
                                                    ? null
                                                    : () => selectedSfId.value =
                                                        entry.key,
                                            child: Text(
                                                selectedSfIdValue == entry.key
                                                    ? 'Selected'
                                                    : 'Select'),
                                          );
                                        }),
                                    ElevatedButton(
                                      onPressed: () =>
                                          unloadSoundfont(entry.key),
                                      child: const Text('Unload'),
                                    ),
                                  ],
                                ),
                              )
                          ],
                        );
                      }),
                  ValueListenableBuilder(
                      valueListenable: selectedSfId,
                      builder: (context, selectedSfIdValue, child) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ValueListenableBuilder(
                                    valueListenable: bankIndex,
                                    builder: (context, bankIndexValue, child) {
                                      return DropdownButton<int>(
                                          value: bankIndexValue,
                                          items: [
                                            for (int i = 0; i < 128; i++)
                                              DropdownMenuItem<int>(
                                                value: i,
                                                child: Text(
                                                  'Bank $i',
                                                  style: const TextStyle(
                                                      fontSize: 13),
                                                ),
                                              )
                                          ],
                                          onChanged: (int? value) {
                                            if (value != null) {
                                              bankIndex.value = value;
                                            }
                                          });
                                    }),
                                ValueListenableBuilder(
                                    valueListenable: instrumentIndex,
                                    builder: (context, channelValue, child) {
                                      return DropdownButton<int>(
                                          value: channelValue,
                                          items: [
                                            for (int i = 0; i < 128; i++)
                                              DropdownMenuItem<int>(
                                                value: i,
                                                child: Text(
                                                  'Instrument $i',
                                                  style: const TextStyle(
                                                      fontSize: 13),
                                                ),
                                              )
                                          ],
                                          onChanged: (int? value) {
                                            if (value != null) {
                                              instrumentIndex.value = value;
                                            }
                                          });
                                    }),
                                ValueListenableBuilder(
                                    valueListenable: channelIndex,
                                    builder:
                                        (context, channelIndexValue, child) {
                                      return DropdownButton<int>(
                                          value: channelIndexValue,
                                          items: [
                                            for (int i = 0; i < 16; i++)
                                              DropdownMenuItem<int>(
                                                value: i,
                                                child: Text(
                                                  'Channel $i',
                                                  style: const TextStyle(
                                                      fontSize: 13),
                                                ),
                                              )
                                          ],
                                          onChanged: (int? value) {
                                            if (value != null) {
                                              channelIndex.value = value;
                                            }
                                          });
                                    }),
                              ],
                            ),
                            ValueListenableBuilder(
                                valueListenable: bankIndex,
                                builder: (context, bankIndexValue, child) {
                                  return ValueListenableBuilder(
                                      valueListenable: channelIndex,
                                      builder:
                                          (context, channelIndexValue, child) {
                                        return ValueListenableBuilder(
                                            valueListenable: instrumentIndex,
                                            builder: (context,
                                                instrumentIndexValue, child) {
                                              return ElevatedButton(
                                                  onPressed:
                                                      selectedSfIdValue != null
                                                          ? () =>
                                                              selectInstrument(
                                                                sfId:
                                                                    selectedSfIdValue,
                                                                program:
                                                                    instrumentIndexValue,
                                                                bank:
                                                                    bankIndexValue,
                                                                channel:
                                                                    channelIndexValue,
                                                              )
                                                          : null,
                                                  child: Text(
                                                      'Load Instrument $instrumentIndexValue on Bank $bankIndexValue to Channel $channelIndexValue'));
                                            });
                                      });
                                }),
                            Padding(
                                padding: const EdgeInsets.all(18),
                                child: ValueListenableBuilder(
                                    valueListenable: pianoVolume,
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
                                            onChanged: selectedSfIdValue != null
                                                ? (value) => pianoVolume.value =
                                                    value.toInt()
                                                : null,
                                          )),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text('${pianoVolume.value}'),
                                        ],
                                      );
                                    })),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: ElevatedButton(
                                onPressed: !(selectedSfIdValue != null)
                                    ? null
                                    : () => unloadSoundfont(
                                        loadedSoundfonts.value.keys.first),
                                child: const Text('Unload Soundfont file'),
                              ),
                            ),
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    FittedBox(
                                      child: Row(
                                        children: [
                                          const ElevatedButton(
                                            onPressed: pickAndPlayMidiFromFile,
                                            child: Text(
                                                "Pick and Play MIDI from File"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => playMidiFromAsset(
                                                midiDataAssetPath),
                                            child: const Text(
                                                "Pick and Play MIDI from path"),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ValueListenableBuilder(
                                        valueListenable: currentNoteEvent,
                                        builder: (context,
                                            currentNoteEventValue, child) {
                                          final int? currentNoteNumber =
                                              currentNoteEventValue?.noteNumber;
                                          final int currentVelocity =
                                              currentNoteEventValue?.velocity ??
                                                  pianoVolume.value;
                                          const noteCount =
                                              15; // 2, 3, 5, 6, 7, 9, 10, 12, 13, 14, 16, 17, 19, 20, 21, 23, 24, 26
                                          const firstOctave =
                                              4; // 22, 25, 29, 32
                                          final Map<int, Color>?
                                              highlightButton =
                                              currentNoteNumber == null
                                                  ? null
                                                  : {
                                                      currentNoteNumber:
                                                          Colors.red
                                                    };

                                          return Column(
                                            children: [
                                              LessonCanvas(
                                                selectedIndex:
                                                    currentNoteNumber,
                                                noteCount: noteCount,
                                                firstOctave: firstOctave,
                                              ),
                                              PianoPro(
                                                noteCount: noteCount,
                                                showOctave: true,
                                                firstOctave: firstOctave,
                                                buttonColors: highlightButton,
                                                onTapDown: (NoteModel? note,
                                                    int tapId) {
                                                  if (note == null) return;
                                                  pointerAndNote[tapId] = note;
                                                  playNote(
                                                      key: note.midiNoteNumber,
                                                      velocity: currentVelocity,
                                                      channel:
                                                          channelIndex.value,
                                                      sfId: selectedSfIdValue!);
                                                  debugPrint(
                                                      'DOWN: note= ${note.name + note.octave.toString() + (note.isFlat ? "♭" : '')}, tapId= $tapId');
                                                },
                                                onTapUpdate: (NoteModel? note,
                                                    int tapId) {
                                                  if (note == null) return;
                                                  if (pointerAndNote[tapId] ==
                                                      note) {
                                                    return;
                                                  }
                                                  stopNote(
                                                      key:
                                                          pointerAndNote[tapId]!
                                                              .midiNoteNumber,
                                                      channel:
                                                          channelIndex.value,
                                                      sfId: selectedSfIdValue!);
                                                  pointerAndNote[tapId] = note;
                                                  playNote(
                                                      channel:
                                                          channelIndex.value,
                                                      key: note.midiNoteNumber,
                                                      velocity: currentVelocity,
                                                      sfId: selectedSfIdValue);
                                                  debugPrint(
                                                      'UPDATE: note= ${note.name + note.octave.toString() + (note.isFlat ? "♭" : '')}, tapId= $tapId');
                                                },
                                                onTapUp: (int tapId) {
                                                  stopNote(
                                                      key:
                                                          pointerAndNote[tapId]!
                                                              .midiNoteNumber,
                                                      channel:
                                                          channelIndex.value,
                                                      sfId: selectedSfIdValue!);
                                                  pointerAndNote.remove(tapId);
                                                  debugPrint(
                                                      'UP: tapId= $tapId');
                                                },
                                              ),
                                            ],
                                          );
                                        }),
                                  ],
                                ),
                                if (selectedSfIdValue == null)
                                  Positioned.fill(
                                    child: Container(
                                      color: Colors.black.withOpacity(0.5),
                                      child: const Center(
                                        child: Text(
                                          'Load Soundfont file\nMust be called before other methods',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            )
                          ],
                        );
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final MidiPro midiPro = MidiPro();
final ValueNotifier<Map<int, String>> loadedSoundfonts =
    ValueNotifier<Map<int, String>>({});
final ValueNotifier<int?> selectedSfId = ValueNotifier<int?>(null);
final instrumentIndex = ValueNotifier<int>(0);
final bankIndex = ValueNotifier<int>(0);
final channelIndex = ValueNotifier<int>(0);
final pianoVolume = ValueNotifier<int>(127);
Map<int, NoteModel> pointerAndNote = {};

/// Loads a soundfont file from the specified path.
/// Returns the soundfont ID.
Future<int> loadSoundFont(String path, int bank, int program) async {
  if (loadedSoundfonts.value.containsValue(path)) {
    print('Soundfont file: $path already loaded. Returning ID.');
    return loadedSoundfonts.value.entries
        .firstWhere((element) => element.value == path)
        .key;
  }
  final int sfId =
      await midiPro.loadSoundfont(path: path, bank: bank, program: program);
  loadedSoundfonts.value = {sfId: path, ...loadedSoundfonts.value};
  print('Loaded soundfont file: $path with ID: $sfId');
  // selectedSfId.value = sfId;

  return sfId;
}

/// Selects an instrument on the specified soundfont.
Future<void> selectInstrument({
  required int sfId,
  required int program,
  int channel = 0,
  int bank = 0,
}) async {
  int? sfIdValue = sfId;
  if (!loadedSoundfonts.value.containsKey(sfId)) {
    sfIdValue = loadedSoundfonts.value.keys.first;
  } else {
    selectedSfId.value = sfId;
  }
  print('Selected soundfont file: $sfIdValue');
  await midiPro.selectInstrument(
      sfId: sfIdValue, channel: channel, bank: bank, program: program);
}

/// Plays a note on the specified channel.
Future<void> playNote({
  required int key,
  required int velocity,
  int channel = 0,
  int sfId = 1,
}) async {
  int? sfIdValue = sfId;
  if (!loadedSoundfonts.value.containsKey(sfId)) {
    sfIdValue = loadedSoundfonts.value.keys.first;
  }
  await midiPro.playNote(
      channel: channel, key: key, velocity: velocity, sfId: sfIdValue);
}

/// Stops a note on the specified channel.
Future<void> stopNote({
  required int key,
  int channel = 0,
  int sfId = 1,
}) async {
  int? sfIdValue = sfId;
  if (!loadedSoundfonts.value.containsKey(sfId)) {
    sfIdValue = loadedSoundfonts.value.keys.first;
  }
  await midiPro.stopNote(channel: channel, key: key, sfId: sfIdValue);
}

/// Unloads a soundfont file.
Future<void> unloadSoundfont(int sfId) async {
  await midiPro.unloadSoundfont(sfId);
  loadedSoundfonts.value = {
    for (final entry in loadedSoundfonts.value.entries)
      if (entry.key != sfId) entry.key: entry.value
  };
  if (selectedSfId.value == sfId) selectedSfId.value = null;
}

final sf2Paths = [
  'assets/soundfonts/YDP-GrandPiano-20160804.sf2',
  'assets/soundfonts/UprightPianoKW-small-20190703.sf2'
];
