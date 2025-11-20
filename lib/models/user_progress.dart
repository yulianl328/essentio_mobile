import 'package:flutter/foundation.dart';

class UserProgress extends ChangeNotifier {
  int level = 1;
  int xp = 0;

  void addXp(int amount) {
    xp += amount;
    while (xp >= xpToNextLevel()) {
      xp -= xpToNextLevel();
      level++;
    }
    notifyListeners();
  }

  int xpToNextLevel() => 100 + (level - 1) * 50;
}

final UserProgress userProgress = UserProgress();
