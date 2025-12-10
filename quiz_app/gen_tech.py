#!/usr/bin/env python3
"""
TECH BATCH GENERATOR - Engineering, Programming
Generates ~80 questions for these 2 categories
"""
import json

def esc(s):
    return s.replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n')

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

all_q = []

# ============================================================================
# ENGINEERING - Need 13 easy, 11 medium, 16 hard (40 total)
# ============================================================================
cat = "Engineering"

# Easy (13)
eng_easy = [
    ("What does CAD stand for?", "Computer-Aided Design", ["Computer-Aided Drawing", "Computer-Assisted Design", "Complex Architectural Design"], "CAD software is used by engineers to create precision drawings."),
    ("What is the main material used in modern skyscrapers?", "Steel", ["Wood", "Brick", "Plastic"], "Steel provides the necessary strength and flexibility for tall structures."),
    ("What simple machine is a ramp?", "Inclined Plane", ["Lever", "Pulley", "Wedge"], "An inclined plane allows heavy loads to be moved up with less force."),
    ("What device converts electrical energy into mechanical energy?", "Motor", ["Generator", "Battery", "Resistor"], "An electric motor converts electrical energy into motion."),
    ("Which engineer is famous for his work with alternating current (AC)?", "Nikola Tesla", ["Thomas Edison", "Alexander Graham Bell", "Henry Ford"], "Nikola Tesla championed the AC system for electricity transmission."),
    ("What structure spans a physical obstacle like a river?", "Bridge", ["Tunnel", "Dam", "Canal"], "Bridges are built to span obstacles without closing the way underneath."),
    ("What is the rotating part of a motor called?", "Rotor", ["Stator", "Axle", "Bearing"], "The rotor is the moving component of an electromagnetic system."),
    ("What is the stationary part of a motor called?", "Stator", ["Rotor", "Commutator", "Brush"], "The stator is the stationary part of a rotary system."),
    ("What device stores electrical energy?", "Battery", ["Motor", "Switch", "Fuse"], "Batteries store chemical energy and convert it to electrical energy."),
    ("What is the unit of electrical resistance?", "Ohm", ["Volt", "Ampere", "Watt"], "The Ohm is the standard unit of electrical resistance."),
    ("What material is a good conductor of electricity?", "Copper", ["Rubber", "Glass", "Plastic"], "Copper is widely used in wiring because it conducts electricity well."),
    ("What is the main function of a dam?", "Retain water", ["Generate wind", "Filter air", "Burn trash"], "Dams are built to hold back water for reservoirs or hydroelectric power."),
    ("What simple machine is a seesaw?", "Lever", ["Pulley", "Screw", "Wheel and Axle"], "A seesaw is a classic example of a lever."),
]

# Medium (11)
eng_medium = [
    ("What is the ratio of stress to strain called?", "Young's Modulus", ["Poisson's Ratio", "Shear Modulus", "Bulk Modulus"], "Young's Modulus measures the stiffness of a solid material."),
    ("What is the primary component of concrete?", "Cement", ["Sand", "Gravel", "Water"], "Cement binds the other ingredients (aggregate and water) together."),
    ("What does HVAC stand for?", "Heating, Ventilation, and Air Conditioning", ["High Voltage Alternating Current", "Heat, Vacuum, and Cooling", "Humidity, Ventilation, and Air Control"], "HVAC systems control the environment inside buildings."),
    ("Which type of bridge uses cables to support the deck?", "Suspension Bridge", ["Arch Bridge", "Beam Bridge", "Truss Bridge"], "Suspension bridges hang the deck from cables strung between towers."),
    ("What is the measure of a material's resistance to deformation?", "Stiffness", ["Strength", "Toughness", "Hardness"], "Stiffness is the extent to which an object resists deformation in response to an applied force."),
    ("What is the process of joining metals by melting them?", "Welding", ["Soldering", "Brazing", "Forging"], "Welding fuses materials by melting them together."),
    ("What is the study of fluids in motion called?", "Fluid Dynamics", ["Thermodynamics", "Statics", "Kinematics"], "Fluid dynamics describes the flow of fluids (liquids and gases)."),
    ("What device increases or decreases voltage?", "Transformer", ["Transistor", "Capacitor", "Inductor"], "Transformers transfer electrical energy between circuits, changing voltage levels."),
    ("What is the term for a failure caused by repeated loading?", "Fatigue", ["Creep", "Fracture", "Buckling"], "Fatigue is the weakening of a material caused by cyclic loading."),
    ("Which law states V = IR?", "Ohm's Law", ["Kirchhoff's Law", "Faraday's Law", "Ampere's Law"], "Ohm's Law relates voltage, current, and resistance."),
    ("What is the main purpose of a flywheel?", "Store rotational energy", ["Generate electricity", "Cool the engine", "Filter fuel"], "Flywheels store rotational kinetic energy to smooth out power delivery."),
]

# Hard (16)
eng_hard = [
    ("What is the efficiency limit of a heat engine called?", "Carnot Efficiency", ["Rankine Efficiency", "Brayton Efficiency", "Otto Efficiency"], "The Carnot efficiency is the maximum theoretical efficiency of a heat engine."),
    ("What phenomenon causes a bridge to collapse due to wind?", "Resonance", ["Damping", "Flutter", "Fatigue"], "Resonance occurs when a force drives a system at its natural frequency (e.g., Tacoma Narrows Bridge)."),
    ("What is the term for the slow deformation of material under stress?", "Creep", ["Fatigue", "Yielding", "Buckling"], "Creep is the tendency of a solid material to move slowly or deform permanently under mechanical stresses."),
    ("What dimensionless number predicts fluid flow regimes?", "Reynolds Number", ["Mach Number", "Prandtl Number", "Nusselt Number"], "The Reynolds number helps predict laminar or turbulent flow patterns."),
    ("What is the name of the chart used to schedule projects?", "Gantt Chart", ["Pie Chart", "Pareto Chart", "Scatter Plot"], "A Gantt chart illustrates a project schedule."),
    ("Which cycle describes the operation of a steam power plant?", "Rankine Cycle", ["Otto Cycle", "Diesel Cycle", "Brayton Cycle"], "The Rankine cycle is an idealized thermodynamic cycle of a heat engine."),
    ("What is the property of a material to absorb energy before fracturing?", "Toughness", ["Hardness", "Stiffness", "Strength"], "Toughness is the ability of a material to absorb energy and plastically deform without fracturing."),
    ("What is the term for the sudden failure of a structural member under compression?", "Buckling", ["Shearing", "Tension", "Torsion"], "Buckling is a sudden change in shape (deformation) of a structural component under load."),
    ("Who is considered the father of civil engineering?", "John Smeaton", ["Isambard Kingdom Brunel", "Thomas Telford", "Gustave Eiffel"], "John Smeaton was the first to call himself a 'civil engineer'."),
    ("What is the primary alloying element in stainless steel?", "Chromium", ["Nickel", "Carbon", "Manganese"], "Chromium prevents rust by forming a passive layer of oxide."),
    ("What is the unit of inductance?", "Henry", ["Farad", "Weber", "Tesla"], "The Henry (H) is the SI unit of inductance."),
    ("Which logic gate outputs true only if both inputs are true?", "AND", ["OR", "XOR", "NAND"], "The AND gate requires both inputs to be high to output high."),
    ("What is the process of removing salt from seawater?", "Desalination", ["Distillation", "Filtration", "Chlorination"], "Desalination removes minerals from saline water."),
    ("What is the ratio of inertial forces to viscous forces?", "Reynolds Number", ["Froude Number", "Weber Number", "Euler Number"], "The Reynolds number quantifies the relative importance of these two types of forces."),
    ("What is the term for the heat required to raise the temperature of a unit mass by one degree?", "Specific Heat Capacity", ["Latent Heat", "Thermal Conductivity", "Enthalpy"], "Specific heat capacity is the heat energy required to raise the temperature of a substance."),
    ("What is the maximum stress a material can withstand while being stretched?", "Tensile Strength", ["Compressive Strength", "Shear Strength", "Yield Strength"], "Tensile strength measures the force required to pull something to the point where it breaks."),
]

# ============================================================================
# PROGRAMMING - Need 14 easy, 10 medium, 16 hard (40 total)
# ============================================================================
cat = "Programming"

# Easy (14)
prog_easy = [
    ("What does HTML stand for?", "HyperText Markup Language", ["HighText Machine Language", "HyperTool Multi Language", "Home Tool Markup Language"], "HTML is the standard markup language for documents designed to be displayed in a web browser."),
    ("What is a bug?", "An error in code", ["A feature", "A virus", "A type of variable"], "A software bug is an error, flaw, or fault in a computer program."),
    ("Which language is named after a snake?", "Python", ["Cobra", "Viper", "Anaconda"], "Python was named after Monty Python, but the snake logo is iconic."),
    ("What does GUI stand for?", "Graphical User Interface", ["General User Interface", "Global User Interface", "Graphical Unit Interface"], "A GUI allows users to interact with electronic devices through graphical icons."),
    ("What is the binary value of 1?", "1", ["0", "10", "11"], "In binary, 1 is represented as 1."),
    ("What symbol is used for comments in Python?", "#", ["//", "/*", "--"], "Python uses the hash symbol (#) for single-line comments."),
    ("What is a loop?", "Repeating code", ["Stopping code", "Deleting code", "Skipping code"], "A loop is a sequence of instructions that is continually repeated until a certain condition is reached."),
    ("What does CSS stand for?", "Cascading Style Sheets", ["Computer Style Sheets", "Creative Style Sheets", "Colorful Style Sheets"], "CSS describes how HTML elements are to be displayed on screen."),
    ("What is the main function in a C program?", "main()", ["start()", "begin()", "init()"], "Execution of a C program begins with the main() function."),
    ("What company owns Java?", "Oracle", ["Microsoft", "Google", "Apple"], "Oracle Corporation acquired Sun Microsystems, the original developer of Java."),
    ("What is 'Hello, World!'?", "First program", ["Last program", "Error message", "Virus name"], "'Hello, World!' is traditionally the first program written when learning a new language."),
    ("Which of these is a boolean value?", "True", ["10", "String", "Null"], "Boolean data types have two possible values: True or False."),
    ("What does CPU stand for?", "Central Processing Unit", ["Computer Processing Unit", "Central Program Unit", "Control Processing Unit"], "The CPU is the primary component of a computer that acts as its 'brain'."),
    ("What is an array?", "A list of items", ["A single number", "A text file", "A database"], "An array is a data structure consisting of a collection of elements."),
]

# Medium (10)
prog_medium = [
    ("What does SQL stand for?", "Structured Query Language", ["Standard Query Language", "Simple Query Language", "System Query Language"], "SQL is a domain-specific language used in programming and designed for managing data held in a RDBMS."),
    ("What is recursion?", "A function calling itself", ["A loop inside a loop", "A database error", "A variable type"], "Recursion is a method where the solution to a problem depends on solutions to smaller instances of the same problem."),
    ("What does API stand for?", "Application Programming Interface", ["Application Program Interconnect", "Advanced Programming Interface", "Automated Program Interface"], "An API is a set of functions and procedures allowing the creation of applications that access the features or data of an operating system, application, or other service."),
    ("What is the difference between '==' and '='?", "Comparison vs Assignment", ["Assignment vs Comparison", "Addition vs Subtraction", "None"], "'==' compares values, while '=' assigns a value to a variable."),
    ("What is Git?", "Version Control System", ["Programming Language", "Operating System", "Text Editor"], "Git is a distributed version-control system for tracking changes in source code."),
    ("What does JSON stand for?", "JavaScript Object Notation", ["Java Source Object Network", "JavaScript Online Notation", "Java System Object Node"], "JSON is an open standard file format using human-readable text to store and transmit data objects."),
    ("What is a class in OOP?", "A blueprint for objects", ["A function", "A variable", "A library"], "In object-oriented programming, a class is an extensible program-code-template for creating objects."),
    ("Which data structure uses LIFO?", "Stack", ["Queue", "Array", "Tree"], "A Stack follows the Last In, First Out (LIFO) principle."),
    ("Which data structure uses FIFO?", "Queue", ["Stack", "Graph", "Heap"], "A Queue follows the First In, First Out (FIFO) principle."),
    ("What is an algorithm?", "Step-by-step instructions", ["A hardware component", "A type of virus", "A programming language"], "An algorithm is a finite sequence of well-defined, computer-implementable instructions."),
]

# Hard (16)
prog_hard = [
    ("What is the time complexity of binary search?", "O(log n)", ["O(n)", "O(n^2)", "O(1)"], "Binary search runs in logarithmic time."),
    ("What does REST stand for in web services?", "Representational State Transfer", ["Remote State Transfer", "Real State Transfer", "Rapid State Transfer"], "REST is a software architectural style that defines a set of constraints to be used for creating Web services."),
    ("What is dependency injection?", "Design pattern", ["Database type", "Sorting algorithm", "Compiler error"], "Dependency injection is a technique in which an object receives other objects that it depends on."),
    ("What are the SOLID principles?", "OOP design guidelines", ["Database rules", "Network protocols", "Security standards"], "SOLID is an acronym for five design principles intended to make software designs more understandable, flexible, and maintainable."),
    ("What is a closure?", "Function with preserved scope", ["End of a program", "Database connection", "Memory leak"], "A closure is a record storing a function together with an environment."),
    ("What is the difference between a process and a thread?", "Threads share memory", ["Processes share memory", "Threads are slower", "Processes are smaller"], "Threads within the same process share the same memory space, while processes have separate memory spaces."),
    ("What is a deadlock?", "Processes waiting for each other", ["Program crash", "Infinite loop", "Memory overflow"], "A deadlock occurs when two or more processes are unable to proceed because each is waiting for the other to release a resource."),
    ("What is polymorphism?", "Objects taking many forms", ["Data encryption", "Code compilation", "Memory management"], "Polymorphism allows objects of different classes to be treated as objects of a common superclass."),
    ("What is the purpose of a constructor?", "Initialize an object", ["Destroy an object", "Copy an object", "Print an object"], "A constructor is a special method of a class or structure in object-oriented programming that initializes a newly created object."),
    ("What is a singleton?", "Class with only one instance", ["Class with no methods", "Class with many instances", "Abstract class"], "The singleton pattern restricts the instantiation of a class to one 'single' instance."),
    ("What is Big O notation used for?", "Describing algorithm performance", ["Naming variables", "Defining classes", "Styling code"], "Big O notation describes the limiting behavior of a function when the argument tends towards a particular value or infinity."),
    ("What is a hash map?", "Key-value pair data structure", ["Sorted list", "Binary tree", "Linear array"], "A hash map implements an associative array abstract data type, a structure that can map keys to values."),
    ("What is the difference between TCP and UDP?", "TCP is reliable, UDP is fast", ["UDP is reliable, TCP is fast", "They are the same", "TCP is for email only"], "TCP provides reliable, ordered, and error-checked delivery, while UDP is connectionless and faster but less reliable."),
    ("What is a race condition?", "Timing-dependent bug", ["Fast code", "Network speed", "Compiler optimization"], "A race condition occurs when a software system's behavior depends on the timing of uncontrollable events."),
    ("What is the CAP theorem?", "Consistency, Availability, Partition tolerance", ["Consistency, Accuracy, Performance", "Capacity, Availability, Performance", "Consistency, Availability, Privacy"], "The CAP theorem states that a distributed data store can only provide two of the three guarantees."),
    ("What is a lambda function?", "Anonymous function", ["Recursive function", "Main function", "Class method"], "A lambda function is a small anonymous function defined with the lambda keyword."),
]

for quest, ans, wrong, exp in eng_easy:
    all_q.append(q("Engineering", "easy", quest, ans, wrong, exp))
for quest, ans, wrong, exp in eng_medium:
    all_q.append(q("Engineering", "medium", quest, ans, wrong, exp))
for quest, ans, wrong, exp in eng_hard:
    all_q.append(q("Engineering", "hard", quest, ans, wrong, exp))

for quest, ans, wrong, exp in prog_easy:
    all_q.append(q("Programming", "easy", quest, ans, wrong, exp))
for quest, ans, wrong, exp in prog_medium:
    all_q.append(q("Programming", "medium", quest, ans, wrong, exp))
for quest, ans, wrong, exp in prog_hard:
    all_q.append(q("Programming", "hard", quest, ans, wrong, exp))

# Print all questions
for i, quest in enumerate(all_q):
    print(quest, end="")
    if i < len(all_q) - 1:
        print(",")
    else:
        print()

print(f"\n// Generated {len(all_q)} Tech questions")
