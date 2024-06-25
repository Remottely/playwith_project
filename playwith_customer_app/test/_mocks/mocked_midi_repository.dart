import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:mocktail/mocktail.dart';
import 'package:piano/piano.dart';
import 'package:playwith_customer_app/features/physical_instrument/data/midi_repository.dart';

class MockedMidiRepository extends Mock implements MidiRepository {
  void mockMidiSetupChangeStream(Stream<String> expected) {
    when(() => midiSetupChangeStream).thenAnswer((invocation) => expected);
  }

  void mockNotesStream(Stream<NotePosition> expected) {
    when(() => notesStream).thenAnswer((invocation) => expected);
  }

  void mockedMidiDevices(List<MidiDevice> expected) {
    when(() => devices).thenAnswer((invocation) => Future.value(expected));
  }

  void mockConnect() {
    when(() => connect(any())).thenAnswer((invocation) => Future.value());
  }
}
