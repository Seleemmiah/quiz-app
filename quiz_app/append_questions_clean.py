"""
Append Math and Engineering questions to local_questions.dart with proper Dart syntax.
Uses raw strings r'''...''' to handle LaTeX equations safely.
"""

def append_math_engineering_questions():
    # Read the current file
    with open('/Users/seleemaleshinloye/quiz-app/quiz_app/lib/screens/local_questions.dart', 'r') as f:
        content = f.read()
    
    # Remove the closing ]; from the end
    content = content.rstrip()
    if content.endswith('];'):
        content = content[:-2]
    
    # Math and Engineering questions with proper Dart syntax
    new_questions = r'''
  ,
  // ========================================
  // Mathematics Questions
  // ========================================
  {
    'category': 'Mathematics',
    'difficulty': 'easy',
    'question': r'What is $$2 + 2$$?',
    'correct_answer': '4',
    'incorrect_answers': ['3', '5', '22'],
    'explanation': r'Basic addition: $$2 + 2 = 4$$',
    'type': 'multiple',
  },
  {
    'category': 'Mathematics',
    'difficulty': 'medium',
    'question': r'Solve for x: $$x^2 = 16$$',
    'correct_answer': r'$$\pm 4$$',
    'incorrect_answers': ['4', '8', '2'],
    'explanation': r'Taking the square root of both sides: $$x = \pm \sqrt{16} = \pm 4$$',
    'type': 'multiple',
  },
  {
    'category': 'Mathematics',
    'difficulty': 'hard',
    'question': r'What is the derivative of $$f(x) = x^3$$?',
    'correct_answer': r'$$3x^2$$',
    'incorrect_answers': [r'$$x^2$$', r'$$3x$$', r'$$x^3$$'],
    'explanation': r'Using the power rule: $$\frac{d}{dx}(x^n) = nx^{n-1}$$, so $$\frac{d}{dx}(x^3) = 3x^2$$',
    'type': 'multiple',
  },
  {
    'category': 'Mathematics',
    'difficulty': 'medium',
    'question': r'What is the value of $$\sin(90°)$$?',
    'correct_answer': '1',
    'incorrect_answers': ['0', '0.5', '-1'],
    'explanation': r'On the unit circle, at 90 degrees (or $$\pi/2$$ radians), the y-coordinate is 1.',
    'type': 'multiple',
  },
  {
    'category': 'Mathematics',
    'difficulty': 'easy',
    'question': r'What is $$\pi$$ approximately equal to?',
    'correct_answer': '3.14159',
    'incorrect_answers': ['2.71828', '1.41421', '3.33333'],
    'explanation': r'$$\pi$$ (pi) is approximately 3.14159, representing the ratio of a circle circumference to its diameter.',
    'type': 'multiple',
  },
  // ========================================
  // Engineering Questions
  // ========================================
  {
    'category': 'Engineering',
    'difficulty': 'medium',
    'question': r'Which law states that $$V = IR$$?',
    'correct_answer': r"Ohm's Law",
    'incorrect_answers': [r"Kirchhoff's Law", r"Newton's Law", r"Faraday's Law"],
    'explanation': r"Ohm's Law relates Voltage (V), Current (I), and Resistance (R).",
    'type': 'multiple',
  },
  {
    'category': 'Engineering',
    'difficulty': 'hard',
    'question': r'Calculate the stress ($$\sigma$$) if a force of 100N is applied to an area of 2m$$^2$$. Formula: $$\sigma = \frac{F}{A}$$',
    'correct_answer': '50 Pa',
    'incorrect_answers': ['200 Pa', '100 Pa', '20 Pa'],
    'explanation': r'$$\sigma = \frac{100}{2} = 50$$ Pascals (Pa).',
    'type': 'multiple',
  },
  {
    'category': 'Engineering',
    'difficulty': 'hard',
    'question': 'In thermodynamics, what does the First Law state regarding energy?',
    'correct_answer': r'$$\Delta U = Q - W$$',
    'incorrect_answers': [r'$$F = ma$$', r'$$E = mc^2$$', r'$$PV = nRT$$'],
    'explanation': r'The change in internal energy ($$\Delta U$$) equals heat added (Q) minus work done (W).',
    'type': 'multiple',
  },
  {
    'category': 'Engineering',
    'difficulty': 'medium',
    'question': 'Identify this component symbol:',
    'correct_answer': 'Resistor',
    'incorrect_answers': ['Capacitor', 'Inductor', 'Diode'],
    'explanation': 'The zig-zag line is the standard US symbol for a resistor.',
    'type': 'multiple',
    'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/Resistor_symbol_America.svg/1200px-Resistor_symbol_America.svg.png',
  },
  {
    'category': 'Engineering',
    'difficulty': 'easy',
    'question': 'What does AC stand for in electrical engineering?',
    'correct_answer': 'Alternating Current',
    'incorrect_answers': ['Absolute Current', 'Active Circuit', 'Amplified Charge'],
    'explanation': 'AC (Alternating Current) is an electric current that periodically reverses direction, unlike DC (Direct Current).',
    'type': 'multiple',
  }
];
'''
    
    # Append the new questions
    final_content = content + new_questions
    
    # Write back to file
    with open('/Users/seleemaleshinloye/quiz-app/quiz_app/lib/screens/local_questions.dart', 'w') as f:
        f.write(final_content)
    
    print("Successfully appended Math and Engineering questions!")

if __name__ == "__main__":
    append_math_engineering_questions()
