import 'package:dart_midi_pro/dart_midi_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playwith_customer_app/canvas_view.dart';
import 'package:playwith_customer_app/midi_controller.dart';

double cut = 100000 / 20;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: FallingNotes(noteCount: 15, firstOctave: 4),
      ),
    );
  }
}

class NotesPainter extends CustomPainter {
  final List<Note> notes;
  final double keyWidth;

  NotesPainter(this.notes, this.keyWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = highlightColor;

    for (var note in notes) {
      double noteHeight = note.duration;
      double yPosition = note.y - noteHeight;
      canvas.drawRect(
        Rect.fromLTWH(
          note.x,
          yPosition,
          keyWidth,
          noteHeight,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class FallingNotes extends StatefulWidget {
  final int noteCount;
  final int firstOctave;

  const FallingNotes({
    super.key,
    required this.noteCount,
    required this.firstOctave,
  });

  @override
  State<FallingNotes> createState() => _FallingNotesState();
}

class _FallingNotesState extends State<FallingNotes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Note> _notes = [];

  late final int firstNoteNumber;
  final ValueNotifier<NoteOnEvent?> currentNoteEvent =
      ValueNotifier<NoteOnEvent?>(null);

  int totalNotesToShow = 0;

  @override
  void initState() {
    // loadSoundFont(sf2Paths[0], bankIndex.value, instrumentIndex.value);
    // loadSoundFont(sf2Paths[1], bankIndex.value, instrumentIndex.value);
    totalNotesToShow = widget.noteCount + (widget.noteCount * 5 ~/ 7);

    firstNoteNumber = (widget.firstOctave - 1) * 12 + 24; //21;

    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(() {
        setState(() {
          double beatDurationInSeconds = microsecondsPerBeat.value / 1000000.0;
          double speed = cut /
              (beatDurationInSeconds * ticksPerBeat.value); // Adjusted speed
          for (var note in _notes) {
            note.update(speed);
          }
        });
      });
    _controller.repeat();
  }

  void _addNoteEvent(NoteOnEvent onEvent, NoteOffEvent offEvent) {
    bool isNoteCountPattern = getIsNoteCountPattern(widget.noteCount);

    // bool isLastNote = index == totalNotesToShow - 1;
    final int midiNoteNumber = offEvent.noteNumber;

    final noteName = getNoteNameWithoutOctave(midiNoteNumber);
    bool isSizeX = sizeX.contains(noteName);
    bool isSizeY = sizeY.contains(noteName);

    final width = MediaQuery.of(context).size.width;
    // final keyWidth =
    //     // isLastNote ? (isNoteCountPattern ? 21 : 16) :
    //     (isSizeX
    //             ? 0.16
    //             : isSizeY
    //                 ? 0.11
    //                 : 0.10) *
    //         (width / totalNotesToShow);

    final double keyWidth = width / totalNotesToShow;

    final double x = calculateXPosition(midiNoteNumber, keyWidth);
    final int noteOnTime = onEvent.deltaTime; // 0
    final int noteOffTime = offEvent.deltaTime; // 501

    setState(() {
      _notes.add(Note(
        x: x,
        y: 0.0,
        noteOnTime: noteOnTime,
        noteOffTime: noteOffTime,
      ));
    });
  }

  double calculateXPosition(int midiNoteNumber, double keyWidth) {
    return (midiNoteNumber - firstNoteNumber) * keyWidth;
  }

  @override
  void dispose() {
    _controller.dispose();
    microsecondsPerBeat.dispose();
    ticksPerBeat.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double keyWidth = constraints.maxWidth / totalNotesToShow;
        return Stack(
          children: [
            CustomPaint(
              painter: NotesPainter(_notes, keyWidth),
              child: Container(),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: ElevatedButton(
                onPressed: () {
                  _playMidiFromAsset(midiDataAssetPath);
                },
                child: const Text('Play MIDI'),
              ),
            ),
          ],
        );
      },
    );
  }

  late NoteOnEvent lastNoteOnEvent;

  void _startCanvasMidiNotes(MidiFile midiData) async {
    for (var track in midiData.tracks) {
      for (var event in track) {
        if (event is NoteOnEvent) {
          int delay = calculateDelayInMicroseconds(
              event.deltaTime, microsecondsPerBeat.value, ticksPerBeat.value);

          lastNoteOnEvent = event;
          await Future.delayed(Duration(microseconds: delay));
        } else if (event is NoteOffEvent) {
          int delay = calculateDelayInMicroseconds(
              event.deltaTime, microsecondsPerBeat.value, ticksPerBeat.value);

          _addNoteEvent(lastNoteOnEvent, event);
          await Future.delayed(Duration(microseconds: delay));
        }
      }
    }
  }

  Future<void> _playMidiFromAsset(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final List<int> bytes = data.buffer.asUint8List();
    final MidiFile midiData = MidiParser().parseMidiFromBuffer(bytes);
    _startCanvasMidiNotes(midiData);
    await Future.delayed(const Duration(milliseconds: 350));
    playMidiNotes(midiData);
  }
}

class Note {
  final double x;
  double y;
  final int noteOnTime;
  final int noteOffTime;

  Note({
    required this.x,
    required this.y,
    required this.noteOnTime,
    required this.noteOffTime,
  });

  void update(double speedMultiplier) {
    y += speedMultiplier;
  }

  double get duration => noteOffTime / (cut / 1000);
}

String getNoteNameWithoutOctave(int midiNoteNumber) {
  const List<String> noteNames = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B'
  ];

  String note = noteNames[midiNoteNumber % 12];

  return note;
}

int calculateDelayInMicroseconds(
    int deltaTime, int microsecondsPerBeat, int ticksPerBeat) {
  return (deltaTime * microsecondsPerBeat) ~/ ticksPerBeat;
}

final ValueNotifier<int> microsecondsPerBeat =
    ValueNotifier<int>(428756); // equals 140bpm
final ValueNotifier<int> ticksPerBeat =
    ValueNotifier<int>(1024); // example value
final ValueNotifier<NoteOnEvent?> currentNoteEvent =
    ValueNotifier<NoteOnEvent?>(null);
