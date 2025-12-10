import re

def fix_broken_quotes(file_path):
    with open(file_path, 'r') as f:
        lines = f.readlines()

    fixed_lines = []
    for line in lines:
        new_line = line
        
        # Check for lines starting with "key": "value',
        # Regex: ^\s*"[^"]+":\s*"[^"]*',
        # Matches: "question": "Who created the sculpture 'The Thinker'?',
        
        # We want to replace the trailing ', with ",
        # But only if the string started with "
        
        # Regex to capture the whole line structure
        # ^(\s*"[^"]+":\s*")([^"]*)',
        # Group 1: indentation + key + start quote
        # Group 2: content
        # Match ends with ',
        
        match = re.search(r'^(\s*"[^"]+":\s*")(.+)\',', line)
        if match:
            # Check if it really ends with ',
            # The regex ensures it.
            # But wait, what if the content has " inside?
            # The regex (.+) is greedy. It consumes everything until the last ',
            # If the line is: "key": "val", "key2": "val',
            # It might match across keys?
            # But this file has one key-value per line.
            
            # So we can safely replace the last ', with ",
            # But only if it started with "
            
            # Let's use the match groups to reconstruct.
            prefix = match.group(1)
            content = match.group(2)
            # Reconstruct with ",
            new_line = f'{prefix}{content}",\n'
        
        fixed_lines.append(new_line)

    with open(file_path, 'w') as f:
        f.writelines(fixed_lines)
    print(f"Fixed broken quotes in {file_path}")

if __name__ == "__main__":
    fix_broken_quotes('/Users/seleemaleshinloye/quiz-app/quiz_app/lib/screens/local_questions.dart')
