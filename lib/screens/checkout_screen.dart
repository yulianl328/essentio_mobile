import 'package:flutter/material.dart';
import '../models/subscription.dart';
import '../models/tea.dart';
import '../models/add_on_product.dart';

class CheckoutScreen extends StatelessWidget {
  final SubscriptionModel subscription;

  const CheckoutScreen({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    // Готова мапа грамування з SubscriptionModel
    final Map<Tea, int> gramsMap = subscription.calculateGramsMap();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Оформлення замовлення'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------------------------------------
            // 1. Ваші чаї
            // ----------------------------------------
            const Text(
              'Ваші чаї',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (subscription.selectedTeas.isEmpty)
              const Text('Чаї не вибрані')
            else
              Column(
                children: [
                  for (final tea in subscription.selectedTeas)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(tea.name),
                      subtitle: Text('${tea.effect} · ${tea.taste}'),
                      trailing: Text(
                        '${gramsMap[tea] ?? 0} г',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                ],
              ),

            const SizedBox(height: 24),

            // ----------------------------------------
            // 2. Супутні товари
            // ----------------------------------------
            const Text(
              'Супутні товари',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (subscription.addOns.isEmpty)
              const Text('Немає додаткових товарів')
            else
              Column(
                children: [
                  for (final AddOnProduct p in subscription.addOns)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(p.name),
                      subtitle: Text(p.description),
                      trailing: Text('${p.price} грн'),
                    ),
                ],
              ),

            const SizedBox(height: 24),

            // ----------------------------------------
            // 3. Адреса доставки (поки заглушка)
            // ----------------------------------------
            const Text(
              'Адреса доставки',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Ваша адреса',
                hintText: 'Місто, відділення Нової пошти / адреса кур’єра',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            // ----------------------------------------
            // 4. Спосіб оплати (заглушка)
            // ----------------------------------------
            const Text(
              'Спосіб оплати',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.credit_card),
              title: const Text('Оплата буде підключена пізніше'),
              subtitle: const Text('Зараз це лише попередній перегляд чека.'),
            ),

            const SizedBox(height: 24),

            // ----------------------------------------
            // 5. Бонуси
            // ----------------------------------------
            const Text(
              'Бонуси',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (subscription.hasFreeShipping)
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.local_shipping),
                title: Text('Безкоштовна доставка'),
              ),
            if (subscription.hasSampleBonus)
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.star),
                title: Text('Семпли включені до посилки'),
              ),
            if (!subscription.hasFreeShipping && !subscription.hasSampleBonus)
              const Text(
                'Бонуси не доступні для поточного бюджету.',
                style: TextStyle(fontSize: 14),
              ),

            const SizedBox(height: 24),

            // ----------------------------------------
            // 6. Підсумок суми
            // ----------------------------------------
            const Text(
              'Разом до списання',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Чай'),
              trailing: Text('${subscription.budget.toInt()} грн'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Супутні товари'),
              trailing: Text('${subscription.addOnsTotal()} грн'),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Разом'),
              trailing: Text(
                '${subscription.totalWithAddOns()} грн',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ----------------------------------------
            // 7. Кнопка підтвердження
            // ----------------------------------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Замовлення оформлено'),
                      content: const Text(
                        'Ваше замовлення буде відправлене у наступну дату підписки.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // закрити діалог
                            Navigator.pop(context); // повернутись назад з чекауту
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Підтвердити замовлення'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
