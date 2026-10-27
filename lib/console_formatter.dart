/// Width of every line/box printed to the console.
const int kWidth = 64;

/// MIXIN: reusable console formatting (lines, headers, rows).
/// Any class can add `with ConsoleFormatter` to print clean, aligned output.
mixin ConsoleFormatter {
  /// Thin divider line.
  void divider() => print('-' * kWidth);

  /// Big title banner with centered text.
  void banner(String title) {
    print('=' * kWidth);
    print(center(title.toUpperCase()));
    print('=' * kWidth);
  }

  /// Section header, e.g.  "STEP 1: LOAD DATA".
  void section(String title) {
    print('');
    print('=' * kWidth);
    print('  $title');
    print('-' * kWidth);
  }

  /// Aligned "Label      : value" row.
  void row(String label, String value) {
    print('  ${label.padRight(14)}: $value');
  }

  /// Status messages.
  void info(String msg) => print('  [i] $msg');
  void success(String msg) => print('  [+] $msg');
  void error(String msg) => print('  [x] $msg');

  /// Centers text within [kWidth].
  String center(String text) {
    final pad = (kWidth - text.length) ~/ 2;
    return ' ' * (pad < 0 ? 0 : pad) + text;
  }
}