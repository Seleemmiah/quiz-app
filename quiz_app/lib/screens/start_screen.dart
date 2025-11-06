import 'package:flutter/material.dart';

// This is our new "home" page (the '/' route)
class StartScreen extends StatelessWidget {
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
              // --- STYLING ---
              Icon(
                Icons.school,
                // Use the theme's primary color instead of a hard-coded one
                color: Theme.of(context).primaryColorLight,
                size: 100,
              ),
              SizedBox(height: 30),
              Text(
                'Welcome to the Quiz!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
              ),
              SizedBox(height: 10),
              Text(
                'Test your knowledge.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 10),
              ),
              SizedBox(height: 50),

              // --- NAVIGATION ---
              ElevatedButton(
                child: Text('Start Quiz'),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/quiz');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
