import re

def fix_mixed_quotes(file_path):
    with open(file_path, 'r') as f:
        lines = f.readlines()

    fixed_lines = []
    for line in lines:
        new_line = line
        
        # Fix mixed quotes in keys
        # 'key": -> 'key':
        new_line = re.sub(r"'([^']+)\":", r"'\1':", new_line)
        # "key': -> 'key':
        new_line = re.sub(r"\"([^']+)\':", r"'\1':", new_line)
        
        # Fix mixed quotes in values (raw strings)
        # r'..." -> r'...'
        # But wait, if it ends with ", maybe it started with "?
        # The error showed: r'Resistor",
        # This implies it started with r' and ended with ",
        # But r'Resistor" is a valid string if it ends with '
        # Wait, if it is r'Resistor", then the string is 'Resistor"' (including the double quote).
        # And the comma is outside?
        # If the line is: 'correct_answer": r'Resistor",
        # The key is broken.
        # The value: r'Resistor",
        # If the key is fixed to 'correct_answer':
        # Then value is r'Resistor",
        # Dart sees r' ... ' as the string.
        # So it sees Resistor", as the content? No.
        # r' starts string.
        # Resistor is content.
        # " is content.
        # , is content.
        # It keeps going until it finds '.
        # If there is no ', it's unterminated.
        
        # So I need to replace the trailing ", with ',
        # IF the start was r'.
        
        # Regex for r' ... ",
        # r'([^']*)",\s*$
        if "r'" in new_line and '",' in new_line:
             new_line = new_line.replace('",', "',")
        
        # Also handle "key": r'value",
        # The key fix above handles the key.
        
        fixed_lines.append(new_line)

    with open(file_path, 'w') as f:
        f.writelines(fixed_lines)
    print(f"Fixed mixed quotes in {file_path}")

if __name__ == "__main__":
    fix_mixed_quotes('/Users/seleemaleshinloye/quiz-app/quiz_app/lib/screens/local_questions.dart')
