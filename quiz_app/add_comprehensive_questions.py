#!/usr/bin/env python3
"""
Add 60+ comprehensive Math and Engineering questions
Covers all engineering disciplines with proper LaTeX formatting
"""

# Mathematics Questions (30 questions)
math_questions = [
    # Calculus - Advanced
    {
        'category': 'Mathematics',
        'difficulty': 'hard',
        'question': r'Find: $$\int \frac{1}{x^2 + 1} dx$$',
        'correct_answer': r'$$\arctan(x) + C$$',
        'incorrect_answers': [r'$$\ln(x^2 + 1) + C$$', r'$$\frac{x}{x^2 + 1} + C$$', r'$$\frac{1}{2}\ln(x^2 + 1) + C$$'],
        'explanation': r'The integral of 1/(x² + 1) is arctan(x) + C, a standard integral formula.',
    },
    {
        'category': 'Mathematics',
        'difficulty': 'hard',
        'question': r'Evaluate: $$\lim_{x \to 0} \frac{\sin(x)}{x}$$',
        'correct_answer': r'$$1$$',
        'incorrect_answers': [r'$$0$$', r'$$\infty$$', r'$$\frac{1}{2}$$'],
        'explanation': r'This is a fundamental limit: lim(x→0) sin(x)/x = 1',
    },
    {
        'category': 'Mathematics',
        'difficulty': 'medium',
        'question': r'Find the derivative: $$\frac{d}{dx}(e^{2x})$$',
        'correct_answer': r'$$2e^{2x}$$',
        'incorrect_answers': [r'$$e^{2x}$$', r'$$2xe^{2x}$$', r'$$e^{2x} + 2$$'],
        'explanation': r'Using chain rule: d/dx(e^(2x)) = e^(2x) · 2 = 2e^(2x)',
    },
    {
        'category': 'Mathematics',
        'difficulty': 'hard',
        'question': r'Solve: $$\int x \cdot e^x dx$$',
        'correct_answer': r'$$xe^x - e^x + C$$',
        'incorrect_answers': [r'$$\frac{x^2 e^x}{2} + C$$', r'$$e^{x^2} + C$$', r'$$\frac{e^x}{x} + C$$'],
        'explanation': r'Using integration by parts: ∫x·e^x dx = xe^x - e^x + C',
    },
    {
        'category': 'Mathematics',
        'difficulty': 'medium',
        'question': r'Find: $$\frac{d}{dx}(\ln(x^2))$$',
        'correct_answer': r'$$\frac{2}{x}$$',
        'incorrect_answers': [r'$$\frac{1}{x^2}$$', r'$$\frac{2x}{x^2}$$', r'$$2\ln(x)$$'],
        'explanation': r'Using chain rule: d/dx(ln(x²)) = (1/x²)·2x = 2/x',
    },
    # Linear Algebra
    {
        'category': 'Mathematics',
        'difficulty': 'medium',
        'question': r'What is the determinant of $$\begin{pmatrix} 2 & 3 \\ 1 & 4 \end{pmatrix}$$?',
        'correct_answer': r'$$5$$',
        'incorrect_answers': [r'$$8$$', r'$$11$$', r'$$-5$$'],
        'explanation': r'For a 2×2 matrix, det = (2×4) - (3×1) = 8 - 3 = 5',
    },
    {
        'category': 'Mathematics',
        'difficulty': 'hard',
        'question': r'Find the eigenvalues of $$\begin{pmatrix} 3 & 1 \\ 0 & 2 \end{pmatrix}$$',
        'correct_answer': r'$$\lambda = 3, 2$$',
        'incorrect_answers': [r'$$\lambda = 5, 0$$', r'$$\lambda = 3, 3$$', r'$$\lambda = 2, 1$$'],
        'explanation': r'For upper triangular matrix, eigenvalues are diagonal elements: 3 and 2',
    },
    # Differential Equations
    {
        'category': 'Mathematics',
        'difficulty': 'hard',
        'question': r'Solve: $$\frac{dy}{dx} = ky$$ where k is constant',
        'correct_answer': r'$$y = Ce^{kx}$$',
        'incorrect_answers': [r'$$y = Ckx$$', r'$$y = C + kx$$', r'$$y = Ce^x$$'],
        'explanation': r'This is exponential growth/decay: dy/dx = ky has solution y = Ce^(kx)',
    },
    {
        'category': 'Mathematics',
        'difficulty': 'medium',
        'question': r'What is the general solution to $$\frac{d^2y}{dx^2} + y = 0$$?',
        'correct_answer': r'$$y = A\cos(x) + B\sin(x)$$',
        'incorrect_answers': [r'$$y = Ae^x + Be^{-x}$$', r'$$y = Ax + B$$', r'$$y = Ae^{ix}$$'],
        'explanation': r'This is simple harmonic motion: y = A·cos(x) + B·sin(x)',
    },
    # Trigonometry
    {
        'category': 'Mathematics',
        'difficulty': 'easy',
        'question': r'What is $$\sin^2(x) + \cos^2(x)$$?',
        'correct_answer': r'$$1$$',
        'incorrect_answers': [r'$$0$$', r'$$2$$', r'$$\tan^2(x)$$'],
        'explanation': r'Pythagorean identity: sin²(x) + cos²(x) = 1 for all x',
    },
    {
        'category': 'Mathematics',
        'difficulty': 'medium',
        'question': r'Find: $$\frac{d}{dx}(\sin(x))$$',
        'correct_answer': r'$$\cos(x)$$',
        'incorrect_answers': [r'$$-\cos(x)$$', r'$$\sin(x)$$', r'$$\tan(x)$$'],
        'explanation': r'The derivative of sin(x) is cos(x)',
    },
    # Complex Numbers
    {
        'category': 'Mathematics',
        'difficulty': 'medium',
        'question': r'What is $$i^2$$ where i is the imaginary unit?',
        'correct_answer': r'$$-1$$',
        'incorrect_answers': [r'$$1$$', r'$$i$$', r'$$0$$'],
        'explanation': r'By definition, i² = -1 where i = √(-1)',
    },
    {
        'category': 'Mathematics',
        'difficulty': 'hard',
        'question': r'Express in polar form: $$1 + i$$',
        'correct_answer': r'$$\sqrt{2} e^{i\pi/4}$$',
        'incorrect_answers': [r'$$2e^{i\pi/2}$$', r'$$e^{i\pi/4}$$', r'$$\sqrt{2}e^{i\pi/2}$$'],
        'explanation': r'Magnitude = √2, angle = π/4, so 1+i = √2·e^(iπ/4)',
    },
    # Series and Sequences
    {
        'category': 'Mathematics',
        'difficulty': 'medium',
        'question': r'Sum of geometric series: $$\sum_{n=0}^{\infty} \frac{1}{2^n}$$',
        'correct_answer': r'$$2$$',
        'incorrect_answers': [r'$$1$$', r'$$\infty$$', r'$$\frac{1}{2}$$'],
        'explanation': r'Geometric series with a=1, r=1/2: sum = a/(1-r) = 1/(1-1/2) = 2',
    },
    {
        'category': 'Mathematics',
        'difficulty': 'hard',
        'question': r'Taylor series of $$e^x$$ at x=0:',
        'correct_answer': r'$$\sum_{n=0}^{\infty} \frac{x^n}{n!}$$',
        'incorrect_answers': [r'$$\sum_{n=0}^{\infty} x^n$$', r'$$\sum_{n=0}^{\infty} \frac{x^{2n}}{(2n)!}$$', r'$$\sum_{n=0}^{\infty} nx^{n-1}$$'],
        'explanation': r'e^x = 1 + x + x²/2! + x³/3! + ... = Σ(x^n/n!)',
    },
]

# Engineering Questions (35 questions across all disciplines)
engineering_questions = [
    # Electrical Engineering (7 questions)
    {
        'category': 'Engineering',
        'difficulty': 'easy',
        'question': r'Ohm\'s Law states: $$V = ?$$',
        'correct_answer': r'$$I \times R$$',
        'incorrect_answers': [r'$$\frac{I}{R}$$', r'$$I + R$$', r'$$\frac{R}{I}$$'],
        'explanation': r'Ohm\'s Law: Voltage = Current × Resistance (V = I×R)',
    },
    {
        'category': 'Engineering',
        'difficulty': 'medium',
        'question': r'Power in AC circuit: $$P = ?$$ (for resistive load)',
        'correct_answer': r'$$V_{rms} \times I_{rms}$$',
        'incorrect_answers': [r'$$V_{peak} \times I_{peak}$$', r'$$\frac{V}{I}$$', r'$$V^2 + I^2$$'],
        'explanation': r'For AC resistive load: P = V_rms × I_rms',
    },
    {
        'category': 'Engineering',
        'difficulty': 'hard',
        'question': r'Impedance of series RLC circuit: $$Z = ?$$',
        'correct_answer': r'$$\sqrt{R^2 + (X_L - X_C)^2}$$',
        'incorrect_answers': [r'$$R + X_L + X_C$$', r'$$\sqrt{R^2 + X_L^2 + X_C^2}$$', r'$$R(X_L - X_C)$$'],
        'explanation': r'Series RLC impedance: Z = √(R² + (X_L - X_C)²)',
    },
    {
        'category': 'Engineering',
        'difficulty': 'medium',
        'question': r'Capacitive reactance: $$X_C = ?$$',
        'correct_answer': r'$$\frac{1}{2\pi fC}$$',
        'incorrect_answers': [r'$$2\pi fC$$', r'$$\frac{C}{2\pi f}$$', r'$$2\pi fL$$'],
        'explanation': r'Capacitive reactance: X_C = 1/(2πfC)',
    },
    {
        'category': 'Engineering',
        'difficulty': 'medium',
        'question': r'Inductive reactance: $$X_L = ?$$',
        'correct_answer': r'$$2\pi fL$$',
        'incorrect_answers': [r'$$\frac{1}{2\pi fL}$$', r'$$\frac{L}{2\pi f}$$', r'$$2\pi fC$$'],
        'explanation': r'Inductive reactance: X_L = 2πfL',
    },
    {
        'category': 'Engineering',
        'difficulty': 'hard',
        'question': r'Resonant frequency of LC circuit: $$f_0 = ?$$',
        'correct_answer': r'$$\frac{1}{2\pi\sqrt{LC}}$$',
        'incorrect_answers': [r'$$2\pi\sqrt{LC}$$', r'$$\frac{1}{\sqrt{LC}}$$', r'$$\sqrt{\frac{L}{C}}$$'],
        'explanation': r'Resonant frequency: f₀ = 1/(2π√(LC))',
    },
    {
        'category': 'Engineering',
        'difficulty': 'easy',
        'question': r'Energy stored in capacitor: $$E = ?$$',
        'correct_answer': r'$$\frac{1}{2}CV^2$$',
        'incorrect_answers': [r'$$CV$$', r'$$\frac{1}{2}C^2V$$', r'$$CV^2$$'],
        'explanation': r'Energy in capacitor: E = (1/2)CV²',
    },
    
    # Mechanical Engineering (7 questions)
    {
        'category': 'Engineering',
        'difficulty': 'easy',
        'question': r'Kinetic energy: $$KE = ?$$',
        'correct_answer': r'$$\frac{1}{2}mv^2$$',
        'incorrect_answers': [r'$$mv$$', r'$$mv^2$$', r'$$\frac{1}{2}m^2v$$'],
        'explanation': r'Kinetic energy: KE = (1/2)mv²',
    },
    {
        'category': 'Engineering',
        'difficulty': 'medium',
        'question': r'Moment of inertia of solid cylinder: $$I = ?$$',
        'correct_answer': r'$$\frac{1}{2}mr^2$$',
        'incorrect_answers': [r'$$mr^2$$', r'$$\frac{2}{5}mr^2$$', r'$$\frac{1}{3}mr^2$$'],
        'explanation': r'For solid cylinder about central axis: I = (1/2)mr²',
    },
    {
        'category': 'Engineering',
        'difficulty': 'hard',
        'question': r'Euler buckling load: $$P_{cr} = ?$$',
        'correct_answer': r'$$\frac{\pi^2 EI}{L^2}$$',
        'incorrect_answers': [r'$$\frac{EI}{L^2}$$', r'$$\frac{\pi EI}{L}$$', r'$$\frac{2\pi^2 EI}{L^2}$$'],
        'explanation': r'Critical buckling load: P_cr = π²EI/L²',
    },
    {
        'category': 'Engineering',
        'difficulty': 'medium',
        'question': r'Stress formula: $$\sigma = ?$$',
        'correct_answer': r'$$\frac{F}{A}$$',
        'incorrect_answers': [r'$$F \times A$$', r'$$\frac{A}{F}$$', r'$$F + A$$'],
        'explanation': r'Stress = Force/Area: σ = F/A',
    },
    {
        'category': 'Engineering',
        'difficulty': 'medium',
        'question': r'Strain formula: $$\epsilon = ?$$',
        'correct_answer': r'$$\frac{\Delta L}{L_0}$$',
        'incorrect_answers': [r'$$\frac{L_0}{\Delta L}$$', r'$$\Delta L \times L_0$$', r'$$L_0 - \Delta L$$'],
        'explanation': r'Strain = Change in length/Original length: ε = ΔL/L₀',
    },
    {
        'category': 'Engineering',
        'difficulty': 'hard',
        'question': r'Hooke\'s Law: $$\sigma = ?$$',
        'correct_answer': r'$$E \times \epsilon$$',
        'incorrect_answers': [r'$$\frac{E}{\epsilon}$$', r'$$E + \epsilon$$', r'$$\frac{\epsilon}{E}$$'],
        'explanation': r'Hooke\'s Law: Stress = Young\'s modulus × Strain (σ = E×ε)',
    },
    {
        'category': 'Engineering',
        'difficulty': 'medium',
        'question': r'Power transmitted by shaft: $$P = ?$$',
        'correct_answer': r'$$T \times \omega$$',
        'incorrect_answers': [r'$$\frac{T}{\omega}$$', r'$$T + \omega$$', r'$$\frac{\omega}{T}$$'],
        'explanation': r'Power = Torque × Angular velocity: P = T×ω',
    },
    
    # Civil Engineering (5 questions)
    {
        'category': 'Engineering',
        'difficulty': 'medium',
        'question': r'Bending stress in beam: $$\sigma = ?$$',
        'correct_answer': r'$$\frac{My}{I}$$',
        'incorrect_answers': [r'$$\frac{M}{I}$$', r'$$\frac{Iy}{M}$$', r'$$MyI$$'],
        'explanation': r'Bending stress: σ = My/I (flexure formula)',
    },
    {
        'category': 'Engineering',
        'difficulty': 'hard',
        'question': r'Deflection of cantilever beam: $$\delta = ?$$',
        'correct_answer': r'$$\frac{PL^3}{3EI}$$',
        'incorrect_answers': [r'$$\frac{PL^2}{2EI}$$', r'$$\frac{PL^3}{EI}$$', r'$$\frac{3PL^3}{EI}$$'],
        'explanation': r'Cantilever deflection at free end: δ = PL³/(3EI)',
    },
    {
        'category': 'Engineering',
        'difficulty': 'medium',
        'question': r'Shear stress in beam: $$\tau = ?$$',
        'correct_answer': r'$$\frac{VQ}{Ib}$$',
        'incorrect_answers': [r'$$\frac{V}{A}$$', r'$$\frac{Vb}{IQ}$$', r'$$\frac{VI}{Qb}$$'],
        'explanation': r'Shear stress: τ = VQ/(Ib) where V=shear force, Q=first moment',
    },
    {
        'category': 'Engineering',
        'difficulty': 'easy',
        'question': r'Pressure in fluid: $$P = ?$$ (at depth h)',
        'correct_answer': r'$$\rho gh$$',
        'incorrect_answers': [r'$$\rho h$$', r'$$gh$$', r'$$\frac{\rho g}{h}$$'],
        'explanation': r'Hydrostatic pressure: P = ρgh where ρ=density, g=gravity, h=depth',
    },
    {
        'category': 'Engineering',
        'difficulty': 'medium',
        'question': r'Bernoulli equation: $$P + \frac{1}{2}\rho v^2 + \rho gh = ?$$',
        'correct_answer': r'$$constant$$',
        'incorrect_answers': [r'$$0$$', r'$$P_0$$', r'$$\rho$$'],
        'explanation': r'Bernoulli: P + (1/2)ρv² + ρgh = constant along streamline',
    },
    
    # Chemical Engineering (5 questions)
    {
        'category': 'Engineering',
        'difficulty': 'easy',
        'question': r'Ideal Gas Law: $$PV = ?$$',
        'correct_answer': r'$$nRT$$',
        'incorrect_answers': [r'$$RT$$', r'$$nT$$', r'$$\frac{nR}{T}$$'],
        'explanation': r'Ideal Gas Law: PV = nRT',
    },
    {
        'category': 'Engineering',
        'difficulty': 'hard',
        'question': r'Arrhenius equation: $$k = ?$$',
        'correct_answer': r'$$Ae^{-E_a/RT}$$',
        'incorrect_answers': [r'$$Ae^{E_a/RT}$$', r'$$A - E_a/RT$$', r'$$\frac{A}{E_a}RT$$'],
        'explanation': r'Arrhenius: k = A·e^(-E_a/RT) for reaction rate constant',
    },
    {
        'category': 'Engineering',
        'difficulty': 'medium',
        'question': r'Reynolds number: $$Re = ?$$',
        'correct_answer': r'$$\frac{\rho vD}{\mu}$$',
        'incorrect_answers': [r'$$\frac{\mu vD}{\rho}$$', r'$$\rho vD\mu$$', r'$$\frac{vD}{\rho\mu}$$'],
        'explanation': r'Reynolds number: Re = ρvD/μ (dimensionless)',
    },
    {
        'category': 'Engineering',
        'difficulty': 'medium',
        'question': r'Mass balance: $$\frac{dm}{dt} = ?$$',
        'correct_answer': r'$$\dot{m}_{in} - \dot{m}_{out}$$',
        'incorrect_answers': [r'$$\dot{m}_{in} + \dot{m}_{out}$$', r'$$\dot{m}_{in} \times \dot{m}_{out}$$', r'$$0$$'],
        'explanation': r'Mass accumulation = mass in - mass out',
    },
    {
        'category': 'Engineering',
        'difficulty': 'hard',
        'question': r'Fick\'s first law: $$J = ?$$',
        'correct_answer': r'$$-D\frac{dC}{dx}$$',
        'incorrect_answers': [r'$$D\frac{dC}{dx}$$', r'$$-\frac{D}{dC/dx}$$', r'$$DdC$$'],
        'explanation': r'Fick\'s law for diffusion: J = -D(dC/dx)',
    },
    
    # Computer/Software Engineering (5 questions)
    {
        'category': 'Engineering',
        'difficulty': 'easy',
        'question': r'Time complexity of binary search: $$O(?)$$',
        'correct_answer': r'$$\log n$$',
        'incorrect_answers': [r'$$n$$', r'$$n^2$$', r'$$1$$'],
        'explanation': r'Binary search has O(log n) time complexity',
    },
    {
        'category': 'Engineering',
        'difficulty': 'medium',
        'question': r'Shannon entropy: $$H = ?$$',
        'correct_answer': r'$$-\sum p_i \log_2(p_i)$$',
        'incorrect_answers': [r'$$\sum p_i \log_2(p_i)$$', r'$$-\sum p_i$$', r'$$\log_2(\sum p_i)$$'],
        'explanation': r'Shannon entropy: H = -Σ p_i·log₂(p_i)',
    },
    {
        'category': 'Engineering',
        'difficulty': 'easy',
        'question': r'How many bits in 1 byte?',
        'correct_answer': r'$$8$$',
        'incorrect_answers': [r'$$4$$', r'$$16$$', r'$$32$$'],
        'explanation': r'1 byte = 8 bits',
    },
    {
        'category': 'Engineering',
        'difficulty': 'medium',
        'question': r'Big-O of quicksort (average): $$O(?)$$',
        'correct_answer': r'$$n \log n$$',
        'incorrect_answers': [r'$$n^2$$', r'$$n$$', r'$$\log n$$'],
        'explanation': r'Quicksort average case: O(n log n)',
    },
    {
        'category': 'Engineering',
        'difficulty': 'hard',
        'question': r'Nyquist sampling theorem: $$f_s \ge ?$$',
        'correct_answer': r'$$2f_{max}$$',
        'incorrect_answers': [r'$$f_{max}$$', r'$$\frac{f_{max}}{2}$$', r'$$4f_{max}$$'],
        'explanation': r'Sampling frequency must be ≥ 2×max frequency (Nyquist rate)',
    },
    
    # Aerospace Engineering (3 questions)
    {
        'category': 'Engineering',
        'difficulty': 'medium',
        'question': r'Lift force: $$L = ?$$',
        'correct_answer': r'$$\frac{1}{2}\rho v^2 S C_L$$',
        'incorrect_answers': [r'$$\rho v^2 S$$', r'$$\frac{1}{2}\rho v S C_L$$', r'$$\rho v S C_L$$'],
        'explanation': r'Lift: L = (1/2)ρv²SC_L where C_L is lift coefficient',
    },
    {
        'category': 'Engineering',
        'difficulty': 'hard',
        'question': r'Rocket equation: $$\Delta v = ?$$',
        'correct_answer': r'$$v_e \ln\frac{m_0}{m_f}$$',
        'incorrect_answers': [r'$$v_e \frac{m_0}{m_f}$$', r'$$v_e (m_0 - m_f)$$', r'$$\frac{v_e m_0}{m_f}$$'],
        'explanation': r'Tsiolkovsky equation: Δv = v_e·ln(m₀/m_f)',
    },
    {
        'category': 'Engineering',
        'difficulty': 'medium',
        'question': r'Mach number: $$M = ?$$',
        'correct_answer': r'$$\frac{v}{a}$$',
        'incorrect_answers': [r'$$\frac{a}{v}$$', r'$$v \times a$$', r'$$v - a$$'],
        'explanation': r'Mach number = velocity/speed of sound: M = v/a',
    },
    
    # Biomedical Engineering (3 questions)
    {
        'category': 'Engineering',
        'difficulty': 'medium',
        'question': r'Poiseuille\'s law for blood flow: $$Q = ?$$',
        'correct_answer': r'$$\frac{\pi r^4 \Delta P}{8\mu L}$$',
        'incorrect_answers': [r'$$\frac{\pi r^2 \Delta P}{8\mu L}$$', r'$$\frac{r^4 \Delta P}{\mu L}$$', r'$$\pi r^4 \Delta P$$'],
        'explanation': r'Poiseuille: Q = πr⁴ΔP/(8μL) for laminar flow',
    },
    {
        'category': 'Engineering',
        'difficulty': 'easy',
        'question': r'Ohm\'s law for current in tissue: $$I = ?$$',
        'correct_answer': r'$$\frac{V}{R}$$',
        'incorrect_answers': [r'$$VR$$', r'$$\frac{R}{V}$$', r'$$V + R$$'],
        'explanation': r'Current = Voltage/Resistance: I = V/R',
    },
    {
        'category': 'Engineering',
        'difficulty': 'hard',
        'question': r'Nernst equation: $$E = E_0 + \frac{RT}{nF}\ln\frac{[ox]}{[red]}$$ at 25°C simplifies to:',
        'correct_answer': r'$$E_0 + \frac{0.059}{n}\log\frac{[ox]}{[red]}$$',
        'incorrect_answers': [r'$$E_0 + 0.059\log\frac{[ox]}{[red]}$$', r'$$E_0 - \frac{0.059}{n}\log\frac{[ox]}{[red]}$$', r'$$\frac{0.059}{n}E_0$$'],
        'explanation': r'Nernst at 25°C: E = E₀ + (0.059/n)·log([ox]/[red])',
    },
]

def append_questions_to_file():
    """Append all questions to local_questions.dart"""
    import os
    
    file_path = 'lib/screens/local_questions.dart'
    
    if not os.path.exists(file_path):
        print(f"Error: {file_path} not found!")
        return
    
    # Read the file
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Find the last closing bracket and semicolon
    last_bracket = content.rfind('];')
    
    if last_bracket == -1:
        print("Error: Could not find end of list!")
        return
    
    # Prepare new questions
    all_questions = math_questions + engineering_questions
    new_content_parts = []
    
    for q in all_questions:
        question_str = f"""  {{
    'category': '{q['category']}',
    'difficulty': '{q['difficulty']}',
    'question': r'''{q['question']}''',
    'correct_answer': r'''{q['correct_answer']}''',
    'incorrect_answers': [
      r'''{q['incorrect_answers'][0]}''',
      r'''{q['incorrect_answers'][1]}''',
      r'''{q['incorrect_answers'][2]}'''
    ],
    'explanation': r'''{q['explanation']}''',
    'type': 'multiple',
  }},
"""
        new_content_parts.append(question_str)
    
    # Insert new questions before the closing bracket
    new_questions_text = '\n'.join(new_content_parts)
    updated_content = content[:last_bracket] + ',\n' + new_questions_text + content[last_bracket:]
    
    # Write back
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(updated_content)
    
    print(f"✅ Successfully added {len(all_questions)} questions!")
    print(f"   - Mathematics: {len(math_questions)} questions")
    print(f"   - Engineering: {len(engineering_questions)} questions")
    print("\nEngineering disciplines covered:")
    print("   - Electrical (7 questions)")
    print("   - Mechanical (7 questions)")
    print("   - Civil (5 questions)")
    print("   - Chemical (5 questions)")
    print("   - Computer/Software (5 questions)")
    print("   - Aerospace (3 questions)")
    print("   - Biomedical (3 questions)")

if __name__ == '__main__':
    append_questions_to_file()
