import os

main_file = 'lib/screens/local_questions.dart'
new_files = [
    'lib/data/new_math_questions.dart', 
    'lib/data/new_sci_questions.dart',
    'lib/data/new_eng_questions.dart',
    'lib/data/new_culture_questions.dart'
]

if not os.path.exists(main_file):
    print("Main file not found")
    exit(1)

with open(main_file, 'r', encoding='utf-8') as f:
    content = f.read()

# TRUNCATE at first import marker
marker = '// --- Imported'
if marker in content:
    print("Found existing imports. Truncating...")
    content = content.split(marker)[0]
    # Aggressively remove closing bracket from base content
    # Find last occurrences of ];
    base_end_idx = content.rfind('];')
    if base_end_idx != -1:
        print(f"Found closing bracket in base at {base_end_idx}. Removing...")
        content = content[:base_end_idx]
    
    content = content.strip()
    # Also check for single ]
    if content.endswith(']'):
        content = content[:-1]
else:
    print("No imports found. Using entire file as base.")
    content = content.strip()
    if content.endswith('];'):
        content = content[:-2]
    elif content.endswith(']'):
        content = content[:-1]

# Ensure comma
content = content.strip()
if not content.endswith(','):
    content += ','

# Append new files
total_appended = 0
for nf in new_files:
    if os.path.exists(nf):
        print(f"Appending {nf}...")
        with open(nf, 'r', encoding='utf-8') as f:
            new_c = f.read().strip()
            # Remove header "final List... = ["
            start_idx = new_c.find('[')
            if start_idx != -1:
                new_c = new_c[start_idx+1:]
            
            # Remove footer "];" using regex to ignore whitespace
            import re
            new_c = re.sub(r'\]\s*;\s*$', '', new_c)
            
            content += "\n  // --- Imported from " + nf + " ---\n"
            content += new_c
            if not content.strip().endswith(','):
                 content += ','
            total_appended += 1
    else:
        print(f"Warning: {nf} not found.")

# Close the list
content += "\n];"

with open(main_file, 'w', encoding='utf-8') as f:
    f.write(content)

print(f"Rebuild verified. Appended {total_appended} files.")
