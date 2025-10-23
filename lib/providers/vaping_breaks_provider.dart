import 'package:flutter_riverpod/flutter_riverpod.dart';

class VapingBreaksNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void addVapeBreak() {
    state = state + 1;
  }

  int getCurrentBreaks() {
    return state;
  }
}

final vapingBreaksProvider = NotifierProvider<VapingBreaksNotifier, int>(
  VapingBreaksNotifier.new,
);