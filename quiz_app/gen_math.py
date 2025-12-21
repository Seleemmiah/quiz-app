import random

def generate_math_questions():
    questions = []
    
    # --- EASY (Arithmetic, Basic Algebra) ---
    for i in range(100):
        a = random.randint(2, 50)
        b = random.randint(2, 50)
        op = random.choice(['+', '-', '*'])
        
        if op == '+':
            q_text = f"$$ {a} + {b} = ? $$"
            ans = a + b
        elif op == '-':
            # Ensure positive result for easy
            if b > a: a, b = b, a
            q_text = f"$$ {a} - {b} = ? $$"
            ans = a - b
        else:
            # Keep numbers smaller for mult
            a = random.randint(2, 12)
            b = random.randint(2, 12)
            q_text = f"$$ {a} \\times {b} = ? $$"
            ans = a * b
            
        wrongs = [ans + random.randint(1, 5), ans - random.randint(1, 5), ans + 10]
        # Shuffle wrongs
        
        questions.append({
            "category": "Mathematics",
            "type": "multiple",
            "difficulty": "easy",
            "question": f"Solve: {q_text}",
            "correct_answer": str(ans),
            "incorrect_answers": [str(w) for w in wrongs],
            "explanation": f"Basic arithmetic: {a} {op} {b} is {ans}.",
            "isEquation": True
        })

    # --- MEDIUM (Algebra, Geometry, Logic) ---
    for i in range(100):
        # Solve ax + b = c
        x = random.randint(1, 20)
        coeff = random.randint(2, 12)
        const = random.randint(1, 50)
        result = coeff * x + const
        
        q_text = f"$$ {coeff}x + {const} = {result} $$"
        
        wrongs = [x+1, x-1, x+random.randint(2,5)]
        
        questions.append({
            "category": "Mathematics",
            "type": "multiple",
            "difficulty": "medium",
            "question": f"Solve for x: {q_text}",
            "correct_answer": str(x),
            "incorrect_answers": [str(w) for w in wrongs],
            "explanation": f"Subtract {const} from {result}, getting {result-const}. Divide by {coeff} to get x = {x}.",
            "isEquation": True
        })

    # --- HARD (Calculus, Proofs, Adv Algebra) ---
    # Proof Questions (Static)
    proofs = [
        {
            "q": "To prove that $$ \\sqrt{2} $$ is irrational, which method is commonly used?",
            "a": "Proof by Contradiction",
            "w": ["Proof by Induction", "Direct Proof", "Proof by Exhaustion"],
            "e": "Assume sqrt(2) is rational (p/q), then show this leads to a contradiction where p and q share a common factor."
        },
        {
            "q": "In the proof of the Pythagorean Theorem ($$ a^2 + b^2 = c^2 $$) using similar triangles, which step is crucial?",
            "a": "Dropping an altitude to the hypotenuse",
            "w": ["Assuming the triangle is isosceles", "Integration", "Using the Law of Cosines"],
            "e": "Dropping an altitude splits the right triangle into two smaller triangles similar to the original."
        },
        {
             "q": "Evaluate the integral: $$ \\int x^2 dx $$",
             "a": "$$ \\frac{x^3}{3} + C $$",
             "w": ["$$ 2x + C $$", "$$ x^3 + C $$", "$$ \\frac{x^2}{2} + C $$"],
             "e": "Power rule for integration."
        },
        {
             "q": "What is the derivative of $$ \\sin(x) $$?",
             "a": "$$ \\cos(x) $$",
             "w": ["$$ -\\cos(x) $$", "$$ \\tan(x) $$", "$$ -\\sin(x) $$"],
             "e": "Standard derivative."
        },
         {
             "q": "Which identity confirms $$ \\sin^2(x) + \\cos^2(x) = 1 $$?",
             "a": "Pythagorean Identity",
             "w": ["Euler's Identity", "Double Angle Identity", "Half Angle Identity"],
             "e": "Derived from the Pythagorean theorem on the unit circle."
        }
    ]
    
    for p in proofs:
        questions.append({
            "category": "Mathematics",
            "type": "multiple",
            "difficulty": "hard",
            "question": p['q'],
            "correct_answer": p['a'],
            "incorrect_answers": p['w'],
            "explanation": p['e'],
            "isEquation": True
        })

    # Add 95 more generated Calculus/Hard
    # Variations:
    # 1. Power rule derivative d/dx(ax^n)
    # 2. Integrate ax^n
    # 3. Solve Quadratic ax^2 + bx + c = 0 (Integer roots)
    
    for i in range(95):
        type_idx = i % 3
        if type_idx == 0:
            # Derivative
            a = random.randint(2, 9)
            n = random.randint(2, 5)
            q_text = f"Find $$ \\frac{{d}}{{dx}} ({a}x^{n}) $$"
            ans = f"$$ {a*n}x^{{{n-1}}} $$"
            w1 = f"$$ {a}x^{{{n-1}}} $$"
            w2 = f"$$ {a*n}x^{{{n}}} $$"
            w3 = f"$$ {a}x^{{{n+1}}} $$"
            expl = f"Power Rule: Multiply {a}*{n}, subtract 1 from exponent."
        elif type_idx == 1:
            # Integral (Definite or Indefinite simple)
            # Indefinite
            n = random.randint(1, 4)
            q_text = f"Find $$ \\int x^{n} dx $$"
            ans = f"$$ \\frac{{x^{{{n+1}}}}}{{{n+1}}} + C $$"
            w1 = f"$$ x^{{{n+1}}} + C $$"
            w2 = f"$$ {n}x^{{{n-1}}} + C $$"
            w3 = f"$$ \\frac{{x^{{{n}}}}}{{{n}}} + C $$"
            expl = "Reverse Power Rule: Add 1 to exponent, divide by new exponent."
        else:
            # Quadratic with integer roots
            r1 = random.randint(-5, 5)
            r2 = random.randint(-5, 5)
            # (x - r1)(x - r2) = x^2 - (r1+r2)x + r1*r2
            b_val = -(r1 + r2)
            c_val = r1 * r2
            
            # Format signs
            b_sign = "+" if b_val >= 0 else "-"
            c_sign = "+" if c_val >= 0 else "-"
            
            q_text = f"Solve for x: $$ x^2 {b_sign} {abs(b_val)}x {c_sign} {abs(c_val)} = 0 $$"
            ans = f"$$ {r1}, {r2} $$"
            w1 = f"$$ {-r1}, {-r2} $$"
            w2 = f"$$ {r1+1}, {r2+1} $$"
            w3 = f"$$ {r1}, {-r2} $$"
            expl = f"Factoring: (x - {r1})(x - {r2}) = 0."

        questions.append({
            "category": "Mathematics",
            "type": "multiple",
            "difficulty": "hard",
            "question": q_text,
            "correct_answer": ans,
            "incorrect_answers": [w1, w2, w3],
            "explanation": expl,
            "isEquation": True
        })

        
    return questions

def dart_escape(s):
    return s.replace("'", "\\'").replace('"', '\\"')

def generate_dart_file(questions, filename="lib/data/new_math_questions.dart"):
    with open(filename, 'w', encoding='utf-8') as f:
        f.write("final List<Map<String, dynamic>> newMathQuestions = [\n")
        for q in questions:
            f.write("  {\n")
            f.write(f'    "category": "{q["category"]}",\n')
            f.write(f'    "type": "{q["type"]}",\n')
            f.write(f'    "difficulty": "{q["difficulty"]}",\n')
            # Use raw strings for questions with LaTeX to avoid escaping issues
            if "$" in q["question"] or "\\" in q["question"]:
                 f.write(f'    "question": r\'{q["question"]}\',\n')
            else:
                 f.write(f'    "question": "{dart_escape(q["question"])}",\n')
            
            # Answers might have Latex
            if "$" in q["correct_answer"]:
                f.write(f'    "correct_answer": r\'{q["correct_answer"]}\',\n')
            else:
                f.write(f'    "correct_answer": "{dart_escape(q["correct_answer"])}",\n')
                
            f.write('    "incorrect_answers": [\n')
            for w in q["incorrect_answers"]:
                if "$" in w:
                     f.write(f'      r\'{w}\',\n')
                else:
                     f.write(f'      "{dart_escape(w)}",\n')
            f.write('    ],\n')
            
            f.write(f'    "explanation": "{dart_escape(q["explanation"])}"\n')
            f.write("  },\n")
        f.write("];\n")
    print(f"Generated {len(questions)} questions in {filename}")

if __name__ == "__main__":
    qs = generate_math_questions()
    generate_dart_file(qs)
