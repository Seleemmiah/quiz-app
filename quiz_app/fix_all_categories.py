#!/usr/bin/env python3
"""
Fix ALL miscategorized engineering questions
"""

def fix_all_categories():
    file_path = 'lib/screens/local_questions.dart'
    
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    changes = 0
    i = 0
    while i < len(lines):
        # Look for any engineering category
        if any(cat in lines[i] for cat in ['Electrical Engineering', 'Mechanical Engineering', 'Civil Engineering', 'Chemical Engineering', 'Computer Engineering', 'Aerospace Engineering', 'Biomedical Engineering']):
            # Get question context
            question_text = ''
            for j in range(max(0, i-5), min(len(lines), i+15)):
                question_text += lines[j].lower()
            
            correct_category = None
            
            # Aerospace keywords (check first - most specific)
            if any(word in question_text for word in ['lift force', 'rocket equation', 'mach number', 'aerospace', 'drag coefficient']):
                correct_category = 'Aerospace Engineering'
            
            # Biomedical keywords
            elif any(word in question_text for word in ['poiseuille', 'blood flow', 'tissue', 'nernst equation', 'biomedical']):
                correct_category = 'Biomedical Engineering'
            
            # Civil keywords
            elif any(word in question_text for word in ['bending stress', 'beam', 'deflection', 'shear stress', 'bernoulli', 'hydrostatic']):
                correct_category = 'Civil Engineering'
            
            # Chemical keywords
            elif any(word in question_text for word in ['ideal gas', 'arrhenius', 'reynolds number', 'mass balance', 'fick', 'diffusion']):
                correct_category = 'Chemical Engineering'
            
            # Computer keywords
            elif any(word in question_text for word in ['time complexity', 'binary search', 'shannon entropy', 'quicksort', 'nyquist', 'algorithm', 'bits', 'bytes']):
                correct_category = 'Computer Engineering'
            
            # Mechanical keywords
            elif any(word in question_text for word in ['kinetic energy', 'moment of inertia', 'torque', 'stress', 'strain', 'hooke', 'euler buckling', 'shaft power', 'thermodynamics', 'carnot', 'heat engine']):
                correct_category = 'Mechanical Engineering'
            
            # Electrical keywords (default for remaining)
            elif any(word in question_text for word in ['ohm', 'voltage', 'current', 'resistance', 'power', 'capacit', 'induct', 'impedance', 'reactance', 'resonant', 'circuit']):
                correct_category = 'Electrical Engineering'
            
            # If we found a better category and it's different from current
            if correct_category:
                current_cat = None
                for cat in ['Electrical Engineering', 'Mechanical Engineering', 'Civil Engineering', 'Chemical Engineering', 'Computer Engineering', 'Aerospace Engineering', 'Biomedical Engineering']:
                    if f"'category': '{cat}'" in lines[i]:
                        current_cat = cat
                        break
                
                if current_cat and current_cat != correct_category:
                    lines[i] = f"    'category': '{correct_category}',\n"
                    changes += 1
                    print(f"Line {i+1}: {current_cat} → {correct_category}")
        
        i += 1
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.writelines(lines)
    
    print(f"\n✅ Fixed {changes} miscategorized questions!")

if __name__ == '__main__':
    fix_all_categories()
