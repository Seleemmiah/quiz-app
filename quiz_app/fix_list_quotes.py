import re

def fix_list_quotes(file_path):
    with open(file_path, 'r') as f:
        lines = f.readlines()

    fixed_lines = []
    for line in lines:
        new_line = line
        
        # 1. Fix "..."', -> "...",
        # Regex: ("[^"]*)',
        # We want to replace the ' with "
        # But be careful about internal '
        # The regex ("[^"]*) matches " followed by non-quotes.
        # If the string is "The Gleaners',
        # It matches "The Gleaners.
        # Then ', follows.
        # So we replace with \1",
        
        new_line = re.sub(r'("[^"]*)\',', r'\1",', new_line)
        
        # 2. Fix "..."'] -> "..."]
        new_line = re.sub(r'("[^"]*)\']', r'\1"]', new_line)
        
        # 3. Fix "..." ] -> "..."] (missing closing quote)
        # Regex: ("[^"]*)(?=\])
        # Matches "Whistler's Mother
        # Followed by ]
        # Check if it ends with "
        # But regex [^"]* ensures it doesn't contain " (and thus doesn't end with it).
        # So "Whistler's Mother matches.
        # We replace with \1"
        
        # But wait, what if it's ["A", "B"]?
        # "B" matches "[^"]*"? No, "B" contains ".
        # So "[^"]* matches "B? No.
        # " matches ".
        # [^"]* matches B.
        # So "B matches.
        # But we want to match the whole string starting with ".
        # So `"[^"]*` matches `"B`.
        # Does it match `"`? Yes.
        # Does it match `B`? Yes.
        # Does it match `"` (closing)? No.
        # So `"[^"]*` matches `"B`.
        # Then `"` follows.
        # So `(?=\])` fails because `"` is there, not `]`.
        
        # So `("[^"]*)(?=\])` ONLY matches if the closing quote is MISSING (or replaced by something else that is not ").
        # Wait, if it is `..."]`, the lookahead sees `]`.
        # But the match `"[^"]*` stops at the closing `"`?
        # No, `[^"]` excludes `"`.
        # So `"[^"]*` matches `"text`.
        # If the next char is `"`, then `(?=\])` fails.
        # If the next char is `]`, then `(?=\])` succeeds.
        # So this correctly identifies missing closing quote before `]`.
        
        new_line = re.sub(r'("[^"]*)(?=\])', r'\1"', new_line)
        
        # 4. Fix "..." , -> "...", (missing closing quote before comma)
        # Regex: ("[^"]*)(?=,)
        # Same logic.
        # But be careful about `key": "value",`
        # "value" matches `"[^"]*`.
        # Next char is `,`? No, next char is `"`.
        # So it fails.
        # So this is safe.
        
        new_line = re.sub(r'("[^"]*)(?=,)', r'\1"', new_line)
        
        fixed_lines.append(new_line)

    with open(file_path, 'w') as f:
        f.writelines(fixed_lines)
    print(f"Fixed list quotes in {file_path}")

if __name__ == "__main__":
    fix_list_quotes('/Users/seleemaleshinloye/quiz-app/quiz_app/lib/screens/local_questions.dart')
