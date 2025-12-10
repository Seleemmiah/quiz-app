import re

def fix_revert_damage(file_path):
    with open(file_path, 'r') as f:
        lines = f.readlines()

    fixed_lines = []
    for line in lines:
        new_line = line
        # We look for lines that have r" ... ',
        # This implies we broke the closing quote.
        
        # Regex: r" ... ',
        # We want to match r" followed by anything, then ',
        # But we need to be careful.
        
        # If line contains r" and ends with ', (ignoring whitespace)
        # or contains ',
        
        if 'r"' in line and "'," in line:
            # Check if the ', corresponds to the r"
            # If we have r"foo',
            # We want to change ', to ",
            
            # But wait, what if we have r"foo" and then ', somewhere else?
            # Unlikely in this file structure.
            
            # Let's just replace ', with ", if r" is present.
            # But wait, what if we have r"foo" and 'bar',?
            # 'incorrect_answers': [r"A", r"B"], -> This is fine.
            # If I broke it: [r"A', r"B',] -> broken.
            
            # So I need to replace ', with ", ONLY if it closes a r" string.
            
            # Regex to find r" ... ',
            # r"([^"]*)',
            # This matches r" followed by non-quotes (because the closing " is missing/replaced by ')
            # Wait, if I replaced " with ', then the string content doesn't have " anymore (unless it had internal ").
            
            # So r" ... ',
            # The ... part shouldn't have " (unless escaped, but raw strings don't escape).
            
            # So I can replace r"([^"]*)', with r"\1",
            
            # But wait, regex `[^"]*` will match until the first `"`?
            # If the closing `"` is gone, it will match until end of line or next `"` (start of next string).
            
            # Example: [r"A', r"B',]
            # Match r"A', -> matches.
            # Replace with r"A",
            # Result: [r"A", r"B',]
            # Then match r"B', -> matches.
            # Replace with r"B",
            # Result: [r"A", r"B",]
            
            # This seems correct.
            
            new_line = re.sub(r'r"([^"]*)\',', r'r"\1",', new_line)
            
            # Also handle the case where it's not followed by comma?
            # The error was `",` -> `',`.
            # So looking for `',` is correct.
            
        fixed_lines.append(new_line)

    with open(file_path, 'w') as f:
        f.writelines(fixed_lines)
    print(f"Reverted damage in {file_path}")

if __name__ == "__main__":
    fix_revert_damage('/Users/seleemaleshinloye/quiz-app/quiz_app/lib/screens/local_questions.dart')
