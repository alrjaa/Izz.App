import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة الإدارة')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              title: Text('إدارة التوثيق'),
              subtitle: Text('مراجعة طلبات توثيق الملاك والتحقق من الشرائح.'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('إدخال نتائج مباشرة'),
              subtitle: Text('تحديث المراكز والتوقيت فور انتهاء الأشواط.'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('إدارة الوسائط والرعاة'),
              subtitle: Text('اعتماد المحتوى المرفوع وتحديث البانرات.'),
            ),
          ),
        ],
      ),
    );
  }
}
