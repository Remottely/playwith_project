// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GameState {
  int get gamesCount => throw _privateConstructorUsedError;
  int get successCount => throw _privateConstructorUsedError;
  CurrentResult get currentResult => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GameStateCopyWith<GameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
  @useResult
  $Res call({int gamesCount, int successCount, CurrentResult currentResult});
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gamesCount = null,
    Object? successCount = null,
    Object? currentResult = null,
  }) {
    return _then(_value.copyWith(
      gamesCount: null == gamesCount
          ? _value.gamesCount
          : gamesCount // ignore: cast_nullable_to_non_nullable
              as int,
      successCount: null == successCount
          ? _value.successCount
          : successCount // ignore: cast_nullable_to_non_nullable
              as int,
      currentResult: null == currentResult
          ? _value.currentResult
          : currentResult // ignore: cast_nullable_to_non_nullable
              as CurrentResult,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameStateImplCopyWith<$Res>
    implements $GameStateCopyWith<$Res> {
  factory _$$GameStateImplCopyWith(
          _$GameStateImpl value, $Res Function(_$GameStateImpl) then) =
      __$$GameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int gamesCount, int successCount, CurrentResult currentResult});
}

/// @nodoc
class __$$GameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$GameStateImpl>
    implements _$$GameStateImplCopyWith<$Res> {
  __$$GameStateImplCopyWithImpl(
      _$GameStateImpl _value, $Res Function(_$GameStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gamesCount = null,
    Object? successCount = null,
    Object? currentResult = null,
  }) {
    return _then(_$GameStateImpl(
      gamesCount: null == gamesCount
          ? _value.gamesCount
          : gamesCount // ignore: cast_nullable_to_non_nullable
              as int,
      successCount: null == successCount
          ? _value.successCount
          : successCount // ignore: cast_nullable_to_non_nullable
              as int,
      currentResult: null == currentResult
          ? _value.currentResult
          : currentResult // ignore: cast_nullable_to_non_nullable
              as CurrentResult,
    ));
  }
}

/// @nodoc

class _$GameStateImpl extends _GameState {
  const _$GameStateImpl(
      {required this.gamesCount,
      required this.successCount,
      required this.currentResult})
      : super._();

  @override
  final int gamesCount;
  @override
  final int successCount;
  @override
  final CurrentResult currentResult;

  @override
  String toString() {
    return 'GameState(gamesCount: $gamesCount, successCount: $successCount, currentResult: $currentResult)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateImpl &&
            (identical(other.gamesCount, gamesCount) ||
                other.gamesCount == gamesCount) &&
            (identical(other.successCount, successCount) ||
                other.successCount == successCount) &&
            (identical(other.currentResult, currentResult) ||
                other.currentResult == currentResult));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, gamesCount, successCount, currentResult);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      __$$GameStateImplCopyWithImpl<_$GameStateImpl>(this, _$identity);
}

abstract class _GameState extends GameState {
  const factory _GameState(
      {required final int gamesCount,
      required final int successCount,
      required final CurrentResult currentResult}) = _$GameStateImpl;
  const _GameState._() : super._();

  @override
  int get gamesCount;
  @override
  int get successCount;
  @override
  CurrentResult get currentResult;
  @override
  @JsonKey(ignore: true)
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
