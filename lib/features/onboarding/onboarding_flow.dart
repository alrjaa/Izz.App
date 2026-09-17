import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';
import '../shell/session.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({required this.onCompleted, super.key});

  final ValueChanged<AppSession> onCompleted;

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int _step = 0;
  String _role = 'owner';
  final Set<String> _interests = {'الكل'};

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مرحبًا بك في عِزّ المسابقات')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Stepper(
                currentStep: _step,
                controlsBuilder: (context, details) => const SizedBox.shrink(),
                steps: [
                  Step(
                    title: const Text('رقم الجوال'),
                    isActive: _step >= 0,
                    content: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            key: const Key('phone_input'),
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'رقم الجوال',
                              hintText: '05xxxxxxxx',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().length < 9) {
                                return 'أدخل رقم جوال صحيح';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          FilledButton(
                            key: const Key('send_otp_button'),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() => _step = 1);
                              }
                            },
                            child: const Text('إرسال رمز OTP (تجريبي)'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Step(
                    title: const Text('التحقق'),
                    isActive: _step >= 1,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('رمز التحقق التجريبي هو: 1234'),
                        const SizedBox(height: 8),
                        TextField(
                          key: const Key('otp_input'),
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'رمز OTP'),
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          key: const Key('verify_otp_button'),
                          onPressed: () {
                            if (_otpController.text.trim() == '1234') {
                              setState(() => _step = 2);
                            }
                          },
                          child: const Text('تأكيد الرمز'),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text('نوع الحساب'),
                    isActive: _step >= 2,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: const [
                            ('owner', 'مالك / عزبة'),
                            ('follower', 'متابع / جمهور'),
                            ('sponsor', 'راعٍ'),
                            ('admin', 'إدارة'),
                          ]
                              .map(
                                (item) => _RoleChoice(role: item.$1, label: item.$2),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          key: const Key('select_role_button'),
                          onPressed: () => setState(() => _step = 3),
                          child: const Text('التالي'),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text('الاهتمامات'),
                    isActive: _step >= 3,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StatefulBuilder(
                          builder: (context, setInnerState) {
                            return Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: ['مزاين الإبل', 'سباقات الهجن', 'الكل']
                                  .map(
                                    (interest) => FilterChip(
                                      label: Text(interest),
                                      selected: _interests.contains(interest),
                                      onSelected: (selected) {
                                        setInnerState(() {
                                          if (selected) {
                                            _interests.add(interest);
                                          } else {
                                            _interests.remove(interest);
                                          }
                                        });
                                      },
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          key: const Key('finish_onboarding_button'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.brown,
                          ),
                          onPressed: () {
                            widget.onCompleted(
                              AppSession(
                                phoneNumber: _phoneController.text.trim(),
                                role: _role,
                                interests: _interests.toList(),
                              ),
                            );
                          },
                          child: const Text('دخول التطبيق'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleChoice extends StatefulWidget {
  const _RoleChoice({required this.role, required this.label});

  final String role;
  final String label;

  @override
  State<_RoleChoice> createState() => _RoleChoiceState();
}

class _RoleChoiceState extends State<_RoleChoice> {
  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_OnboardingFlowState>();
    return ChoiceChip(
      label: Text(widget.label),
      selected: state?._role == widget.role,
      onSelected: (_) => state?.setState(() => state._role = widget.role),
    );
  }
}
