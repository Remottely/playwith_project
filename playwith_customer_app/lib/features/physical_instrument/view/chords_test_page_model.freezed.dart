// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chords_test_page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ChordsTestPageModel {
  List<MidiDevice> get devices => throw _privateConstructorUsedError;
  ConnectionStatus get connectionStatus => throw _privateConstructorUsedError;
  MidiDevice? get selectedDevice => throw _privateConstructorUsedError;
  Chord? get expectedChord => throw _privateConstructorUsedError;
  List<NotePosition> get playedNotes => throw _privateConstructorUsedError;
  GameState? get gameState => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChordsTestPageModelCopyWith<ChordsTestPageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChordsTestPageModelCopyWith<$Res> {
  factory $ChordsTestPageModelCopyWith(
          ChordsTestPageModel value, $Res Function(ChordsTestPageModel) then) =
      _$ChordsTestPageModelCopyWithImpl<$Res, ChordsTestPageModel>;
  @useResult
  $Res call(
      {List<MidiDevice> devices,
      ConnectionStatus connectionStatus,
      MidiDevice? selectedDevice,
      Chord? expectedChord,
      List<NotePosition> playedNotes,
      GameState? gameState});

  $ChordCopyWith<$Res>? get expectedChord;
  $GameStateCopyWith<$Res>? get gameState;
}

/// @nodoc
class _$ChordsTestPageModelCopyWithImpl<$Res, $Val extends ChordsTestPageModel>
    implements $ChordsTestPageModelCopyWith<$Res> {
  _$ChordsTestPageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? devices = null,
    Object? connectionStatus = null,
    Object? selectedDevice = freezed,
    Object? expectedChord = freezed,
    Object? playedNotes = null,
    Object? gameState = freezed,
  }) {
    return _then(_value.copyWith(
      devices: null == devices
          ? _value.devices
          : devices // ignore: cast_nullable_to_non_nullable
              as List<MidiDevice>,
      connectionStatus: null == connectionStatus
          ? _value.connectionStatus
          : connectionStatus // ignore: cast_nullable_to_non_nullable
              as ConnectionStatus,
      selectedDevice: freezed == selectedDevice
          ? _value.selectedDevice
          : selectedDevice // ignore: cast_nullable_to_non_nullable
              as MidiDevice?,
      expectedChord: freezed == expectedChord
          ? _value.expectedChord
          : expectedChord // ignore: cast_nullable_to_non_nullable
              as Chord?,
      playedNotes: null == playedNotes
          ? _value.playedNotes
          : playedNotes // ignore: cast_nullable_to_non_nullable
              as List<NotePosition>,
      gameState: freezed == gameState
          ? _value.gameState
          : gameState // ignore: cast_nullable_to_non_nullable
              as GameState?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ChordCopyWith<$Res>? get expectedChord {
    if (_value.expectedChord == null) {
      return null;
    }

    return $ChordCopyWith<$Res>(_value.expectedChord!, (value) {
      return _then(_value.copyWith(expectedChord: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $GameStateCopyWith<$Res>? get gameState {
    if (_value.gameState == null) {
      return null;
    }

    return $GameStateCopyWith<$Res>(_value.gameState!, (value) {
      return _then(_value.copyWith(gameState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChordsTestePageModelImplCopyWith<$Res>
    implements $ChordsTestPageModelCopyWith<$Res> {
  factory _$$ChordsTestePageModelImplCopyWith(_$ChordsTestePageModelImpl value,
          $Res Function(_$ChordsTestePageModelImpl) then) =
      __$$ChordsTestePageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<MidiDevice> devices,
      ConnectionStatus connectionStatus,
      MidiDevice? selectedDevice,
      Chord? expectedChord,
      List<NotePosition> playedNotes,
      GameState? gameState});

  @override
  $ChordCopyWith<$Res>? get expectedChord;
  @override
  $GameStateCopyWith<$Res>? get gameState;
}

/// @nodoc
class __$$ChordsTestePageModelImplCopyWithImpl<$Res>
    extends _$ChordsTestPageModelCopyWithImpl<$Res, _$ChordsTestePageModelImpl>
    implements _$$ChordsTestePageModelImplCopyWith<$Res> {
  __$$ChordsTestePageModelImplCopyWithImpl(_$ChordsTestePageModelImpl _value,
      $Res Function(_$ChordsTestePageModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? devices = null,
    Object? connectionStatus = null,
    Object? selectedDevice = freezed,
    Object? expectedChord = freezed,
    Object? playedNotes = null,
    Object? gameState = freezed,
  }) {
    return _then(_$ChordsTestePageModelImpl(
      devices: null == devices
          ? _value._devices
          : devices // ignore: cast_nullable_to_non_nullable
              as List<MidiDevice>,
      connectionStatus: null == connectionStatus
          ? _value.connectionStatus
          : connectionStatus // ignore: cast_nullable_to_non_nullable
              as ConnectionStatus,
      selectedDevice: freezed == selectedDevice
          ? _value.selectedDevice
          : selectedDevice // ignore: cast_nullable_to_non_nullable
              as MidiDevice?,
      expectedChord: freezed == expectedChord
          ? _value.expectedChord
          : expectedChord // ignore: cast_nullable_to_non_nullable
              as Chord?,
      playedNotes: null == playedNotes
          ? _value._playedNotes
          : playedNotes // ignore: cast_nullable_to_non_nullable
              as List<NotePosition>,
      gameState: freezed == gameState
          ? _value.gameState
          : gameState // ignore: cast_nullable_to_non_nullable
              as GameState?,
    ));
  }
}

/// @nodoc

class _$ChordsTestePageModelImpl implements _ChordsTestePageModel {
  const _$ChordsTestePageModelImpl(
      {required final List<MidiDevice> devices,
      required this.connectionStatus,
      required this.selectedDevice,
      required this.expectedChord,
      required final List<NotePosition> playedNotes,
      required this.gameState})
      : _devices = devices,
        _playedNotes = playedNotes;

  final List<MidiDevice> _devices;
  @override
  List<MidiDevice> get devices {
    if (_devices is EqualUnmodifiableListView) return _devices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_devices);
  }

  @override
  final ConnectionStatus connectionStatus;
  @override
  final MidiDevice? selectedDevice;
  @override
  final Chord? expectedChord;
  final List<NotePosition> _playedNotes;
  @override
  List<NotePosition> get playedNotes {
    if (_playedNotes is EqualUnmodifiableListView) return _playedNotes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playedNotes);
  }

  @override
  final GameState? gameState;

  @override
  String toString() {
    return 'ChordsTestPageModel(devices: $devices, connectionStatus: $connectionStatus, selectedDevice: $selectedDevice, expectedChord: $expectedChord, playedNotes: $playedNotes, gameState: $gameState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChordsTestePageModelImpl &&
            const DeepCollectionEquality().equals(other._devices, _devices) &&
            (identical(other.connectionStatus, connectionStatus) ||
                other.connectionStatus == connectionStatus) &&
            (identical(other.selectedDevice, selectedDevice) ||
                other.selectedDevice == selectedDevice) &&
            (identical(other.expectedChord, expectedChord) ||
                other.expectedChord == expectedChord) &&
            const DeepCollectionEquality()
                .equals(other._playedNotes, _playedNotes) &&
            (identical(other.gameState, gameState) ||
                other.gameState == gameState));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_devices),
      connectionStatus,
      selectedDevice,
      expectedChord,
      const DeepCollectionEquality().hash(_playedNotes),
      gameState);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChordsTestePageModelImplCopyWith<_$ChordsTestePageModelImpl>
      get copyWith =>
          __$$ChordsTestePageModelImplCopyWithImpl<_$ChordsTestePageModelImpl>(
              this, _$identity);
}

abstract class _ChordsTestePageModel implements ChordsTestPageModel {
  const factory _ChordsTestePageModel(
      {required final List<MidiDevice> devices,
      required final ConnectionStatus connectionStatus,
      required final MidiDevice? selectedDevice,
      required final Chord? expectedChord,
      required final List<NotePosition> playedNotes,
      required final GameState? gameState}) = _$ChordsTestePageModelImpl;

  @override
  List<MidiDevice> get devices;
  @override
  ConnectionStatus get connectionStatus;
  @override
  MidiDevice? get selectedDevice;
  @override
  Chord? get expectedChord;
  @override
  List<NotePosition> get playedNotes;
  @override
  GameState? get gameState;
  @override
  @JsonKey(ignore: true)
  _$$ChordsTestePageModelImplCopyWith<_$ChordsTestePageModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
