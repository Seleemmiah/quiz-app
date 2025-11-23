import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/services/class_service.dart';

class JoinClassScreen extends StatefulWidget {
  const JoinClassScreen({super.key});

  @override
  State<JoinClassScreen> createState() => _JoinClassScreenState();
}

class _JoinClassScreenState extends State<JoinClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _classCodeController = TextEditingController();

  final ClassService _classService = ClassService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  bool _isLoading = false;

  @override
  void dispose() {
    _classCodeController.dispose();
    super.dispose();
  }

  Future<void> _joinClass() async {
    if (!_formKey.currentState!.validate() || _currentUser == null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final classModel = await _classService.joinClass(
        classCode: _classCodeController.text.trim().toUpperCase(),
        userId: _currentUser!.uid,
        userName: _currentUser!.displayName ?? 'Student',
        userAvatar: '👨‍🎓',
      );

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully joined "${classModel.className}"!'),
            backgroundColor: Colors.green,
          ),
        );

        // Go back to classes screen
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Class'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Icon(
                Icons.login,
                size: 80,
                color: Colors.green,
              ),
              const SizedBox(height: 24),
              Text(
                'Join a Class',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the 6-character code provided by your teacher',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Class Code Input
              TextFormField(
                controller: _classCodeController,
                decoration: InputDecoration(
                  labelText: 'Class Code',
                  hintText: 'ABC123',
                  prefixIcon: const Icon(Icons.vpn_key),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                ),
                textCapitalization: TextCapitalization.characters,
                maxLength: 6,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
                textAlign: TextAlign.center,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a class code';
                  }
                  if (value.trim().length != 6) {
                    return 'Class code must be 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Join Button
              ElevatedButton(
                onPressed: _isLoading ? null : _joinClass,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Join Class',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
              const SizedBox(height: 24),

              // Help Text
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'How to get a class code?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ask your teacher for the 6-character class code. They can find it in their class details.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
