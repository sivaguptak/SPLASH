class Env {
  // Use --dart-define=LOCASY_BFF=http://10.0.2.2:3000 for Android emulator
  static const bffBase = String.fromEnvironment('LOCASY_BFF', defaultValue: 'http://10.0.2.2:3000');
}
