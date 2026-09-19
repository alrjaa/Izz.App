import 'package:flutter_test/flutter_test.dart';
import 'package:izz_app/state/app_controller.dart';

void main() {
  group('AppController', () {
    test('creates an owner for the signed-in user', () {
      final controller = AppController();
      controller.signIn('user-admin');

      final before = controller.state.owners.length;
      final owner = controller.createOwner(
        name: 'مالك جديد',
        region: 'القصيم',
        bio: 'ملف مالك جديد',
      );

      expect(controller.state.owners.length, before + 1);
      expect(owner.userId, 'user-admin');
    });

    test('adds a camel to an owner the user can manage', () {
      final controller = AppController();
      controller.signIn('user-owner');

      final before = controller.state.camels.length;
      final camel = controller.addCamel(
        ownerId: 'owner-1',
        name: 'الشاهينية',
        gender: 'بكار',
        ageLabel: 'زمول',
        color: 'وضحاء',
        summary: 'مطية مضافة للاختبار',
      );

      expect(controller.state.camels.length, before + 1);
      expect(camel.ownerId, 'owner-1');
    });

    test('approving a pending result generates an official winner card', () {
      final controller = AppController();
      controller.signIn('user-admin');

      final before = controller.state.winnerCards.length;
      final card = controller.approveResult('result-2');
      final result = controller.state.results.firstWhere((item) => item.id == 'result-2');

      expect(controller.state.winnerCards.length, before + 1);
      expect(result.isOfficial, isTrue);
      expect(result.winnerCardId, isNotNull);
      expect(controller.findWinnerCardByCode(card.verificationCode), isNotNull);
    });

    test('social interactions update state and notifications', () {
      final controller = AppController();
      controller.signIn('user-follower');

      controller.toggleLike('content-2');
      controller.toggleFollowOwner('owner-1');
      controller.addComment(contentId: 'content-2', body: 'محتوى رائع');

      final content = controller.state.contents.firstWhere((item) => item.id == 'content-2');
      expect(content.likeUserIds, contains('user-follower'));
      expect(controller.state.followedOwnerIds, contains('owner-1'));
      expect(
        controller.state.notifications.any((item) => item.userId == 'user-owner'),
        isTrue,
      );
    });
  });
}
