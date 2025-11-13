import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:quiz_app/settings.dart';
import 'package:quiz_app/services/api_service.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  // --- State Variables ---
  Difficulty _selectedDifficulty = Difficulty.easy;
  int? _selectedTimeInMinutes = 5; // Default to 5 minutes
  String? _selectedCategory;

  // Future to hold categories from the API
  late Future<List<String>> _categoriesFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Fetch categories when the widget is first created
    _categoriesFuture = _apiService.fetchCategories();
  }

  // Helper to create a map for time options for clarity
  final Map<int?, String> _timeOptions = {
    2: '2 Min',
    5: '5 Min',
    10: '10 Min',
    null: 'Unlimited', // null represents unlimited time
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.school,
                color: Theme.of(context).primaryColor,
                size: 100,
              ),
              const SizedBox(height: 30),
              Text(
                'Welcome to the Quiz!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight:
                          FontWeight.bold, // Keep bold, but remove size/color
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                'Test your knowledge.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 40),

              // --- Category Selector ---
              // Animate the dropdown appearing
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: FutureBuilder<List<String>>(
                  future: _categoriesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return const Text('Could not load categories.');
                    }
                    final categories = snapshot.data!;
                    if (_selectedCategory == null && categories.isNotEmpty) {
                      _selectedCategory = categories.first;
                    }
                    return DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Select Category',
                        filled: true, // Add a fill color
                        fillColor:
                            Theme.of(context).canvasColor.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none, // Hide the border
                        ),
                      ),
                      items: categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // --- Difficulty Selector ---
              Text(
                'Select Difficulty:',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              SegmentedButton<Difficulty>(
                segments: const [
                  ButtonSegment(value: Difficulty.easy, label: Text('Easy')),
                  ButtonSegment(
                      value: Difficulty.medium, label: Text('Medium')),
                  ButtonSegment(value: Difficulty.hard, label: Text('Hard')),
                ],
                selected: {_selectedDifficulty},
                onSelectionChanged: (Set<Difficulty> newSelection) {
                  setState(() {
                    _selectedDifficulty = newSelection.first;
                  });
                },
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.2),
                  selectedForegroundColor: Theme.of(context).primaryColor,
                ),
              ),

              const SizedBox(height: 20),

              // --- Time Limit Selector ---
              Text(
                'Select Time:',
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              SegmentedButton<int?>(
                segments: _timeOptions.entries.map((entry) {
                  return ButtonSegment<int?>(
                    value: entry.key,
                    label: Text(entry.value),
                  );
                }).toList(),
                selected: {_selectedTimeInMinutes},
                onSelectionChanged: (Set<int?> newSelection) {
                  setState(() {
                    _selectedTimeInMinutes = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                child: const Text('Start Quiz'),
                onPressed: () {
                  if (_selectedCategory == null)
                    return; // Don't start if no category
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(
                          difficulty: _selectedDifficulty,
                          category: _selectedCategory,
                          timeLimitInMinutes: _selectedTimeInMinutes),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
