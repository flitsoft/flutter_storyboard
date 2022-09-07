// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'graph_data_container.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GraphDataContainer _$GraphDataContainerFromJson(Map<String, dynamic> json) {
  return _GraphDataContainer.fromJson(json);
}

/// @nodoc
class _$GraphDataContainerTearOff {
  const _$GraphDataContainerTearOff();

  _GraphDataContainer call(
      {@JsonKey() required String id,
      @JsonKey() required String branchName,
      @JsonKey() required String updatedAt,
      @JsonKey() required GraphDataStore data}) {
    return _GraphDataContainer(
      id: id,
      branchName: branchName,
      updatedAt: updatedAt,
      data: data,
    );
  }

  GraphDataContainer fromJson(Map<String, Object> json) {
    return GraphDataContainer.fromJson(json);
  }
}

/// @nodoc
const $GraphDataContainer = _$GraphDataContainerTearOff();

/// @nodoc
mixin _$GraphDataContainer {
  @JsonKey()
  String get id => throw _privateConstructorUsedError;
  @JsonKey()
  String get branchName => throw _privateConstructorUsedError;
  @JsonKey()
  String get updatedAt => throw _privateConstructorUsedError;
  @JsonKey()
  GraphDataStore get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GraphDataContainerCopyWith<GraphDataContainer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GraphDataContainerCopyWith<$Res> {
  factory $GraphDataContainerCopyWith(
          GraphDataContainer value, $Res Function(GraphDataContainer) then) =
      _$GraphDataContainerCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey() String id,
      @JsonKey() String branchName,
      @JsonKey() String updatedAt,
      @JsonKey() GraphDataStore data});
}

/// @nodoc
class _$GraphDataContainerCopyWithImpl<$Res>
    implements $GraphDataContainerCopyWith<$Res> {
  _$GraphDataContainerCopyWithImpl(this._value, this._then);

  final GraphDataContainer _value;
  // ignore: unused_field
  final $Res Function(GraphDataContainer) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? branchName = freezed,
    Object? updatedAt = freezed,
    Object? data = freezed,
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
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      data: data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as GraphDataStore,
    ));
  }
}

/// @nodoc
abstract class _$GraphDataContainerCopyWith<$Res>
    implements $GraphDataContainerCopyWith<$Res> {
  factory _$GraphDataContainerCopyWith(
          _GraphDataContainer value, $Res Function(_GraphDataContainer) then) =
      __$GraphDataContainerCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey() String id,
      @JsonKey() String branchName,
      @JsonKey() String updatedAt,
      @JsonKey() GraphDataStore data});
}

/// @nodoc
class __$GraphDataContainerCopyWithImpl<$Res>
    extends _$GraphDataContainerCopyWithImpl<$Res>
    implements _$GraphDataContainerCopyWith<$Res> {
  __$GraphDataContainerCopyWithImpl(
      _GraphDataContainer _value, $Res Function(_GraphDataContainer) _then)
      : super(_value, (v) => _then(v as _GraphDataContainer));

  @override
  _GraphDataContainer get _value => super._value as _GraphDataContainer;

  @override
  $Res call({
    Object? id = freezed,
    Object? branchName = freezed,
    Object? updatedAt = freezed,
    Object? data = freezed,
  }) {
    return _then(_GraphDataContainer(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      branchName: branchName == freezed
          ? _value.branchName
          : branchName // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      data: data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as GraphDataStore,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GraphDataContainer implements _GraphDataContainer {
  const _$_GraphDataContainer(
      {@JsonKey() required this.id,
      @JsonKey() required this.branchName,
      @JsonKey() required this.updatedAt,
      @JsonKey() required this.data});

  factory _$_GraphDataContainer.fromJson(Map<String, dynamic> json) =>
      _$_$_GraphDataContainerFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String branchName;
  @override
  @JsonKey()
  final String updatedAt;
  @override
  @JsonKey()
  final GraphDataStore data;

  @override
  String toString() {
    return 'GraphDataContainer(id: $id, branchName: $branchName, updatedAt: $updatedAt, data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _GraphDataContainer &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.branchName, branchName) ||
                const DeepCollectionEquality()
                    .equals(other.branchName, branchName)) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality()
                    .equals(other.updatedAt, updatedAt)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(branchName) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      const DeepCollectionEquality().hash(data);

  @JsonKey(ignore: true)
  @override
  _$GraphDataContainerCopyWith<_GraphDataContainer> get copyWith =>
      __$GraphDataContainerCopyWithImpl<_GraphDataContainer>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_GraphDataContainerToJson(this);
  }
}

abstract class _GraphDataContainer implements GraphDataContainer {
  const factory _GraphDataContainer(
      {@JsonKey() required String id,
      @JsonKey() required String branchName,
      @JsonKey() required String updatedAt,
      @JsonKey() required GraphDataStore data}) = _$_GraphDataContainer;

  factory _GraphDataContainer.fromJson(Map<String, dynamic> json) =
      _$_GraphDataContainer.fromJson;

  @override
  @JsonKey()
  String get id => throw _privateConstructorUsedError;
  @override
  @JsonKey()
  String get branchName => throw _privateConstructorUsedError;
  @override
  @JsonKey()
  String get updatedAt => throw _privateConstructorUsedError;
  @override
  @JsonKey()
  GraphDataStore get data => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$GraphDataContainerCopyWith<_GraphDataContainer> get copyWith =>
      throw _privateConstructorUsedError;
}
