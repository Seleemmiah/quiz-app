#!/usr/bin/env python3
"""
MEGA QUESTION GENERATOR - ALL REMAINING CATEGORIES
Generates ~600 questions for 13 categories
Output: Dart-formatted questions ready for local_questions.dart
"""

import json

def esc(s):
    """Escape for Dart strings"""
    return s.replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n')

def q(cat, diff, question, correct, incorrect, expl):
    """Generate single Dart question"""
    return f'''  {{
    "category": "{esc(cat)}",
    "type": "multiple",
    "difficulty": "{diff}",
    "question": "{esc(question)}",
    "correct_answer": "{esc(correct)}",
    "incorrect_answers": {json.dumps([esc(a) for a in incorrect])},
    "explanation": "{esc(expl)}"
  }}'''

# Store all questions
all_questions = []

# ============================================================================
# SCIENCE: COMPUTERS - Need 18 easy, 17 medium, 20 hard
# ============================================================================
cat = "Science: Computers"

# Easy (18)
easy_cs = [
    ("What does CPU stand for?", "Central Processing Unit", ["Central Process Unit", "Computer Personal Unit", "Central Processor Unit"], "CPU stands for Central Processing Unit, the main processor of a computer."),
    ("What does RAM stand for?", "Random Access Memory", ["Read Access Memory", "Random Application Memory", "Rapid Access Memory"], "RAM is Random Access Memory, used for temporary data storage."),
    ("Who is considered the Father of Computers?", "Charles Babbage", ["Alan Turing", "John von Neumann", "Bill Gates"], "Charles Babbage designed the first mechanical computer, the Analytical Engine."),
    ("How many bits are in a byte?", "8", ["4", "16", "32"], "A byte consists of 8 bits, the basic unit of computer storage."),
    ("What does GUI stand for?", "Graphical User Interface", ["General User Interface", "Graphical Utility Interface", "General Utility Interface"], "GUI stands for Graphical User Interface, allowing visual interaction with computers."),
    ("What does USB stand for?", "Universal Serial Bus", ["United Serial Bus", "Universal System Bus", "Uniform Serial Bus"], "USB stands for Universal Serial Bus, a standard for connecting devices."),
    ("What is the main circuit board of a computer called?", "Motherboard", ["Fatherboard", "Mainboard", "Systemboard"], "The motherboard is the main printed circuit board in a computer."),
    ("What does WWW stand for?", "World Wide Web", ["Wide World Web", "World Web Wide", "Web World Wide"], "WWW stands for World Wide Web, the information system on the Internet."),
    ("What is the smallest unit of data in a computer?", "Bit", ["Byte", "Nibble", "Word"], "A bit is the smallest unit of data, representing a 0 or 1."),
    ("What does PDF stand for?", "Portable Document Format", ["Print Document Format", "Portable Data File", "Public Document Format"], "PDF stands for Portable Document Format, developed by Adobe."),
    ("What is malware?", "Malicious software", ["Mail software", "Main software", "Manual software"], "Malware is malicious software designed to harm or exploit computers."),
    ("What does URL stand for?", "Uniform Resource Locator", ["Universal Resource Locator", "Uniform Reference Link", "Universal Reference Locator"], "URL stands for Uniform Resource Locator, the address of a web resource."),
    ("What does LAN stand for?", "Local Area Network", ["Large Area Network", "Long Access Network", "Limited Area Network"], "LAN stands for Local Area Network, a network in a limited area."),
    ("What is a firewall used for?", "Network security", ["File storage", "Data backup", "Video editing"], "A firewall protects networks by controlling incoming and outgoing traffic."),
    ("What does SSD stand for?", "Solid State Drive", ["Super Speed Drive", "Solid Storage Device", "System State Drive"], "SSD stands for Solid State Drive, a type of storage device."),
    ("What is phishing?", "Fraudulent attempt to obtain sensitive information", ["A type of computer game", "A programming language", "A hardware component"], "Phishing is a cybercrime where attackers trick people into revealing sensitive data."),
    ("One gigabyte equals how many megabytes?", "1024", ["1000", "512", "2048"], "One gigabyte equals 1024 megabytes in binary notation."),
    ("What is cloud computing?", "Storing and accessing data over the internet", ["Computing in bad weather", "A type of processor", "A programming language"], "Cloud computing delivers computing services over the internet."),
]

# Medium (17)
medium_cs = [
    ("What does HTML stand for?", "HyperText Markup Language", ["High Tech Modern Language", "Home Tool Markup Language", "Hyperlinks and Text Markup Language"], "HTML is HyperText Markup Language, used to create web pages."),
    ("Which programming language is named after an Indonesian island?", "Java", ["Python", "Ruby", "Perl"], "Java is named after Java, an Indonesian island known for its coffee."),
    ("Who created the C++ programming language?", "Bjarne Stroustrup", ["Dennis Ritchie", "James Gosling", "Guido van Rossum"], "Bjarne Stroustrup created C++ in 1979 as an extension of C."),
    ("What does ENIAC stand for?", "Electronic Numerical Integrator and Computer", ["Electronic Network Integration and Control", "Enhanced Numerical Interface and Calculator", "Electronic Numeric Instruction and Computation"], "ENIAC was one of the earliest electronic digital computers."),
    ("What operating system is Linux designed to imitate?", "Unix", ["Windows", "macOS", "DOS"], "Linux is a Unix-like operating system created by Linus Torvalds."),
    ("What is the kernel in an operating system?", "The core responsible for resource management", ["The user interface", "The application layer", "The network driver"], "The kernel is the core of an OS, managing resources, files, and security."),
    ("What does API stand for?", "Application Programming Interface", ["Advanced Programming Interface", "Application Process Interface", "Advanced Process Integration"], "API stands for Application Programming Interface, allowing software to communicate."),
    ("What is the time complexity of binary search?", "O(log n)", ["O(n)", "O(n^2)", "O(1)"], "Binary search has O(log n) time complexity as it halves the search space each iteration."),
    ("What does SQL stand for?", "Structured Query Language", ["Standard Query Language", "Simple Query Language", "System Query Language"], "SQL is Structured Query Language used for managing relational databases."),
    ("What is the purpose of DNS?", "Translate domain names to IP addresses", ["Secure network connections", "Store website data", "Compress files"], "DNS (Domain Name System) converts human-readable domain names to IP addresses."),
    ("What is a computer worm?", "Self-replicating malware that spreads automatically", ["A debugging tool", "A type of cable", "A search algorithm"], "A worm is malware that replicates itself and spreads without user interaction."),
    ("What is a compiler?", "Translates source code to machine code", ["Executes code line by line", "Debugs programs", "Compresses files"], "A compiler translates entire source code into machine code before execution."),
    ("What is the difference between RAM and ROM?", "RAM is volatile, ROM is non-volatile", ["RAM is slower", "ROM is larger", "RAM is permanent"], "RAM loses data when power is off, while ROM retains data permanently."),
    ("What is a virtual machine?", "Software emulation of a computer", ["A cloud server", "A network device", "A storage system"], "A virtual machine is a software emulation of a physical computer."),
    ("What is cache memory?", "High-speed memory for frequently accessed data", ["Long-term storage", "Backup memory", "Network memory"], "Cache memory stores frequently accessed data for faster retrieval."),
    ("What does HTTP stand for?", "HyperText Transfer Protocol", ["Hyperlink Text Transfer Protocol", "High-Level Text Transfer Protocol", "HyperText Translation Protocol"], "HTTP is HyperText Transfer Protocol, the foundation of data communication on the web."),
    ("What is the primary function of a router?", "Forward data packets between networks", ["Store files", "Run applications", "Display graphics"], "A router forwards data packets between computer networks."),
]

# Hard (20)
hard_cs = [
    ("Who is regarded as the first computer programmer?", "Ada Lovelace", ["Charles Babbage", "Alan Turing", "Grace Hopper"], "Ada Lovelace wrote the first algorithm for Charles Babbage's Analytical Engine."),
    ("What IBM computer defeated Garry Kasparov in 1997?", "Deep Blue", ["Watson", "Summit", "Blue Gene"], "Deep Blue defeated world chess champion Garry Kasparov in 1997."),
    ("What is IEEE 1394 commonly known as?", "FireWire", ["Thunderbolt", "USB-C", "HDMI"], "IEEE 1394 is commonly known as FireWire, used for high-speed data transfer."),
    ("What was the first virus detected on ARPANET?", "Creeper", ["Morris", "ILOVEYOU", "Melissa"], "Creeper was the first virus detected on ARPANET in the early 1970s."),
    ("Who co-designed TCP/IP protocols?", "Vinton Cerf", ["Tim Berners-Lee", "Robert Kahn", "Larry Page"], "Vinton Cerf and Robert Kahn co-designed the TCP/IP protocols."),
    ("What is the CAP theorem in distributed systems?", "Consistency, Availability, Partition tolerance", ["Cache, API, Protocol", "Compute, Allocate, Process", "Connect, Authenticate, Protect"], "CAP theorem states you can only guarantee two of three: Consistency, Availability, Partition tolerance."),
    ("What is the halting problem?", "Determining if a program will terminate", ["Finding infinite loops", "Debugging code", "Optimizing algorithms"], "The halting problem proves it's impossible to determine if any program will halt for all inputs."),
    ("What is a Turing machine?", "Abstract computational model", ["A physical computer", "A programming language", "An operating system"], "A Turing machine is a mathematical model of computation that defines an abstract machine."),
    ("What is the difference between P and NP problems?", "P is polynomial time, NP is nondeterministic polynomial", ["P is parallel, NP is not", "P is private, NP is public", "P is permanent, NP is temporary"], "P problems can be solved in polynomial time; NP problems can be verified in polynomial time."),
    ("What is a bloom filter?", "Probabilistic data structure for set membership", ["A sorting algorithm", "A compression technique", "A security protocol"], "A bloom filter is a space-efficient probabilistic data structure to test set membership."),
    ("What is eventual consistency?", "Data becomes consistent over time", ["Immediate consistency", "Strong consistency", "No consistency"], "Eventual consistency guarantees that if no new updates are made, all replicas will eventually converge."),
    ("What is a trie data structure?", "Tree for storing strings efficiently", ["A sorting algorithm", "A hash function", "A graph traversal"], "A trie is a tree data structure used for efficient string storage and retrieval."),
    ("What is a B-tree?", "Self-balancing tree for databases", ["A binary tree", "A sorting algorithm", "A hash table"], "A B-tree is a self-balancing tree structure commonly used in databases and file systems."),
    ("What is the MapReduce paradigm?", "Processing large datasets in parallel", ["A sorting technique", "A security protocol", "A network model"], "MapReduce is a programming model for processing large datasets across distributed clusters."),
    ("What is a race condition?", "Multiple threads accessing shared data simultaneously", ["A performance optimization", "A security feature", "A debugging tool"], "A race condition occurs when multiple threads access shared data concurrently, causing unpredictable results."),
    ("What is the lambda calculus?", "Formal system for expressing computation", ["A programming language", "A database query", "A network protocol"], "Lambda calculus is a formal system in mathematical logic for expressing computation based on function abstraction."),
    ("What is Byzantine fault tolerance?", "System continues despite malicious failures", ["A security protocol", "A network standard", "A programming paradigm"], "Byzantine fault tolerance allows a system to continue operating correctly even when some components fail maliciously."),
    ("What sorting algorithm has O(n log n) average complexity?", "Quicksort", ["Bubble Sort", "Insertion Sort", "Selection Sort"], "Quicksort has O(n log n) average time complexity and is very efficient for large datasets."),
    ("What is the two-phase commit protocol?", "Distributed transaction protocol", ["A sorting algorithm", "A security measure", "A compression method"], "Two-phase commit ensures all nodes in a distributed transaction commit or abort together."),
    ("What is a consensus algorithm?", "Algorithm for agreement in distributed systems", ["A sorting method", "A search technique", "A compression algorithm"], "Consensus algorithms enable distributed systems to agree on a single value despite failures."),
]

for quest, ans, wrong, exp in easy_cs:
    all_questions.append(q(cat, "easy", quest, ans, wrong, exp))
for quest, ans, wrong, exp in medium_cs:
    all_questions.append(q(cat, "medium", quest, ans, wrong, exp))
for quest, ans, wrong, exp in hard_cs:
    all_questions.append(q(cat, "hard", quest, ans, wrong, exp))

print(f"// Generated {len(all_questions)} Science: Computers questions so far...")

# Print all questions
for i, quest in enumerate(all_questions):
    print(quest, end="")
    if i < len(all_questions) - 1:
        print(",")
    else:
        print()

print(f"\n// Total: {len(all_questions)} questions generated")
print("// Science: Computers: 18 easy, 17 medium, 20 hard")
