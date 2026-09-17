import 'package:flutter/material.dart';

class HejinSectionScreen extends StatefulWidget {
  const HejinSectionScreen({super.key});

  @override
  State<HejinSectionScreen> createState() => _HejinSectionScreenState();
}

class _HejinSectionScreenState extends State<HejinSectionScreen> {
  String ageFilter = 'الكل';
  String distanceFilter = 'الكل';

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const Key('hejin_section'),
      padding: const EdgeInsets.all(16),
      children: [
        const Text('قسم سباقات الهجن', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['الكل', 'حقايق', 'لقايا', 'جذاع']
              .map(
                (item) => ChoiceChip(
                  label: Text(item),
                  selected: ageFilter == item,
                  onSelected: (_) => setState(() => ageFilter = item),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['الكل', '2 كم', '3 كم', '5 كم']
              .map(
                (item) => ChoiceChip(
                  label: Text(item),
                  selected: distanceFilter == item,
                  onSelected: (_) => setState(() => distanceFilter = item),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            title: Text('شوط الحقايق بكار'),
            subtitle: Text('أفضل توقيت: 4:21.210 • الميدان: المرموم'),
          ),
        ),
      ],
    );
  }
}
