#!/usr/bin/env python3
"""
Update existing engineering questions to use subcategories
and add 20+ more questions to each engineering discipline
"""

import re

def update_questions_file():
    file_path = 'lib/screens/local_questions.dart'
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Update existing Engineering questions to specific categories
    # Electrical Engineering keywords
    content = re.sub(
        r"'category': 'Engineering',\s*\n\s*'difficulty': '(easy|medium|hard)',\s*\n\s*'question': r'''.*?(Ohm|Voltage|Current|Resistance|Power|AC|DC|RLC|Capacit|Induct|Impedance|Reactance|Resonant|Circuit).*?'''",
        lambda m: m.group(0).replace("'category': 'Engineering'", "'category': 'Electrical Engineering'"),
        content,
        flags=re.DOTALL | re.IGNORECASE
    )
    
    # Mechanical Engineering keywords
    content = re.sub(
        r"'category': 'Engineering',\s*\n\s*'difficulty': '(easy|medium|hard)',\s*\n\s*'question': r'''.*?(Kinetic|Moment|Inertia|Torque|Stress|Strain|Hooke|Euler|Buckling|Shaft|Mechanical).*?'''",
        lambda m: m.group(0).replace("'category': 'Engineering'", "'category': 'Mechanical Engineering'"),
        content,
        flags=re.DOTALL | re.IGNORECASE
    )
    
    # Civil Engineering keywords  
    content = re.sub(
        r"'category': 'Engineering',\s*\n\s*'difficulty': '(easy|medium|hard)',\s*\n\s*'question': r'''.*?(Bending|Beam|Deflection|Shear|Pressure|Fluid|Bernoulli|Hydrostatic).*?'''",
        lambda m: m.group(0).replace("'category': 'Engineering'", "'category': 'Civil Engineering'"),
        content,
        flags=re.DOTALL | re.IGNORECASE
    )
    
    # Chemical Engineering keywords
    content = re.sub(
        r"'category': 'Engineering',\s*\n\s*'difficulty': '(easy|medium|hard)',\s*\n\s*'question': r'''.*?(Ideal Gas|Arrhenius|Reynolds|Mass balance|Fick|Chemical|Reaction).*?'''",
        lambda m: m.group(0).replace("'category': 'Engineering'", "'category': 'Chemical Engineering'"),
        content,
        flags=re.DOTALL | re.IGNORECASE
    )
    
    # Computer Engineering keywords
    content = re.sub(
        r"'category': 'Engineering',\s*\n\s*'difficulty': '(easy|medium|hard)',\s*\n\s*'question': r'''.*?(Time complexity|Binary search|Shannon|Entropy|Bits|Bytes|Quicksort|Nyquist|Algorithm).*?'''",
        lambda m: m.group(0).replace("'category': 'Engineering'", "'category': 'Computer Engineering'"),
        content,
        flags=re.DOTALL | re.IGNORECASE
    )
    
    # Aerospace Engineering keywords
    content = re.sub(
        r"'category': 'Engineering',\s*\n\s*'difficulty': '(easy|medium|hard)',\s*\n\s*'question': r'''.*?(Lift|Rocket|Mach|Aerospace|Flight|Drag).*?'''",
        lambda m: m.group(0).replace("'category': 'Engineering'", "'category': 'Aerospace Engineering'"),
        content,
        flags=re.DOTALL | re.IGNORECASE
    )
    
    # Biomedical Engineering keywords
    content = re.sub(
        r"'category': 'Engineering',\s*\n\s*'difficulty': '(easy|medium|hard)',\s*\n\s*'question': r'''.*?(Poiseuille|Blood|Tissue|Nernst|Biomedical).*?'''",
        lambda m: m.group(0).replace("'category': 'Engineering'", "'category': 'Biomedical Engineering'"),
        content,
        flags=re.DOTALL | re.IGNORECASE
    )
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print("✅ Updated existing engineering questions to use subcategories!")

if __name__ == '__main__':
    update_questions_file()
