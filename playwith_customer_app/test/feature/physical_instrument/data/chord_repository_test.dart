import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:playwith_customer_app/features/physical_instrument/data/chord_repository.dart';

import '../../../_mocks/mocked_random.dart';

void main() {
  group('$ChordRepository', () {
    late MockedRandom mockedRandom;
    late ChordRepository repository;

    setUp(() {
      mockedRandom = MockedRandom();
      repository = ChordRepository(mockedRandom);
    });

    group('random', () {
      test('should randomize within all of the items', () {
        mockedRandom.mockNextInt(repository.all.length - 1);

        repository.random;

        verify(() => mockedRandom.nextInt(repository.all.length)).called(1);
      });
    });
  });
}
