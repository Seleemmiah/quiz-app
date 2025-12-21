import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/widgets/glass_dialog.dart';

class AvatarSelectionDialog extends StatefulWidget {
  final String currentAvatar;
  final Function(String) onAvatarSelected;

  const AvatarSelectionDialog({
    super.key,
    required this.currentAvatar,
    required this.onAvatarSelected,
  });

  @override
  State<AvatarSelectionDialog> createState() => _AvatarSelectionDialogState();
}

class _AvatarSelectionDialogState extends State<AvatarSelectionDialog> {
  // Available avatars
  static const List<String> avatars = [
    '👨‍🎓', '👩‍🎓', '🧑‍🎓', // Students
    '👨‍🏫', '👩‍🏫', '🧑‍🏫', // Teachers
    '🧑‍💻', '👨‍💻', '👩‍💻', // Tech
    '🧑‍🔬', '👨‍🔬', '👩‍🔬', // Science
    '🦸', '🦸‍♂️', '🦸‍♀️', // Heroes
    '🧙', '🧙‍♂️', '🧙‍♀️', // Wizards
    '🥷', '🤓', '😎', // Cool
    '🐶', '🐱', '🐼', // Animals
    '🦊', '🦁', '🐯', // More animals
    '🚀', '⭐', '🏆', // Objects
  ];

  String _selectedAvatar = '';

  @override
  void initState() {
    super.initState();
    _selectedAvatar = widget.currentAvatar;
  }

  Future<void> _saveAvatar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'avatar': _selectedAvatar});

        widget.onAvatarSelected(_selectedAvatar);
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving avatar: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassDialog(
      title: 'Choose Your Avatar',
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: avatars.length,
          itemBuilder: (context, index) {
            final avatar = avatars[index];
            final isSelected = avatar == _selectedAvatar;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedAvatar = avatar;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.withOpacity(0.3),
                    width: isSelected ? 3 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: isSelected
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : null,
                ),
                child: Center(
                  child: Text(
                    avatar,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveAvatar,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
