#!/usr/bin/env python3
"""
Mega Question Generator - Batch 2
Generates questions for: Science: Computers, Sports, Mythology, Entertainment: Film
"""

import json

def esc(s):
    return s.replace('\\', '\\\\').replace('"', '\\"')

def q(cat, diff, question, correct, incorrect, expl):
    return f'''  {{
    "category": "{esc(cat)}",
    "type": "multiple",
    "difficulty": "{diff}",
    "question": "{esc(question)}",
    "correct_answer": "{esc(correct)}",
    "incorrect_answers": {json.dumps([esc(a) for a in incorrect])},
    "explanation": "{esc(expl)}"
  }}'''

questions = []

# Science: Computers - Need 18 easy, 17 medium, 20 hard
cat = "Science: Computers"

# Easy questions (18 needed)
for i, (quest, ans, wrong, exp) in enumerate([
    ("What does CPU stand for?", "Central Processing Unit", ["Central Process Unit", "Computer Personal Unit", "Central Processor Unit"], "CPU stands for Central Processing Unit, the main processor of a computer."),
    ("What does RAM stand for?", "Random Access Memory", ["Read Access Memory", "Random Application Memory", "Rapid Access Memory"], "RAM is Random Access Memory, used for temporary data storage."),
    ("What is the brain of the computer?", "CPU", ["RAM", "Hard Drive", "Motherboard"], "The CPU is often called the brain of the computer as it processes instructions."),
    ("What does USB stand for?", "Universal Serial Bus", ["United Serial Bus", "Universal System Bus", "Uniform Serial Bus"], "USB stands for Universal Serial Bus, a standard for connecting devices."),
    ("What is the main circuit board of a computer called?", "Motherboard", ["Fatherboard", "Mainboard", "Systemboard"], "The motherboard is the main printed circuit board in a computer."),
    ("What does HTML stand for?", "HyperText Markup Language", ["High Tech Modern Language", "Home Tool Markup Language", "Hyperlinks and Text Markup Language"], "HTML is HyperText Markup Language, used to create web pages."),
    ("What is a byte composed of?", "8 bits", ["4 bits", "16 bits", "32 bits"], "A byte consists of 8 bits, the basic unit of computer storage."),
    ("What does WWW stand for?", "World Wide Web", ["Wide World Web", "World Web Wide", "Web World Wide"], "WWW stands for World Wide Web, the information system on the Internet."),
    ("What is the smallest unit of data in a computer?", "Bit", ["Byte", "Nibble", "Word"], "A bit is the smallest unit of data, representing a 0 or 1."),
    ("What does PDF stand for?", "Portable Document Format", ["Print Document Format", "Portable Data File", "Public Document Format"], "PDF stands for Portable Document Format, developed by Adobe."),
    ("What is malware?", "Malicious software", ["Mail software", "Main software", "Manual software"], "Malware is malicious software designed to harm or exploit computers."),
    ("What does URL stand for?", "Uniform Resource Locator", ["Universal Resource Locator", "Uniform Reference Link", "Universal Reference Locator"], "URL stands for Uniform Resource Locator, the address of a web resource."),
    ("What is the main function of an operating system?", "Manage computer resources", ["Create documents", "Browse the internet", "Play games"], "An operating system manages hardware and software resources."),
    ("What does LAN stand for?", "Local Area Network", ["Large Area Network", "Long Access Network", "Limited Area Network"], "LAN stands for Local Area Network, a network in a limited area."),
    ("What is a firewall used for?", "Network security", ["File storage", "Data backup", "Video editing"], "A firewall protects networks by controlling incoming and outgoing traffic."),
    ("What does SSD stand for?", "Solid State Drive", ["Super Speed Drive", "Solid Storage Device", "System State Drive"], "SSD stands for Solid State Drive, a type of storage device."),
    ("What is phishing?", "Fraudulent attempt to obtain sensitive information", ["A type of computer game", "A programming language", "A hardware component"], "Phishing is a cybercrime where attackers trick people into revealing sensitive data."),
    ("What does GUI stand for?", "Graphical User Interface", ["General User Interface", "Graphical Utility Interface", "General Utility Interface"], "GUI stands for Graphical User Interface, allowing visual interaction with computers."),
]):
    questions.append(q(cat, "easy", quest, ans, wrong, exp))

# Print all questions
for i, quest in enumerate(questions):
    print(quest, end="")
    if i < len(questions) - 1:
        print(",")
    else:
        print()

print(f"\n// Generated {len(questions)} questions for Science: Computers")
