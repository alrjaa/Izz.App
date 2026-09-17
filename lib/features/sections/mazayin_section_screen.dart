import 'package:flutter/material.dart';

class MazayinSectionScreen extends StatefulWidget {
  const MazayinSectionScreen({super.key});

  @override
  State<MazayinSectionScreen> createState() => _MazayinSectionScreenState();
}

class _MazayinSectionScreenState extends State<MazayinSectionScreen> {
  String colorFilter = 'الكل';
  String participationFilter = 'الكل';

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const Key('mazayin_section'),
      padding: const EdgeInsets.all(16),
      children: [
        const Text('قسم المزاين', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('فلترة حسب الفئة اللونية ونوع المشاركة'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['الكل', 'وضح', 'مجاهيم', 'شعل', 'صفر']
              .map(
                (item) => ChoiceChip(
                  label: Text(item),
                  selected: colorFilter == item,
                  onSelected: (_) => setState(() => colorFilter = item),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['الكل', 'فرديات', 'قعدان']
              .map(
                (item) => ChoiceChip(
                  label: Text(item),
                  selected: participationFilter == item,
                  onSelected: (_) => setState(() => participationFilter = item),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            title: Text('نتيجة لجنة التحكيم - شوط الفردي جل'),
            subtitle: Text('المركز الأول: الفردية “النوادر” • نقاط: 95.5'),
          ),
        ),
      ],
    );
  }
}
