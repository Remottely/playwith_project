import 'package:flutter/material.dart';

import 'main_canvas_animated.dart';

const highlightColor = Colors.orange;
final highlightShadowColor = Colors.black.withOpacity(0.5);

List<String> notes = [
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
  'B',
];

Set<String> sizeX = {'C', 'E', 'F', 'B'};
Set<String> sizeY = {'D', 'G', 'A'};
// Set<String> sizeZ = {'C#', 'D#', 'F#', 'G#', 'A#'};

class CanvasView extends StatelessWidget {
  final int? midiNoteNumber;
  final int noteCount;
  final int firstOctave;

  const CanvasView({
    super.key,
    required this.midiNoteNumber,
    this.noteCount = 12,
    this.firstOctave = 4,
  });

  @override
  Widget build(BuildContext context) {
    double canvasHeight = MediaQuery.of(context).size.height * 0.7;

    // Total number of notes in an octave (natural + accidental)
    const int totalNotesInOctave = 12;

    // Calculate the total number of notes to be displayed
    int totalNotesToShow = noteCount + (noteCount * 5 ~/ 7);

    return Padding(
      padding: EdgeInsets.zero,
      //  const EdgeInsets.only(left: 12.0, right: 26),
      child: Stack(
        children: [
          Row(
            children: List.generate(totalNotesToShow, (index) {
              int octave = (index ~/ totalNotesInOctave) + firstOctave;
              String noteName = notes[index % totalNotesInOctave];
              int noteIndex = index % totalNotesInOctave;

              // Calculate the MIDI note number
              int calculatedMidiNoteNumber = (octave + 1) * 12 + noteIndex;

              bool isAccidental = noteName.contains('#');

              bool isNoteCountPattern = getIsNoteCountPattern(noteCount);
              bool isSizeX = sizeX.contains(noteName);
              bool isSizeY = sizeY.contains(noteName);
              // bool isSizeZ = sizeZ.contains(note);
              bool isLastNote = index == totalNotesToShow - 1;

              return Flexible(
                // flex: isLastNote
                //     ? (isNoteCountPattern ? 21 : 16)
                //     : isSizeX
                //         ? 16
                //         : isSizeY
                //             ? 11
                //             : 10,
                child: Container(
                  height: canvasHeight,
                  margin: const EdgeInsets.all(0.5),
                  decoration: BoxDecoration(
                    color: calculatedMidiNoteNumber == midiNoteNumber
                        ? highlightShadowColor
                        : isAccidental
                            ? Colors.grey.shade900
                            : const Color.fromARGB(255, 45, 45, 45),
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        '$noteName$octave',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(
            height: canvasHeight,
            child: FallingNotes(noteCount: noteCount, firstOctave: firstOctave),
          ),
        ],
      ),
    );
  }
}

bool getIsNoteCountPattern(int noteCount) {
  List<int> patternList = [];
  int currentValue = 4;
  bool addThree = false;

  while (currentValue <= 128) {
    patternList.add(currentValue);
    currentValue += addThree ? 3 : 4;
    addThree = !addThree;
  }

  // false: [2, 3, 5, 6, 7, 9, 10, 12, 13, 14, 16, 17, 19, 20, 21, 23, 24, 26, 27, 28, 30, 31, ..., 128]
  // true: [4, 8, 11, 15, 18, 22, 25, 29, 32 ..., 128]
  return patternList.contains(noteCount);
}
