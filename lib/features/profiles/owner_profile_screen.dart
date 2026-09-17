import 'package:flutter/material.dart';

import '../shell/session.dart';
import 'animal_profile_screen.dart';

class OwnerProfileScreen extends StatelessWidget {
  const OwnerProfileScreen({required this.session, super.key});

  final AppSession session;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const Key('owner_profile_screen'),
      padding: const EdgeInsets.all(16),
      children: [
        const Card(
          child: ListTile(
            leading: CircleAvatar(child: Icon(Icons.shield_outlined)),
            title: Text('عزبة النخبة'),
            subtitle: Text('موثّق • مجموع الرموز: 7'),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            title: const Text('بيانات الحساب'),
            subtitle: Text('الدور: ${session.role} • الهاتف: ${session.phoneNumber}'),
          ),
        ),
        const SizedBox(height: 8),
        const AnimalProfileCard(),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.notifications_active_outlined),
          label: const Text('متابعة وتفعيل التنبيهات'),
        ),
      ],
    );
  }
}
