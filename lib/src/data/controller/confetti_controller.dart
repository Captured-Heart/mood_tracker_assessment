import 'package:confetti/confetti.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final confettiProvider = Provider.autoDispose.family<ConfettiController, int>((ref, secs) {
  return ConfettiController(duration: Duration(seconds: secs));
});
