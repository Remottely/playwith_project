// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chord.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Chord {
  String get name => throw _privateConstructorUsedError;
  List<NotePosition> get notes => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChordCopyWith<Chord> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChordCopyWith<$Res> {
  factory $ChordCopyWith(Chord value, $Res Function(Chord) then) =
      _$ChordCopyWithImpl<$Res, Chord>;
  @useResult
  $Res call({String name, List<NotePosition> notes});
}

/// @nodoc
class _$ChordCopyWithImpl<$Res, $Val extends Chord>
    implements $ChordCopyWith<$Res> {
  _$ChordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? notes = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<NotePosition>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChordsImplCopyWith<$Res> implements $ChordCopyWith<$Res> {
  factory _$$ChordsImplCopyWith(
          _$ChordsImpl value, $Res Function(_$ChordsImpl) then) =
      __$$ChordsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, List<NotePosition> notes});
}

/// @nodoc
class __$$ChordsImplCopyWithImpl<$Res>
    extends _$ChordCopyWithImpl<$Res, _$ChordsImpl>
    implements _$$ChordsImplCopyWith<$Res> {
  __$$ChordsImplCopyWithImpl(
      _$ChordsImpl _value, $Res Function(_$ChordsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? notes = null,
  }) {
    return _then(_$ChordsImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value._notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<NotePosition>,
    ));
  }
}

/// @nodoc

class _$ChordsImpl implements _Chords {
  const _$ChordsImpl(
      {required this.name, required final List<NotePosition> notes})
      : _notes = notes;

  @override
  final String name;
  final List<NotePosition> _notes;
  @override
  List<NotePosition> get notes {
    if (_notes is EqualUnmodifiableListView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notes);
  }

  @override
  String toString() {
    return 'Chord(name: $name, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChordsImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._notes, _notes));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, name, const DeepCollectionEquality().hash(_notes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChordsImplCopyWith<_$ChordsImpl> get copyWith =>
      __$$ChordsImplCopyWithImpl<_$ChordsImpl>(this, _$identity);
}

abstract class _Chords implements Chord {
  const factory _Chords(
      {required final String name,
      required final List<NotePosition> notes}) = _$ChordsImpl;

  @override
  String get name;
  @override
  List<NotePosition> get notes;
  @override
  @JsonKey(ignore: true)
  _$$ChordsImplCopyWith<_$ChordsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
