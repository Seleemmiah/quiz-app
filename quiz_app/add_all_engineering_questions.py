#!/usr/bin/env python3
"""
Add comprehensive engineering questions - ALL disciplines
Target: 20+ questions per discipline
"""

import sys
sys.path.append('.')

all_new_questions = []

# Import part 1 questions
exec(open('add_engineering_questions_part1.py').read())
all_new_questions.extend(new_questions)

# ========== COMPUTER ENGINEERING (Add 15 more) ==========
computer_questions = [
    {
        'category': 'Computer Engineering',
        'difficulty': 'medium',
        'question': r'Time complexity of merge sort: $$O(?)$$',
        'correct_answer': r'$$n \log n$$',
        'incorrect_answers': [r'$$n^2$$', r'$$n$$', r'$$\log n$$'],
        'explanation': r'Merge sort: O(n log n) in all cases',
    },
    {
        'category': 'Computer Engineering',
        'difficulty': 'hard',
        'question': r'Master theorem for $$T(n) = aT(n/b) + f(n)$$:',
        'correct_answer': r'Compare $$f(n)$$ with $$n^{\log_b a}$$',
        'incorrect_answers': [r'Always $$O(n \log n)$$', r'Always $$O(n^2)$$', r'Sum all terms'],
        'explanation': r'Master theorem compares f(n) with n^(log_b a) to determine complexity',
    },
    {
        'category': 'Computer Engineering',
        'difficulty': 'easy',
        'question': r'Boolean algebra: $$A + \overline{A} = ?$$',
        'correct_answer': r'$$1$$',
        'incorrect_answers': [r'$$0$$', r'$$A$$', r'$$\overline{A}$$'],
        'explanation': r'Complement law: A + Ā = 1',
    },
    {
        'category': 'Computer Engineering',
        'difficulty': 'easy',
        'question': r'De Morgan\'s Law: $$\overline{A \cdot B} = ?$$',
        'correct_answer': r'$$\overline{A} + \overline{B}$$',
        'incorrect_answers': [r'$$\overline{A} \cdot \overline{B}$$', r'$$A + B$$', r'$$A \cdot B$$'],
        'explanation': r'De Morgan: NOT(A AND B) = (NOT A) OR (NOT B)',
    },
    {
        'category': 'Computer Engineering',
        'difficulty': 'medium',
        'question': r'Cache hit rate formula: $$H = ?$$',
        'correct_answer': r'$$\frac{hits}{hits + misses}$$',
        'incorrect_answers': [r'$$\frac{misses}{hits}$$', r'$$hits - misses$$', r'$$\frac{hits}{misses}$$'],
        'explanation': r'Hit rate = hits / total accesses',
    },
    {
        'category': 'Computer Engineering',
        'difficulty': 'hard',
        'question': r'Amdahl\'s Law speedup: $$S = ?$$',
        'correct_answer': r'$$\frac{1}{(1-P) + P/N}$$',
        'incorrect_answers': [r'$$N$$', r'$$\frac{N}{P}$$', r'$$1 + P \times N$$'],
        'explanation': r'Amdahl: S = 1/[(1-P) + P/N] where P=parallel fraction, N=processors',
    },
    {
        'category': 'Computer Engineering',
        'difficulty': 'medium',
        'question': r'CPI (Cycles Per Instruction): $$CPI = ?$$',
        'correct_answer': r'$$\frac{cycles}{instructions}$$',
        'incorrect_answers': [r'$$\frac{instructions}{cycles}$$', r'$$cycles \times instructions$$', r'$$\frac{time}{cycles}$$'],
        'explanation': r'CPI = total cycles / instruction count',
    },
    {
        'category': 'Computer Engineering',
        'difficulty': 'easy',
        'question': r'CPU time: $$T = ?$$',
        'correct_answer': r'$$IC \times CPI \times T_{cycle}$$',
        'incorrect_answers': [r'$$\frac{IC}{CPI}$$', r'$$IC + CPI$$', r'$$\frac{CPI}{IC}$$'],
        'explanation': r'CPU time = instruction count × CPI × clock cycle time',
    },
    {
        'category': 'Computer Engineering',
        'difficulty': 'medium',
        'question': r'Hamming distance between 1010 and 1100:',
        'correct_answer': r'$$2$$',
        'incorrect_answers': [r'$$1$$', r'$$3$$', r'$$4$$'],
        'explanation': r'Hamming distance = number of bit positions that differ (2 bits)',
    },
    {
        'category': 'Computer Engineering',
        'difficulty': 'hard',
        'question': r'Parity bits needed for Hamming code (n data bits): $$p = ?$$',
        'correct_answer': r'$$\lceil \log_2(n+p+1) \rceil$$',
        'incorrect_answers': [r'$$n/2$$', r'$$\log_2 n$$', r'$$n$$'],
        'explanation': r'Hamming: 2^p ≥ n + p + 1, solve for p',
    },
    {
        'category': 'Computer Engineering',
        'difficulty': 'medium',
        'question': r'Throughput: $$\lambda = ?$$',
        'correct_answer': r'$$\frac{1}{service\_time}$$',
        'incorrect_answers': [r'$$service\_time$$', r'$$\frac{1}{arrival\_rate}$$', r'$$queue\_length$$'],
        'explanation': r'Throughput = 1/service time (requests per unit time)',
    },
    {
        'category': 'Computer Engineering',
        'difficulty': 'easy',
        'question': r'IPv4 address size:',
        'correct_answer': r'$$32$$ bits',
        'incorrect_answers': [r'$$16$$ bits', r'$$64$$ bits', r'$$128$$ bits'],
        'explanation': r'IPv4 uses 32-bit addresses (4 octets)',
    },
    {
        'category': 'Computer Engineering',
        'difficulty': 'medium',
        'question': r'Little\'s Law: $$L = ?$$',
        'correct_answer': r'$$\lambda W$$',
        'incorrect_answers': [r'$$\frac{\lambda}{W}$$', r'$$\lambda + W$$', r'$$\frac{W}{\lambda}$$'],
        'explanation': r'Little: L = λW (avg items = arrival rate × avg wait time)',
    },
    {
        'category': 'Computer Engineering',
        'difficulty': 'hard',
        'question': r'Channel capacity (Shannon): $$C = ?$$',
        'correct_answer': r'$$B \log_2(1 + SNR)$$',
        'incorrect_answers': [r'$$B \times SNR$$', r'$$\log_2(B \times SNR)$$', r'$$\frac{B}{SNR}$$'],
        'explanation': r'Shannon capacity: C = B·log₂(1+SNR) bits/sec',
    },
    {
        'category': 'Computer Engineering',
        'difficulty': 'medium',
        'question': r'MIPS (Million Instructions Per Second): $$MIPS = ?$$',
        'correct_answer': r'$$\frac{IC}{T \times 10^6}$$',
        'incorrect_answers': [r'$$\frac{T}{IC}$$', r'$$IC \times T$$', r'$$\frac{10^6}{IC}$$'],
        'explanation': r'MIPS = instruction count / (time × 10⁶)',
    },
]

# ========== AEROSPACE ENGINEERING (Add 18 more) ==========
aerospace_questions = [
    {
        'category': 'Aerospace Engineering',
        'difficulty': 'medium',
        'question': r'Drag force: $$D = ?$$',
        'correct_answer': r'$$\frac{1}{2}\rho v^2 S C_D$$',
        'incorrect_answers': [r'$$\rho v^2 S$$', r'$$\frac{1}{2}\rho v S C_D$$', r'$$C_D \rho v$$'],
        'explanation': r'Drag: D = (1/2)ρv²SC_D where C_D is drag coefficient',
    },
    {
        'category': 'Aerospace Engineering',
        'difficulty': 'hard',
        'question': r'Lift-to-drag ratio: $$L/D = ?$$',
        'correct_answer': r'$$\frac{C_L}{C_D}$$',
        'incorrect_answers': [r'$$C_L \times C_D$$', r'$$\frac{C_D}{C_L}$$', r'$$C_L + C_D$$'],
        'explanation': r'L/D ratio = C_L/C_D (aerodynamic efficiency)',
    },
    {
        'category': 'Aerospace Engineering',
        'difficulty': 'medium',
        'question': r'Thrust-to-weight ratio: $$T/W = ?$$',
        'correct_answer': r'$$\frac{T}{mg}$$',
        'incorrect_answers': [r'$$\frac{mg}{T}$$', r'$$T \times mg$$', r'$$T - mg$$'],
        'explanation': r'T/W = thrust / weight (acceleration capability)',
    },
    {
        'category': 'Aerospace Engineering',
        'difficulty': 'easy',
        'question': r'Standard atmosphere pressure at sea level:',
        'correct_answer': r'$$101.325$$ kPa',
        'incorrect_answers': [r'$$100$$ kPa', r'$$1$$ atm = $$10$$ kPa', r'$$1000$$ kPa'],
        'explanation': r'Standard pressure: 101.325 kPa = 1 atm',
    },
    {
        'category': 'Aerospace Engineering',
        'difficulty': 'hard',
        'question': r'Specific impulse: $$I_{sp} = ?$$',
        'correct_answer': r'$$\frac{v_e}{g_0}$$',
        'incorrect_answers': [r'$$v_e \times g_0$$', r'$$\frac{g_0}{v_e}$$', r'$$v_e - g_0$$'],
        'explanation': r'Specific impulse: I_sp = v_e/g₀ (exhaust velocity/gravity)',
    },
    {
        'category': 'Aerospace Engineering',
        'difficulty': 'medium',
        'question': r'Orbital velocity: $$v = ?$$',
        'correct_answer': r'$$\sqrt{\frac{GM}{r}}$$',
        'incorrect_answers': [r'$$\frac{GM}{r}$$', r'$$\sqrt{GMr}$$', r'$$\frac{r}{GM}$$'],
        'explanation': r'Circular orbit velocity: v = √(GM/r)',
    },
    {
        'category': 'Aerospace Engineering',
        'difficulty': 'hard',
        'question': r'Escape velocity: $$v_e = ?$$',
        'correct_answer': r'$$\sqrt{\frac{2GM}{r}}$$',
        'incorrect_answers': [r'$$\sqrt{\frac{GM}{r}}$$', r'$$\frac{2GM}{r}$$', r'$$2\sqrt{\frac{GM}{r}}$$'],
        'explanation': r'Escape velocity: v_e = √(2GM/r) = √2 × orbital velocity',
    },
    {
        'category': 'Aerospace Engineering',
        'difficulty': 'medium',
        'question': r'Wing loading: $$W/S = ?$$',
        'correct_answer': r'$$\frac{Weight}{Wing\_area}$$',
        'incorrect_answers': [r'$$Weight \times Wing\_area$$', r'$$\frac{Wing\_area}{Weight}$$', r'$$Weight - Wing\_area$$'],
        'explanation': r'Wing loading = aircraft weight / wing area',
    },
    {
        'category': 'Aerospace Engineering',
        'difficulty': 'easy',
        'question': r'Four forces on aircraft in level flight:',
        'correct_answer': r'Lift, Weight, Thrust, Drag',
        'incorrect_answers': [r'Only Lift and Weight', r'Only Thrust and Drag', r'Lift, Weight, Pressure'],
        'explanation': r'Four forces: Lift (up), Weight (down), Thrust (forward), Drag (back)',
    },
    {
        'category': 'Aerospace Engineering',
        'difficulty': 'hard',
        'question': r'Reynolds number for aircraft: $$Re = ?$$',
        'correct_answer': r'$$\frac{\rho v L}{\mu}$$',
        'incorrect_answers': [r'$$\frac{\mu v}{\rho L}$$', r'$$\rho v L \mu$$', r'$$\frac{v}{\rho \mu L}$$'],
        'explanation': r'Reynolds: Re = ρvL/μ (inertial/viscous forces)',
    },
    {
        'category': 'Aerospace Engineering',
        'difficulty': 'medium',
        'question': r'Stall occurs when:',
        'correct_answer': r'Angle of attack exceeds critical value',
        'incorrect_answers': [r'Speed is too high', r'Altitude is too low', r'Engine fails'],
        'explanation': r'Stall: airflow separates when angle of attack too large',
    },
    {
        'category': 'Aerospace Engineering',
        'difficulty': 'hard',
        'question': r'Prandtl-Glauert rule: $$C_{p,M} = ?$$',
        'correct_answer': r'$$\frac{C_{p,0}}{\sqrt{1-M^2}}$$',
        'incorrect_answers': [r'$$C_{p,0}\sqrt{1-M^2}$$', r'$$\frac{C_{p,0}}{1-M^2}$$', r'$$C_{p,0}(1-M^2)$$'],
        'explanation': r'Compressibility correction: C_p,M = C_p,0/√(1-M²)',
    },
    {
        'category': 'Aerospace Engineering',
        'difficulty': 'medium',
        'question': r'Aspect ratio: $$AR = ?$$',
        'correct_answer': r'$$\frac{b^2}{S}$$',
        'incorrect_answers': [r'$$\frac{S}{b^2}$$', r'$$b \times S$$', r'$$\frac{b}{S}$$'],
        'explanation': r'Aspect ratio: AR = b²/S (wingspan²/wing area)',
    },
    {
        'category': 'Aerospace Engineering',
        'difficulty': 'easy',
        'question': r'Bernoulli for incompressible flow: $$P + \frac{1}{2}\rho v^2 + \rho gh = ?$$',
        'correct_answer': r'$$constant$$',
        'incorrect_answers': [r'$$0$$', r'$$P_0$$', r'$$\rho$$'],
        'explanation': r'Bernoulli: P + (1/2)ρv² + ρgh = constant',
    },
    {
        'category': 'Aerospace Engineering',
        'difficulty': 'hard',
        'question': r'Hohmann transfer Δv total: $$\Delta v_{total} = ?$$',
        'correct_answer': r'$$\Delta v_1 + \Delta v_2$$',
        'incorrect_answers': [r'$$\Delta v_1 \times \Delta v_2$$', r'$$\sqrt{\Delta v_1^2 + \Delta v_2^2}$$', r'$$\Delta v_1 - \Delta v_2$$'],
        'explanation': r'Hohmann: total Δv = burn at periapsis + burn at apoapsis',
    },
    {
        'category': 'Aerospace Engineering',
        'difficulty': 'medium',
        'question': r'Induced drag coefficient: $$C_{D,i} = ?$$',
        'correct_answer': r'$$\frac{C_L^2}{\pi e AR}$$',
        'incorrect_answers': [r'$$\frac{C_L}{\pi AR}$$', r'$$C_L^2 \pi AR$$', r'$$\frac{\pi AR}{C_L^2}$$'],
        'explanation': r'Induced drag: C_D,i = C_L²/(πeAR) where e=efficiency',
    },
    {
        'category': 'Aerospace Engineering',
        'difficulty': 'medium',
        'question': r'Glide ratio equals:',
        'correct_answer': r'$$L/D$$',
        'incorrect_answers': [r'$$D/L$$', r'$$L \times D$$', r'$$\sqrt{L/D}$$'],
        'explanation': r'Glide ratio = L/D (horizontal distance / altitude lost)',
    },
    {
        'category': 'Aerospace Engineering',
        'difficulty': 'hard',
        'question': r'Oblique shock angle relation: $$\tan(\theta) = ?$$',
        'correct_answer': r'$$2\cot(\beta)\frac{M_1^2\sin^2(\beta)-1}{M_1^2(\gamma+\cos(2\beta))+2}$$',
        'incorrect_answers': [r'$$M_1 \sin(\beta)$$', r'$$\frac{1}{M_1}$$', r'$$\beta/\theta$$'],
        'explanation': r'Oblique shock: relates flow deflection θ to shock angle β',
    },
]

# ========== BIOMEDICAL ENGINEERING (Add 20 more) ==========
biomedical_questions = [
    {
        'category': 'Biomedical Engineering',
        'difficulty': 'medium',
        'question': r'Cardiac output: $$CO = ?$$',
        'correct_answer': r'$$HR \times SV$$',
        'incorrect_answers': [r'$$\frac{HR}{SV}$$', r'$$HR + SV$$', r'$$\frac{SV}{HR}$$'],
        'explanation': r'Cardiac output = heart rate × stroke volume',
    },
    {
        'category': 'Biomedical Engineering',
        'difficulty': 'hard',
        'question': r'Starling equation (capillary filtration): $$J_v = ?$$',
        'correct_answer': r'$$K_f[(P_c - P_i) - \sigma(\pi_c - \pi_i)]$$',
        'incorrect_answers': [r'$$K_f(P_c - P_i)$$', r'$$\sigma(\pi_c - \pi_i)$$', r'$$K_f P_c$$'],
        'explanation': r'Starling: fluid filtration = hydraulic - oncotic pressure',
    },
    {
        'category': 'Biomedical Engineering',
        'difficulty': 'medium',
        'question': r'Blood pressure: $$MAP = ?$$',
        'correct_answer': r'$$\frac{SBP + 2DBP}{3}$$',
        'incorrect_answers': [r'$$\frac{SBP + DBP}{2}$$', r'$$SBP - DBP$$', r'$$\frac{2SBP + DBP}{3}$$'],
        'explanation': r'Mean arterial pressure ≈ (systolic + 2×diastolic)/3',
    },
    {
        'category': 'Biomedical Engineering',
        'difficulty': 'easy',
        'question': r'Normal body temperature:',
        'correct_answer': r'$$37°C$$ (98.6°F)',
        'incorrect_answers': [r'$$35°C$$', r'$$40°C$$', r'$$32°C$$'],
        'explanation': r'Normal human body temperature: 37°C or 98.6°F',
    },
    {
        'category': 'Biomedical Engineering',
        'difficulty': 'hard',
        'question': r'Goldman-Hodgkin-Katz equation: $$V_m = ?$$',
        'correct_answer': r'$$\frac{RT}{F}\ln\frac{P_K[K^+]_o + P_{Na}[Na^+]_o}{P_K[K^+]_i + P_{Na}[Na^+]_i}$$',
        'incorrect_answers': [r'$$\frac{RT}{F}\ln\frac{[K^+]_o}{[K^+]_i}$$', r'$$E_K + E_{Na}$$', r'$$\frac{[Na^+]}{[K^+]}$$'],
        'explanation': r'GHK: membrane potential considering multiple ions and permeabilities',
    },
    {
        'category': 'Biomedical Engineering',
        'difficulty': 'medium',
        'question': r'Oxygen saturation: $$SaO_2 = ?$$',
        'correct_answer': r'$$\frac{HbO_2}{HbO_2 + Hb} \times 100\%$$',
        'incorrect_answers': [r'$$\frac{Hb}{HbO_2}$$', r'$$HbO_2 + Hb$$', r'$$\frac{PO_2}{100}$$'],
        'explanation': r'O₂ saturation = oxyhemoglobin / total hemoglobin × 100%',
    },
    {
        'category': 'Biomedical Engineering',
        'difficulty': 'easy',
        'question': r'Normal resting heart rate (adult):',
        'correct_answer': r'60-100 bpm',
        'incorrect_answers': [r'40-60 bpm', r'100-120 bpm', r'120-140 bpm'],
        'explanation': r'Normal adult resting HR: 60-100 beats per minute',
    },
    {
        'category': 'Biomedical Engineering',
        'difficulty': 'medium',
        'question': r'Fick principle for cardiac output: $$CO = ?$$',
        'correct_answer': r'$$\frac{VO_2}{C_a - C_v}$$',
        'incorrect_answers': [r'$$VO_2 \times (C_a - C_v)$$', r'$$\frac{C_a - C_v}{VO_2}$$', r'$$VO_2 + C_a - C_v$$'],
        'explanation': r'Fick: CO = O₂ consumption / arteriovenous O₂ difference',
    },
    {
        'category': 'Biomedical Engineering',
        'difficulty': 'hard',
        'question': r'Windkessel model resistance: $$R = ?$$',
        'correct_answer': r'$$\frac{\Delta P}{Q}$$',
        'incorrect_answers': [r'$$\frac{Q}{\Delta P}$$', r'$$\Delta P \times Q$$', r'$$C \times \Delta P$$'],
        'explanation': r'Vascular resistance: R = pressure drop / flow rate',
    },
    {
        'category': 'Biomedical Engineering',
        'difficulty': 'medium',
        'question': r'Compliance (vessel): $$C = ?$$',
        'correct_answer': r'$$\frac{\Delta V}{\Delta P}$$',
        'incorrect_answers': [r'$$\frac{\Delta P}{\Delta V}$$', r'$$\Delta V \times \Delta P$$', r'$$\frac{V}{P}$$'],
        'explanation': r'Compliance = change in volume / change in pressure',
    },
    {
        'category': 'Biomedical Engineering',
        'difficulty': 'easy',
        'question': r'ECG measures:',
        'correct_answer': r'Electrical activity of the heart',
        'incorrect_answers': [r'Blood pressure', r'Heart sounds', r'Blood flow'],
        'explanation': r'Electrocardiogram (ECG) records heart\'s electrical signals',
    },
    {
        'category': 'Biomedical Engineering',
        'difficulty': 'hard',
        'question': r'Laplace\'s law (vessel): $$T = ?$$',
        'correct_answer': r'$$\frac{Pr}{h}$$',
        'incorrect_answers': [r'$$\frac{Ph}{r}$$', r'$$Prh$$', r'$$\frac{h}{Pr}$$'],
        'explanation': r'Wall tension: T = Pr/h (pressure × radius / wall thickness)',
    },
    {
        'category': 'Biomedical Engineering',
        'difficulty': 'medium',
        'question': r'Hematocrit is:',
        'correct_answer': r'Percentage of blood volume occupied by RBCs',
        'incorrect_answers': [r'Number of white blood cells', r'Hemoglobin concentration', r'Platelet count'],
        'explanation': r'Hematocrit: % of blood volume that is red blood cells (~45%)',
    },
    {
        'category': 'Biomedical Engineering',
        'difficulty': 'medium',
        'question': r'Systemic vascular resistance: $$SVR = ?$$',
        'correct_answer': r'$$\frac{MAP - CVP}{CO}$$',
        'incorrect_answers': [r'$$\frac{CO}{MAP}$$', r'$$MAP \times CO$$', r'$$\frac{CVP}{CO}$$'],
        'explanation': r'SVR = (mean arterial - central venous pressure) / cardiac output',
    },
    {
        'category': 'Biomedical Engineering',
        'difficulty': 'hard',
        'question': r'Alveolar gas equation: $$P_AO_2 = ?$$',
        'correct_answer': r'$$P_IO_2 - \frac{P_ACO_2}{R}$$',
        'incorrect_answers': [r'$$P_IO_2 + P_ACO_2$$', r'$$\frac{P_IO_2}{P_ACO_2}$$', r'$$P_IO_2 \times R$$'],
        'explanation': r'Alveolar O₂: P_AO₂ = inspired O₂ - alveolar CO₂/R',
    },
    {
        'category': 'Biomedical Engineering',
        'difficulty': 'easy',
        'question': r'Normal blood pH:',
        'correct_answer': r'7.35-7.45',
        'incorrect_answers': [r'6.5-7.0', r'7.0-7.2', r'7.5-8.0'],
        'explanation': r'Normal arterial blood pH: 7.35-7.45 (slightly alkaline)',
    },
    {
        'category': 'Biomedical Engineering',
        'difficulty': 'medium',
        'question': r'Ejection fraction: $$EF = ?$$',
        'correct_answer': r'$$\frac{SV}{EDV} \times 100\%$$',
        'incorrect_answers': [r'$$\frac{EDV}{SV}$$', r'$$SV - EDV$$', r'$$\frac{SV}{ESV}$$'],
        'explanation': r'EF = stroke volume / end-diastolic volume × 100%',
    },
    {
        'category': 'Biomedical Engineering',
        'difficulty': 'hard',
        'question': r'Henderson-Hasselbalch equation: $$pH = ?$$',
        'correct_answer': r'$$pK_a + \log\frac{[A^-]}{[HA]}$$',
        'incorrect_answers': [r'$$pK_a - \log\frac{[A^-]}{[HA]}$$', r'$$\frac{[A^-]}{[HA]}$$', r'$$pK_a \times [A^-]$$'],
        'explanation': r'pH = pKa + log([base]/[acid]) for buffer solutions',
    },
    {
        'category': 'Biomedical Engineering',
        'difficulty': 'medium',
        'question': r'Clearance (renal): $$C = ?$$',
        'correct_answer': r'$$\frac{U \times V}{P}$$',
        'incorrect_answers': [r'$$\frac{P}{U \times V}$$', r'$$U + V + P$$', r'$$\frac{V}{U \times P}$$'],
        'explanation': r'Renal clearance = (urine conc. × urine flow) / plasma conc.',
    },
    {
        'category': 'Biomedical Engineering',
        'difficulty': 'easy',
        'question': r'Pulse pressure: $$PP = ?$$',
        'correct_answer': r'$$SBP - DBP$$',
        'incorrect_answers': [r'$$SBP + DBP$$', r'$$\frac{SBP}{DBP}$$', r'$$\frac{SBP + DBP}{2}$$'],
        'explanation': r'Pulse pressure = systolic - diastolic blood pressure',
    },
]

all_new_questions.extend(computer_questions)
all_new_questions.extend(aerospace_questions)
all_new_questions.extend(biomedical_questions)

# Now append to file
def append_to_local_questions():
    file_path = 'lib/screens/local_questions.dart'
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Find last closing bracket
    last_bracket = content.rfind('];')
    
    if last_bracket == -1:
        print("Error: Could not find end of list!")
        return
    
    # Build new questions
    new_content_parts = []
    for q in all_new_questions:
        q_str = f"""
  {{
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
  }},"""
        new_content_parts.append(q_str)
    
    new_text = ''.join(new_content_parts)
    updated_content = content[:last_bracket] + new_text + '\n' + content[last_bracket:]
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(updated_content)
    
    print(f"\n✅ Successfully added {len(all_new_questions)} questions!")
    print(f"\nBreakdown:")
    print(f"  - Electrical Engineering: 10 questions")
    print(f"  - Mechanical Engineering: 10 questions")
    print(f"  - Civil Engineering: 15 questions")
    print(f"  - Chemical Engineering: 15 questions")
    print(f"  - Computer Engineering: 15 questions")
    print(f"  - Aerospace Engineering: 18 questions")
    print(f"  - Biomedical Engineering: 20 questions")
    print(f"\nTotal new questions: {len(all_new_questions)}")

if __name__ == '__main__':
    append_to_local_questions()
