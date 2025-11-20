import 'package:flutter/material.dart';
import '../models/tea.dart';

class TeaCard extends StatelessWidget {
  final Tea tea;
  final bool selected;
  final VoidCallback onTap;
  final double? grams;
  final VoidCallback? onInfo;

  const TeaCard({
    super.key,
    required this.tea,
    required this.selected,
    required this.onTap,
    this.grams,
    this.onInfo,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.secondary;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                selected ? Icons.check_circle : Icons.local_cafe_outlined,
                color: selected ? accent : Colors.grey.shade700,
                size: 28,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tea.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'натисніть, щоб переглянути',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${tea.effect} - ${tea.taste}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '~${tea.pricePer100g} \u0433\u0440\u043d / 100 \u0433',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (grams != null)
                Text(
                  '${grams!.toStringAsFixed(0)} г',
                  style: const TextStyle(fontSize: 12),
                ),
              const SizedBox(width: 8),
              onInfo != null
                  ? IconButton(
                      icon: const Icon(Icons.info_outline, size: 20),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 36, minHeight: 36),
                      onPressed: onInfo,
                      splashRadius: 20,
                    )
                  : const Icon(Icons.info_outline, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
