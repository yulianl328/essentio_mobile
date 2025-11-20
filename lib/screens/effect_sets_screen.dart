import 'package:flutter/material.dart';

import '../models/add_on_product.dart';
import '../models/subscription.dart';
import '../models/tea.dart';
import '../widgets/tea_card.dart';

const List<AddOnProduct> _addOnProducts = [
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

class TrialSet {
  final String id;
  final String name;
  final String effect;
  final Map<Tea, int> gramsByTea;

  const TrialSet({
    required this.id,
    required this.name,
    required this.effect,
    required this.gramsByTea,
  });
}

class EffectSetsScreen extends StatelessWidget {
  final SubscriptionModel subscription;

  const EffectSetsScreen({super.key, required this.subscription});

  List<TrialSet> _buildTrialSets() {
    Tea find(String id) =>
        allTeas.firstWhere((t) => t.id == id, orElse: () {
          throw Exception('Tea with id=$id not found in allTeas');
        });

    return [
      TrialSet(
        id: 'set_energy',
        name: 'Набір "Енергія" (9 чаїв)',
        effect: 'Енергія',
        gramsByTea: {
          find('da_hong_pao'): 15,
          find('shui_xian'): 15,
          find('gold_snail'): 15,
          find('dragon_well'): 15,
          find('lapsang'): 15,
          find('golden_needles'): 15,
          find('gaba_oolong'): 10,
          find('shen_pearls'): 10,
          find('qiao_qiao'): 20,
        },
      ),
      TrialSet(
        id: 'set_focus',
        name: 'Набір "Фокус" (9 чаїв)',
        effect: 'Фокус',
        gramsByTea: {
          find('gaba_oolong'): 15,
          find('sheng_rice'): 15,
          find('shen_pearls'): 15,
          find('lapsang'): 15,
          find('nuomang_sheng'): 15,
          find('white_monkey'): 10,
          find('milk_oolong'): 15,
          find('qiao_qiao'): 20,
          find('golden_needles'): 10,
        },
      ),
      TrialSet(
        id: 'set_relax',
        name: 'Набір "Релакс" (9 чаїв)',
        effect: 'Релакс',
        gramsByTea: {
          find('tgy_nongxiang'): 15,
          find('white_peony'): 15,
          find('silver_needles'): 10,
          find('lao_cha_tou'): 20,
          find('shu_mandarin'): 15,
          find('milk_oolong'): 15,
          find('oolong_aijiao'): 15,
          find('white_monkey'): 10,
          find('qiao_qiao'): 20,
        },
      ),
    ];
  }

  void _openTrialSet(BuildContext context, TrialSet set) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrialSetDetailsScreen(trialSet: set),
      ),
    );
  }

  void _openAddOnsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _AddOnProductsSheet(
        subscription: subscription,
        products: _addOnProducts,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sets = _buildTrialSets();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Набори з 9 чаїв'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sets.length,
        itemBuilder: (context, index) {
          final set = sets[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _openTrialSet(context, set),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      set.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ефект: ${set.effect}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'У наборі ${set.gramsByTea.length} чаїв з фіксованою вагою та смаком.',
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _openAddOnsSheet(context),
                        child: const Text('Придбати набір'),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Натисніть, щоб додати аксесуари перед оформленням.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TrialSetDetailsScreen extends StatelessWidget {
  final TrialSet trialSet;

  const TrialSetDetailsScreen({super.key, required this.trialSet});

  void _showTeaInfo(BuildContext context, Tea tea) {
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
                if (tea.taste != null && tea.taste!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Смак: ${tea.taste}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                if (tea.description != null && tea.description!.isNotEmpty)
                  Text(
                    tea.description!,
                    style: const TextStyle(fontSize: 14, height: 1.4),
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

  @override
  Widget build(BuildContext context) {
    final entries = trialSet.gramsByTea.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(trialSet.name),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final tea = entries[index].key;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == entries.length - 1 ? 0 : 12,
            ),
            child: TeaCard(
              tea: tea,
              selected: false,
              onTap: () => _showTeaInfo(context, tea),
              onInfo: () => _showTeaInfo(context, tea),
            ),
          );
        },
      ),
    );
  }
}

class _AddOnProductsSheet extends StatefulWidget {
  final SubscriptionModel subscription;
  final List<AddOnProduct> products;

  const _AddOnProductsSheet({
    required this.subscription,
    required this.products,
  });

  @override
  State<_AddOnProductsSheet> createState() => _AddOnProductsSheetState();
}

class _AddOnProductsSheetState extends State<_AddOnProductsSheet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
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
              const Text(
                'Додаткові товари',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Оберіть аксесуари перед оформленням набору.',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 12),
              ...widget.products.map((product) {
                final selected =
                    widget.subscription.addOns.contains(product);
                return SwitchListTile(
                  value: selected,
                  onChanged: (_) {
                    setState(() {
                      widget.subscription.toggleAddOn(product);
                    });
                  },
                  title: Text(product.name),
                  subtitle: Text('${product.description}\n${product.price} грн'),
                  isThreeLine: true,
                );
              }),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Разом аксесуари: ${widget.subscription.addOnsTotal()} грн',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Готово'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
