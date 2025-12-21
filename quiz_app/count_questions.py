import re
import os

file_path = 'lib/screens/local_questions.dart'

if not os.path.exists(file_path):
    print(f"Error: {file_path} not found.")
    exit(1)

with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
    lines = f.readlines()

count_dict = {}
current_category = None
current_difficulty = None

for line in lines:
    # Match category
    cat_match = re.search(r'"category":\s*"(.*?)"', line)
    if cat_match:
        current_category = cat_match.group(1)
        # Normalize category names if needed (e.g. Science: Computers -> Science)
        # For now, keep exact.

    # Match difficulty
    diff_match = re.search(r'"difficulty":\s*"(.*?)"', line)
    if diff_match:
        current_difficulty = diff_match.group(1)

    # Count at a marker (e.g., correct_answer) to avoid incomplete parsing
    # But difficulty usually comes AFTER category in this file. 
    # Let's count when we hit "question" or "type"?
    # The order seems constant: category, type, difficulty, question.
    # So if we have both and hit "question", we count.
    
    if '"question":' in line and current_category and current_difficulty:
        key = (current_category, current_difficulty)
        count_dict[key] = count_dict.get(key, 0) + 1
        # Reset is tricky if order varies, but let's assume valid blocks reset logic naturally
        # Actually, in a map, fields are separate.
        # We assume one question per block.
        # We can just reset after counting.
        current_category = None
        current_difficulty = None

print(f"{'Category':<30} | {'Difficulty':<10} | {'Count'}")
print("-" * 55)

categories = sorted(list(set(k[0] for k in count_dict.keys())))
difficulties = ['easy', 'medium', 'hard']

low_buckets = []

for cat in categories:
    for diff in difficulties:
        count = count_dict.get((cat, diff), 0)
        print(f"{cat:<30} | {diff:<10} | {count}")
        if count < 20:
            low_buckets.append((cat, diff, 20 - count))

print("\n--- DEFICITS (< 20) ---")
for cat, diff, missing in low_buckets:
    print(f"{cat} - {diff}: Need {missing} more")
