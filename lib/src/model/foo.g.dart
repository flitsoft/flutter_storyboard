// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'foo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Foo _$FooFromJson(Map json) {
  return $checkedNew('Foo', json, () {
    final val = Foo(
      locale: $checkedConvert(json, 'locale', (v) => v as String?),
      remote: $checkedConvert(json, 'remote', (v) => v as int?),
    );
    return val;
  });
}

Map<String, dynamic> _$FooToJson(Foo instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('locale', instance.locale);
  writeNotNull('remote', instance.remote);
  return val;
}

FooWithLocal _$FooWithLocalFromJson(Map json) {
  return $checkedNew('FooWithLocal', json, () {
    final val = FooWithLocal(
      locale: $checkedConvert(json, 'locale', (v) => v as String),
      remote: $checkedConvert(json, 'remote', (v) => v as int?),
    );
    return val;
  });
}

Map<String, dynamic> _$FooWithLocalToJson(FooWithLocal instance) {
  final val = <String, dynamic>{
    'locale': instance.locale,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('remote', instance.remote);
  return val;
}

FooWithRemote _$FooWithRemoteFromJson(Map json) {
  return $checkedNew('FooWithRemote', json, () {
    final val = FooWithRemote(
      locale: $checkedConvert(json, 'locale', (v) => v as String?),
      remote: $checkedConvert(json, 'remote', (v) => v as int),
    );
    return val;
  });
}

Map<String, dynamic> _$FooWithRemoteToJson(FooWithRemote instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('locale', instance.locale);
  val['remote'] = instance.remote;
  return val;
}
