import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_vape/models/break.dart';

class VapingBreaksNotifier extends Notifier<Break> {
  @override
  Break build() {
    return const Break(vapeBreaks: 0, substitutes: 0);
  }

  void addVapeBreak() {
    state = Break(vapeBreaks: state.vapeBreaks + 1, substitutes: state.substitutes);
  }

  void addSubstitute() {
    state = Break(vapeBreaks: state.vapeBreaks, substitutes: state.substitutes + 1);
  }

  Break getCurrentBreaks() {
    return state;
  }
}

final vapingBreaksProvider = NotifierProvider<VapingBreaksNotifier, Break>(
  VapingBreaksNotifier.new,
);