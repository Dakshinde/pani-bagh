import 'dart:async';
import 'dart:math';

class MockService {
  // This simulates the sensor sending a percentage every 2 seconds
  Stream<double> get waterLevelStream async* {
    double mockLevel = 70.0; // Start at 70%
    while (true) {
      await Future.delayed(const Duration(seconds: 2));
      // Simulate usage: drop level slightly, or reset if empty
      mockLevel -= (Random().nextDouble() * 2); 
      if (mockLevel <= 0) mockLevel = 100; 
      yield mockLevel;
    }
  }
}