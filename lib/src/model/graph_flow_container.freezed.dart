// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'graph_flow_container.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GraphFlowContainer _$GraphFlowContainerFromJson(Map<String, dynamic> json) {
  return _GraphFlowContainer.fromJson(json);
}

/// @nodoc
class _$GraphFlowContainerTearOff {
  const _$GraphFlowContainerTearOff();

  _GraphFlowContainer call(
      {@JsonKey() required String id,
      @JsonKey() required String branchName,
      @JsonKey() required Map<String, dynamic> storyboardFlows,
      @JsonKey() required String updatedAt}) {
    return _GraphFlowContainer(
      id: id,
      branchName: branchName,
      storyboardFlows: storyboardFlows,
      updatedAt: updatedAt,
    );
  }

  GraphFlowContainer fromJson(Map<String, Object> json) {
    return GraphFlowContainer.fromJson(json);
  }
}

/// @nodoc
const $GraphFlowContainer = _$GraphFlowContainerTearOff();

/// @nodoc
mixin _$GraphFlowContainer {
  @JsonKey()
  String get id => throw _privateConstructorUsedError;
  @JsonKey()
  String get branchName => throw _privateConstructorUsedError;
  @JsonKey()
  Map<String, dynamic> get storyboardFlows =>
      throw _privateConstructorUsedError;
  @JsonKey()
  String get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GraphFlowContainerCopyWith<GraphFlowContainer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GraphFlowContainerCopyWith<$Res> {
  factory $GraphFlowContainerCopyWith(
          GraphFlowContainer value, $Res Function(GraphFlowContainer) then) =
      _$GraphFlowContainerCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey() String id,
      @JsonKey() String branchName,
      @JsonKey() Map<String, dynamic> storyboardFlows,
      @JsonKey() String updatedAt});
}

/// @nodoc
class _$GraphFlowContainerCopyWithImpl<$Res>
    implements $GraphFlowContainerCopyWith<$Res> {
  _$GraphFlowContainerCopyWithImpl(this._value, this._then);

  final GraphFlowContainer _value;
  // ignore: unused_field
  final $Res Function(GraphFlowContainer) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? branchName = freezed,
    Object? storyboardFlows = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      branchName: branchName == freezed
          ? _value.branchName
          : branchName // ignore: cast_nullable_to_non_nullable
              as String,
      storyboardFlows: storyboardFlows == freezed
          ? _value.storyboardFlows
          : storyboardFlows // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$GraphFlowContainerCopyWith<$Res>
    implements $GraphFlowContainerCopyWith<$Res> {
  factory _$GraphFlowContainerCopyWith(
          _GraphFlowContainer value, $Res Function(_GraphFlowContainer) then) =
      __$GraphFlowContainerCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey() String id,
      @JsonKey() String branchName,
      @JsonKey() Map<String, dynamic> storyboardFlows,
      @JsonKey() String updatedAt});
}

/// @nodoc
class __$GraphFlowContainerCopyWithImpl<$Res>
    extends _$GraphFlowContainerCopyWithImpl<$Res>
    implements _$GraphFlowContainerCopyWith<$Res> {
  __$GraphFlowContainerCopyWithImpl(
      _GraphFlowContainer _value, $Res Function(_GraphFlowContainer) _then)
      : super(_value, (v) => _then(v as _GraphFlowContainer));

  @override
  _GraphFlowContainer get _value => super._value as _GraphFlowContainer;

  @override
  $Res call({
    Object? id = freezed,
    Object? branchName = freezed,
    Object? storyboardFlows = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_GraphFlowContainer(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      branchName: branchName == freezed
          ? _value.branchName
          : branchName // ignore: cast_nullable_to_non_nullable
              as String,
      storyboardFlows: storyboardFlows == freezed
          ? _value.storyboardFlows
          : storyboardFlows // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GraphFlowContainer implements _GraphFlowContainer {
  const _$_GraphFlowContainer(
      {@JsonKey() required this.id,
      @JsonKey() required this.branchName,
      @JsonKey() required this.storyboardFlows,
      @JsonKey() required this.updatedAt});

  factory _$_GraphFlowContainer.fromJson(Map<String, dynamic> json) =>
      _$_$_GraphFlowContainerFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String branchName;
  @override
  @JsonKey()
  final Map<String, dynamic> storyboardFlows;
  @override
  @JsonKey()
  final String updatedAt;

  @override
  String toString() {
    return 'GraphFlowContainer(id: $id, branchName: $branchName, storyboardFlows: $storyboardFlows, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _GraphFlowContainer &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.branchName, branchName) ||
                const DeepCollectionEquality()
                    .equals(other.branchName, branchName)) &&
            (identical(other.storyboardFlows, storyboardFlows) ||
                const DeepCollectionEquality()
                    .equals(other.storyboardFlows, storyboardFlows)) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality()
                    .equals(other.updatedAt, updatedAt)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(branchName) ^
      const DeepCollectionEquality().hash(storyboardFlows) ^
      const DeepCollectionEquality().hash(updatedAt);

  @JsonKey(ignore: true)
  @override
  _$GraphFlowContainerCopyWith<_GraphFlowContainer> get copyWith =>
      __$GraphFlowContainerCopyWithImpl<_GraphFlowContainer>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_GraphFlowContainerToJson(this);
  }
}

abstract class _GraphFlowContainer implements GraphFlowContainer {
  const factory _GraphFlowContainer(
      {@JsonKey() required String id,
      @JsonKey() required String branchName,
      @JsonKey() required Map<String, dynamic> storyboardFlows,
      @JsonKey() required String updatedAt}) = _$_GraphFlowContainer;

  factory _GraphFlowContainer.fromJson(Map<String, dynamic> json) =
      _$_GraphFlowContainer.fromJson;

  @override
  @JsonKey()
  String get id => throw _privateConstructorUsedError;
  @override
  @JsonKey()
  String get branchName => throw _privateConstructorUsedError;
  @override
  @JsonKey()
  Map<String, dynamic> get storyboardFlows =>
      throw _privateConstructorUsedError;
  @override
  @JsonKey()
  String get updatedAt => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$GraphFlowContainerCopyWith<_GraphFlowContainer> get copyWith =>
      throw _privateConstructorUsedError;
}
