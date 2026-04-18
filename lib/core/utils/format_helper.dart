import 'package:flutter/services.dart';

class TaxCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll('-', '');

    if (!RegExp(r'^\d*$').hasMatch(text)) {
      return oldValue;
    }

    if (text.length <= 10) {
      return newValue.copyWith(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }

    if (text.length <= 13) {
      String formatted = '${text.substring(0, 10)}-${text.substring(10)}';

      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    return oldValue;
  }
}
