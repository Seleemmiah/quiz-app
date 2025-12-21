import os

main_file = 'lib/screens/local_questions.dart'
new_files = ['lib/data/new_math_questions.dart', 'lib/data/new_sci_questions.dart']

if not os.path.exists(main_file):
    print("Main file not found")
    exit(1)

with open(main_file, 'r', encoding='utf-8') as f:
    main_content = f.read().strip()

# Find the last '];'
if main_content.endswith('];'):
    main_content = main_content[:-2] # Remove ];
elif main_content.endswith(']'):
    main_content = main_content[:-1] # Remove ]

# Ensure it ends with a comma
main_content = main_content.strip()
if not main_content.endswith(','):
    main_content += ','

# Append new content
for nf in new_files:
    if os.path.exists(nf):
        with open(nf, 'r', encoding='utf-8') as f:
            new_c = f.read().strip()
            # Remove header "final List... = ["
            start_idx = new_c.find('[')
            if start_idx != -1:
                new_c = new_c[start_idx+1:]
            
            # Remove footer "];"
            if new_c.endswith('];'):
                new_c = new_c[:-2]
            
            main_content += "\n  // --- Imported from " + nf + " ---\n"
            main_content += new_c
            if not main_content.strip().endswith(','):
                 main_content += ','

# Close the list
main_content += "\n];"

with open(main_file, 'w', encoding='utf-8') as f:
    f.write(main_content)

print("Merged questions successfully.")
