def fix_specific_errors(file_path):
    with open(file_path, 'r') as f:
        content = f.read()

    # Fix r'Ohm's Law' -> r"Ohm's Law"
    # We use replace which replaces all occurrences.
    new_content = content.replace("r'Ohm's Law'", 'r"Ohm\'s Law"')
    
    # Also check for other potential issues
    # r'Kirchhoff's Law' -> r"Kirchhoff's Law" (already fixed by regex script?)
    # r'Newton's Law' -> r"Newton's Law"
    # r'Faraday's Law' -> r"Faraday's Law"
    
    # Let's just be safe and replace them if they exist in the broken form
    new_content = new_content.replace("r'Kirchhoff's Law'", 'r"Kirchhoff\'s Law"')
    new_content = new_content.replace("r'Newton's Law'", 'r"Newton\'s Law"')
    new_content = new_content.replace("r'Faraday's Law'", 'r"Faraday\'s Law"')
    
    # Also check for "Ohm's Law relates..."
    # r'Ohm's Law relates
    new_content = new_content.replace("r'Ohm's Law relates", 'r"Ohm\'s Law relates')
    # This one is tricky because we need to close it with " instead of '
    # But replace only changes the start.
    # If we change start to r", the end ' will be mismatched.
    
    # So we need to find the whole string.
    # r'Ohm's Law relates Voltage (V), Current (I), and Resistance (R).'
    # -> r"Ohm's Law relates Voltage (V), Current (I), and Resistance (R)."
    
    target_string = "r'Ohm's Law relates Voltage (V), Current (I), and Resistance (R).'"
    replacement_string = 'r"Ohm\'s Law relates Voltage (V), Current (I), and Resistance (R)."'
    new_content = new_content.replace(target_string, replacement_string)

    with open(file_path, 'w') as f:
        f.write(new_content)
    print(f"Fixed specific errors in {file_path}")

if __name__ == "__main__":
    fix_specific_errors('/Users/seleemaleshinloye/quiz-app/quiz_app/lib/screens/local_questions.dart')
