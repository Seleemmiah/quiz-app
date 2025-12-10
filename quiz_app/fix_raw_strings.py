import re

def fix_broken_raw_strings(file_path):
    with open(file_path, 'r') as f:
        lines = f.readlines()

    fixed_lines = []
    for line in lines:
        # Regex to capture r' ... ' where ... contains '
        # We use lookahead (?=[,\]}\n]) to find the end of the string but not consume the separator.
        # Group 1 is the content inside r'...'
        
        def replace_raw(match):
            content = match.group(1)
            # If content has ' and not ", switch to r"..."
            if "'" in content and '"' not in content:
                return f'r"{content}"'
            return match.group(0) # No change
        
        # Regex: r'((?:[^']|'[^,\]}\n])*?)'(?=[,\]}\n])
        # This matches r' followed by content, ending with ' followed by separator.
        # The content can contain ' as long as it's not followed by a separator.
        # This is heuristic but should work for the specific broken lines like: 'correct_answer': r'Ohm's Law',
        
        new_line = re.sub(r"r'((?:[^']|'[^,\]}\n])*?)'(?=[,\]}\n])", replace_raw, line)
        fixed_lines.append(new_line)

    with open(file_path, 'w') as f:
        f.writelines(fixed_lines)
    print(f"Fixed broken raw strings in {file_path}")

if __name__ == "__main__":
    fix_broken_raw_strings('/Users/seleemaleshinloye/quiz-app/quiz_app/lib/screens/local_questions.dart')
