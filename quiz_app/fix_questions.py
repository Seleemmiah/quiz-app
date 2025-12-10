import re

def fix_local_questions(file_path):
    with open(file_path, 'r') as f:
        lines = f.readlines()

    fixed_lines = []
    for line in lines:
        # Check for double-quoted strings containing $ or \
        # This is a simple heuristic. A full parser would be better but overkill.
        # We look for: "key": "value"
        
        # Regex to capture the value part: "key": "value"
        # We want to find lines that have a string value with $ or \ inside double quotes
        
        # Pattern: "key": "value"
        # We are looking for lines that look like map entries
        match = re.search(r'^\s*"[^"]+":\s*"([^"]*)"', line)
        if match:
            value_content = match.group(1)
            if '$' in value_content or '\\' in value_content:
                # Needs fixing.
                # Strategy: Convert to raw string r'...'
                # But we need to handle single quotes inside the value
                
                # Replace "key": "value" with 'key': r'value'
                
                # 1. Extract key and value
                key_match = re.search(r'^\s*"([^"]+)":', line)
                key = key_match.group(1)
                
                # 2. Escape single quotes in value if we use r'...'
                # Actually, if we use r'...', we can't escape ' inside it easily if it's the delimiter.
                # Dart raw strings: r'foo' or r"foo".
                # If the value contains ", we can use r'...'.
                # If the value contains ', we can use r"...".
                # If it contains both, we are in trouble with raw strings.
                
                if "'" not in value_content:
                    # Use r'...'
                    new_line = line.replace(f'"{value_content}"', f"r'{value_content}'")
                    # Also replace key quotes for consistency (optional)
                    # new_line = new_line.replace(f'"{key}"', f"'{key}'")
                    fixed_lines.append(new_line)
                elif '"' not in value_content:
                    # Use r"..."
                    new_line = line.replace(f'"{value_content}"', f'r"{value_content}"')
                    fixed_lines.append(new_line)
                else:
                    # Contains both ' and ". Fallback to escaping $ and \ in a normal string.
                    # Actually, if we use normal string, we must escape \ and $.
                    # The user pasted raw text, so \ was meant to be a literal backslash (e.g. LaTeX).
                    # In a normal string "...", \ is an escape char. So \ must be \\.
                    # $ must be \$.
                    
                    fixed_value = value_content.replace('\\', '\\\\').replace('$', '\\$').replace('"', '\\"')
                    # We keep the surrounding double quotes
                    # But wait, the original line already has "value".
                    # If we just replace the content...
                    
                    # Let's try to use r'''...''' (multiline raw string) which handles both quotes better?
                    # But that spans lines.
                    
                    # Let's just escape $ and \ and use double quotes.
                    fixed_value = value_content.replace('\\', '\\\\').replace('$', '\\$')
                    new_line = line.replace(value_content, fixed_value)
                    fixed_lines.append(new_line)
            else:
                fixed_lines.append(line)
        else:
            fixed_lines.append(line)

    with open(file_path, 'w') as f:
        f.writelines(fixed_lines)
    print(f"Fixed {file_path}")

if __name__ == "__main__":
    fix_local_questions('/Users/seleemaleshinloye/quiz-app/quiz_app/lib/screens/local_questions.dart')
