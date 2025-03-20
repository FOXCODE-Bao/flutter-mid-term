import 'dart:convert';

int generateUniqueId(String input) {
  final bytes = utf8.encode(input); // Convert string to bytes
  return bytes.fold(0, (sum, byte) => sum + byte); // Sum up byte values
}
