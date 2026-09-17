import 'package:flutter/material.dart';

import '../../data/mock/mock_data.dart';

class MediaCenterScreen extends StatelessWidget {
  const MediaCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const Key('media_center_screen'),
      padding: const EdgeInsets.all(16),
      itemCount: MockData.media.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Card(
            child: ListTile(
              title: Text('مركز الوسائط'),
              subtitle: Text('رفع الصور والفيديوهات بعد مراجعة الإدارة.'),
            ),
          );
        }

        final item = MockData.media[index - 1];
        return Card(
          child: ListTile(
            leading: Icon(item.mediaType == 'video' ? Icons.play_circle : Icons.image),
            title: Text(item.mediaUrl),
            subtitle: Text('مشاهدات ${item.viewsCount} • إعجابات ${item.likesCount}'),
            trailing: const Icon(Icons.share_outlined),
          ),
        );
      },
    );
  }
}
