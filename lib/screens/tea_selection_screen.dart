import 'package:flutter/material.dart';
import '../models/subscription.dart';
import '../models/tea.dart';
import '../widgets/tea_card.dart';
import 'budget_screen.dart';
import '../models/user_progress.dart';

class TeaSelectionScreen extends StatefulWidget {
  final SubscriptionModel subscription;

  const TeaSelectionScreen({super.key, required this.subscription});

  @override
  State<TeaSelectionScreen> createState() => _TeaSelectionScreenState();
}

class _TeaSelectionScreenState extends State<TeaSelectionScreen> {
  String? effectFilter;
  String? tasteFilter;

  void _showTeaDetails(Tea tea) {
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
                  '${tea.type} • ${tea.effect}',
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
                if (tea.taste != null && tea.taste!.isNotEmpty)
                  Text(
                    'Смак: ${tea.taste}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
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

  List<Tea> get filteredTeas {
    return allTeas.where((t) {
      final effectOK = effectFilter == null || t.effect == effectFilter;
      final tasteOK = tasteFilter == null ||
          (t.taste ?? '').toLowerCase().contains(tasteFilter!.toLowerCase());
      return effectOK && tasteOK;
    }).toList();
  }

  void _next() {
    if (widget.subscription.selectedTeas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Оберіть хоча б один чай.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            BudgetScreen(subscription: widget.subscription),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Обрати чаї'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Оберіть 1–3 сорти чаю.',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                ),
                const SizedBox(height: 10),

                //
                // ФІЛЬТРИ
                //
                Text('Ефект', style: TextStyle(fontWeight: FontWeight.w600)),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Усі'),
                      selected: effectFilter == null,
                      onSelected: (_) => setState(() => effectFilter = null),
                    ),
                    ...['Енергія', 'Релакс', 'Концентрація', 'Баланс']
                        .map(
                          (e) => ChoiceChip(
                            label: Text(e),
                            selected: effectFilter == e,
                            onSelected: (_) =>
                                setState(() => effectFilter = e),
                          ),
                        )
                        ,
                  ],
                ),
                const SizedBox(height: 12),

                Text('Смак', style: TextStyle(fontWeight: FontWeight.w600)),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Усі'),
                      selected: tasteFilter == null,
                      onSelected: (_) => setState(() => tasteFilter = null),
                    ),
                    ...['квітковий', 'димний', 'фруктовий', 'зерновий', 'горіховий']
                        .map(
                          (t) => ChoiceChip(
                            label: Text(t),
                            selected: tasteFilter == t,
                            onSelected: (_) => setState(() => tasteFilter = t),
                          ),
                        )
                        ,
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          //
          // СПИСОК ЧАЇВ
          //
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredTeas.length,
              itemBuilder: (_, i) {
                final tea = filteredTeas[i];
                final selected = widget.subscription.selectedTeas.contains(tea);

                return TeaCard(
                  tea: tea,
                  selected: selected,
                  onInfo: () => _showTeaDetails(tea),
                  onTap: () {
                    setState(() {
                      final added = widget.subscription.selectTea(tea);
                      if (added) {
                        userProgress.addXp(5);
                      }
                    });
                  },
                );
              },
            ),
          ),

          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
              child: ElevatedButton(
                onPressed: _next,
                child: const Text('Перейти до бюджету'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
