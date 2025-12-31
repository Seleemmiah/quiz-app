import 'package:flutter/material.dart';
import 'package:quiz_app/services/offline_cache_service.dart';
import 'package:quiz_app/settings.dart';
import 'package:intl/intl.dart';

class OfflineLibraryScreen extends StatefulWidget {
  const OfflineLibraryScreen({super.key});

  @override
  State<OfflineLibraryScreen> createState() => _OfflineLibraryScreenState();
}

class _OfflineLibraryScreenState extends State<OfflineLibraryScreen> {
  List<Map<String, dynamic>> _quizzes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  void _loadQuizzes() {
    setState(() => _isLoading = true);
    final quizzes = OfflineCacheService.getAllSavedQuizzes();
    setState(() {
      _quizzes = quizzes;
      _isLoading = false;
    });
  }

  void _playQuiz(Map<String, dynamic> quizData) {
    final questions = OfflineCacheService.getQuizQuestions(quizData['id']);

    Navigator.pushNamed(
      context,
      '/quiz',
      arguments: {
        'difficulty': Difficulty.medium,
        'category': quizData['category'],
        'quizLength': questions.length,
        'customQuestions': questions,
      },
    );
  }

  void _deleteQuiz(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Quiz?'),
        content: const Text(
            'This will remove the quiz and its cached images from your device.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      await OfflineCacheService.deleteQuiz(id);
      _loadQuizzes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'Offline Library',
                children: [
                  const Text(
                      'All quizzes here are fully available without internet connection, including their images.'),
                ],
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _quizzes.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _quizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = _quizzes[index];
                    final date = DateTime.parse(quiz['downloadedAt']);
                    final isGenerated = quiz['isGenerated'] ?? false;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: isGenerated
                              ? Colors.purple.shade100
                              : Colors.blue.shade100,
                          child: Icon(
                            isGenerated
                                ? Icons.auto_awesome
                                : Icons.download_done,
                            color: isGenerated ? Colors.purple : Colors.blue,
                          ),
                        ),
                        title: Text(
                          quiz['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Category: ${quiz['category']}'),
                            Text(
                                'Downloaded: ${DateFormat.yMMMd().add_jm().format(date)}'),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.green.shade200),
                              ),
                              child: const Text(
                                'Ready Offline',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () => _deleteQuiz(quiz['id']),
                            ),
                            ElevatedButton(
                              onPressed: () => _playQuiz(quiz),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              child: const Text('Play'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off, size: 100, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Text(
            'Your offline library is empty',
            style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Generate an AI quiz or download a textbook chapter to see it here!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/generateQuiz'),
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Generate AI Quiz'),
          ),
        ],
      ),
    );
  }
}
