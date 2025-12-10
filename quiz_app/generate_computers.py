#!/usr/bin/env python3
"""
Comprehensive AI-Assisted Quiz Question Generator
Generates questions for all remaining categories using templates and factual data
"""

import json
import random

def escape_dart_string(s):
    """Escape special characters for Dart strings"""
    return s.replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n')

def convert_to_dart(category, difficulty, questions):
    """Convert questions to Dart map format"""
    dart_output = []
    
    for q, correct, incorrect, explanation in questions:
        dart_map = f'''  {{
    "category": "{escape_dart_string(category)}",
    "type": "multiple",
    "difficulty": "{difficulty}",
    "question": "{escape_dart_string(q)}",
    "correct_answer": "{escape_dart_string(correct)}",
    "incorrect_answers": {json.dumps([escape_dart_string(ans) for ans in incorrect])},
    "explanation": "{escape_dart_string(explanation)}"
  }}'''
        dart_output.append(dart_map)
    
    return dart_output

# Complete question database for all categories
ALL_QUESTIONS = {
    "Science: Computers": {
        "easy": [
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
            ("What is cloud computing?", "Storing and accessing data over the internet", ["Computing in bad weather", "A type of processor", "A programming language"], "Cloud computing delivers computing services over the internet."),
            ("What does Wi-Fi stand for?", "Wireless Fidelity", ["Wide Fidelity", "Wireless Field", "Wide Field"], "Wi-Fi is a wireless networking technology based on IEEE 802.11 standards."),
        ],
        "medium": [
            ("What is the time complexity of binary search?", "O(log n)", ["O(n)", "O(n^2)", "O(1)"], "Binary search has O(log n) time complexity as it halves the search space each iteration."),
            ("What does API stand for?", "Application Programming Interface", ["Advanced Programming Interface", "Application Process Interface", "Advanced Process Integration"], "API stands for Application Programming Interface, allowing software to communicate."),
            ("What is polymorphism in OOP?", "Ability of objects to take multiple forms", ["Multiple inheritance", "Data hiding", "Code reusability"], "Polymorphism allows objects of different classes to be treated as objects of a common parent class."),
            ("What is the difference between TCP and UDP?", "TCP is connection-oriented, UDP is connectionless", ["TCP is faster than UDP", "UDP is more reliable", "TCP uses less bandwidth"], "TCP ensures reliable delivery while UDP prioritizes speed over reliability."),
            ("What is a stack data structure?", "Last In First Out (LIFO)", ["First In First Out", "Random Access", "Sorted Access"], "A stack follows LIFO principle where the last element added is the first to be removed."),
            ("What does SQL stand for?", "Structured Query Language", ["Standard Query Language", "Simple Query Language", "System Query Language"], "SQL is Structured Query Language used for managing relational databases."),
            ("What is recursion in programming?", "A function calling itself", ["A loop structure", "An array operation", "A sorting algorithm"], "Recursion is when a function calls itself to solve a problem."),
            ("What is the purpose of DNS?", "Translate domain names to IP addresses", ["Secure network connections", "Store website data", "Compress files"], "DNS (Domain Name System) converts human-readable domain names to IP addresses."),
            ("What is a hash table?", "Data structure using key-value pairs", ["A sorted array", ["A linked list", "A binary tree"], "A hash table stores data in key-value pairs for fast lookup."),
            ("What is the OSI model?", "7-layer network communication model", ["Operating system interface", "Online security interface", "Open source initiative"], "The OSI model is a conceptual framework with 7 layers for network communication."),
            ("What is multithreading?", "Concurrent execution of multiple threads", ["Multiple processors", "Multiple programs", "Multiple users"], "Multithreading allows concurrent execution of two or more parts of a program."),
            ("What is Big O notation used for?", "Analyzing algorithm efficiency", ["Measuring file size", "Counting code lines", "Testing software"], "Big O notation describes the performance or complexity of an algorithm."),
            ("What is a compiler?", "Translates source code to machine code", ["Executes code line by line", "Debugs programs", "Compresses files"], "A compiler translates entire source code into machine code before execution."),
            ("What is encapsulation in OOP?", "Bundling data and methods together", ["Inheriting properties", "Overloading functions", "Creating objects"], "Encapsulation bundles data and methods that operate on that data within a class."),
            ("What is a RESTful API?", "API following REST architectural style", ["A database system", ["A programming language", "A web framework"], "REST (Representational State Transfer) is an architectural style for web services."),
            ("What is the purpose of version control?", "Track and manage code changes", ["Compile programs", "Test software", "Deploy applications"], "Version control systems track changes to code over time, enabling collaboration."),
            ("What is a deadlock?", "Two processes waiting for each other", ["A security breach", "A syntax error", "A memory leak"], "Deadlock occurs when processes are blocked waiting for resources held by each other."),
            ("What is the difference between RAM and ROM?", "RAM is volatile, ROM is non-volatile", ["RAM is slower", "ROM is larger", "RAM is permanent"], "RAM loses data when power is off, while ROM retains data permanently."),
            ("What is a virtual machine?", "Software emulation of a computer", ["A cloud server", "A network device", "A storage system"], "A virtual machine is a software emulation of a physical computer."),
            ("What is cache memory?", "High-speed memory for frequently accessed data", ["Long-term storage", "Backup memory", "Network memory"], "Cache memory stores frequently accessed data for faster retrieval."),
        ],
        "hard": [
            ("What is the CAP theorem in distributed systems?", "Consistency, Availability, Partition tolerance", ["Cache, API, Protocol", "Compute, Allocate, Process", "Connect, Authenticate, Protect"], "CAP theorem states you can only guarantee two of three: Consistency, Availability, Partition tolerance."),
            ("What is the Byzantine Generals Problem?", "Achieving consensus in distributed systems with faulty nodes", ["A sorting algorithm", "A network protocol", "A security vulnerability"], "The Byzantine Generals Problem addresses reaching consensus when some nodes may be faulty or malicious."),
            ("What is the difference between mutex and semaphore?", "Mutex allows one thread, semaphore allows multiple", ["Mutex is faster", "Semaphore is binary", "Mutex uses more memory"], "A mutex allows only one thread access, while a semaphore can allow multiple threads."),
            ("What is the halting problem?", "Determining if a program will terminate", ["Finding infinite loops", "Debugging code", "Optimizing algorithms"], "The halting problem proves it's impossible to determine if any program will halt for all inputs."),
            ("What is a Turing machine?", "Abstract computational model", ["A physical computer", "A programming language", "An operating system"], "A Turing machine is a mathematical model of computation that defines an abstract machine."),
            ("What is the difference between P and NP problems?", "P is polynomial time, NP is nondeterministic polynomial", ["P is parallel, NP is not", "P is private, NP is public", "P is permanent, NP is temporary"], "P problems can be solved in polynomial time; NP problems can be verified in polynomial time."),
            ("What is a bloom filter?", "Probabilistic data structure for set membership", ["A sorting algorithm", "A compression technique", "A security protocol"], "A bloom filter is a space-efficient probabilistic data structure to test set membership."),
            ("What is the actor model?", "Concurrent computation model using actors", ["A design pattern", "A database model", "A network protocol"], "The actor model treats actors as universal primitives of concurrent computation."),
            ("What is eventual consistency?", "Data becomes consistent over time", ["Immediate consistency", "Strong consistency", "No consistency"], "Eventual consistency guarantees that if no new updates are made, all replicas will eventually converge."),
            ("What is the two-phase commit protocol?", "Distributed transaction protocol", ["A sorting algorithm", "A security measure", "A compression method"], "Two-phase commit ensures all nodes in a distributed transaction commit or abort together."),
            ("What is a trie data structure?", "Tree for storing strings efficiently", ["A sorting algorithm", "A hash function", "A graph traversal"], "A trie is a tree data structure used for efficient string storage and retrieval."),
            ("What is the difference between strong and weak consistency?", "Strong guarantees immediate consistency, weak allows delays", ["Strong is faster", "Weak is more reliable", "Strong uses less memory"], "Strong consistency ensures all nodes see the same data immediately; weak allows temporary inconsistencies."),
            ("What is a B-tree?", "Self-balancing tree for databases", ["A binary tree", "A sorting algorithm", "A hash table"], "A B-tree is a self-balancing tree structure commonly used in databases and file systems."),
            ("What is the MapReduce paradigm?", "Processing large datasets in parallel", ["A sorting technique", "A security protocol", "A network model"], "MapReduce is a programming model for processing large datasets across distributed clusters."),
            ("What is a race condition?", "Multiple threads accessing shared data simultaneously", ["A performance optimization", "A security feature", "A debugging tool"], "A race condition occurs when multiple threads access shared data concurrently, causing unpredictable results."),
            ("What is the difference between stack and heap memory?", "Stack is automatic, heap is dynamic", ["Stack is larger", "Heap is faster", "Stack is permanent"], "Stack memory is automatically managed for local variables; heap is manually managed for dynamic allocation."),
            ("What is a consensus algorithm?", "Algorithm for agreement in distributed systems", ["A sorting method", "A search technique", "A compression algorithm"], "Consensus algorithms enable distributed systems to agree on a single value despite failures."),
            ("What is the lambda calculus?", "Formal system for expressing computation", ["A programming language", "A database query", "A network protocol"], "Lambda calculus is a formal system in mathematical logic for expressing computation based on function abstraction."),
            ("What is a skip list?", "Probabilistic data structure for fast search", ["A sorting algorithm", "A compression method", "A security protocol"], "A skip list is a probabilistic alternative to balanced trees for fast search operations."),
            ("What is the Byzantine fault tolerance?", "System continues despite malicious failures", ["A security protocol", "A network standard", "A programming paradigm"], "Byzantine fault tolerance allows a system to continue operating correctly even when some components fail maliciously."),
        ],
    },
}

def main():
    """Generate all questions in Dart format"""
    print("// AUTO-GENERATED QUIZ QUESTIONS - PART 2")
    print("// Science: Computers category")
    print("// Add these to the localQuestions list in local_questions.dart\n")
    
    all_questions = []
    stats = {}
    
    for category, difficulties in ALL_QUESTIONS.items():
        stats[category] = {}
        for difficulty, questions in difficulties.items():
            dart_qs = convert_to_dart(category, difficulty, questions)
            all_questions.extend(dart_qs)
            stats[category][difficulty] = len(questions)
    
    # Print questions with commas
    for i, q in enumerate(all_questions):
        print(q, end="")
        if i < len(all_questions) - 1:
            print(",")
        else:
            print()
    
    # Print statistics
    print("\n// Statistics:")
    total = 0
    for category, diffs in stats.items():
        cat_total = sum(diffs.values())
        total += cat_total
        print(f"// {category}: {diffs.get('easy', 0)} easy, {diffs.get('medium', 0)} medium, {diffs.get('hard', 0)} hard (Total: {cat_total})")
    print(f"// TOTAL: {total} questions")

if __name__ == "__main__":
    main()
