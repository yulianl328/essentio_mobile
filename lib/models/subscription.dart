import 'add_on_product.dart';
import 'tea.dart';

enum SubscriptionType {
  byTea,
  byEffect,
}

class SubscriptionModel {
  SubscriptionType? type;
  List<Tea> selectedTeas = [];
  List<AddOnProduct> addOns = [];
  String? selectedEffect;
  double budget = 800; // грн/міс

  // settings
  static const double minGramsPerTea = 20;
  static const double gramsStep = 10;
  static const double freeShippingThreshold = 1500;
  static const double sampleBonusThreshold = 1000;

  /// Add / remove tea
  bool selectTea(Tea tea) {
    if (selectedTeas.contains(tea)) {
      selectedTeas.remove(tea);
      return false;
    } else if (selectedTeas.length < 3) {
      selectedTeas.add(tea);
      return true;
    }
    return false;
  }

  /// Select effect set (3 teas)
  void selectEffect(String effect) {
    type = SubscriptionType.byEffect;
    selectedEffect = effect;
    selectedTeas = allTeas.where((t) => t.effect == effect).take(3).toList();
  }

  /// ░░░░░░░░░░░░░░░░░░░░░░░░
  ///     CALCULATE GRAMS
  /// ░░░░░░░░░░░░░░░░░░░░░░░░
  double calculateGrams(Tea tea) {
    if (selectedTeas.isEmpty) return 0;

    // бюджет на кожен чай
    double budgetPerTea = budget / selectedTeas.length;

    // якщо ціна не вказана — фіксоване мінімум
    if (tea.pricePer100g <= 0) {
      return minGramsPerTea;
    }

    // основна формула
    double grams = (budgetPerTea / tea.pricePer100g) * 100;

    // мінімум
    if (grams < minGramsPerTea) grams = minGramsPerTea;

    // округлення
    grams = (grams / gramsStep).round() * gramsStep;

    return grams;
  }

  /// Map with rounding
  Map<Tea, int> calculateGramsMap() {
    final Map<Tea, int> result = {};
    for (final tea in selectedTeas) {
      result[tea] = calculateGrams(tea).toInt();
    }
    return result;
  }

  int totalGrams({Map<Tea, int>? map}) {
    final gramsMap = map ?? calculateGramsMap();
    if (gramsMap.isEmpty) return 0;
    return gramsMap.values.fold(0, (sum, g) => sum + g);
  }

  /// ░░░░░ TOTALS & BONUSES ░░░░░

  double get _totalWithAddOns => budget + addOnsTotal();

  bool get hasFreeShipping => _totalWithAddOns >= freeShippingThreshold;

  bool get hasSampleBonus => _totalWithAddOns >= sampleBonusThreshold;

  int addOnsTotal() {
    return addOns.fold(0, (sum, item) => sum + item.price);
  }

  int totalWithAddOns() {
    return _totalWithAddOns.toInt();
  }

  void toggleAddOn(AddOnProduct product) {
    if (addOns.contains(product)) {
      addOns.remove(product);
    } else {
      addOns.add(product);
    }
  }

  /// Bonus teas based on effect
  List<Tea> bonusSamples() {
    if (!hasSampleBonus || selectedTeas.isEmpty) return [];

    final String effect = selectedEffect ?? selectedTeas.first.effect;

    return allTeas
        .where((t) => t.effect == effect && !selectedTeas.contains(t))
        .take(2)
        .toList();
  }
}
