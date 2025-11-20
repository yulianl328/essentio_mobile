import 'package:flutter/material.dart';

import '../models/subscription.dart';
import '../models/tea.dart';
import '../models/add_on_product.dart';
import 'checkout_screen.dart';

class BudgetScreen extends StatefulWidget {
  final SubscriptionModel subscription;

  const BudgetScreen({
    super.key,
    required this.subscription,
  });

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late double _currentBudget;

  // Локальний список супутніх товарів (поки що статичний)
  final List<AddOnProduct> _availableAddOns = const [
    AddOnProduct(
      id: 'infuser',
      name: 'Еко-ситечко для чаю',
      description: 'Металеве багаторазове ситечко для заварювання.',
      price: 199,
      recommended: true,
    ),
    AddOnProduct(
      id: 'cup',
      name: 'Керамічна чашка',
      description: 'Мінімалістична чашка для вашого чайного ритуалу.',
      price: 349,
      recommended: false,
    ),
    AddOnProduct(
      id: 'honey',
      name: 'Натуральний мед',
      description: 'Невелика баночка меду до чаю (органічний).',
      price: 179,
      recommended: false,
    ),
  ];

  SubscriptionModel get subscription => widget.subscription;

  @override
  void initState() {
    super.initState();
    _currentBudget = subscription.budget;
  }

  void _onBudgetChanged(double value) {
    setState(() {
      _currentBudget = value;
      subscription.budget = value;
    });
  }

  void _toggleAddOn(AddOnProduct product) {
    setState(() {
      subscription.toggleAddOn(product);
    });
  }

  void _goToCheckout() {
    if (subscription.selectedTeas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Спочатку оберіть хоча б один чай')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutScreen(subscription: subscription),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gramsMap = subscription.calculateGramsMap();
    final totalGrams = subscription.totalGrams(map: gramsMap);

    final teaSum = subscription.budget.toInt();
    final addOnsSum = subscription.addOnsTotal();
    final total = subscription.totalWithAddOns();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Налаштування підписки'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context)
                  .colorScheme
                  .surfaceVariant
                  .withOpacity(0.4),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildBudgetCard(),
                const SizedBox(height: 16),
                _buildTeasCard(gramsMap, totalGrams),
                const SizedBox(height: 16),
                _buildAddOnsCard(addOnsSum),
                const SizedBox(height: 16),
                _buildBonusesCard(),
                const SizedBox(height: 16),
                _buildSummaryCard(teaSum, addOnsSum, total),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _goToCheckout,
                    child: const Text('Перейти до оформлення'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //       БЛОК: БЮДЖЕТ
  // ─────────────────────────────────────────────────────────

  Widget _buildBudgetCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Місячний бюджет на чай',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              '${_currentBudget.toInt()} грн',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Slider(
              value: _currentBudget,
              min: 400,
              max: 2000,
              divisions: 32,
              label: '${_currentBudget.toInt()} грн',
              onChanged: _onBudgetChanged,
            ),
            const SizedBox(height: 4),
            const Text(
              'Рекомендовано 600–900 грн на місяць для комфортної дегустації.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //       БЛОК: ВАШІ ЧАЇ
  // ─────────────────────────────────────────────────────────

  Widget _buildTeasCard(Map<Tea, int> gramsMap, int totalGrams) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ваші чаї',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            const Text(
              'Натисніть на рядок чаю, щоб переглянути опис і деталі.',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            if (subscription.selectedTeas.isEmpty)
              const Text(
                'Чаї ще не вибрані. Поверніться назад і оберіть 1–3 сорти.',
                style: TextStyle(fontSize: 13),
              )
            else
              Column(
                children: [
                  for (final tea in subscription.selectedTeas)
                    _buildTeaRow(tea, gramsMap[tea] ?? 0),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Разом грамів',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text('$totalGrams г'),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeaRow(Tea tea, int grams) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _showTeaDetails(tea, grams),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tea.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${tea.effect} · ${tea.taste ?? ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Натисніть, щоб переглянути опис',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$grams г',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.info_outline,
              size: 18,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }

  void _showTeaDetails(Tea tea, int grams) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  tea.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${tea.type} · ${tea.effect}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 12),
                if (tea.description != null && tea.description!.isNotEmpty)
                  Text(
                    tea.description!,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                const SizedBox(height: 12),
                Text(
                  'Приблизне грамування у цій підписці: $grams г',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Закрити'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────
  //       БЛОК: СУПУТНІ ТОВАРИ
  // ─────────────────────────────────────────────────────────

  Widget _buildAddOnsCard(int addOnsSum) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Додати до наступної посилки',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            const Text(
              'Супутні товари не входять у чайний бюджет, але впливають на бонуси.',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            Column(
              children: _availableAddOns.map((p) {
                final selected = subscription.addOns.contains(p);
                return SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: selected,
                  onChanged: (_) => _toggleAddOn(p),
                  title: Text(p.name),
                  subtitle: Text('${p.description}\n${p.price} грн'),
                  isThreeLine: true,
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Сума супутніх товарів: $addOnsSum грн',
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //       БЛОК: БОНУСИ
  // ─────────────────────────────────────────────────────────

  Widget _buildBonusesCard() {
    final hasShip = subscription.hasFreeShipping;
    final hasSamples = subscription.hasSampleBonus;
    final samples = subscription.bonusSamples();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ваші бонуси',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            if (!hasShip && !hasSamples)
              const Text(
                'Бонуси стануть доступними при більшому загальному бюджеті (чай + супутні товари).',
                style: TextStyle(fontSize: 13),
              ),
            if (hasShip)
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.local_shipping),
                title: Text('Безкоштовна доставка'),
                subtitle: Text('Доступно завдяки загальній сумі підписки.'),
              ),
            if (hasSamples)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.star),
                title: const Text('Семпли до посилки'),
                subtitle: samples.isEmpty
                    ? const Text('Ми підберемо семпли до вашого ефекту.')
                    : Text(
                        'Можливі семпли: ${samples.map((t) => t.name).join(', ')}',
                      ),
              ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //       БЛОК: ПІДСУМОК
  // ─────────────────────────────────────────────────────────

  Widget _buildSummaryCard(int teaSum, int addOnsSum, int total) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Підсумок',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Чайна підписка'),
                Text('$teaSum грн'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Супутні товари'),
                Text('$addOnsSum грн'),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Разом до списання',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '$total грн',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Чай розрахований тільки з базового бюджету, а бонуси — з чайного бюджету + супутніх товарів.',
              style: TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
