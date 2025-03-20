void logError(String message) {
  print("\x1B[31m[ERROR] $message\x1B[0m");
}

void logSuccess(String message) {
  print("\x1B[32m[SUCCESS] $message\x1B[0m");
}

void logWarning(String message) {
  print("\x1B[33m[WARNING] $message\x1B[0m");
}