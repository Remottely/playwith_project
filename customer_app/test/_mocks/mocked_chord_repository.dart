import 'package:mocktail/mocktail.dart';
import 'package:playwith_customer_app/features/physical_instrument/data/chord_repository.dart';
import 'package:playwith_customer_app/features/physical_instrument/domain/chord.dart';

class MockedChordRepository extends Mock implements ChordRepository {
  void mockRnadom(Chord expected) {
    when(() => random).thenReturn(expected);
  }
}
