import random

def generate_engineering_questions():
    questions = []
    
    # --- ELECTRICAL ENGINEERING ---
    category = "Electrical Engineering"
    
    # Easy: V=IR (Loop 100)
    for i in range(100):
        r = random.randint(10, 100) + i
        i_val = random.randint(1, 10)
        v = r * i_val
        questions.append({
            "category": category,
            "type": "multiple",
            "difficulty": "easy",
            "question": f"Calculate Voltage: I={i_val}A, R={r}Ω ($$ V=IR $$). (Q{i})",
            "correct_answer": f"{v}V",
            "incorrect_answers": [f"{v+10}V", f"{v-5}V", f"{r+i_val}V"],
            "explanation": f"V = {i_val} * {r} = {v}V.",
            "isEquation": True
        })

    # Medium: Power P=IV or P=I^2R (Loop 100)
    for i in range(100):
        mode = i % 2
        i_val = random.randint(2, 20)
        if mode == 0:
            v = random.randint(10, 240)
            p = i_val * v
            questions.append({
                "category": category,
                "type": "multiple",
                "difficulty": "medium",
                "question": f"Calculate Power: V={v}V, I={i_val}A ($$ P=IV $$).",
                "correct_answer": f"{p}W",
                "incorrect_answers": [f"{p+100}W", f"{p-100}W", f"{v+i_val}W"],
                "explanation": f"P = {v} * {i_val} = {p}W.",
                "isEquation": True
            })
        else:
            r = random.randint(5, 50)
            p = (i_val ** 2) * r
            questions.append({
                "category": category,
                "type": "multiple",
                "difficulty": "medium",
                "question": f"Calculate Power loss: I={i_val}A, R={r}Ω ($$ P=I^2R $$).",
                "correct_answer": f"{p}W",
                "incorrect_answers": [f"{p+50}W", f"{p-50}W", f"{i_val*r}W"],
                "explanation": f"P = {i_val}^2 * {r} = {p}W.",
                "isEquation": True
            })

    # Hard: Capacitors/Parallel Resistors (Loop 100)
    for i in range(100):
        r1 = random.randint(10, 100)
        r2 = random.randint(10, 100)
        req = round((r1*r2)/(r1+r2), 2)
        questions.append({
            "category": category,
            "type": "multiple",
            "difficulty": "hard",
            "question": f"Equivalent Resistance (Parallel): R1={r1}Ω, R2={r2}Ω ($$ R_{{eq}} = \\frac{{R_1 R_2}}{{R_1+R_2}} $$).",
            "correct_answer": f"{req}Ω",
            "incorrect_answers": [f"{round(req*2,2)}Ω", f"{round(req/2,2)}Ω", f"{r1+r2}Ω"],
            "explanation": f"({r1}*{r2})/({r1}+{r2}) = {req}",
            "isEquation": True
        })

    # --- MECHANICAL ENGINEERING ---
    category = "Mechanical Engineering"
    
    # Easy: Force/Pressure P=F/A
    for i in range(100):
        f = random.randint(100, 1000)
        a = random.randint(2, 20)
        p = int(f / a)
        questions.append({
            "category": category,
            "type": "multiple",
            "difficulty": "easy",
            "question": f"Calculate Pressure: Force={f}N, Area={a}m² ($$ P=F/A $$).",
            "correct_answer": f"{p}Pa",
            "incorrect_answers": [f"{p+10}Pa", f"{p-10}Pa", f"{f+a}Pa"],
            "explanation": f"P = {f}/{a} = {p}Pa.",
            "isEquation": True
        })

    # Medium: Torque T=F*d (Loop 100)
    for i in range(100):
        f = random.randint(50, 500)
        d = random.randint(1, 10)
        t = f * d
        questions.append({
            "category": category,
            "type": "multiple",
            "difficulty": "medium",
            "question": f"Calculate Torque: Force={f}N at distance {d}m ($$ \\tau = F \\times d $$).",
            "correct_answer": f"{t}Nm",
            "incorrect_answers": [f"{t+50}Nm", f"{t-50}Nm", f"{f+d}Nm"],
            "explanation": f"Torque = {f} * {d} = {t}Nm.",
            "isEquation": True
        })
        
    # Hard: Thermodynamics (Efficiency = (Th-Tc)/Th)
    for i in range(100):
        th = random.randint(400, 800) # Kelvin
        tc = random.randint(200, 350)
        eff = round(1 - (tc/th), 2) * 100
        eff = round(eff, 1)
        questions.append({
            "category": category,
            "type": "multiple",
            "difficulty": "hard",
            "question": f"Carnot Efficiency: Th={th}K, Tc={tc}K ($$ \\eta = 1 - \\frac{{T_c}}{{T_h}} $$).",
            "correct_answer": f"{eff}%",
            "incorrect_answers": [f"{round(eff+10,1)}%", f"{round(eff-10,1)}%", f"{round((tc/th)*100,1)}%"],
            "explanation": f"1 - ({tc}/{th}) = {eff/100:.2f} -> {eff}%",
            "isEquation": True
        })

    # --- CIVIL ENGINEERING ---
    category = "Civil Engineering"
    
    # Easy: Density = Mass/Volume
    for i in range(100):
        m = random.randint(1000, 5000)
        v = random.randint(1, 10)
        d = int(m/v)
        questions.append({
            "category": category,
            "type": "multiple",
            "difficulty": "easy",
            "question": f"Calculate Density of concrete: Mass={m}kg, Volume={v}m³.",
            "correct_answer": f"{d} kg/m³",
            "incorrect_answers": [f"{d+100} kg/m³", f"{d-100} kg/m³", f"{m-100} kg/m³"],
            "explanation": f"Density = {m}/{v} = {d}.",
            "isEquation": True
        })

    # Medium: Loads (Total Load = Dead + Live) - Simple Arithmetic but context matters
    for i in range(100):
        dead = random.randint(50, 200)
        live = random.randint(50, 200)
        total = dead + live
        questions.append({
            "category": category,
            "type": "multiple",
            "difficulty": "medium",
            "question": f"Calculate Factored Load (approx): Dead Load={dead}kN, Live Load={live}kN. (Simple Sum)",
            "correct_answer": f"{total}kN",
            "incorrect_answers": [f"{total+50}kN", f"{total-20}kN", f"{dead}kN"],
            "explanation": f"Total = {dead} + {live} = {total}kN (Simplified).",
            "isEquation": False
        })

    # Hard: Stress = Force/Area (Applied to columns)
    for i in range(100):
        f = random.randint(10000, 50000) # Newtons
        side = random.randint(10, 50) # cm
        area_cm2 = side * side
        # Stress in N/cm2 aka 10 kPa
        stress = round(f / area_cm2, 2)
        questions.append({
            "category": category,
            "type": "multiple",
            "difficulty": "hard",
            "question": f"Column Stress: Load={f}N, Square Column Side={side}cm.",
            "correct_answer": f"{stress} N/cm²",
            "incorrect_answers": [f"{round(stress*2,2)} N/cm²", f"{round(stress/2,2)} N/cm²", f"{stress+100} N/cm²"],
            "explanation": f"Area = {side}*{side} = {area_cm2}. Stress = {f}/{area_cm2}.",
            "isEquation": True
        })

    # --- BIOMEDICAL ENGINEERING ---
    category = "Biomedical Engineering"

    # Easy: Biomechanics (Stress/Strain basic), Medical Device Definitions
    for i in range(100):
        f = random.randint(100, 1000)
        area = random.randint(1, 10)
        stress = int(f/area)
        questions.append({
            "category": category,
            "type": "multiple",
            "difficulty": "easy",
            "question": f"Calculate Stress on a bone: Force={f}N, Area={area}cm² ($$ \\sigma = F/A $$).",
            "correct_answer": f"{stress} N/cm²",
            "incorrect_answers": [f"{stress+10} N/cm²", f"{stress-10} N/cm²", f"{f} N/cm²"],
            "explanation": f"Stress = Force / Area = {f}/{area} = {stress}.",
            "isEquation": True
        })

    # Medium: Nernst Equation / Membrane Potential / Flow
    for i in range(100):
        v = random.randint(10, 50)
        d = random.randint(1, 5)
        r = d/2
        area = round(3.14159 * (r**2), 2)
        flow = round(area * v, 1)
        questions.append({
            "category": category,
            "type": "multiple",
            "difficulty": "medium",
            "question": f"Calculate Blood Flow Rate: Velocity={v}cm/s, Diameter={d}cm ($$ Q = A \\times v $$).",
            "correct_answer": f"{flow} cm³/s",
            "incorrect_answers": [f"{round(flow*2,1)} cm³/s", f"{round(flow/2,1)} cm³/s", f"{v*d} cm³/s"],
            "explanation": f"Area = pi*r^2 = 3.14*{r}^2 = {area}. Q = {area}*{v} = {flow}.",
            "isEquation": True
        })

    # Hard: Larmor Frequency (MRI)
    for i in range(100):
        b = random.randint(1, 7)
        gamma = 42.58
        freq = round(gamma * b, 2)
        questions.append({
            "category": category,
            "type": "multiple",
            "difficulty": "hard",
            "question": f"Calculate Larmor Frequency for Hydrogen at {b} Tesla (gamma = 42.58 MHz/T).",
            "correct_answer": f"{freq} MHz",
            "incorrect_answers": [f"{round(freq+10,2)} MHz", f"{round(freq-10,2)} MHz", f"{b*10} MHz"],
            "explanation": f"f = gamma * B = 42.58 * {b} = {freq} MHz.",
            "isEquation": True
        })

    # --- CHEMICAL ENGINEERING ---
    category = "Chemical Engineering"
    
    # Easy: pH
    for i in range(100):
        ph = random.randint(1, 13)
        conc = f"10^{{-{ph}}}"
        questions.append({
            "category": category,
            "type": "multiple",
            "difficulty": "easy",
            "question": f"Calculate pH if [H+] = $${conc}$$ M.",
            "correct_answer": f"{ph}",
            "incorrect_answers": [f"{ph+1}", f"{ph-1}", f"{14-ph}"],
            "explanation": f"pH = -log(10^-{ph}) = {ph}.",
            "isEquation": True
        })

    # Medium: Ideal Gas
    for i in range(100):
        p = random.randint(100, 200)
        v = random.randint(10, 50)
        n = random.randint(1, 5)
        r = 8.314
        t = int((p * v) / (n * r))
        questions.append({
            "category": category,
            "type": "multiple",
            "difficulty": "medium",
            "question": f"Calculate Temp (T): P={p}kPa, V={v}L, n={n}mol ($$ PV=nRT $$).",
            "correct_answer": f"{t}K",
            "incorrect_answers": [f"{t+50}K", f"{t-50}K", f"{t*2}K"],
            "explanation": f"T = PV/nR = ({p}*{v})/({n}*8.314) = {t}K.",
            "isEquation": True
        })
        
    # Hard: Heat Exchanger
    for i in range(100):
        m_rate = random.randint(1, 10)
        cp = 4.18
        dt = random.randint(10, 50)
        q = round(m_rate * cp * dt, 1)
        questions.append({
            "category": category,
            "type": "multiple",
            "difficulty": "hard",
            "question": f"Calculate Heat Load: Flow={m_rate}kg/s, Cp=4.18 (Water), dT={dt}°C ($$ Q = \\dot{{m}} C_p \\Delta T $$).",
            "correct_answer": f"{q} kW",
            "incorrect_answers": [f"{round(q+10,1)} kW", f"{round(q*2,1)} kW", f"{m_rate*dt} kW"],
            "explanation": f"Q = {m_rate} * 4.18 * {dt} = {q} kW.",
            "isEquation": True
        })

    # --- COMPUTER ENGINEERING ---
    category = "Computer Engineering"
    
    # Easy: Binary
    for i in range(100):
        val = random.randint(0, 15)
        binary = format(val, '04b')
        questions.append({
            "category": category,
            "type": "multiple",
            "difficulty": "easy",
            "question": f"Convert binary {binary} to decimal.",
            "correct_answer": str(val),
            "incorrect_answers": [str(val+1), str(val-1), str(val+2)],
            "explanation": f"Binary {binary} = {val}.",
            "isEquation": False
        })
        
    # Medium: Logic Gates
    for i in range(100):
        a = random.choice([0, 1])
        b = random.choice([0, 1])
        gate = random.choice(['AND', 'OR', 'XOR'])
        if gate == 'AND': res = a & b
        elif gate == 'OR': res = a | b
        else: res = a ^ b
        questions.append({
            "category": category,
            "type": "multiple",
            "difficulty": "medium",
            "question": f"Logic Gate: {a} {gate} {b} = ?",
            "correct_answer": str(res),
            "incorrect_answers": [str(1-res)],
            "explanation": f"Truth table for {gate}.",
            "isEquation": False
        })
        
    # Hard: Memory
    for i in range(100):
        power = random.randint(10, 30)
        size_bytes = 2**power
        if power < 20: size_str = f"{2**(power-10)} KB"
        elif power < 30: size_str = f"{2**(power-20)} MB"
        else: size_str = f"{2**(power-30)} GB"
        questions.append({
            "category": category,
            "type": "multiple",
            "difficulty": "hard",
            "question": f"How many address bits are needed for {size_str} of byte-addressable memory?",
            "correct_answer": f"{power} bits",
            "incorrect_answers": [f"{power-1} bits", f"{power+1} bits", f"{power*8} bits"],
            "explanation": f"2^{power} bytes = {size_str}.",
            "isEquation": False
        })

    # --- AEROSPACE ENGINEERING ---
    category = "Aerospace Engineering"
    
    # Easy: Lift equation components
    for i in range(100):
        # L = 0.5 * rho * v^2 * S * CL
        # Ask for Lift or Velocity relationship
        v = random.randint(100, 300) # m/s
        rho = 1.225 # sea level
        s = random.randint(10, 50) # Wing area
        cl = round(random.uniform(0.5, 1.5), 2)
        lift = int(0.5 * rho * (v**2) * s * cl)
        questions.append({
            "category": category,
            "type": "multiple",
            "difficulty": "easy",
            "question": f"Calculate Lift (approx): V={v}m/s, S={s}m², CL={cl} ($$ L = \\frac{{1}}{{2}} \\rho v^2 S C_L $$).",
            "correct_answer": f"{lift} N",
            "incorrect_answers": [f"{lift+1000} N", f"{lift-1000} N", f"{int(lift/2)} N"],
            "explanation": f"L = 0.5 * 1.225 * {v}^2 * {s} * {cl} = {lift}.",
            "isEquation": True
        })

    # Medium: Orbital Velocity v = sqrt(GM/r)
    for i in range(100):
        # Earth Orbit
        h = random.randint(200, 2000) # km altitude
        r_earth = 6371 # km
        r = (r_earth + h) * 1000 # meters
        g_const = 6.674e-11
        m_earth = 5.972e24
        v_orb = (g_const * m_earth / r)**0.5
        v_orb = int(v_orb)
        questions.append({
            "category": category,
            "type": "multiple",
            "difficulty": "medium",
            "question": f"Calculate Orbital Velocity at {h}km altitude ($$ v = \\sqrt{{GM/r}} $$).",
            "correct_answer": f"{v_orb} m/s",
            "incorrect_answers": [f"{v_orb+500} m/s", f"{v_orb-500} m/s", f"7900 m/s"],
            "explanation": f"Orbital mechanics calculation.",
            "isEquation": True
        })
        
    # Hard: Rocket Equation dV = Isp * g0 * ln(m0/mf)
    for i in range(100):
        isp = random.randint(250, 450) # seconds
        m0 = random.randint(10000, 50000)
        mf = random.randint(2000, 9000)
        import math
        dv = isp * 9.81 * math.log(m0/mf)
        dv = int(dv)
        questions.append({
            "category": category,
            "type": "multiple",
            "difficulty": "hard",
            "question": f"Calculate Delta-V: Isp={isp}s, Initial Mass={m0}kg, Dry Mass={mf}kg.",
            "correct_answer": f"{dv} m/s",
            "incorrect_answers": [f"{dv+200} m/s", f"{dv-200} m/s", f"{isp*10} m/s"],
            "explanation": f"Tsiolkovsky: {isp} * 9.81 * ln({m0}/{mf}) = {dv}.",
            "isEquation": True
        })

    return questions

def dart_escape(s):
    return s.replace("'", "\\'").replace('"', '\\"')

def write_kv(f, key, val):
    if "$" in val or "\\" in val:
        if "'" in val:
            if '"' in val:
                esc = val.replace('\\', '\\\\').replace('"', '\\"')
                f.write(f'    "{key}": "{esc}",\n')
            else:
                 f.write(f'    "{key}": r"{val}",\n')
        else:
             f.write(f'    "{key}": r\'{val}\',\n')
    else:
         f.write(f'    "{key}": "{dart_escape(val)}",\n')

def generate_dart_file(questions, filename="lib/data/new_eng_questions.dart"):
    with open(filename, 'w', encoding='utf-8') as f:
        f.write("final List<Map<String, dynamic>> newEngQuestions = [\n")
        for q in questions:
            f.write("  {\n")
            f.write(f'    "category": "{q["category"]}",\n')
            f.write(f'    "type": "{q["type"]}",\n')
            f.write(f'    "difficulty": "{q["difficulty"]}",\n')
            
            write_kv(f, "question", q["question"])
            write_kv(f, "correct_answer", q["correct_answer"])

            f.write('    "incorrect_answers": [\n')
            for w in q["incorrect_answers"]:
                f.write('      ') 
                val = w
                if "$" in val or "\\" in val:
                    if "'" in val:
                        if '"' in val:
                             esc = val.replace('\\', '\\\\').replace('"', '\\"')
                             f.write(f'"{esc}",\n')
                        else:
                             f.write(f'r"{val}",\n')
                    else:
                         f.write(f'r\'{val}\',\n')
                else:
                     f.write(f'"{dart_escape(val)}",\n')
            f.write('    ],\n')
            
            write_kv(f, "explanation", q["explanation"])
            f.write("  },\n")
        f.write("];\n")

if __name__ == "__main__":
    qs = generate_engineering_questions()
    generate_dart_file(qs)
