import 'package:decimal/decimal.dart';

interceptFormat(String? content, {int length = 6}) {
  if (content == null) return '';
  if (content.length > 2 * length) {
    return content.substring(0, length) +
        "..." +
        content.substring(content.length - length, content.length);
  }
  return content;
}

extension SizeExtension on Decimal {
  String get showBalance =>
      Decimal.parse(toDouble().toStringAsFixed(8)).toString();
}
