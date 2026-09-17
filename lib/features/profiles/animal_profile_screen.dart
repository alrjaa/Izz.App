import 'package:flutter/material.dart';

class AnimalProfileCard extends StatelessWidget {
  const AnimalProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: ListTile(
        title: Text('بطاقة الذلول: النوادر'),
        subtitle: Text(
          'شريحة: MC-77441 • السلالة: الأب شاهين / الأم لمياء\n'
          'إنجازات: المركز الأول - شوط الفردي جل',
        ),
      ),
    );
  }
}
