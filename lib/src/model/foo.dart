import 'package:json_annotation/json_annotation.dart';

part 'foo.g.dart';

abstract class SerializableProtocol {
  Map<String, dynamic> toJson();
}

@JsonSerializable()
class Foo implements SerializableProtocol {
  Foo? castFrom<T extends SerializableProtocol>(T map) {
    try {
      return Foo.fromJson(map.toJson());
    } catch (e) {
      print(e);
      return null;
    }
  }

  @JsonKey()
  String? locale;
  @JsonKey()
  int? remote;

  Foo({
    this.locale,
    this.remote,
  });

  Foo fromJson(Map<String, dynamic> json) {
    return Foo.fromJson(json);
  }

  factory Foo.fromJson(Map<String, dynamic> json) => _$FooFromJson(json);

  Map<String, dynamic> toJson() => _$FooToJson(this);
}

@JsonSerializable()
class FooWithLocal implements SerializableProtocol {
  static FooWithLocal? castFrom<T extends SerializableProtocol>(T map) {
    try {
      return FooWithLocal.fromJson(map.toJson());
    } catch (e) {
      print(e);
      return null;
    }
  }

  @JsonKey()
  String locale;
  @JsonKey()
  int? remote;

  FooWithLocal({
    required this.locale,
    this.remote,
  });

  factory FooWithLocal.fromJson(Map<String, dynamic> json) =>
      _$FooWithLocalFromJson(json);

  Map<String, dynamic> toJson() => _$FooWithLocalToJson(this);
}

@JsonSerializable()
class FooWithRemote {
  FooWithRemote? castFrom<T extends SerializableProtocol>(T map) {
    try {
      return FooWithRemote.fromJson(map.toJson());
    } catch (e) {
      print(e);
      return null;
    }
  }

  @JsonKey()
  String? locale;
  @JsonKey()
  int remote;

  FooWithRemote({
    this.locale,
    required this.remote,
  });

  factory FooWithRemote.fromJson(Map<String, dynamic> json) =>
      _$FooWithRemoteFromJson(json);

  Map<String, dynamic> toJson() => _$FooWithRemoteToJson(this);
}

void main() {
  final map = {"locale": null, "remote": 123};
  final fooFromServer = Foo.fromJson(map);
  final fooWithLocalate = FooWithLocal.castFrom(fooFromServer);
}
