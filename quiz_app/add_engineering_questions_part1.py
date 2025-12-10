#!/usr/bin/env python3
"""
Add 20+ questions to each engineering discipline
Target: 20+ questions per discipline (adding what's needed to reach 20+)
"""

# We need to add:
# Electrical: 6+ more (currently 14)
# Mechanical: 6+ more (currently 14)
# Civil: 12+ more (currently 8)
# Chemical: 12+ more (currently 8)
# Computer: 13+ more (currently 7)
# Aerospace: 16+ more (currently 4)
# Biomedical: 18+ more (currently 2)

new_questions = []

# ========== ELECTRICAL ENGINEERING (Add 10 more) ==========
electrical_questions = [
    {
        'category': 'Electrical Engineering',
        'difficulty': 'medium',
        'question': r'Transformer turns ratio: $$\frac{V_p}{V_s} = ?$$',
        'correct_answer': r'$$\frac{N_p}{N_s}$$',
        'incorrect_answers': [r'$$\frac{N_s}{N_p}$$', r'$$N_p \times N_s$$', r'$$N_p + N_s$$'],
        'explanation': r'Voltage ratio equals turns ratio: V_p/V_s = N_p/N_s',
    },
    {
        'category': 'Electrical Engineering',
        'difficulty': 'hard',
        'question': r'Three-phase power: $$P = ?$$ (balanced load)',
        'correct_answer': r'$$\sqrt{3} V_L I_L \cos(\phi)$$',
        'incorrect_answers': [r'$$3 V_L I_L$$', r'$$V_L I_L \cos(\phi)$$', r'$$\sqrt{3} V_L I_L$$'],
        'explanation': r'Three-phase power: P = √3·V_L·I_L·cos(φ)',
    },
    {
        'category': 'Electrical Engineering',
        'difficulty': 'medium',
        'question': r'Thevenin equivalent resistance is found by:',
        'correct_answer': r'Short-circuiting voltage sources and open-circuiting current sources',
        'incorrect_answers': [r'Open-circuiting all sources', r'Short-circuiting all sources', r'Removing the load only'],
        'explanation': r'Thevenin resistance: deactivate sources (V→short, I→open)',
    },
    {
        'category': 'Electrical Engineering',
        'difficulty': 'easy',
        'question': r'Kirchhoff\'s Current Law (KCL) states:',
        'correct_answer': r'$$\sum I_{in} = \sum I_{out}$$',
        'incorrect_answers': [r'$$\sum V = 0$$', r'$$I = V/R$$', r'$$P = VI$$'],
        'explanation': r'KCL: Sum of currents entering = sum leaving a node',
    },
    {
        'category': 'Electrical Engineering',
        'difficulty': 'easy',
        'question': r'Kirchhoff\'s Voltage Law (KVL) states:',
        'correct_answer': r'$$\sum V = 0$$ around a closed loop',
        'incorrect_answers': [r'$$\sum I = 0$$', r'$$V = IR$$', r'$$\sum P = 0$$'],
        'explanation': r'KVL: Sum of voltages around any closed loop is zero',
    },
    {
        'category': 'Electrical Engineering',
        'difficulty': 'hard',
        'question': r'Quality factor of RLC circuit: $$Q = ?$$',
        'correct_answer': r'$$\frac{\omega_0 L}{R}$$',
        'incorrect_answers': [r'$$\frac{R}{\omega_0 L}$$', r'$$\omega_0 LC$$', r'$$\frac{1}{\omega_0 RC}$$'],
        'explanation': r'Quality factor: Q = ω₀L/R = 1/(ω₀RC)',
    },
    {
        'category': 'Electrical Engineering',
        'difficulty': 'medium',
        'question': r'Bandwidth of RLC circuit: $$BW = ?$$',
        'correct_answer': r'$$\frac{\omega_0}{Q}$$',
        'incorrect_answers': [r'$$\omega_0 Q$$', r'$$\frac{Q}{\omega_0}$$', r'$$\omega_0 + Q$$'],
        'explanation': r'Bandwidth: BW = ω₀/Q where Q is quality factor',
    },
    {
        'category': 'Electrical Engineering',
        'difficulty': 'medium',
        'question': r'Norton equivalent current is:',
        'correct_answer': r'Short-circuit current at terminals',
        'incorrect_answers': [r'Open-circuit voltage', r'Load current', r'Source current'],
        'explanation': r'Norton current = short-circuit current (I_sc)',
    },
    {
        'category': 'Electrical Engineering',
        'difficulty': 'hard',
        'question': r'Skin effect causes:',
        'correct_answer': r'Current to concentrate near conductor surface at high frequency',
        'incorrect_answers': [r'Uniform current distribution', r'Current to flow in center', r'Voltage drop'],
        'explanation': r'Skin effect: AC current concentrates at surface, increases with frequency',
    },
    {
        'category': 'Electrical Engineering',
        'difficulty': 'medium',
        'question': r'Superposition theorem applies to:',
        'correct_answer': r'Linear circuits only',
        'incorrect_answers': [r'All circuits', r'Nonlinear circuits', r'AC circuits only'],
        'explanation': r'Superposition works only for linear circuits',
    },
]

# ========== MECHANICAL ENGINEERING (Add 10 more) ==========
mechanical_questions = [
    {
        'category': 'Mechanical Engineering',
        'difficulty': 'medium',
        'question': r'Angular momentum: $$L = ?$$',
        'correct_answer': r'$$I \omega$$',
        'incorrect_answers': [r'$$m v$$', r'$$I \alpha$$', r'$$\frac{1}{2}I\omega^2$$'],
        'explanation': r'Angular momentum: L = I·ω (moment of inertia × angular velocity)',
    },
    {
        'category': 'Mechanical Engineering',
        'difficulty': 'hard',
        'question': r'Parallel axis theorem: $$I = ?$$',
        'correct_answer': r'$$I_{cm} + md^2$$',
        'incorrect_answers': [r'$$I_{cm} - md^2$$', r'$$I_{cm} \times md^2$$', r'$$I_{cm}/md^2$$'],
        'explanation': r'Parallel axis: I = I_cm + md² where d is distance from CM',
    },
    {
        'category': 'Mechanical Engineering',
        'difficulty': 'medium',
        'question': r'Coefficient of restitution: $$e = ?$$',
        'correct_answer': r'$$\frac{v_{separation}}{v_{approach}}$$',
        'incorrect_answers': [r'$$\frac{v_{approach}}{v_{separation}}$$', r'$$v_1 - v_2$$', r'$$\frac{m_1}{m_2}$$'],
        'explanation': r'e = relative velocity of separation / approach (0=inelastic, 1=elastic)',
    },
    {
        'category': 'Mechanical Engineering',
        'difficulty': 'easy',
        'question': r'Potential energy: $$PE = ?$$',
        'correct_answer': r'$$mgh$$',
        'incorrect_answers': [r'$$\frac{1}{2}mv^2$$', r'$$Fd$$', r'$$\frac{1}{2}kx^2$$'],
        'explanation': r'Gravitational potential energy: PE = mgh',
    },
    {
        'category': 'Mechanical Engineering',
        'difficulty': 'medium',
        'question': r'Spring potential energy: $$U = ?$$',
        'correct_answer': r'$$\frac{1}{2}kx^2$$',
        'incorrect_answers': [r'$$kx$$', r'$$\frac{1}{2}mv^2$$', r'$$mgh$$'],
        'explanation': r'Elastic potential energy: U = (1/2)kx²',
    },
    {
        'category': 'Mechanical Engineering',
        'difficulty': 'hard',
        'question': r'Poisson\'s ratio: $$\nu = ?$$',
        'correct_answer': r'$$-\frac{\epsilon_{lateral}}{\epsilon_{axial}}$$',
        'incorrect_answers': [r'$$\frac{\epsilon_{axial}}{\epsilon_{lateral}}$$', r'$$\frac{\sigma}{\epsilon}$$', r'$$\frac{E}{G}$$'],
        'explanation': r'Poisson\'s ratio: ν = -ε_lateral/ε_axial',
    },
    {
        'category': 'Mechanical Engineering',
        'difficulty': 'medium',
        'question': r'Shear modulus: $$G = ?$$ (in terms of E and ν)',
        'correct_answer': r'$$\frac{E}{2(1+\nu)}$$',
        'incorrect_answers': [r'$$\frac{E}{1-\nu}$$', r'$$E(1+\nu)$$', r'$$\frac{E}{\nu}$$'],
        'explanation': r'Shear modulus: G = E/[2(1+ν)]',
    },
    {
        'category': 'Mechanical Engineering',
        'difficulty': 'hard',
        'question': r'Bulk modulus: $$K = ?$$',
        'correct_answer': r'$$\frac{E}{3(1-2\nu)}$$',
        'incorrect_answers': [r'$$\frac{E}{2(1+\nu)}$$', r'$$E\nu$$', r'$$\frac{E}{1-\nu^2}$$'],
        'explanation': r'Bulk modulus: K = E/[3(1-2ν)]',
    },
    {
        'category': 'Mechanical Engineering',
        'difficulty': 'medium',
        'question': r'Centripetal acceleration: $$a_c = ?$$',
        'correct_answer': r'$$\frac{v^2}{r}$$',
        'incorrect_answers': [r'$$vr$$', r'$$\frac{r}{v^2}$$', r'$$v^2r$$'],
        'explanation': r'Centripetal acceleration: a_c = v²/r = ω²r',
    },
    {
        'category': 'Mechanical Engineering',
        'difficulty': 'easy',
        'question': r'Work done: $$W = ?$$',
        'correct_answer': r'$$F \cdot d \cos(\theta)$$',
        'incorrect_answers': [r'$$F \cdot d \sin(\theta)$$', r'$$F/d$$', r'$$F + d$$'],
        'explanation': r'Work: W = F·d·cos(θ) where θ is angle between F and d',
    },
]

# ========== CIVIL ENGINEERING (Add 15 more) ==========
civil_questions = [
    {
        'category': 'Civil Engineering',
        'difficulty': 'medium',
        'question': r'Simply supported beam max deflection: $$\delta_{max} = ?$$',
        'correct_answer': r'$$\frac{5wL^4}{384EI}$$',
        'incorrect_answers': [r'$$\frac{wL^4}{8EI}$$', r'$$\frac{wL^3}{48EI}$$', r'$$\frac{wL^4}{384EI}$$'],
        'explanation': r'Max deflection at center: δ = 5wL⁴/(384EI) for UDL',
    },
    {
        'category': 'Civil Engineering',
        'difficulty': 'hard',
        'question': r'Section modulus: $$S = ?$$',
        'correct_answer': r'$$\frac{I}{c}$$',
        'incorrect_answers': [r'$$Ic$$', r'$$\frac{c}{I}$$', r'$$I + c$$'],
        'explanation': r'Section modulus: S = I/c where c is distance to extreme fiber',
    },
    {
        'category': 'Civil Engineering',
        'difficulty': 'medium',
        'question': r'Radius of gyration: $$r = ?$$',
        'correct_answer': r'$$\sqrt{\frac{I}{A}}$$',
        'incorrect_answers': [r'$$\frac{I}{A}$$', r'$$\sqrt{IA}$$', r'$$\frac{A}{I}$$'],
        'explanation': r'Radius of gyration: r = √(I/A)',
    },
    {
        'category': 'Civil Engineering',
        'difficulty': 'easy',
        'question': r'Continuity equation: $$A_1 v_1 = ?$$',
        'correct_answer': r'$$A_2 v_2$$',
        'incorrect_answers': [r'$$\frac{A_2}{v_2}$$', r'$$A_2 + v_2$$', r'$$constant$$'],
        'explanation': r'Continuity: A₁v₁ = A₂v₂ (conservation of mass)',
    },
    {
        'category': 'Civil Engineering',
        'difficulty': 'medium',
        'question': r'Manning\'s equation for flow: $$v = ?$$',
        'correct_answer': r'$$\frac{1}{n}R^{2/3}S^{1/2}$$',
        'incorrect_answers': [r'$$nRS$$', r'$$\frac{R}{nS}$$', r'$$\frac{n}{RS}$$'],
        'explanation': r'Manning: v = (1/n)R^(2/3)S^(1/2) where n=roughness',
    },
    {
        'category': 'Civil Engineering',
        'difficulty': 'hard',
        'question': r'Slenderness ratio: $$\lambda = ?$$',
        'correct_answer': r'$$\frac{L_e}{r}$$',
        'incorrect_answers': [r'$$\frac{r}{L_e}$$', r'$$L_e \times r$$', r'$$\frac{L_e}{I}$$'],
        'explanation': r'Slenderness ratio: λ = L_e/r (effective length/radius of gyration)',
    },
    {
        'category': 'Civil Engineering',
        'difficulty': 'medium',
        'question': r'Darcy-Weisbach equation: $$h_f = ?$$',
        'correct_answer': r'$$f\frac{L}{D}\frac{v^2}{2g}$$',
        'incorrect_answers': [r'$$\frac{fLv}{Dg}$$', r'$$\frac{fDv^2}{Lg}$$', r'$$fLDv$$'],
        'explanation': r'Head loss: h_f = f(L/D)(v²/2g) where f=friction factor',
    },
    {
        'category': 'Civil Engineering',
        'difficulty': 'easy',
        'question': r'Archimedes principle: Buoyant force = ?',
        'correct_answer': r'Weight of displaced fluid',
        'incorrect_answers': [r'Weight of object', r'Volume of object', r'Density of object'],
        'explanation': r'Buoyancy = weight of fluid displaced by object',
    },
    {
        'category': 'Civil Engineering',
        'difficulty': 'medium',
        'question': r'Froude number: $$Fr = ?$$',
        'correct_answer': r'$$\frac{v}{\sqrt{gL}}$$',
        'incorrect_answers': [r'$$\frac{\sqrt{gL}}{v}$$', r'$$vgL$$', r'$$\frac{v}{gL}$$'],
        'explanation': r'Froude number: Fr = v/√(gL) (inertial/gravitational forces)',
    },
    {
        'category': 'Civil Engineering',
        'difficulty': 'hard',
        'question': r'Plastic section modulus: $$Z = ?$$ (rectangular)',
        'correct_answer': r'$$\frac{bh^2}{4}$$',
        'incorrect_answers': [r'$$\frac{bh^2}{6}$$', r'$$\frac{bh^3}{12}$$', r'$$bh^2$$'],
        'explanation': r'Plastic modulus (rectangle): Z = bh²/4',
    },
    {
        'category': 'Civil Engineering',
        'difficulty': 'medium',
        'question': r'Hazen-Williams equation coefficient C for:',
        'correct_answer': r'Smooth pipes: C ≈ 140',
        'incorrect_answers': [r'C ≈ 50', r'C ≈ 200', r'C ≈ 10'],
        'explanation': r'Hazen-Williams C: smooth pipes ~140, rough ~100',
    },
    {
        'category': 'Civil Engineering',
        'difficulty': 'easy',
        'question': r'Specific gravity: $$SG = ?$$',
        'correct_answer': r'$$\frac{\rho_{substance}}{\rho_{water}}$$',
        'incorrect_answers': [r'$$\rho_{substance}$$', r'$$\frac{\rho_{water}}{\rho_{substance}}$$', r'$$\rho_{substance} + \rho_{water}$$'],
        'explanation': r'Specific gravity = density of substance / density of water',
    },
    {
        'category': 'Civil Engineering',
        'difficulty': 'hard',
        'question': r'Torsional shear stress: $$\tau = ?$$',
        'correct_answer': r'$$\frac{Tr}{J}$$',
        'incorrect_answers': [r'$$\frac{T}{Jr}$$', r'$$TrJ$$', r'$$\frac{J}{Tr}$$'],
        'explanation': r'Torsion: τ = Tr/J where T=torque, r=radius, J=polar moment',
    },
    {
        'category': 'Civil Engineering',
        'difficulty': 'medium',
        'question': r'Polar moment of inertia (solid circle): $$J = ?$$',
        'correct_answer': r'$$\frac{\pi r^4}{2}$$',
        'incorrect_answers': [r'$$\frac{\pi r^4}{4}$$', r'$$\pi r^4$$', r'$$\frac{\pi r^2}{2}$$'],
        'explanation': r'Polar moment (solid circle): J = πr⁴/2',
    },
    {
        'category': 'Civil Engineering',
        'difficulty': 'medium',
        'question': r'Discharge through orifice: $$Q = ?$$',
        'correct_answer': r'$$C_d A \sqrt{2gh}$$',
        'incorrect_answers': [r'$$A\sqrt{gh}$$', r'$$C_d Agh$$', r'$$\frac{C_d A}{h}$$'],
        'explanation': r'Orifice discharge: Q = C_d·A·√(2gh) where C_d=discharge coeff',
    },
]

# ========== CHEMICAL ENGINEERING (Add 15 more) ==========
chemical_questions = [
    {
        'category': 'Chemical Engineering',
        'difficulty': 'medium',
        'question': r'Raoult\'s Law: $$P_i = ?$$',
        'correct_answer': r'$$x_i P_i^*$$',
        'incorrect_answers': [r'$$\frac{P_i^*}{x_i}$$', r'$$x_i + P_i^*$$', r'$$\frac{x_i}{P_i^*}$$'],
        'explanation': r'Raoult: Partial pressure P_i = mole fraction × vapor pressure',
    },
    {
        'category': 'Chemical Engineering',
        'difficulty': 'hard',
        'question': r'Antoine equation: $$\log P = ?$$',
        'correct_answer': r'$$A - \frac{B}{C+T}$$',
        'incorrect_answers': [r'$$A + BT$$', r'$$\frac{A}{B+T}$$', r'$$A - BT$$'],
        'explanation': r'Antoine: log(P) = A - B/(C+T) for vapor pressure',
    },
    {
        'category': 'Chemical Engineering',
        'difficulty': 'medium',
        'question': r'Hagen-Poiseuille for laminar flow: $$\Delta P = ?$$',
        'correct_answer': r'$$\frac{8\mu LQ}{\pi r^4}$$',
        'incorrect_answers': [r'$$\frac{\mu LQ}{r^2}$$', r'$$\frac{8\mu Q}{\pi r^4}$$', r'$$\mu LQr$$'],
        'explanation': r'Pressure drop: ΔP = 8μLQ/(πr⁴) for laminar pipe flow',
    },
    {
        'category': 'Chemical Engineering',
        'difficulty': 'easy',
        'question': r'Dalton\'s Law: $$P_{total} = ?$$',
        'correct_answer': r'$$\sum P_i$$',
        'incorrect_answers': [r'$$\prod P_i$$', r'$$\frac{1}{\sum P_i}$$', r'$$P_1 - P_2$$'],
        'explanation': r'Dalton: Total pressure = sum of partial pressures',
    },
    {
        'category': 'Chemical Engineering',
        'difficulty': 'hard',
        'question': r'Sherwood number: $$Sh = ?$$',
        'correct_answer': r'$$\frac{k_c L}{D}$$',
        'incorrect_answers': [r'$$\frac{D}{k_c L}$$', r'$$k_c LD$$', r'$$\frac{L}{k_c D}$$'],
        'explanation': r'Sherwood: Sh = k_c·L/D (mass transfer coefficient)',
    },
    {
        'category': 'Chemical Engineering',
        'difficulty': 'medium',
        'question': r'Schmidt number: $$Sc = ?$$',
        'correct_answer': r'$$\frac{\mu}{\rho D}$$',
        'incorrect_answers': [r'$$\frac{\rho D}{\mu}$$', r'$$\mu \rho D$$', r'$$\frac{D}{\mu \rho}$$'],
        'explanation': r'Schmidt: Sc = μ/(ρD) = ν/D (momentum/mass diffusivity)',
    },
    {
        'category': 'Chemical Engineering',
        'difficulty': 'hard',
        'question': r'Prandtl number: $$Pr = ?$$',
        'correct_answer': r'$$\frac{\mu c_p}{k}$$',
        'incorrect_answers': [r'$$\frac{k}{\mu c_p}$$', r'$$\mu c_p k$$', r'$$\frac{c_p}{k}$$'],
        'explanation': r'Prandtl: Pr = μc_p/k (momentum/thermal diffusivity)',
    },
    {
        'category': 'Chemical Engineering',
        'difficulty': 'medium',
        'question': r'Nusselt number: $$Nu = ?$$',
        'correct_answer': r'$$\frac{hL}{k}$$',
        'incorrect_answers': [r'$$\frac{k}{hL}$$', r'$$hLk$$', r'$$\frac{L}{hk}$$'],
        'explanation': r'Nusselt: Nu = hL/k (convective/conductive heat transfer)',
    },
    {
        'category': 'Chemical Engineering',
        'difficulty': 'easy',
        'question': r'Henry\'s Law: $$P_i = ?$$',
        'correct_answer': r'$$H x_i$$',
        'incorrect_answers': [r'$$\frac{H}{x_i}$$', r'$$H + x_i$$', r'$$\frac{x_i}{H}$$'],
        'explanation': r'Henry: Partial pressure = Henry constant × mole fraction',
    },
    {
        'category': 'Chemical Engineering',
        'difficulty': 'hard',
        'question': r'Ergun equation for packed bed: $$\Delta P/L = ?$$',
        'correct_answer': r'$$150\frac{(1-\epsilon)^2}{\epsilon^3}\frac{\mu v}{d_p^2} + 1.75\frac{1-\epsilon}{\epsilon^3}\frac{\rho v^2}{d_p}$$',
        'incorrect_answers': [r'$$\frac{\mu v}{d_p}$$', r'$$\frac{\rho v^2}{d_p}$$', r'$$\mu v d_p$$'],
        'explanation': r'Ergun: combines viscous and kinetic energy losses in packed beds',
    },
    {
        'category': 'Chemical Engineering',
        'difficulty': 'medium',
        'question': r'Grashof number: $$Gr = ?$$',
        'correct_answer': r'$$\frac{g\beta \Delta T L^3}{\nu^2}$$',
        'incorrect_answers': [r'$$\frac{\nu^2}{g\beta \Delta T L^3}$$', r'$$g\beta \Delta T L$$', r'$$\frac{L^3}{\nu^2}$$'],
        'explanation': r'Grashof: Gr = gβΔTL³/ν² (buoyancy/viscous forces)',
    },
    {
        'category': 'Chemical Engineering',
        'difficulty': 'medium',
        'question': r'Peclet number: $$Pe = ?$$',
        'correct_answer': r'$$Re \times Pr$$',
        'incorrect_answers': [r'$$Re + Pr$$', r'$$Re/Pr$$', r'$$Re - Pr$$'],
        'explanation': r'Peclet: Pe = Re×Pr (advection/diffusion)',
    },
    {
        'category': 'Chemical Engineering',
        'difficulty': 'easy',
        'question': r'Conversion in reactor: $$X = ?$$',
        'correct_answer': r'$$\frac{N_{A0} - N_A}{N_{A0}}$$',
        'incorrect_answers': [r'$$\frac{N_A}{N_{A0}}$$', r'$$N_{A0} - N_A$$', r'$$\frac{N_{A0}}{N_A}$$'],
        'explanation': r'Conversion: X = (moles reacted)/(initial moles)',
    },
    {
        'category': 'Chemical Engineering',
        'difficulty': 'hard',
        'question': r'CSTR design equation: $$V = ?$$',
        'correct_answer': r'$$\frac{F_{A0} X}{-r_A}$$',
        'incorrect_answers': [r'$$F_{A0} X r_A$$', r'$$\frac{-r_A}{F_{A0} X}$$', r'$$F_{A0}/X$$'],
        'explanation': r'CSTR volume: V = F_A0·X/(-r_A) where r_A=reaction rate',
    },
    {
        'category': 'Chemical Engineering',
        'difficulty': 'medium',
        'question': r'Space time: $$\tau = ?$$',
        'correct_answer': r'$$\frac{V}{v_0}$$',
        'incorrect_answers': [r'$$\frac{v_0}{V}$$', r'$$Vv_0$$', r'$$V + v_0$$'],
        'explanation': r'Space time: τ = V/v₀ (reactor volume/volumetric flow rate)',
    },
]

# Continue in next part due to length...
new_questions.extend(electrical_questions)
new_questions.extend(mechanical_questions)
new_questions.extend(civil_questions)
new_questions.extend(chemical_questions)

print(f"Part 1: Added {len(new_questions)} questions")
print(f"  - Electrical: {len(electrical_questions)}")
print(f"  - Mechanical: {len(mechanical_questions)}")
print(f"  - Civil: {len(civil_questions)}")
print(f"  - Chemical: {len(chemical_questions)}")
