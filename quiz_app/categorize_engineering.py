#!/usr/bin/env python3
"""
Properly categorize all Engineering questions based on their content
"""

def categorize_engineering_questions():
    file_path = 'lib/screens/local_questions.dart'
    
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    # Track changes
    changes = 0
    
    # Go through each line
    for i, line in enumerate(lines):
        if "'category': 'Engineering'," in line:
            # Look at the question text in nearby lines
            question_text = ''
            for j in range(max(0, i-5), min(len(lines), i+10)):
                question_text += lines[j].lower()
            
            new_category = None
            
            # Electrical Engineering keywords
            if any(word in question_text for word in ['ohm', 'voltage', 'current', 'resistance', 'power', 'ac ', 'dc ', 'rlc', 'capacit', 'induct', 'impedance', 'reactance', 'resonant', 'circuit', 'electrical']):
                new_category = 'Electrical Engineering'
            
            # Mechanical Engineering keywords
            elif any(word in question_text for word in ['kinetic', 'moment', 'inertia', 'torque', 'stress', 'strain', 'hooke', 'euler', 'buckling', 'shaft', 'mechanical', 'cylinder']):
                new_category = 'Mechanical Engineering'
            
            # Civil Engineering keywords
            elif any(word in question_text for word in ['bending', 'beam', 'deflection', 'shear', 'pressure', 'fluid', 'bernoulli', 'hydrostatic', 'civil']):
                new_category = 'Civil Engineering'
            
            # Chemical Engineering keywords
            elif any(word in question_text for word in ['ideal gas', 'arrhenius', 'reynolds', 'mass balance', 'fick', 'chemical', 'reaction', 'diffusion']):
                new_category = 'Chemical Engineering'
            
            # Computer Engineering keywords
            elif any(word in question_text for word in ['time complexity', 'binary search', 'shannon', 'entropy', 'bits', 'bytes', 'quicksort', 'nyquist', 'algorithm', 'computer']):
                new_category = 'Computer Engineering'
            
            # Aerospace Engineering keywords
            elif any(word in question_text for word in ['lift', 'rocket', 'mach', 'aerospace', 'flight', 'drag']):
                new_category = 'Aerospace Engineering'
            
            # Biomedical Engineering keywords
            elif any(word in question_text for word in ['poiseuille', 'blood', 'tissue', 'nernst', 'biomedical']):
                new_category = 'Biomedical Engineering'
            
            if new_category:
                lines[i] = f"    'category': '{new_category}',\n"
                changes += 1
                print(f"Line {i+1}: Changed to {new_category}")
    
    # Write back
    with open(file_path, 'w', encoding='utf-8') as f:
        f.writelines(lines)
    
    print(f"\n✅ Updated {changes} engineering questions to specific categories!")

if __name__ == '__main__':
    categorize_engineering_questions()
