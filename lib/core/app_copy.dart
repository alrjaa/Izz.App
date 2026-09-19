class AppCopy {
  static const Map<String, Map<String, String>> _values = {
    'title': {'ar': 'عز للهجن', 'en': 'Izz Camel Platform'},
    'home': {'ar': 'الرئيسية', 'en': 'Home'},
    'owners': {'ar': 'الملاك', 'en': 'Owners'},
    'championships': {'ar': 'البطولات', 'en': 'Championships'},
    'admin': {'ar': 'الإدارة', 'en': 'Admin'},
    'login': {'ar': 'الدخول', 'en': 'Login'},
    'logout': {'ar': 'خروج', 'en': 'Logout'},
    'notifications': {'ar': 'الإشعارات', 'en': 'Notifications'},
    'search': {'ar': 'البحث', 'en': 'Search'},
    'winnerCard': {'ar': 'بطاقة الفوز', 'en': 'Winner card'},
    'verify': {'ar': 'تحقق', 'en': 'Verify'},
    'follow': {'ar': 'متابعة', 'en': 'Follow'},
    'following': {'ar': 'متابَع', 'en': 'Following'},
    'like': {'ar': 'إعجاب', 'en': 'Like'},
    'save': {'ar': 'حفظ', 'en': 'Save'},
    'comment': {'ar': 'تعليق', 'en': 'Comment'},
    'report': {'ar': 'بلاغ', 'en': 'Report'},
    'approve': {'ar': 'اعتماد رسمي', 'en': 'Approve officially'},
    'pending': {'ar': 'قيد الانتظار', 'en': 'Pending'},
    'official': {'ar': 'رسمي', 'en': 'Official'},
    'accessDenied': {'ar': 'الوصول مرفوض', 'en': 'Access denied'},
    'currentChampionships': {'ar': 'البطولات الحالية والقادمة', 'en': 'Current & upcoming championships'},
    'communityFeed': {'ar': 'محتوى المجتمع', 'en': 'Community feed'},
    'pendingResults': {'ar': 'نتائج تنتظر الاعتماد', 'en': 'Pending result approvals'},
    'officialCards': {'ar': 'بطاقات الفوز الرسمية', 'en': 'Official winner cards'},
    'linkedEntity': {'ar': 'مرتبط بـ', 'en': 'Linked to'},
    'createOwner': {'ar': 'إنشاء ملف مالك', 'en': 'Create owner profile'},
    'addCamel': {'ar': 'إضافة هجن', 'en': 'Add camel'},
    'addPost': {'ar': 'نشر محتوى', 'en': 'Publish content'},
    'reports': {'ar': 'البلاغات', 'en': 'Reports'},
    'audit': {'ar': 'سجل التدقيق', 'en': 'Audit log'},
    'noData': {'ar': 'لا توجد بيانات', 'en': 'No data available'},
  };

  static String t(String key, String localeCode) {
    return _values[key]?[localeCode] ?? _values[key]?['en'] ?? key;
  }
}
