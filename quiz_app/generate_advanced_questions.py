"""
Generate comprehensive Math and Engineering questions with LaTeX equations.
Covers: Calculus, Linear Algebra, Differential Equations, Statistics
Engineering: Electrical, Mechanical, Civil, Chemical, Computer
"""

def generate_questions():
    questions = []
    
    # ========================================
    # MATHEMATICS - CALCULUS
    # ========================================
    math_calculus = [
        {
            'category': 'Mathematics',
            'difficulty': 'medium',
            'question': r'Find the integral: $$\int x^2 dx$$',
            'correct_answer': r'$$\frac{x^3}{3} + C$$',
            'incorrect_answers': [r'$$\frac{x^2}{2} + C$$', r'$$x^3 + C$$', r'$$2x + C$$'],
            'explanation': r'Using the power rule for integration: $$\int x^n dx = \frac{x^{n+1}}{n+1} + C$$',
            'type': 'multiple',
        },
        {
            'category': 'Mathematics',
            'difficulty': 'hard',
            'question': r'Evaluate: $$\lim_{x \to 0} \frac{\sin(x)}{x}$$',
            'correct_answer': '1',
            'incorrect_answers': ['0', r'$$\infty$$', 'undefined'],
            'explanation': r'This is a fundamental limit in calculus: $$\lim_{x \to 0} \frac{\sin(x)}{x} = 1$$',
            'type': 'multiple',
        },
        {
            'category': 'Mathematics',
            'difficulty': 'hard',
            'question': r'Find $$\frac{d}{dx}[\ln(x)]$$',
            'correct_answer': r'$$\frac{1}{x}$$',
            'incorrect_answers': [r'$$\ln(x)$$', r'$$x$$', r'$$e^x$$'],
            'explanation': r'The derivative of the natural logarithm is $$\frac{d}{dx}[\ln(x)] = \frac{1}{x}$$',
            'type': 'multiple',
        },
        {
            'category': 'Mathematics',
            'difficulty': 'medium',
            'question': r'What is the second derivative of $$f(x) = e^{2x}$$?',
            'correct_answer': r'$$4e^{2x}$$',
            'incorrect_answers': [r'$$2e^{2x}$$', r'$$e^{2x}$$', r'$$2xe^{2x}$$'],
            'explanation': r'First derivative: $$2e^{2x}$$. Second derivative: $$4e^{2x}$$',
            'type': 'multiple',
        },
    ]
    
    # ========================================
    # MATHEMATICS - LINEAR ALGEBRA
    # ========================================
    math_linear_algebra = [
        {
            'category': 'Mathematics',
            'difficulty': 'medium',
            'question': r'What is the determinant of $$\begin{bmatrix} 2 & 1 \\ 4 & 3 \end{bmatrix}$$?',
            'correct_answer': '2',
            'incorrect_answers': ['6', '10', '5'],
            'explanation': r'For a 2x2 matrix $$\begin{bmatrix} a & b \\ c & d \end{bmatrix}$$, det = $$ad - bc = 2(3) - 1(4) = 2$$',
            'type': 'multiple',
        },
        {
            'category': 'Mathematics',
            'difficulty': 'hard',
            'question': r'What is the rank of a 3x3 identity matrix?',
            'correct_answer': '3',
            'incorrect_answers': ['1', '2', '0'],
            'explanation': r'The identity matrix has full rank equal to its dimension. All rows/columns are linearly independent.',
            'type': 'multiple',
        },
        {
            'category': 'Mathematics',
            'difficulty': 'medium',
            'question': r'If $$A$$ is a 3x2 matrix and $$B$$ is a 2x4 matrix, what is the dimension of $$AB$$?',
            'correct_answer': '3x4',
            'incorrect_answers': ['2x2', '3x2', '2x4'],
            'explanation': r'Matrix multiplication: $$(m \times n)(n \times p) = (m \times p)$$, so $$(3 \times 2)(2 \times 4) = 3 \times 4$$',
            'type': 'multiple',
        },
    ]
    
    # ========================================
    # MATHEMATICS - DIFFERENTIAL EQUATIONS
    # ========================================
    math_diff_eq = [
        {
            'category': 'Mathematics',
            'difficulty': 'hard',
            'question': r'Solve: $$\frac{dy}{dx} = ky$$ where $$k$$ is constant',
            'correct_answer': r'$$y = Ce^{kx}$$',
            'incorrect_answers': [r'$$y = Ckx$$', r'$$y = C\ln(kx)$$', r'$$y = Cx^k$$'],
            'explanation': r'This is exponential growth/decay. Solution: $$y = Ce^{kx}$$ where $$C$$ is the initial condition.',
            'type': 'multiple',
        },
        {
            'category': 'Mathematics',
            'difficulty': 'hard',
            'question': r'What is the general solution to $$y'' + 4y = 0$$?',
            'correct_answer': r'$$y = C_1\cos(2x) + C_2\sin(2x)$$',
            'incorrect_answers': [r'$$y = C_1e^{2x} + C_2e^{-2x}$$', r'$$y = C_1x + C_2$$', r'$$y = Ce^{4x}$$'],
            'explanation': r'Characteristic equation: $$r^2 + 4 = 0$$, so $$r = \pm 2i$$. Solution involves sin and cos.',
            'type': 'multiple',
        },
    ]
    
    # ========================================
    # MATHEMATICS - STATISTICS & PROBABILITY
    # ========================================
    math_stats = [
        {
            'category': 'Mathematics',
            'difficulty': 'medium',
            'question': r'What is the variance formula for a sample?',
            'correct_answer': r'$$s^2 = \frac{\sum(x_i - \bar{x})^2}{n-1}$$',
            'incorrect_answers': [r'$$s^2 = \frac{\sum(x_i - \bar{x})^2}{n}$$', r'$$s^2 = \sum(x_i - \bar{x})^2$$', r'$$s^2 = \sqrt{\frac{\sum(x_i - \bar{x})^2}{n}}$$'],
            'explanation': r'Sample variance uses $$n-1$$ (Bessel correction) for unbiased estimation.',
            'type': 'multiple',
        },
        {
            'category': 'Mathematics',
            'difficulty': 'easy',
            'question': r'In a normal distribution, what percentage of data falls within 1 standard deviation of the mean?',
            'correct_answer': '68%',
            'incorrect_answers': ['95%', '99.7%', '50%'],
            'explanation': r'The empirical rule: 68% within 1$$\sigma$$, 95% within 2$$\sigma$$, 99.7% within 3$$\sigma$$',
            'type': 'multiple',
        },
    ]
    
    # ========================================
    # ENGINEERING - ELECTRICAL
    # ========================================
    eng_electrical = [
        {
            'category': 'Engineering',
            'difficulty': 'medium',
            'question': r'Calculate total resistance for resistors in parallel: $$R_1 = 4\Omega$$, $$R_2 = 6\Omega$$',
            'correct_answer': r'$$2.4\Omega$$',
            'incorrect_answers': [r'$$10\Omega$$', r'$$5\Omega$$', r'$$1.2\Omega$$'],
            'explanation': r'Parallel: $$\frac{1}{R_T} = \frac{1}{R_1} + \frac{1}{R_2} = \frac{1}{4} + \frac{1}{6} = \frac{5}{12}$$, so $$R_T = 2.4\Omega$$',
            'type': 'multiple',
        },
        {
            'category': 'Engineering',
            'difficulty': 'hard',
            'question': r'What is the impedance of a series RLC circuit at resonance?',
            'correct_answer': r'$$Z = R$$ (minimum, purely resistive)',
            'incorrect_answers': [r'$$Z = \infty$$', r'$$Z = 0$$', r'$$Z = \sqrt{R^2 + (X_L - X_C)^2}$$'],
            'explanation': r'At resonance, $$X_L = X_C$$, so they cancel. Impedance $$Z = R$$ (minimum).',
            'type': 'multiple',
        },
        {
            'category': 'Engineering',
            'difficulty': 'medium',
            'question': r'Calculate power: $$V = 120V$$, $$I = 5A$$, power factor = 0.8',
            'correct_answer': '480W',
            'incorrect_answers': ['600W', '96W', '750W'],
            'explanation': r'Real power: $$P = VI\cos(\theta) = 120 \times 5 \times 0.8 = 480W$$',
            'type': 'multiple',
        },
        {
            'category': 'Engineering',
            'difficulty': 'hard',
            'question': r'What is the time constant $$\tau$$ for an RC circuit?',
            'correct_answer': r'$$\tau = RC$$',
            'incorrect_answers': [r'$$\tau = \frac{R}{C}$$', r'$$\tau = \frac{C}{R}$$', r'$$\tau = \frac{1}{RC}$$'],
            'explanation': r'Time constant $$\tau = RC$$ determines charging/discharging rate. After $$5\tau$$, capacitor is ~99% charged.',
            'type': 'multiple',
        },
    ]
    
    # ========================================
    # ENGINEERING - MECHANICAL
    # ========================================
    eng_mechanical = [
        {
            'category': 'Engineering',
            'difficulty': 'medium',
            'question': r'Calculate kinetic energy: mass = 10kg, velocity = 5 m/s. Formula: $$KE = \frac{1}{2}mv^2$$',
            'correct_answer': '125 J',
            'incorrect_answers': ['250 J', '50 J', '25 J'],
            'explanation': r'$$KE = \frac{1}{2}(10)(5)^2 = \frac{1}{2}(10)(25) = 125$$ Joules',
            'type': 'multiple',
        },
        {
            'category': 'Engineering',
            'difficulty': 'hard',
            'question': r'What is the moment of inertia for a solid cylinder about its central axis? (mass $$m$$, radius $$r$$)',
            'correct_answer': r'$$I = \frac{1}{2}mr^2$$',
            'incorrect_answers': [r'$$I = mr^2$$', r'$$I = \frac{2}{5}mr^2$$', r'$$I = \frac{1}{3}mr^2$$'],
            'explanation': r'For a solid cylinder rotating about its central axis: $$I = \frac{1}{2}mr^2$$',
            'type': 'multiple',
        },
        {
            'category': 'Engineering',
            'difficulty': 'medium',
            'question': r'Calculate torque: Force = 50N, distance = 2m, angle = 90°. Formula: $$\tau = rF\sin(\theta)$$',
            'correct_answer': '100 Nm',
            'incorrect_answers': ['50 Nm', '25 Nm', '200 Nm'],
            'explanation': r'$$\tau = (2)(50)\sin(90°) = 100 \times 1 = 100$$ Nm',
            'type': 'multiple',
        },
        {
            'category': 'Engineering',
            'difficulty': 'hard',
            'question': r'What is the efficiency formula for a heat engine?',
            'correct_answer': r'$$\eta = 1 - \frac{T_C}{T_H}$$ (Carnot)',
            'incorrect_answers': [r'$$\eta = \frac{T_C}{T_H}$$', r'$$\eta = \frac{T_H - T_C}{T_C}$$', r'$$\eta = \frac{W}{Q_H + Q_C}$$'],
            'explanation': r'Carnot efficiency: $$\eta = 1 - \frac{T_C}{T_H}$$ where $$T_C$$ is cold reservoir, $$T_H$$ is hot reservoir (in Kelvin).',
            'type': 'multiple',
        },
    ]
    
    # ========================================
    # ENGINEERING - CIVIL
    # ========================================
    eng_civil = [
        {
            'category': 'Engineering',
            'difficulty': 'medium',
            'question': r'Calculate bending stress: $$M = 1000$$ Nm, $$y = 0.05$$ m, $$I = 0.0001$$ m$$^4$$. Formula: $$\sigma = \frac{My}{I}$$',
            'correct_answer': '500 kPa',
            'incorrect_answers': ['1000 kPa', '250 kPa', '50 kPa'],
            'explanation': r'$$\sigma = \frac{1000 \times 0.05}{0.0001} = 500,000$$ Pa = 500 kPa',
            'type': 'multiple',
        },
        {
            'category': 'Engineering',
            'difficulty': 'hard',
            'question': r'What is the Euler buckling load formula for a column?',
            'correct_answer': r'$$P_{cr} = \frac{\pi^2 EI}{(KL)^2}$$',
            'incorrect_answers': [r'$$P_{cr} = \frac{EI}{L^2}$$', r'$$P_{cr} = \pi EI$$', r'$$P_{cr} = \frac{\pi EI}{L}$$'],
            'explanation': r'Euler buckling: $$P_{cr} = \frac{\pi^2 EI}{(KL)^2}$$ where $$K$$ is effective length factor.',
            'type': 'multiple',
        },
        {
            'category': 'Engineering',
            'difficulty': 'medium',
            'question': r'Calculate shear stress: Force = 5000N, Area = 0.01 m$$^2$$. Formula: $$\tau = \frac{F}{A}$$',
            'correct_answer': '500 kPa',
            'incorrect_answers': ['50 kPa', '5000 kPa', '5 MPa'],
            'explanation': r'$$\tau = \frac{5000}{0.01} = 500,000$$ Pa = 500 kPa',
            'type': 'multiple',
        },
    ]
    
    # ========================================
    # ENGINEERING - CHEMICAL
    # ========================================
    eng_chemical = [
        {
            'category': 'Engineering',
            'difficulty': 'medium',
            'question': r'What is the ideal gas law?',
            'correct_answer': r'$$PV = nRT$$',
            'incorrect_answers': [r'$$PV = RT$$', r'$$P = nRT$$', r'$$V = \frac{nRT}{P^2}$$'],
            'explanation': r'Ideal gas law: $$PV = nRT$$ where $$P$$ = pressure, $$V$$ = volume, $$n$$ = moles, $$R$$ = gas constant, $$T$$ = temperature',
            'type': 'multiple',
        },
        {
            'category': 'Engineering',
            'difficulty': 'hard',
            'question': r'What is the Arrhenius equation for reaction rate?',
            'correct_answer': r'$$k = Ae^{-E_a/RT}$$',
            'incorrect_answers': [r'$$k = Ae^{E_a/RT}$$', r'$$k = A\ln(E_a/RT)$$', r'$$k = \frac{A}{E_a}RT$$'],
            'explanation': r'Arrhenius equation: $$k = Ae^{-E_a/RT}$$ where $$E_a$$ is activation energy.',
            'type': 'multiple',
        },
        {
            'category': 'Engineering',
            'difficulty': 'medium',
            'question': r'Calculate molar mass of water (H$$_2$$O). H = 1 g/mol, O = 16 g/mol',
            'correct_answer': '18 g/mol',
            'incorrect_answers': ['17 g/mol', '20 g/mol', '16 g/mol'],
            'explanation': r'H$$_2$$O: $$2(1) + 16 = 18$$ g/mol',
            'type': 'multiple',
        },
    ]
    
    # ========================================
    # ENGINEERING - COMPUTER/SOFTWARE
    # ========================================
    eng_computer = [
        {
            'category': 'Engineering',
            'difficulty': 'medium',
            'question': r'What is the time complexity of binary search?',
            'correct_answer': r'$$O(\log n)$$',
            'incorrect_answers': [r'$$O(n)$$', r'$$O(n^2)$$', r'$$O(1)$$'],
            'explanation': r'Binary search halves the search space each iteration, giving $$O(\log n)$$ complexity.',
            'type': 'multiple',
        },
        {
            'category': 'Engineering',
            'difficulty': 'hard',
            'question': r'What is the Shannon entropy formula?',
            'correct_answer': r'$$H(X) = -\sum p(x)\log_2 p(x)$$',
            'incorrect_answers': [r'$$H(X) = \sum p(x)$$', r'$$H(X) = \log_2 n$$', r'$$H(X) = -\log_2 p(x)$$'],
            'explanation': r'Shannon entropy measures information content: $$H(X) = -\sum p(x)\log_2 p(x)$$',
            'type': 'multiple',
        },
        {
            'category': 'Engineering',
            'difficulty': 'medium',
            'question': r'How many bits in 1 byte?',
            'correct_answer': '8',
            'incorrect_answers': ['16', '4', '32'],
            'explanation': r'1 byte = 8 bits. This is a fundamental unit in computer science.',
            'type': 'multiple',
        },
    ]
    
    # Combine all questions
    questions.extend(math_calculus)
    questions.extend(math_linear_algebra)
    questions.extend(math_diff_eq)
    questions.extend(math_stats)
    questions.extend(eng_electrical)
    questions.extend(eng_mechanical)
    questions.extend(eng_civil)
    questions.extend(eng_chemical)
    questions.extend(eng_computer)
    
    return questions

def append_to_file():
    questions = generate_questions()
    
    # Read current file
    with open('/Users/seleemaleshinloye/quiz-app/quiz_app/lib/screens/local_questions.dart', 'r') as f:
        content = f.read()
    
    # Remove closing ];
    content = content.rstrip()
    if content.endswith('];'):
        content = content[:-2]
    
    # Build new questions string
    new_content = '\n  ,\n  // ========================================\n  // ADVANCED MATHEMATICS & ENGINEERING\n  // ========================================\n'
    
    for q in questions:
        new_content += '  {\n'
        new_content += f"    'category': '{q['category']}',\n"
        new_content += f"    'difficulty': '{q['difficulty']}',\n"
        
        # Handle question - it's already a raw string from the dict
        new_content += f"    'question': {q['question']},\n"
        
        # Handle correct_answer - it's already formatted
        new_content += f"    'correct_answer': {q['correct_answer']},\n"
        
        # Handle incorrect_answers - it's already a list
        new_content += f"    'incorrect_answers': {q['incorrect_answers']},\n"
        
        # Handle explanation - it's already a raw string
        new_content += f"    'explanation': {q['explanation']},\n"
        
        new_content += f"    'type': '{q['type']}',\n"
        new_content += '  },\n'
    
    # Add closing
    new_content += '];\n'
    
    # Write back
    with open('/Users/seleemaleshinloye/quiz-app/quiz_app/lib/screens/local_questions.dart', 'w') as f:
        f.write(content + new_content)
    
    print(f"✅ Added {len(questions)} advanced Math & Engineering questions!")
    print(f"   - Mathematics: Calculus, Linear Algebra, Diff Eq, Statistics")
    print(f"   - Engineering: Electrical, Mechanical, Civil, Chemical, Computer")

if __name__ == "__main__":
    append_to_file()
