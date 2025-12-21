import random

def generate_questions():
    questions = []
    
    # --- PHYSICS ---
    # EASY: F=ma (Solve for F)
    for i in range(100):
        m = random.randint(1, 20)
        a = random.randint(1, 20)
        f_val = m * a
        wrongs = [f_val+random.choice([1,2,5]), f_val-random.choice([1,2,5]), m+a]
        questions.append({
            "category": "Physics",
            "type": "multiple",
            "difficulty": "easy",
            "question": f"A {m}kg object accelerates at {a}m/s². What is the net force? ($$ F=ma $$)",
            "correct_answer": f"{f_val}N",
            "incorrect_answers": [f"{w}N" for w in wrongs],
            "explanation": f"F = {m} * {a} = {f_val}N.",
            "isEquation": True
        })

    # MEDIUM: KE = 0.5mv^2 (Solve for KE)
    for i in range(100):
        m = random.randint(1, 10) * 2
        v = random.randint(2, 12)
        ke = int(0.5 * m * (v**2))
        wrongs = [ke+10, ke-10, int(ke*1.5)]
        questions.append({
            "category": "Physics",
            "type": "multiple",
            "difficulty": "medium",
            "question": f"Calculate the Kinetic Energy of a {m}kg object moving at {v}m/s ($$ KE = \\frac{{1}}{{2}}mv^2 $$).",
            "correct_answer": f"{ke}J",
            "incorrect_answers": [f"{w}J" for w in wrongs],
            "explanation": f"KE = 0.5 * {m} * {v}^2 = {ke}J.",
            "isEquation": True
        })

    # HARD: Work = F * d * cos(theta) or similar
    # Or mixed Physics: Momentum p=mv, PE=mgh
    for i in range(100):
        mode = i % 2
        if mode == 0:
            # PE = mgh
            m = random.randint(1, 10)
            h = random.randint(1, 20)
            g = 9.8
            pe = round(m * g * h, 1)
            wrongs = [round(pe+10,1), round(pe-10,1), round(m*h,1)]
            questions.append({
                "category": "Physics",
                "type": "multiple",
                "difficulty": "hard",
                "question": f"Calculate Potential Energy: mass={m}kg, height={h}m, g=9.8m/s² ($$ PE=mgh $$).",
                "correct_answer": f"{pe}J",
                "incorrect_answers": [f"{w}J" for w in wrongs],
                "explanation": f"PE = {m} * 9.8 * {h} = {pe}J.",
                "isEquation": True
            })
        else:
            # Momentum p=mv
            m = random.randint(10, 50)
            v = random.randint(5, 20)
            p = m * v
            wrongs = [p+50, p-50, m+v]
            questions.append({
                "category": "Physics",
                "type": "multiple",
                "difficulty": "hard",
                "question": f"Calculate momentum of a {m}kg car at {v}m/s ($$ p=mv $$).",
                "correct_answer": f"{p} kg·m/s",
                "incorrect_answers": [f"{w} kg·m/s" for w in wrongs],
                "explanation": f"Momentum = {m} * {v} = {p}.",
                "isEquation": True
            })

    # --- CHEMISTRY ---
    # EASY: Atomic Mass lookups (Simulated)
    # Just generating basic proton/neutron counts
    for i in range(100):
        protons = random.randint(1, 20)
        neutrons = random.randint(1, 22)
        mass = protons + neutrons
        questions.append({
            "category": "Chemistry",
            "type": "multiple",
            "difficulty": "easy",
            "question": f"An atom has {protons} protons and {neutrons} neutrons. What is its mass number?",
            "correct_answer": str(mass),
            "incorrect_answers": [str(mass-1), str(mass+1), str(protons)],
            "explanation": "Mass Number = Protons + Neutrons.",
            "isEquation": True
        })

    # MEDIUM: Molar Mass (Alkane CnH(2n+2))
    for i in range(100):
        n = random.randint(1, 15)
        h = 2*n + 2
        mass = n*12 + h*1
        questions.append({
            "category": "Chemistry",
            "type": "multiple",
            "difficulty": "medium",
            "question": f"Calculate the molar mass of $$ C_{{{n}}}H_{{{h}}} $$ (C=12, H=1).",
            "correct_answer": f"{mass} g/mol",
            "incorrect_answers": [f"{mass+2} g/mol", f"{mass-2} g/mol", f"{mass+10} g/mol"],
            "explanation": f"({n}*12) + ({h}*1) = {mass}.",
            "isEquation": True
        })

    # HARD: Ideal Gas Law PV = nRT (Solve for P)
    # P = nRT / V. R = 8.31
    for i in range(100):
        n = random.randint(1, 5)
        T = random.randint(273, 350) # Kelvin
        V = random.randint(10, 50) # Liters? Scale units carefully.
        # Let's say SI units: V in m^3 (small), P in Pa.
        # Or just stick to numbers.
        # P = (n * 8.31 * T) / V
        P = (n * 8.31 * T) / V
        P = round(P, 2)
        questions.append({
            "category": "Chemistry",
            "type": "multiple",
            "difficulty": "hard",
            "question": f"Calculate Pressure (P) if n={n}mol, T={T}K, V={V}m³, R=8.31 ($$ PV=nRT $$).",
            "correct_answer": f"{P} Pa",
            "incorrect_answers": [f"{round(P*2,2)} Pa", f"{round(P/2,2)} Pa", f"{round(P+100,2)} Pa"],
            "explanation": f"P = (nRT)/V = ({n}*8.31*{T})/{V} = {P}.",
            "isEquation": True
        })

    # --- ENGINEERING REMOVED (Moved to gen_eng_specific.py) ---
    # pass

    return questions

def dart_escape(s):
    return s.replace("'", "\\'").replace('"', '\\"')

def generate_dart_file(questions, filename="lib/data/new_sci_questions.dart"):
    with open(filename, 'w', encoding='utf-8') as f:
        f.write("final List<Map<String, dynamic>> newSciQuestions = [\n")
        for q in questions:
            f.write("  {\n")
            f.write(f'    "category": "{q["category"]}",\n')
            f.write(f'    "type": "{q["type"]}",\n')
            f.write(f'    "difficulty": "{q["difficulty"]}",\n')
            if "$" in q["question"] or "\\" in q["question"]:
                 f.write(f'    "question": r\'{q["question"]}\',\n')
            else:
                 f.write(f'    "question": "{dart_escape(q["question"])}",\n')
            
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
    qs = generate_questions()
    generate_dart_file(qs)
