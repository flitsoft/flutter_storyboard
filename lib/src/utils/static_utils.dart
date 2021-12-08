import 'package:collection/collection.dart' show IterableExtension;

class StaticUtils {
  static String removeTrailingZero(double? n) {
    if (n == null) {
      return '';
    }
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  static T? enumFromString<T>(Iterable<T> values, String? value) {
    return values
        .firstWhereOrNull((type) => type.toString().split(".").last == value);
  }

  static String camelToSentence(String text) {
    return text.replaceAllMapped(RegExp(r'^([a-z])|[A-Z]'), (Match m) {
      var m1 = m[1];
      if (m1 == null) {
        return " ${m[0]}";
      }
      return m1.toUpperCase();
    });
  }
}
