import json
import random

def generate_questions():
    questions = [
        # --- MATHEMATICS ---
        {
            "category": "Mathematics",
            "difficulty": "medium",
            "question": "Solve for x: $$2x + 5 = 15$$",
            "correct_answer": "5",
            "incorrect_answers": ["10", "7.5", "2"],
            "explanation": "Subtract 5 from both sides: $$2x = 10$$. Divide by 2: $$x = 5$$.",
            "type": "multiple"
        },
        {
            "category": "Mathematics",
            "difficulty": "hard",
            "question": "What are the roots of the quadratic equation $$x^2 - 5x + 6 = 0$$?",
            "correct_answer": "2 and 3",
            "incorrect_answers": ["-2 and -3", "1 and 6", "-1 and -6"],
            "explanation": "Factor the equation: $$(x-2)(x-3) = 0$$. Thus, $$x=2$$ or $$x=3$$.",
            "type": "multiple"
        },
        {
            "category": "Mathematics",
            "difficulty": "hard",
            "question": "Evaluate the integral: $$\\int x^2 dx$$",
            "correct_answer": "$$\\frac{x^3}{3} + C$$",
            "incorrect_answers": ["$$2x + C$$", "$$x^3 + C$$", "$$\\frac{x^2}{2} + C$$"],
            "explanation": "The power rule for integration states $$\\int x^n dx = \\frac{x^{n+1}}{n+1} + C$$. Here n=2.",
            "type": "multiple"
        },
        {
            "category": "Mathematics",
            "difficulty": "medium",
            "question": "What is the value of $$\\sin(90^\\circ)$$?",
            "correct_answer": "1",
            "incorrect_answers": ["0", "0.5", "-1"],
            "explanation": "On the unit circle, at 90 degrees (or $$\\pi/2$$ radians), the y-coordinate is 1.",
            "type": "multiple"
        },

        # --- ENGINEERING ---
        {
            "category": "Engineering",
            "difficulty": "medium",
            "question": "Which law states that $$V = IR$$?",
            "correct_answer": "Ohm's Law",
            "incorrect_answers": ["Kirchhoff's Law", "Newton's Law", "Faraday's Law"],
            "explanation": "Ohm's Law relates Voltage (V), Current (I), and Resistance (R).",
            "type": "multiple"
        },
        {
            "category": "Engineering",
            "difficulty": "hard",
            "question": "Calculate the stress ($$\\sigma$$) if a force of 100N is applied to an area of 2m$$^2$$. Formula: $$\\sigma = \\frac{F}{A}$$",
            "correct_answer": "50 Pa",
            "incorrect_answers": ["200 Pa", "100 Pa", "20 Pa"],
            "explanation": "$$\\sigma = \\frac{100}{2} = 50$$ Pascals (Pa).",
            "type": "multiple"
        },
        {
            "category": "Engineering",
            "difficulty": "hard",
            "question": "In thermodynamics, what does the First Law state regarding energy?",
            "correct_answer": "$$\\Delta U = Q - W$$",
            "incorrect_answers": ["$$F = ma$$", "$$E = mc^2$$", "$$PV = nRT$$"],
            "explanation": "The change in internal energy ($$\\Delta U$$) equals heat added (Q) minus work done (W).",
            "type": "multiple"
        },
        {
            "category": "Engineering",
            "difficulty": "medium",
            "question": "Identify this component symbol:",
            "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/Resistor_symbol_America.svg/1200px-Resistor_symbol_America.svg.png",
            "correct_answer": "Resistor",
            "incorrect_answers": ["Capacitor", "Inductor", "Diode"],
            "explanation": "The zig-zag line is the standard US symbol for a resistor.",
            "type": "multiple"
        }
    ]
    
    # Save to a JSON file (or print to stdout to be captured)
    # For this environment, we'll write to a specific file that the app can 'import' or we can copy-paste.
    # Actually, the app reads from `lib/screens/local_questions.dart`.
    # We should append these to that file.
    
    return questions

if __name__ == "__main__":
    new_questions = generate_questions()
    
    # Read existing local_questions.dart
    path = '/Users/seleemaleshinloye/quiz-app/quiz_app/lib/screens/local_questions.dart'
    
    try:
        with open(path, 'r') as f:
            content = f.read()
            
        # Find the end of the list
        # Assuming the file ends with "];"
        last_bracket_index = content.rfind('];')
        
        if last_bracket_index != -1:
            # Prepare new content
            new_content_str = ""
            for q in new_questions:
                new_content_str += "  {\n"
                new_content_str += f"    'category': '{q['category']}',\n"
                new_content_str += f"    'difficulty': '{q['difficulty']}',\n"
                new_content_str += f"    'question': r'{q['question']}',\n" # Use raw string for LaTeX
                new_content_str += f"    'correct_answer': r'{q['correct_answer']}',\n"
                new_content_str += f"    'incorrect_answers': {q['incorrect_answers']},\n" # List to string
                # Fix list string to use raw strings if needed, but simple numbers/text are fine
                # Actually, for LaTeX in answers, we might need raw strings too.
                # Let's do it manually for safety.
                
                incorrect_str = "["
                for ans in q['incorrect_answers']:
                    incorrect_str += f"r'{ans}', "
                incorrect_str = incorrect_str.rstrip(", ") + "]"
                
                # Re-do incorrect_answers line
                new_content_str = new_content_str.replace(f"    'incorrect_answers': {q['incorrect_answers']},\n", f"    'incorrect_answers': {incorrect_str},\n")

                new_content_str += f"    'explanation': r'{q['explanation']}',\n"
                new_content_str += f"    'type': '{q['type']}',\n"
                if 'imageUrl' in q:
                    new_content_str += f"    'imageUrl': '{q['imageUrl']}',\n"
                new_content_str += "  },\n"
            
            # Insert before the closing bracket
            updated_content = content[:last_bracket_index] + new_content_str + content[last_bracket_index:]
            
            with open(path, 'w') as f:
                f.write(updated_content)
            print("Successfully appended Math and Engineering questions.")
        else:
            print("Could not find closing bracket in local_questions.dart")
            
    except FileNotFoundError:
        print(f"File not found: {path}")

