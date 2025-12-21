import os

files = ['lib/data/new_math_questions.dart', 'lib/data/new_sci_questions.dart', 'lib/data/new_eng_questions.dart']

for f_path in files:
    if os.path.exists(f_path):
        with open(f_path, 'r', encoding='utf-8') as f:
            content = f.read()
            tail = content[-20:]
            print(f"--- {f_path} Tail ---")
            print(repr(tail))
            
            # Simulated strip
            import re
            fixed = re.sub(r'\]\s*;\s*$', '', content)
            print(f"Stripped tail: {repr(fixed[-20:])}")
