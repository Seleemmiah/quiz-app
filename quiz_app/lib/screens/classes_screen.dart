import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/models/class_model.dart';
import 'package:quiz_app/services/class_service.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  final ClassService _classService = ClassService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  late Future<List<ClassModel>> _classesFuture;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  void _loadClasses() {
    if (_currentUser != null) {
      setState(() {
        _classesFuture = _classService.getUserClasses(_currentUser!.uid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Classes')),
        body: const Center(
          child: Text('Please log in to view classes'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Classes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadClasses,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<List<ClassModel>>(
        future: _classesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadClasses,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final classes = snapshot.data ?? [];

          if (classes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No Classes Yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Create a class or join one with a code',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final classModel = classes[index];
              final isTeacher = classModel.teacherId == _currentUser!.uid;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    child: Icon(
                      isTeacher ? Icons.school : Icons.class_,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  title: Text(
                    classModel.className,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (classModel.subject != null)
                        Text('Subject: ${classModel.subject}'),
                      Text(
                        isTeacher
                            ? 'Teacher • ${classModel.memberCount} members'
                            : 'Student • ${classModel.teacherName}',
                      ),
                      Text(
                        'Code: ${classModel.classCode}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/class_detail',
                      arguments: classModel,
                    ).then((_) => _loadClasses());
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'create_class',
            onPressed: () {
              Navigator.pushNamed(context, '/create_class')
                  .then((_) => _loadClasses());
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Class'),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'join_class',
            onPressed: () {
              Navigator.pushNamed(context, '/join_class')
                  .then((_) => _loadClasses());
            },
            icon: const Icon(Icons.login),
            label: const Text('Join Class'),
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
