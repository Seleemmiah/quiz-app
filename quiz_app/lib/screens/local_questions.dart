import '../models/question_model.dart';

final List<Map<String, dynamic>> localQuestions = [
  {
    "category": "History",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Who was the first Emperor of Rome?",
    "correct_answer": "Augustus",
    "incorrect_answers": ["Julius Caesar", "Nero", "Caligula"],
    "explanation":
        "While Julius Caesar was a pivotal figure in the demise of the Roman Republic, he was never emperor. His adopted son, Octavian, was given the title 'Augustus' by the Senate in 27 BC, marking the beginning of the Roman Empire. Augustus's reign, known as the Pax Romana, was a period of relative peace and stability that lasted for over two centuries. He reformed the military, established the Praetorian Guard, and initiated vast building projects in Rome, famously claiming he 'found Rome a city of bricks and left it a city of marble'.",
    "videoUrl": "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  },
  {
    "category": "Science: Computers",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What does 'CPU' stand for?",
    "correct_answer": "Central Processing Unit",
    "incorrect_answers": [
      "Central Process Unit",
      "Computer Personal Unit",
      "Central Processor Unit"
    ],
    "explanation":
        "The CPU, or Central Processing Unit, is often called the 'brain' of the computer. It is the primary component responsible for executing the instructions of a computer program. It performs most of the processing inside a computer, carrying out arithmetic, logic, controlling, and input/output (I/O) operations specified by the instructions. Modern CPUs are microprocessors, meaning they are contained on a single integrated circuit (IC) chip."
  },
  {
    "category": "Entertainment: Film",
    "type": "multiple",
    "difficulty": "hard",
    "question": "In the movie 'The Matrix', what is the name of the main ship?",
    "correct_answer": "Nebuchadnezzar",
    "incorrect_answers": ["The Logos", "The Mjolnir", "The Osiris"],
    "explanation":
        "The Nebuchadnezzar is the main hovercraft captained by Morpheus in 'The Matrix' trilogy. Its name is a reference to the biblical king of Babylon, Nebuchadnezzar II, who is known for his dreams and their interpretations, mirroring the film's themes of reality and illusion. The ship serves as the mobile base of operations for the crew as they navigate the desolate real world and jack into the Matrix. A plaque on the ship reads 'Mark III No. 11', indicating its model and production number."
  },
  {
    "category": "General Knowledge",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the capital of France?",
    "correct_answer": "Paris",
    "incorrect_answers": ["London", "Berlin", "Madrid"],
    "explanation":
        "Paris is the capital and most populous city of France. It is known for its art, fashion, gastronomy and culture."
  },
  {
    "category": "Science: Computers",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What does RAM stand for?",
    "correct_answer": "Random Access Memory",
    "incorrect_answers": [
      "Read Only Memory",
      "Realtime Application Management",
      "Rapid Action-item Memory"
    ],
    "explanation":
        "Random Access Memory (RAM) is a form of computer memory that can be read and changed in any order, typically used to store working data and machine code."
  },
  {
    "category": "History",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Who was the first President of the United States?",
    "correct_answer": "George Washington",
    "incorrect_answers": ["Abraham Lincoln", "Thomas Jefferson", "John Adams"],
    "explanation":
        "George Washington was an American political leader, military general, statesman, and Founding Father who served as the first president of the United States from 1789 to 1797."
  },
  {
    "category": "Geography",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the largest ocean on Earth?",
    "correct_answer": "Pacific Ocean",
    "incorrect_answers": ["Atlantic Ocean", "Indian Ocean", "Arctic Ocean"],
    "explanation":
        "The Pacific Ocean is the largest and deepest of Earth's five oceans. It extends from the Arctic Ocean in the north to the Southern Ocean in the south and is bounded by the continents of Asia and Australia in the west and the Americas in the east."
  },
  {
    "category": "Entertainment: Film",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Who directed the movie 'Jurassic Park'?",
    "correct_answer": "Steven Spielberg",
    "incorrect_answers": ["George Lucas", "James Cameron", "Martin Scorsese"],
    "explanation":
        "Jurassic Park is a 1993 American science fiction action film directed by Steven Spielberg and produced by Kathleen Kennedy and Gerald R. Molen."
  },
  {
    "category": "Science: Biology",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the powerhouse of the cell?",
    "correct_answer": "Mitochondria",
    "incorrect_answers": ["Nucleus", "Ribosome", "Chloroplast"],
    "explanation":
        "Mitochondria are membrane-bound cell organelles that generate most of the chemical energy needed to power the cell's biochemical reactions."
  },
  {
    "category": "Art",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Who painted the Mona Lisa?",
    "correct_answer": "Leonardo da Vinci",
    "incorrect_answers": ["Vincent van Gogh", "Pablo Picasso", "Claude Monet"],
    "explanation":
        "The Mona Lisa is a half-length portrait painting by Italian artist Leonardo da Vinci. Considered an archetypal masterpiece of the Italian Renaissance, it has been described as 'the best known, the most visited, the most written about, the most sung about, the most parodied work of art in the world'."
  },
  {
    "category": "Sports",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Which country won the 2014 FIFA World Cup?",
    "correct_answer": "Germany",
    "incorrect_answers": ["Argentina", "Brazil", "Netherlands"],
    "explanation":
        "The 2014 FIFA World Cup was the 20th FIFA World Cup, the quadrennial world championship for men's national football teams organized by FIFA. It took place in Brazil from 12 June to 13 July 2014. Germany won the tournament, defeating Argentina 1–0 in the final."
  },
  {
    "category": "Mythology",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Who is the Greek god of the sea?",
    "correct_answer": "Poseidon",
    "incorrect_answers": ["Zeus", "Hades", "Apollo"],
    "explanation":
        "Poseidon was one of the Twelve Olympians in ancient Greek religion and myth. He was the god of the Sea and other waters, of earthquakes, and of horses."
  },
  //
  // Here are the 30 new questions you requested:
  //
  {
    "category": "Science: Computers",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What does 'HTML' stand for?",
    "correct_answer": "HyperText Markup Language",
    "incorrect_answers": [
      "Hyperlink and Text Markup Language",
      "Home Tool Markup Language",
      "Hyperlinking Texting Markup Language"
    ],
    "explanation":
        "HTML (HyperText Markup Language) is the standard markup language for documents designed to be displayed in a web browser. It can be assisted by technologies such as Cascading Style Sheets (CSS) and scripting languages such as JavaScript."
  },
  {
    "category": "Geography",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the longest river in the world?",
    "correct_answer": "The Amazon River",
    "incorrect_answers": [
      "The Nile River",
      "The Mississippi River",
      "The Yangtze River"
    ],
    "explanation":
        "While the Nile was long considered the longest, recent studies (2007) suggest the Amazon River is longer. This is due to a more distant source point being identified, making it approximately 6,992 kilometers long."
  },
  {
    "category": "History",
    "type": "multiple",
    "difficulty": "hard",
    "question": "In what year was the Magna Carta originally issued?",
    "correct_answer": "1215",
    "incorrect_answers": ["1066", "1492", "1776"],
    "explanation":
        "The Magna Carta, a foundational document for constitutional law, was first issued by King John of England in 1215. It was a charter of rights agreed to by the king, promising to uphold certain rights of his barons and limit his own power."
  },
  {
    "category": "Entertainment: Film",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Who directed the 'Pulp Fiction' (1994)?",
    "correct_answer": "Quentin Tarantino",
    "incorrect_answers": [
      "Steven Spielberg",
      "Martin Scorsese",
      "Christopher Nolan"
    ],
    "explanation":
        "Quentin Tarantino directed and co-wrote 'Pulp Fiction', a landmark film known for its non-linear narrative, eclectic dialogue, and pop culture references. It won the Palme d'Or at the 1994 Cannes Film Festival."
  },
  {
    "category": "Sports",
    "type": "multiple",
    "difficulty": "medium",
    "question": "How many rings are on the Olympic flag?",
    "correct_answer": "5",
    "incorrect_answers": ["4", "6", "7"],
    "explanation":
        "The Olympic flag features five interlocking rings of different colors (blue, yellow, black, green, and red) on a white background. These rings represent the five inhabited continents (Africa, Americas, Asia, Europe, Oceania)."
  },
  {
    "category": "Art",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Who painted 'The Starry Night'?",
    "correct_answer": "Vincent van Gogh",
    "incorrect_answers": ["Leonardo da Vinci", "Pablo Picasso", "Claude Monet"],
    "explanation":
        "'The Starry Night' is an oil-on-canvas painting by Dutch Post-Impressionist painter Vincent van Gogh. Painted in June 1889, it depicts the view from his asylum room at Saint-Rémy-de-Provence."
  },
  {
    "category": "Mythology",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Who is the Norse god of thunder?",
    "correct_answer": "Thor",
    "incorrect_answers": ["Odin", "Loki", "Heimdall"],
    "explanation":
        "Thor is the hammer-wielding god associated with thunder, lightning, storms, oak trees, strength, and the protection of mankind in Norse mythology. He is the son of Odin."
  },
  {
    "category": "Science: Biology",
    "type": "multiple",
    "difficulty": "medium",
    "question":
        "What is the process by which plants make their own food using sunlight?",
    "correct_answer": "Photosynthesis",
    "incorrect_answers": ["Respiration", "Transpiration", "Fermentation"],
    "explanation":
        "Photosynthesis is a process used by plants and other organisms to convert light energy into chemical energy, through a process that converts carbon dioxide and water into sugars (food) and oxygen."
  },
  {
    "category": "General Knowledge",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the largest planet in our solar system?",
    "correct_answer": "Jupiter",
    "incorrect_answers": ["Saturn", "Earth", "Neptune"],
    "explanation":
        "Jupiter is the fifth planet from the Sun and the largest in the Solar System. It is a gas giant with a mass more than two and a half times that of all the other planets in the Solar System combined."
  },
  {
    "category": "History",
    "type": "multiple",
    "difficulty": "hard",
    "question": "Who discovered penicillin?",
    "correct_answer": "Alexander Fleming",
    "incorrect_answers": ["Marie Curie", "Louis Pasteur", "Robert Koch"],
    "explanation":
        "Sir Alexander Fleming, a Scottish biologist, discovered the antibiotic substance penicillin by accident in 1928 when he noticed that a mold (Penicillium notatum) had contaminated one of his bacterial cultures and was inhibiting its growth."
  },
  {
    "category": "Science: Computers",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is a 'firewall' in computer terms?",
    "correct_answer":
        "A network security system that monitors and controls traffic",
    "incorrect_answers": [
      "A type of computer virus",
      "A physical barrier to cool a server",
      "A software for creating 3D graphics"
    ],
    "explanation":
        "A firewall is a network security system that monitors and controls incoming and outgoing network traffic based on predetermined security rules. It establishes a barrier between a trusted internal network and untrusted external networks, such as the Internet."
  },
  {
    "category": "Entertainment: Film",
    "type": "multiple",
    "difficulty": "hard",
    "question":
        "Which movie won the first-ever Academy Award for Best Animated Feature?",
    "correct_answer": "Shrek",
    "incorrect_answers": ["Toy Story", "Monsters, Inc.", "Spirited Away"],
    "explanation":
        "The Academy Award for Best Animated Feature was first introduced at the 74th Academy Awards in 2002. The first film to win this award was 'Shrek' (2001)."
  },
  {
    "category": "Geography",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the highest mountain in the world?",
    "correct_answer": "Mount Everest",
    "incorrect_answers": ["K2", "Kangchenjunga", "Makalu"],
    "explanation":
        "Mount Everest, located in the Himalayas on the border of Nepal and China, is Earth's highest mountain above sea level, with its peak at 8,848.86 meters (29,031.7 ft)."
  },
  {
    "category": "Sports",
    "type": "multiple",
    "difficulty": "medium",
    "question": "In ice hockey, what is a 'hat-trick'?",
    "correct_answer": "When a single player scores three goals in one game",
    "incorrect_answers": [
      "When a player is sent to the penalty box three times",
      "When a team wins three games in a row",
      "When a goalie blocks three consecutive shots"
    ],
    "explanation":
        "A hat-trick in ice hockey occurs when a single player scores three goals in a single game. Traditionally, fans will celebrate this by throwing their hats onto the ice."
  },
  {
    "category": "Mythology",
    "type": "multiple",
    "difficulty": "medium",
    "question": "In Greek mythology, who flew too close to the sun?",
    "correct_answer": "Icarus",
    "incorrect_answers": ["Daedalus", "Perseus", "Theseus"],
    "explanation":
        "Icarus was the son of the master craftsman Daedalus. His father built wings of wax and feathers for them to escape Crete, but Icarus, ignoring his father's warning, flew too close to the sun. The wax melted, and he fell into the sea and drowned."
  },
  {
    "category": "Art",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Who sculpted the famous statue of 'David'?",
    "correct_answer": "Michelangelo",
    "incorrect_answers": ["Donatello", "Leonardo da Vinci", "Raphael"],
    "explanation":
        "Michelangelo sculpted the marble statue of the biblical figure David between 1501 and 1504. It is one of the most renowned works of the Renaissance and is housed in the Galleria dell'Accademia in Florence, Italy."
  },
  {
    "category": "Science: Biology",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What gas do plants absorb from the atmosphere?",
    "correct_answer": "Carbon Dioxide",
    "incorrect_answers": ["Oxygen", "Nitrogen", "Hydrogen"],
    "explanation":
        "Plants absorb carbon dioxide (CO2) from the atmosphere as a key ingredient for photosynthesis. In this process, they use sunlight to convert CO2 and water into glucose (energy) and oxygen."
  },
  {
    "category": "General Knowledge",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the hardest natural substance on Earth?",
    "correct_answer": "Diamond",
    "incorrect_answers": ["Graphene", "Quartz", "Wurtzite boron nitride"],
    "explanation":
        "Diamond is the hardest known natural material, scoring a 10 on the Mohs scale of hardness. Its hardness is a result of its strong covalent bonds between carbon atoms in a perfect crystal lattice."
  },
  {
    "category": "History",
    "type": "multiple",
    "difficulty": "medium",
    "question": "In what year did World War II end?",
    "correct_answer": "1945",
    "incorrect_answers": ["1939", "1941", "1950"],
    "explanation":
        "World War II ended in 1945. Germany surrendered in May (V-E Day), and Japan formally surrendered in September (V-J Day) after the atomic bombings of Hiroshima and Nagasaki."
  },
  {
    "category": "Entertainment: Film",
    "type": "multiple",
    "difficulty": "medium",
    "question":
        "What is the name of the fictional African country in the movie 'Black Panther'?",
    "correct_answer": "Wakanda",
    "incorrect_answers": ["Genosha", "Latveria", "Zamunda"],
    "explanation":
        "Wakanda is a fictional, technologically advanced African nation in the Marvel Cinematic Universe. It is the home of the superhero Black Panther and the world's only source of the powerful metal, Vibranium."
  },
  {
    "category": "Geography",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the largest desert in the world?",
    "correct_answer": "Antarctic Polar Desert",
    "incorrect_answers": [
      "Sahara Desert",
      "Gobi Desert",
      "Arctic Polar Desert"
    ],
    "explanation":
        "A desert is defined by its low amount of precipitation. The largest desert in the world is the Antarctic Polar Desert, which covers an area of over 14 million square kilometers. The Sahara is just the largest *hot* desert."
  },
  {
    "category": "Science: Computers",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What does 'HTTP' stand for?",
    "correct_answer": "HyperText Transfer Protocol",
    "incorrect_answers": [
      "Hyperlink Text Transfer Protocol",
      "High-Level Text Transfer Protocol",
      "HyperText Translation Protocol"
    ],
    "explanation":
        "HyperText Transfer Protocol (HTTP) is the foundation of data communication for the World Wide Web. It's the protocol used to transmit hypermedia, such as HTML documents."
  },
  {
    "category": "Sports",
    "type": "multiple",
    "difficulty": "easy",
    "question": "In which sport would you perform a 'slam dunk'?",
    "correct_answer": "Basketball",
    "incorrect_answers": ["Volleyball", "American Football", "Tennis"],
    "explanation":
        "A slam dunk, or dunk, is a type of shot in basketball that is performed when a player jumps in the air and forcefully slams the ball through the hoop with one or two hands."
  },
  {
    "category": "Art",
    "type": "multiple",
    "difficulty": "hard",
    "question": "Which art movement is Salvador Dalí most associated with?",
    "correct_answer": "Surrealism",
    "incorrect_answers": ["Cubism", "Impressionism", "Abstract Expressionism"],
    "explanation":
        "Salvador Dalí was a Spanish surrealist artist renowned for his technical skill, precise draftsmanship, and the striking and bizarre images in his work, such as 'The Persistence of Memory' (1931)."
  },
  {
    "category": "Mythology",
    "type": "multiple",
    "difficulty": "hard",
    "question": "In Egyptian mythology, who is the god of the afterlife?",
    "correct_answer": "Osiris",
    "incorrect_answers": ["Ra", "Anubis", "Horus"],
    "explanation":
        "While Anubis is the god of mummification and guides souls, Osiris is the god of the afterlife, the underworld, and the dead. He judges souls in the Hall of Two Truths to determine their fate in the afterlife."
  },
  {
    "category": "Science: Biology",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the human body's largest organ?",
    "correct_answer": "The Skin",
    "incorrect_answers": ["The Liver", "The Brain", "The Lungs"],
    "explanation":
        "The skin is the largest organ of the human body, covering its entire external surface. It has a total area of about 20 square feet and serves as a protective barrier against the environment."
  },

  {
    "category": "General Knowledge",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the currency of Japan?",
    "correct_answer": "Yen",
    "incorrect_answers": ["Won", "Yuan", "Dollar"],
    "explanation":
        "The Yen (JPY) is the official currency of Japan. It is the third-most traded currency in the foreign exchange market after the United States dollar and the Euro."
  },
  {
    "category": "History",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Which ancient civilization built the pyramids at Giza?",
    "correct_answer": "The Egyptians",
    "incorrect_answers": ["The Mayans", "The Romans", "The Greeks"],
    "explanation":
        "The Great Pyramids of Giza were built by the ancient Egyptians during the Old Kingdom period, primarily as tombs for their pharaohs. The Great Pyramid was built for Pharaoh Khufu."
  },
  {
    "category": "Engineering",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What does 'CAD' stand for in engineering?",
    "correct_answer": "Computer-Aided Design",
    "incorrect_answers": [
      "Computer-Assisted Datalogging",
      "Calculated-Angle Dimensioning",
      "Civil and Architectural Design"
    ],
    "explanation":
        "Computer-Aided Design (CAD) is software used by engineers, architects, and designers to create 2D and 3D precision models of physical objects."
  },
  {
    "category": "Engineering",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is Ohm's Law?",
    "correct_answer": "Voltage = Current x Resistance (V=IR)",
    "incorrect_answers": [
      "Power = Voltage x Current (P=VI)",
      "Force = Mass x Acceleration (F=ma)",
      "Energy = Mass x (Speed of Light)^2 (E=mc²)"
    ],
    "explanation":
        "Ohm's Law is a fundamental equation in electrical engineering that states the voltage (V) across a resistor is directly proportional to the current (I) flowing through it and its resistance (R)."
  },
  {
    "category": "Engineering",
    "type": "multiple",
    "difficulty": "easy",
    "question":
        "Which of these is a type of bridge known for its curved structure?",
    "correct_answer": "Arch Bridge",
    "incorrect_answers": [
      "Suspension Bridge",
      "Beam Bridge",
      "Cantilever Bridge"
    ],
    "explanation":
        "An arch bridge is a bridge with abutments at each end shaped as a curved arch. Arch bridges work by transferring the weight of the bridge and its loads partially into a horizontal thrust restrained by the abutments at either side."
  },
  {
    "category": "Engineering",
    "type": "multiple",
    "difficulty": "medium",
    "question":
        "What are the four primary forces acting on an airplane in flight?",
    "correct_answer": "Lift, Weight, Thrust, and Drag",
    "incorrect_answers": [
      "Lift, Gravity, Speed, and Friction",
      "Thrust, Drag, Altitude, and Weight",
      "Force, Mass, Acceleration, and Gravity"
    ],
    "explanation":
        "For an aircraft to fly, these four forces must be managed. Lift opposes Weight (gravity), and Thrust opposes Drag (air resistance)."
  },
  {
    "category": "Engineering",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What material is added to iron to create steel?",
    "correct_answer": "Carbon",
    "incorrect_answers": ["Aluminum", "Copper", "Tin"],
    "explanation":
        "Steel is an alloy made by combining iron with a small amount of carbon (typically less than 2%) to improve its strength and fracture resistance."
  },
  {
    "category": "Engineering",
    "type": "multiple",
    "difficulty": "medium",
    "question":
        "In mechanical engineering, what does 'tensile strength' measure?",
    "correct_answer": "A material's resistance to being pulled apart",
    "incorrect_answers": [
      "A material's resistance to being compressed",
      "A material's hardness",
      "A material's resistance to heat"
    ],
    "explanation":
        "Tensile strength measures the maximum stress a material can withstand while being stretched or pulled (tension) before breaking."
  },
  {
    "category": "Engineering",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is Bernoulli's Principle, a key concept in aerodynamics?",
    "correct_answer":
        "An increase in the speed of a fluid occurs simultaneously with a decrease in pressure",
    "incorrect_answers": [
      "For every action, there is an equal and opposite reaction",
      "Energy cannot be created or destroyed, only transferred",
      "The rate of heat transfer is proportional to the temperature difference"
    ],
    "explanation":
        "Bernoulli's Principle explains how an airplane's wing generates lift. The curved shape of the wing (airfoil) forces the air above it to travel faster, creating a low-pressure zone, while the slower-moving air below creates a high-pressure zone, pushing the wing up."
  },
  {
    "category": "Engineering",
    "type": "multiple",
    "difficulty": "easy",
    "question":
        "What is the common term for the steel bars placed inside concrete to increase its strength?",
    "correct_answer": "Rebar",
    "incorrect_answers": ["Post-tensioning", "Girders", "Struts"],
    "explanation":
        "Rebar (short for reinforcing bar) is used to create reinforced concrete. Concrete is very strong in compression but weak in tension; the rebar adds the necessary tensile strength."
  },
  {
    "category": "Engineering",
    "type": "multiple",
    "difficulty": "medium",
    "question":
        "What is the primary function of a capacitor in an electrical circuit?",
    "correct_answer": "To store electrical energy",
    "incorrect_answers": [
      "To resist the flow of current",
      "To amplify the signal",
      "To only allow current to flow in one direction"
    ],
    "explanation":
        "A capacitor is a passive component that stores electrical energy in an electric field. It's like a small, very fast-charging battery that can release its energy quickly."
  },
  {
    "category": "Engineering",
    "type": "multiple",
    "difficulty": "medium",
    "question":
        "Which of the three laws of thermodynamics states that the entropy of any isolated system always increases?",
    "correct_answer": "The Second Law",
    "incorrect_answers": ["The First Law", "The Third Law", "The Zeroth Law"],
    "explanation":
        "The Second Law of Thermodynamics states that the total entropy (a measure of disorder) of an isolated system can only increase over time or remain constant; it can never decrease. This is why heat flows from hot to cold."
  },
  {
    "category": "Engineering",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What does 'AC' stand for in electrical engineering?",
    "correct_answer": "Alternating Current",
    "incorrect_answers": [
      "Ampere Current",
      "Applied Current",
      "Direct Current"
    ],
    "explanation":
        "Alternating Current (AC) is a type of electrical current, used in homes and businesses, in which the flow of electric charge periodically reverses direction."
  },
  {
    "category": "Engineering",
    "type": "multiple",
    "difficulty": "hard",
    "question":
        "In chemical engineering, what is the process of separating a liquid mixture into its components by boiling and condensing?",
    "correct_answer": "Distillation",
    "incorrect_answers": ["Filtration", "Chromatography", "Catalysis"],
    "explanation":
        "Distillation is a widely used method for separating mixtures based on differences in the boiling points of their components. The mixture is heated, the component with the lower boiling point evaporates first, and the vapor is then cooled (condensed) and collected."
  },
  {
    "category": "Engineering",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is a 'Factor of Safety' (FoS)?",
    "correct_answer":
        "A ratio of a structure's absolute strength to the actual load applied to it",
    "incorrect_answers": [
      "A measure of a project's budget overrun",
      "A code for emergency stop procedures",
      "The number of backup systems in place"
    ],
    "explanation":
        "A Factor of Safety (FoS) is a term describing the structural capacity of a system beyond the expected loads. For example, a bridge with a FoS of 2 can theoretically hold twice its maximum intended load before failing."
  },
  {
    "category": "Engineering",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Which of these is a renewable energy source?",
    "correct_answer": "Solar Power",
    "incorrect_answers": ["Natural Gas", "Coal", "Nuclear Fission"],
    "explanation":
        "Renewable energy is collected from resources that are naturally replenished on a human timescale. Solar power (from the sun), wind power, and hydropower are common examples."
  },
  {
    "category": "Engineering",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the main purpose of a gearbox in a machine?",
    "correct_answer": "To change the speed and torque of a motor",
    "incorrect_answers": [
      "To cool the engine",
      "To filter the fuel",
      "To store electrical charge"
    ],
    "explanation":
        "A gearbox (or transmission) uses a set of gears to alter the relationship between the speed of a drive shaft (like a car's engine) and the speed of the driven wheels. It trades speed for torque, or vice-versa."
  },
  {
    "category": "Engineering",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is 'reverse engineering'?",
    "correct_answer":
        "Deconstructing a product to understand how it was made or how it works",
    "incorrect_answers": [
      "Designing a product to run in reverse",
      "A software development model",
      "The process of building a product from a schematic"
    ],
    "explanation":
        "Reverse engineering is the process of taking apart a finished product (like a machine or a piece of software) to analyze its components and functionality, often to learn, duplicate, or improve upon the design."
  },
  {
    "category": "Engineering",
    "type": "multiple",
    "difficulty": "hard",
    "question":
        "A 'semiconductor' is the foundational material for most modern electronics. What is its key property?",
    "correct_answer":
        "Its electrical conductivity can be controlled and modified",
    "incorrect_answers": [
      "It is a perfect conductor with zero resistance",
      "It is a perfect insulator that blocks all current",
      "It generates its own electrical charge when heated"
    ],
    "explanation":
        "A semiconductor (like silicon) has conductivity between that of a conductor (like copper) and an insulator (like glass). Its conductivity can be precisely controlled by 'doping' it with impurities, which is the basis for transistors and diodes."
  },
  {
    "category": "Engineering",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What does a civil engineer primarily design and build?",
    "correct_answer": "Public infrastructure (roads, bridges, dams)",
    "incorrect_answers": [
      "Computer-aided design (CAD) software",
      "Car engines and transmissions",
      "Electrical power grids"
    ],
    "explanation":
        "Civil engineering is a discipline that deals with the design, construction, and maintenance of the physical and naturally built environment, including public works such as roads, bridges, canals, dams, airports, and buildings."
  },
  {
    "category": "Engineering",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the function of a 'catalyst' in a chemical reaction?",
    "correct_answer": "It speeds up the reaction without being consumed",
    "incorrect_answers": [
      "It stops the reaction completely",
      "It provides the primary fuel for the reaction",
      "It changes the final product of the reaction"
    ],
    "explanation":
        "A catalyst is a substance that increases the rate of a chemical reaction by lowering its activation energy, but it is not consumed in the process. Catalytic converters in cars are a common example."
  },
  {
    "category": "Medicine",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What does 'CPR' stand for?",
    "correct_answer": "Cardiopulmonary Resuscitation",
    "incorrect_answers": [
      "Cardiac Pulmonary Response",
      "Cardiopulmonary Recovery",
      "Cardiac Pressure Regulation"
    ],
    "explanation":
        "CPR (Cardiopulmonary Resuscitation) is an emergency lifesaving procedure performed when the heart stops beating. It combines chest compressions with artificial ventilation (rescue breaths)."
  },
  {
    "category": "Medicine",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the common name for the 'patella'?",
    "correct_answer": "Kneecap",
    "incorrect_answers": ["Elbow bone", "Shoulder blade", "Collarbone"],
    "explanation":
        "The patella, or kneecap, is a small bone located in front of the knee joint. It protects the knee and connects the muscles in the front of the thigh to the tibia (shinbone)."
  },
  {
    "category": "Medicine",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the primary function of antibiotics?",
    "correct_answer": "To kill or inhibit the growth of bacteria",
    "incorrect_answers": [
      "To kill viruses",
      "To reduce inflammation",
      "To lower blood pressure"
    ],
    "explanation":
        "Antibiotics are medicines used to treat bacterial infections. They do not work against viral infections like the common cold or flu. Using them for viruses is ineffective and contributes to antibiotic resistance."
  },
  {
    "category": "Medicine",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What medical instrument is used to measure blood pressure?",
    "correct_answer": "Sphygmomanometer",
    "incorrect_answers": ["Stethoscope", "Otoscope", "Thermometer"],
    "explanation":
        "A sphygmomanometer (or blood pressure cuff) is used to measure arterial blood pressure. A stethoscope is often used *with* it to listen for the blood flow, but the cuff itself is the sphygmomanometer."
  },
  {
    "category": "Medicine",
    "type": "multiple",
    "difficulty": "hard",
    "question":
        "What part of the brain controls the body's endocrine system by influencing the pituitary gland?",
    "correct_answer": "Hypothalamus",
    "incorrect_answers": ["Cerebellum", "Medulla Oblongata", "Frontal Lobe"],
    "explanation":
        "The hypothalamus is a small region of the brain that links the nervous system to the endocrine system. It produces releasing and inhibiting hormones that control the 'master gland', the pituitary."
  },
  {
    "category": "Medicine",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the main function of red blood cells?",
    "correct_answer": "To carry oxygen to the body's tissues",
    "incorrect_answers": [
      "To fight infection",
      "To help blood clot",
      "To digest nutrients"
    ],
    "explanation":
        "Red blood cells contain a protein called hemoglobin, which binds to oxygen in the lungs and transports it to all other parts of the body."
  },
  {
    "category": "Medicine",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the 'Hippocratic Oath'?",
    "correct_answer": "An oath of ethics historically taken by physicians",
    "incorrect_answers": [
      "A law requiring patient confidentiality",
      "The first medical textbook",
      "A pledge to heal all patients for free"
    ],
    "explanation":
        "The Hippocratic Oath is an oath of ethics historically taken by physicians. It is one of the most widely known Greek medical texts and requires a new physician to swear to uphold specific ethical standards."
  },
  {
    "category": "Medicine",
    "type": "multiple",
    "difficulty": "hard",
    "question":
        "Who is credited with discovering the first vaccine, which was for smallpox?",
    "correct_answer": "Edward Jenner",
    "incorrect_answers": ["Louis Pasteur", "Alexander Fleming", "Jonas Salk"],
    "explanation":
        "In 1796, the English physician Edward Jenner observed that milkmaids who had previously caught cowpox were immune to smallpox. This led him to develop the world's first vaccine."
  },
  {
    "category": "Medicine",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Which of these is NOT a type of human blood?",
    "correct_answer": "C",
    "incorrect_answers": ["A", "B", "AB", "O"],
    "explanation":
        "The four main blood types in the ABO system are A, B, AB, and O. Each can be 'positive' or 'negative' for the Rh factor, but 'C' is not a primary blood type."
  },
  {
    "category": "Programming",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What does 'API' stand for?",
    "correct_answer": "Application Programming Interface",
    "incorrect_answers": [
      "Application Process Integration",
      "Advanced Programming-language Interface",
      "Application Protocol Initialization"
    ],
    "explanation":
        "An API is a set of rules and protocols that allows different software applications to communicate with each other. It's the 'messenger' that takes requests and tells a system what you want it to do."
  },
  {
    "category": "Programming",
    "type": "multiple",
    "difficulty": "easy",
    "question": "In programming, what is a 'variable'?",
    "correct_answer": "A container for storing a data value",
    "incorrect_answers": [
      "A type of function",
      "A loop that never ends",
      "A constant that cannot be changed"
    ],
    "explanation":
        "A variable is a symbolic name for a storage location that contains a value (like a number, text, or object). The value it holds can be changed (it is 'variable') during the program's execution."
  },
  {
    "category": "Programming",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Which of these is a 'high-level' programming language?",
    "correct_answer": "Python",
    "incorrect_answers": ["Assembly Language", "Machine Code", "Binary"],
    "explanation":
        "High-level languages (like Python, Java, C#) use strong abstraction from the details of the computer. They are more human-readable. Low-level languages (like Assembly) have little to no abstraction and are very close to the hardware instructions."
  },
  {
    "category": "Programming",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is 'git'?",
    "correct_answer": "A distributed version control system",
    "incorrect_answers": [
      "A programming language",
      "A web hosting service",
      "A text editor"
    ],
    "explanation":
        "Git is a version control system used to track changes in source code during software development. It allows multiple developers to collaborate on the same project without overwriting each other's work."
  },
  {
    "category": "Programming",
    "type": "multiple",
    "difficulty": "easy",
    "question":
        "What data type would you use to store a single true/false value?",
    "correct_answer": "Boolean",
    "incorrect_answers": ["Integer", "String", "Float"],
    "explanation":
        "A Boolean is a data type that has only two possible values: 'true' or 'false'. It is used for logical operations and conditional statements (like 'if' statements)."
  },
  {
    "category": "Programming",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the primary purpose of a 'for loop'?",
    "correct_answer": "To iterate over a sequence of items",
    "incorrect_answers": [
      "To define a new function",
      "To make a decision based on a condition",
      "To stop the program from running"
    ],
    "explanation":
        "A 'for loop' is a control flow statement used to repeatedly execute a block of code a specific number of times, typically by iterating over a list, array, or range of numbers."
  },
  {
    "category": "Programming",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is 'recursion' in programming?",
    "correct_answer": "A function that calls itself",
    "incorrect_answers": [
      "A function that calls another function",
      "A loop that runs backwards",
      "A method for sorting data"
    ],
    "explanation":
        "Recursion is a method of solving a problem where the solution depends on solutions to smaller instances of the same problem. In programming, this is achieved when a function calls itself, breaking down a large problem until it reaches a simple 'base case'."
  },
  {
    "category": "Programming",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What does 'CSS' stand for?",
    "correct_answer": "Cascading Style Sheets",
    "incorrect_answers": [
      "Computer Style Sheets",
      "Creative Style Sheets",
      "Code Styling System"
    ],
    "explanation":
        "CSS is a stylesheet language used to describe the presentation (the look and formatting) of a document written in a markup language like HTML. It controls colors, fonts, and layout."
  },
  {
    "category": "Programming",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the difference between '==' and '===' in JavaScript?",
    "correct_answer":
        "'===' checks for both value and type; '==' only checks for value",
    "incorrect_answers": [
      "'==' checks for both value and type; '===' only checks for value",
      "They are identical",
      "'===' is for assignment; '==' is for comparison"
    ],
    "explanation":
        "'==' is the 'loose equality' operator, which will perform type coercion (e.g., '5' == 5 is true). '===' is the 'strict equality' operator, which does not (e.g., '5' === 5 is false)."
  },
  {
    "category": "Programming",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Which company developed the 'Flutter' framework?",
    "correct_answer": "Google",
    "incorrect_answers": ["Apple", "Facebook (Meta)", "Microsoft"],
    "explanation":
        "Flutter is an open-source UI software development kit created by Google. It is used to develop cross-platform applications for Android, iOS, Linux, macOS, Windows, and the web from a single codebase."
  },
  {
    "category": "Programming",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is 'polymorphism' in Object-Oriented Programming (OOP)?",
    "correct_answer": "The ability of an object to take on many forms",
    "incorrect_answers": [
      "The process of hiding implementation details",
      "The bundling of data and methods into one unit",
      "A method for creating a new class from an existing class"
    ],
    "explanation":
        "Polymorphism (from Greek for 'many shapes') is a core OOP concept where a method or object can be used in different ways. A common example is a 'render()' method that works on a 'Circle' object, a 'Square' object, and a 'Triangle' object, even though each one's render logic is different."
  },
  {
    "category": "Programming",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What symbol is used to write a 'comment' in Python?",
    "correct_answer": "#",
    "incorrect_answers": ["//", "/* */", ""],
    "explanation":
        "In Python, a single-line comment is started with the hash symbol (#). The interpreter ignores all text that follows it on that line. '//' is for C++/Java/C#, and '' is for HTML."
  },
  {
    "category": "Programming",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is 'SQL' (Structured Query Language) used for?",
    "correct_answer": "Managing and querying relational databases",
    "incorrect_answers": [
      "Creating user interfaces",
      "Writing machine learning algorithms",
      "Styling web pages"
    ],
    "explanation":
        "SQL is a domain-specific language used to manage data held in a relational database management system. It is used to 'INSERT', 'SELECT' (query), 'UPDATE', and 'DELETE' data."
  },
  {
    "category": "Programming",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is the time complexity of a 'binary search' algorithm?",
    "correct_answer": "O(log n)",
    "incorrect_answers": ["O(n)", "O(n²)", "O(1)"],
    "explanation":
        "Binary search is an efficient algorithm for finding an item in a *sorted* list. It works by repeatedly dividing the search interval in half. This 'halving' characteristic gives it a logarithmic time complexity, O(log n), which is much faster than a linear search, O(n)."
  },
  {
    "category": "Programming",
    "type": "multiple",
    "difficulty": "medium",
    "question":
        "Which company developed the 'React' library for building user interfaces?",
    "correct_answer": "Facebook (Meta)",
    "incorrect_answers": ["Google", "Microsoft", "Twitter (X)"],
    "explanation":
        "React is a free and open-source front-end JavaScript library for building user interfaces based on components. It is maintained by Meta (formerly Facebook) and a community of developers."
  },
  {
    "category": "Programming",
    "type": "multiple",
    "difficulty": "easy",
    "question": "In programming, what is a 'bug'?",
    "correct_answer": "An error or flaw in a computer program",
    "incorrect_answers": [
      "A hidden feature",
      "A security protocol",
      "A type of data structure"
    ],
    "explanation":
        "A bug is an error, flaw, or fault in a computer program or system that causes it to produce an incorrect or unexpected result, or to behave in unintended ways."
  },
  {
    "category": "Programming",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What does 'JSON' stand for?",
    "correct_answer": "JavaScript Object Notation",
    "incorrect_answers": [
      "JavaScript Online Network",
      "Java-Based Standard Object Network",
      "JavaScript Object Naming"
    ],
    "explanation":
        "JSON is a lightweight data-interchange format. It is easy for humans to read and write and easy for machines to parse and generate. It is often used to send data from a server to a web page (as an alternative to XML)."
  },
  {
    "category": "Programming",
    "type": "multiple",
    "difficulty": "hard",
    "question":
        "What is the difference between a 'compiler' and an 'interpreter'?",
    "correct_answer":
        "A compiler translates the entire program at once; an interpreter translates it line by line",
    "incorrect_answers": [
      "An interpreter translates the entire program at once; a compiler translates it line by line",
      "A compiler is for high-level languages; an interpreter is for low-level",
      "They are the same thing"
    ],
    "explanation":
        "A compiler (used by C++, Java) scans the entire program and translates it into machine code. An interpreter (used by Python, JavaScript) reads and executes the program one line at a time."
  },
  // --- 10 New 'Chemistry' Questions ---
  {
    "category": "Chemistry",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the chemical symbol for Gold?",
    "correct_answer": "Au",
    "incorrect_answers": ["Go", "Ag", "Gd"],
    "explanation":
        "The chemical symbol for Gold is 'Au', which comes from its Latin name, 'aurum', meaning 'shining dawn'. 'Ag' is the symbol for Silver."
  },
  {
    "category": "Chemistry",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the most abundant gas in the Earth's atmosphere?",
    "correct_answer": "Nitrogen",
    "incorrect_answers": ["Oxygen", "Carbon Dioxide", "Argon"],
    "explanation":
        "Earth's atmosphere is composed of about 78% Nitrogen, 21% Oxygen, and small amounts of other gases including Argon and Carbon Dioxide."
  },
  {
    "category": "Chemistry",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the pH of pure water?",
    "correct_answer": "7",
    "incorrect_answers": ["0", "14", "1"],
    "explanation":
        "The pH scale measures acidity/alkalinity from 0 to 14. A pH of 7 is neutral. Anything below 7 is acidic, and anything above 7 is alkaline (or basic)."
  },
  {
    "category": "Chemistry",
    "type": "multiple",
    "difficulty": "medium",
    "question":
        "What is the process of a solid turning directly into a gas, bypassing the liquid state?",
    "correct_answer": "Sublimation",
    "incorrect_answers": ["Evaporation", "Condensation", "Deposition"],
    "explanation":
        "Sublimation is the transition of a substance directly from the solid to the gas state, without passing through the liquid state. A common example is 'dry ice' (solid CO2) turning into CO2 gas."
  },
  {
    "category": "Chemistry",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What are 'isotopes'?",
    "correct_answer":
        "Atoms of the same element with different numbers of neutrons",
    "incorrect_answers": [
      "Atoms of the same element with different numbers of protons",
      "Atoms with the same mass but different elements",
      "Molecules with the same formula but different structures"
    ],
    "explanation":
        "Isotopes are variants of a particular chemical element. While all isotopes of a given element have the same number of protons, they differ in the number of neutrons in their nuclei. For example, Carbon-12 and Carbon-14 are both isotopes of carbon."
  },
  {
    "category": "Chemistry",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the common name for 'Sodium Chloride'?",
    "correct_answer": "Table Salt",
    "incorrect_answers": ["Sugar", "Baking Soda", "Vinegar"],
    "explanation":
        "Sodium Chloride (chemical formula NaCl) is an ionic compound that is commonly known as salt. It is the primary substance responsible for the salinity of seawater."
  },
  {
    "category": "Chemistry",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is H₂O the chemical formula for?",
    "correct_answer": "Water",
    "incorrect_answers": ["Hydrogen Peroxide", "Oxygen", "Salt"],
    "explanation":
        "H₂O is the chemical formula for water, indicating that one molecule of water is composed of two hydrogen (H) atoms and one oxygen (O) atom."
  },
  {
    "category": "Chemistry",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Which of these is a 'noble gas'?",
    "correct_answer": "Helium",
    "incorrect_answers": ["Hydrogen", "Oxygen", "Nitrogen"],
    "explanation":
        "The noble gases are a group of chemical elements with similar properties; they are all odorless, colorless, and have very low chemical reactivity. They are found in Group 18 of the periodic table and include Helium, Neon, Argon, Krypton, Xenon, and Radon."
  },
  {
    "category": "Chemistry",
    "type": "multiple",
    "difficulty": "hard",
    "question":
        "What is the name of the process that uses an electric current to drive an otherwise non-spontaneous chemical reaction?",
    "correct_answer": "Electrolysis",
    "incorrect_answers": ["Photosynthesis", "Catalysis", "Hydrolysis"],
    "explanation":
        "Electrolysis is a technique that uses direct electric current (DC) to drive a chemical reaction. A common example is using electrolysis to split water (H₂O) into hydrogen gas and oxygen gas."
  },
  {
    "category": "Chemistry",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is 'polymerization'?",
    "correct_answer":
        "A process where small molecules (monomers) link together to form a large chain (polymer)",
    "incorrect_answers": [
      "The separation of a mixture into its components",
      "The decay of radioactive atoms",
      "The process of dissolving a solid in a liquid"
    ],
    "explanation":
        "Polymerization is a chemical reaction in which many small, identical molecules (monomers) join together, end-to-end, to form a very large chain-like molecule (a polymer). This is how plastics like polyethylene are made."
  },

  // --- 10 New 'Music' Questions ---
  {
    "category": "Music",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Which band was known as the 'Fab Four'?",
    "correct_answer": "The Beatles",
    "incorrect_answers": [
      "The Rolling Stones",
      "The Beach Boys",
      "Led Zeppelin"
    ],
    "explanation":
        "The Beatles, a rock band from Liverpool, England, were often referred to as the 'Fab Four'. The members were John Lennon, Paul McCartney, George Harrison, and Ringo Starr."
  },
  {
    "category": "Music",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the most-streamed song on Spotify as of late 2024?",
    "correct_answer": "Blinding Lights by The Weeknd",
    "incorrect_answers": [
      "Shape of You by Ed Sheeran",
      "Someone You Loved by Lewis Capaldi",
      "Bohemian Rhapsody by Queen"
    ],
    "explanation":
        "'Blinding Lights' by The Weeknd surpassed 'Shape of You' to become the most-streamed song in Spotify history in early 2023 and has held the title since."
  },
  {
    "category": "Music",
    "type": "multiple",
    "difficulty": "easy",
    "question": "How many keys are on a standard, full-sized piano?",
    "correct_answer": "88",
    "incorrect_answers": ["76", "61", "92"],
    "explanation":
        "A standard modern piano has 88 keys, consisting of 52 white keys (for the notes of the C major scale) and 36 black keys (for the sharps and flats)."
  },
  {
    "category": "Music",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Who is known as the 'King of Pop'?",
    "correct_answer": "Michael Jackson",
    "incorrect_answers": ["Elvis Presley", "Freddie Mercury", "Prince"],
    "explanation":
        "Michael Jackson was an American singer, songwriter, and dancer. Dubbed the 'King of Pop', he is regarded as one of the most significant cultural figures of the 20th century."
  },
  {
    "category": "Music",
    "type": "multiple",
    "difficulty": "hard",
    "question":
        "What is the term for a musical piece, typically for a solo instrument, designed to showcase the performer's skill?",
    "correct_answer": "Etude",
    "incorrect_answers": ["Sonata", "Symphony", "Concerto"],
    "explanation":
        "An 'etude' (French for 'study') is a short musical composition of considerable difficulty, designed to provide practice material for perfecting a particular musical skill."
  },
  {
    "category": "Music",
    "type": "multiple",
    "difficulty": "medium",
    "question":
        "Which of these composers is considered part of the 'Classical' period?",
    "correct_answer": "Wolfgang Amadeus Mozart",
    "incorrect_answers": [
      "Johann Sebastian Bach",
      "Ludwig van Beethoven",
      "Richard Wagner"
    ],
    "explanation":
        "Mozart is a central figure of the Classical period (approx. 1750-1820). Bach is from the Baroque period (before), and Beethoven is a transitional figure to the Romantic period (after), which Wagner also belongs to."
  },
  {
    "category": "Music",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the name of the lead singer of the band 'Queen'?",
    "correct_answer": "Freddie Mercury",
    "incorrect_answers": ["Roger Daltrey", "Robert Plant", "David Bowie"],
    "explanation":
        "Freddie Mercury was a British singer and songwriter, best known as the lead vocalist and co-principal songwriter of the rock band Queen."
  },
  {
    "category": "Music",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What does 'piano' mean in musical terms?",
    "correct_answer": "To play softly",
    "incorrect_answers": [
      "To play loudly",
      "To play at a medium volume",
      "To play quickly"
    ],
    "explanation":
        "In musical dynamics, 'piano' (p) is an instruction to play the music softly. 'Forte' (f) means to play loudly."
  },
  {
    "category": "Music",
    "type": "multiple",
    "difficulty": "hard",
    "question":
        "Which 1991 album by Nirvana is often credited with bringing 'grunge' music to the mainstream?",
    "correct_answer": "Nevermind",
    "incorrect_answers": ["In Utero", "Bleach", "Ten"],
    "explanation":
        "Nirvana's second album, 'Nevermind' (1991), featuring the single 'Smells Like Teen Spirit', was an unexpected commercial success that brought alternative rock, and specifically grunge, to a global audience. 'Ten' is by Pearl Jam."
  },
  {
    "category": "Music",
    "type": "multiple",
    "difficulty": "medium",
    "question": "A 'crescendo' is a musical instruction to do what?",
    "correct_answer": "Gradually get louder",
    "incorrect_answers": [
      "Gradually get softer",
      "Gradually get faster",
      "Gradually get slower"
    ],
    "explanation":
        "A crescendo is a dynamic marking that instructs the performer to gradually increase the volume of the music. The opposite, a decrescendo or diminuendo, means to gradually get softer."
  },

  // --- 10 More 'Science: Biology' Questions ---
  {
    "category": "Science: Biology",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is 'homeostasis'?",
    "correct_answer":
        "The body's ability to maintain a stable internal environment",
    "incorrect_answers": [
      "The process of cell division",
      "The study of hereditary traits",
      "The mutation of genes"
    ],
    "explanation":
        "Homeostasis is the state of steady internal, physical, and chemical conditions maintained by living systems. This includes the regulation of body temperature, fluid balance, and pH levels."
  },
  {
    "category": "Science: Biology",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the 'double helix'?",
    "correct_answer": "The structure of a DNA molecule",
    "incorrect_answers": [
      "The shape of a protein",
      "A type of bacteria",
      "A part of the human eye"
    ],
    "explanation":
        "A DNA molecule consists of two strands that wind around each other like a twisted ladder, forming a shape known as a double helix."
  },
  {
    "category": "Science: Biology",
    "type": "multiple",
    "difficulty": "hard",
    "question": "Who is known as the 'father of genetics'?",
    "correct_answer": "Gregor Mendel",
    "incorrect_answers": ["Charles Darwin", "Louis Pasteur", "James Watson"],
    "explanation":
        "Gregor Mendel, an Augustinian friar, discovered the basic principles of heredity through his experiments with pea plants. His work laid the foundation for the modern science of genetics."
  },
  {
    "category": "Science: Biology",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the common name for the 'scapula'?",
    "correct_answer": "Shoulder blade",
    "incorrect_answers": ["Collarbone", "Kneecap", "Breastbone"],
    "explanation":
        "The scapula, or shoulder blade, is the large, triangular bone that connects the humerus (upper arm bone) with the clavicle (collarbone)."
  },
  {
    "category": "Science: Biology",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is 'fermentation'?",
    "correct_answer": "A metabolic process that produces energy without oxygen",
    "incorrect_answers": [
      "The process of plants making food",
      "The formal name for breathing",
      "The division of a cell into two"
    ],
    "explanation":
        "Fermentation is an anaerobic process (it doesn't need oxygen) where microorganisms like yeast and bacteria convert sugars into energy, producing byproducts like alcohol, lactic acid, and carbon dioxide. It's used to make beer, wine, and yogurt."
  },
  {
    "category": "Science: Biology",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the main function of 'white blood cells'?",
    "correct_answer": "To fight infection",
    "incorrect_answers": [
      "To carry oxygen",
      "To help blood clot",
      "To transmit nerve signals"
    ],
    "explanation":
        "White blood cells (leukocytes) are a key component of the immune system. They circulate in the blood and body fluids, ready to find and attack pathogens like bacteria, viruses, and fungi."
  },
  {
    "category": "Science: Biology",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is 'CRISPR'?",
    "correct_answer": "A gene-editing technology",
    "incorrect_answers": [
      "A type of protein",
      "A newly discovered bacteria",
      "A blood-clotting disorder"
    ],
    "explanation":
        "CRISPR-Cas9 is a powerful and precise gene-editing tool derived from a bacterial immune system. It allows scientists to find, cut, and alter specific stretches of DNA, opening up new possibilities for treating genetic diseases."
  },
  {
    "category": "Science: Biology",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the common name for the 'cranium'?",
    "correct_answer": "Skull",
    "incorrect_answers": ["Spine", "Rib cage", "Pelvis"],
    "explanation":
        "The cranium is the part of the skull that encloses the brain. In common usage, 'skull' and 'cranium' are often used interchangeably to refer to the bony framework of the head."
  },
  {
    "category": "Science: Biology",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What are 'carnivores', 'herbivores', and 'omnivores'?",
    "correct_answer": "Types of organisms based on their diet",
    "incorrect_answers": [
      "Types of plant cells",
      "Stages of metamorphosis",
      "Different kingdoms of life"
    ],
    "explanation":
        "These terms classify animals by what they eat. Carnivores eat meat (e.g., lions), herbivores eat plants (e.g., cows), and omnivores eat both (e.g., bears, humans)."
  },
  {
    "category": "Science: Biology",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is 'mitosis'?",
    "correct_answer":
        "A type of cell division resulting in two identical daughter cells",
    "incorrect_answers": [
      "A type of cell division resulting in four sex cells (gametes)",
      "The process of a cell dying",
      "The process of a cell creating proteins"
    ],
    "explanation":
        "Mitosis is the process of cell division where one cell divides to produce two genetically identical 'daughter' cells. This is how organisms grow and repair tissue. Meiosis is the process that creates sex cells (sperm and eggs)."
  },

  // --- 10 More 'Art' Questions ---
  {
    "category": "Art",
    "type": "multiple",
    "difficulty": "medium",
    "question":
        "What is 'Cubism', the art movement co-founded by Pablo Picasso?",
    "correct_answer":
        "An art style that depicts subjects from multiple viewpoints at once",
    "incorrect_answers": [
      "An art style that uses hyper-realistic detail",
      "An art style focused on dreams and the unconscious",
      "An art style that uses dots to create an image"
    ],
    "explanation":
        "Cubism, pioneered by Pablo Picasso and Georges Braque, was a revolutionary art movement (early 20th century) that broke from traditional perspective. It depicts subjects from multiple angles simultaneously, often in a fragmented, geometric form."
  },
  {
    "category": "Art",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What are the three 'primary colors' in pigment (paint)?",
    "correct_answer": "Red, Yellow, Blue",
    "incorrect_answers": [
      "Red, Green, Blue",
      "Red, Yellow, Green",
      "Cyan, Magenta, Yellow"
    ],
    "explanation":
        "In the traditional RYB color model (used for paint/pigment), Red, Yellow, and Blue are the primary colors that can be mixed to create all other colors. (Red, Green, Blue are the primary colors of *light*, and Cyan, Magenta, Yellow are used in printing)."
  },
  {
    "category": "Art",
    "type": "multiple",
    "difficulty": "medium",
    "question":
        "Who is the artist famous for his 'Campbell's Soup Cans' and 'Marilyn Diptych' artworks?",
    "correct_answer": "Andy Warhol",
    "incorrect_answers": [
      "Roy Lichtenstein",
      "Jackson Pollock",
      "Jean-Michel Basquiat"
    ],
    "explanation":
        "Andy Warhol was a leading figure in the 'Pop Art' movement. His work explored the relationship between artistic expression, celebrity culture, and advertising, famously using screenprinting to mass-produce his images."
  },
  {
    "category": "Art",
    "type": "multiple",
    "difficulty": "medium",
    "question":
        "What is the name of the art movement that focused on capturing the fleeting impressions of light and color?",
    "correct_answer": "Impressionism",
    "incorrect_answers": ["Expressionism", "Surrealism", "Renaissance"],
    "explanation":
        "Impressionism (19th-century, Paris-based) was characterized by thin, visible brushstrokes and an emphasis on the accurate depiction of light in its changing qualities. Claude Monet was a key figure."
  },
  {
    "category": "Art",
    "type": "multiple",
    "difficulty": "hard",
    "question":
        "The painting 'The Girl with a Pearl Earring' is the most famous work by which Dutch Golden Age artist?",
    "correct_answer": "Johannes Vermeer",
    "incorrect_answers": ["Rembrandt", "Vincent van Gogh", "Frans Hals"],
    "explanation":
        "Johannes Vermeer was a Dutch Baroque painter known for his masterful treatment of light. 'The Girl with a Pearl Earring' (c. 1665) is his most iconic work, often called the 'Mona Lisa of the North'."
  },
  {
    "category": "Art",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is a 'fresco'?",
    "correct_answer": "A technique of painting on wet lime plaster",
    "incorrect_answers": [
      "A painting made of small, colored tiles",
      "A sculpture carved from a single block of wood",
      "A type of oil painting"
    ],
    "explanation":
        "Fresco (Italian for 'fresh') is a mural painting technique where water-based pigments are applied to freshly laid ('wet') lime plaster. The most famous example is the ceiling of the Sistine Chapel by Michelangelo."
  },
  {
    "category": "Art",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is 'origami'?",
    "correct_answer": "The Japanese art of paper folding",
    "incorrect_answers": [
      "The Japanese art of flower arranging",
      "The Japanese art of calligraphy",
      "The Japanese art of sword fighting"
    ],
    "explanation":
        "Origami is the art of paper folding, which is often associated with Japanese culture. The goal is to transform a flat square sheet of paper into a finished sculpture through folding."
  },
  {
    "category": "Art",
    "type": "multiple",
    "difficulty": "hard",
    "question": "Which American architect designed the 'Fallingwater' house?",
    "correct_answer": "Frank Lloyd Wright",
    "incorrect_answers": ["Frank Gehry", "I. M. Pei", "Le Corbusier"],
    "explanation":
        "Frank Lloyd Wright designed Fallingwater (1935) in Pennsylvania. It's a masterpiece of 'organic architecture', designed to be in harmony with its natural setting, famously built over a waterfall."
  },
  {
    "category": "Art",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What art movement was Jackson Pollock a leader of?",
    "correct_answer": "Abstract Expressionism",
    "incorrect_answers": ["Pop Art", "Dadaism", "Minimalism"],
    "explanation":
        "Jackson Pollock was a pivotal figure in the Abstract Expressionist movement. He was famous for his unique 'drip painting' technique, where he would pour or splash paint onto a canvas laid on the floor."
  },
  {
    "category": "Art",
    "type": "multiple",
    "difficulty": "medium",
    "question":
        "What is the name of the iconic, melting clocks painting by Salvador Dalí?",
    "correct_answer": "The Persistence of Memory",
    "incorrect_answers": [
      "The Elephants",
      "Swans Reflecting Elephants",
      "The Disintegration of Time"
    ],
    "explanation":
        "'The Persistence of Memory' (1931) is one of Salvador Dalí's most famous paintings. The soft, melting pocket watches are a classic example of Surrealism, exploring the unconscious mind and the nature of time."
  },
  {
    "category": "Programming",
    "type": "multiple",
    "difficulty": "medium",
    "question":
        "Which programming language, known for its use in data science, was named after a British comedy group?",
    "correct_answer": "Python",
    "incorrect_answers": ["R", "Java", "Swift"],
    "explanation":
        "When Guido van Rossum was creating Python, he was also reading the published scripts from 'Monty Python's Flying Circus', a BBC comedy series. He chose the name 'Python' as it was 'short, unique, and slightly mysterious'."
  },
  {
    "category": "Programming",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is 'null' in programming?",
    "correct_answer": "A special value representing 'no value' or 'empty'",
    "incorrect_answers": [
      "The same as the number 0",
      "A string with no characters ('')",
      "An error"
    ],
    "explanation":
        "'null' is a special value that represents the intentional absence of any object value. It is different from 0 (which is a number) and an empty string (which is a string). It means 'nothing' or 'empty'."
  },
  {
    "category": "Medicine",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the medical term for the 'voice box'?",
    "correct_answer": "Larynx",
    "incorrect_answers": ["Pharynx", "Trachea", "Esophagus"],
    "explanation":
        "The larynx (or voice box) is an organ in the top of the neck involved in breathing, producing sound, and protecting the trachea against food aspiration. The pharynx is the part of the throat behind the mouth and nasal cavity."
  },
  {
    "category": "Medicine",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the main difference between a virus and a bacterium?",
    "correct_answer":
        "Bacteria are living cells; viruses are not cells and require a host to replicate",
    "incorrect_answers": [
      "Viruses are larger than bacteria",
      "Only bacteria can be harmful",
      "Bacteria can be seen with the naked eye; viruses cannot"
    ],
    "explanation":
        "Bacteria are single-celled living organisms that can reproduce on their own. Viruses are much smaller, non-living infectious agents that must invade a host cell (like a human cell) to multiply."
  },
  {
    "category": "Medicine",
    "type": "multiple",
    "difficulty": "hard",
    "question":
        "What medical imaging technique uses a powerful magnetic field and radio waves to create detailed images of the organs and tissues?",
    "correct_answer": "MRI (Magnetic Resonance Imaging)",
    "incorrect_answers": [
      "CT Scan (Computed Tomography)",
      "X-Ray",
      "Ultrasound"
    ],
    "explanation":
        "MRI uses a large magnet and radio waves to look at organs and structures inside your body. It's particularly good for imaging soft tissues, like the brain, muscles, and ligaments."
  },
  {
    "category": "Medicine",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the human body's largest internal organ?",
    "correct_answer": "Liver",
    "incorrect_answers": ["Skin", "Brain", "Lungs"],
    "explanation":
        "The liver is the largest *internal* organ. (The skin is the largest organ overall). The liver performs over 500 vital functions, including filtering blood, detoxifying chemicals, and metabolizing drugs."
  },
  {
    "category": "Medicine",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is a 'placebo' in a clinical trial?",
    "correct_answer":
        "A substance with no therapeutic effect, used as a control",
    "incorrect_answers": [
      "The active drug being tested",
      "A high-dose version of a drug",
      "A type of painkiller"
    ],
    "explanation":
        "A placebo is an inactive substance (like a sugar pill) given to a control group in a clinical trial. This is done to measure the 'placebo effect' and see if the active drug being tested performs significantly better."
  },
  {
    "category": "Medicine",
    "type": "multiple",
    "difficulty": "medium",
    "question":
        "What is the condition of having persistently high blood pressure called?",
    "correct_answer": "Hypertension",
    "incorrect_answers": ["Hypotension", "Anemia", "Hyperglycemia"],
    "explanation":
        "Hypertension (high blood pressure) is a long-term medical condition in which the blood pressure in the arteries is persistently elevated. Hypotension is the opposite: low blood pressure."
  },
  {
    "category": "Medicine",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is the 'Heimlich maneuver' officially called?",
    "correct_answer": "Abdominal thrusts",
    "incorrect_answers": [
      "Cardiopulmonary resuscitation",
      "Tracheal intubation",
      "Thoracic compression"
    ],
    "explanation":
        "The Heimlich maneuver is a first-aid procedure for dislodging an obstruction from a person's windpipe. It is now officially and more descriptively called 'abdominal thrusts'."
  },
  {
    "category": "Medicine",
    "type": "multiple",
    "difficulty": "medium",
    "question":
        "Which type of 'white blood cell' is primarily responsible for producing antibodies?",
    "correct_answer": "B-Cells (Lymphocytes)",
    "incorrect_answers": ["Neutrophils", "Platelets", "Red Blood Cells"],
    "explanation":
        "B-cells are a type of lymphocyte (a white blood cell) that are a key part of the adaptive immune system. When activated by an antigen, they mature into plasma cells that produce antibodies."
  },
  {
    "category": "Medicine",
    "type": "multiple",
    "difficulty": "hard",
    "question":
        "Who is known as the 'father of antiseptic surgery' for introducing carbolic acid to sterilize surgical instruments?",
    "correct_answer": "Joseph Lister",
    "incorrect_answers": ["Louis Pasteur", "Robert Koch", "Ignaz Semmelweis"],
    "explanation":
        "Joseph Lister was a British surgeon who promoted the idea of sterile surgery. He successfully introduced carbolic acid (now known as phenol) to sterilize surgical instruments and clean wounds, dramatically reducing post-operative infections."
  },
  {
    "category": "Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the name of the galaxy our Solar System is in?",
    "correct_answer": "The Milky Way",
    "incorrect_answers": [
      "The Andromeda Galaxy",
      "The Triangulum Galaxy",
      "The Pinwheel Galaxy"
    ],
    "explanation":
        "Our Solar System is located in the Milky Way, a barred spiral galaxy. The name 'Milky Way' is a translation of the Latin 'Via Lactea', derived from the Greek 'Galaxias kyklos' (milky circle)."
  },
  {
    "category": "Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Which planet is known as the 'Red Planet'?",
    "correct_answer": "Mars",
    "incorrect_answers": ["Jupiter", "Venus", "Saturn"],
    "explanation":
        "Mars is often called the 'Red Planet' because of the iron oxide (rust) prevalent on its surface, which gives it a distinct reddish appearance."
  },
  {
    "category": "Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is a 'light-year'?",
    "correct_answer": "The distance light travels in one year",
    "incorrect_answers": [
      "The time it takes light to travel from the Sun",
      "A measure of brightness",
      "A unit of time used in space"
    ],
    "explanation":
        "A light-year is a unit of astronomical distance. It's the distance that light, which travels at about 299,792 kilometers per second, covers in one Julian year. It is approximately 9.46 trillion kilometers (5.88 trillion miles)."
  },
  {
    "category": "Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question":
        "What is the name of the massive black hole at the center of our galaxy?",
    "correct_answer": "Sagittarius A*",
    "incorrect_answers": ["Cygnus X-1", "M87*", "Andromeda A*"],
    "explanation":
        "Sagittarius A* (pronounced 'A-star') is the supermassive black hole at the Galactic Center of the Milky Way. It has a mass about 4 million times that of our Sun."
  },
  {
    "category": "Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is the 'Chandrasekhar Limit'?",
    "correct_answer": "The maximum mass of a stable white dwarf star",
    "incorrect_answers": [
      "The point at which a black hole's gravity is escapable",
      "The minimum mass required for a star to ignite fusion",
      "The orbital distance where a moon will be torn apart by gravity"
    ],
    "explanation":
        "The Chandrasekhar Limit is the maximum mass (about 1.4 times the mass of our Sun) that a white dwarf star can have and still be supported by electron degeneracy pressure. Above this mass, it will collapse, potentially triggering a Type Ia supernova."
  },
  {
    "category": "Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the largest planet in our solar system?",
    "correct_answer": "Jupiter",
    "incorrect_answers": ["Saturn", "Neptune", "Uranus"],
    "explanation":
        "Jupiter is the fifth planet from the Sun and the largest in the Solar System. It is a gas giant with a mass more than two and a half times that of all the other planets in the Solar System combined."
  },
  {
    "category": "Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the 'Great Red Spot' on Jupiter?",
    "correct_answer": "A massive, persistent storm",
    "incorrect_answers": [
      "A giant volcano",
      "A large, red-colored moon",
      "A continent-sized crater"
    ],
    "explanation":
        "The Great Red Spot is a gigantic anticyclonic storm on Jupiter, similar to a hurricane on Earth but much larger (it could fit Earth inside it) and far more persistent, having been observed for at least 350 years."
  },
  {
    "category": "Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Which planet is famous for its extensive ring system?",
    "correct_answer": "Saturn",
    "incorrect_answers": ["Jupiter", "Uranus", "Neptune"],
    "explanation":
        "Saturn is the most famous for its prominent ring system. While Jupiter, Uranus, and Neptune also have rings, Saturn's are the largest, brightest, and most complex, composed mostly of ice particles."
  },
  {
    "category": "Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What are 'Pulsars'?",
    "correct_answer": "Rotating neutron stars that emit beams of radiation",
    "incorrect_answers": [
      "A type of galaxy",
      "Stars that are about to go supernova",
      "A variable star that pulsates in brightness"
    ],
    "explanation":
        "Pulsars are highly magnetized, rotating neutron stars. They emit beams of electromagnetic radiation from their magnetic poles. As the star rotates, these beams sweep across space, and if they cross Earth, we observe a 'pulse' of radiation."
  },
  {
    "category": "Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question":
        "What is the name of the force that holds planets in orbit around the sun?",
    "correct_answer": "Gravity",
    "incorrect_answers": ["Magnetism", "The Strong Force", "Solar Wind"],
    "explanation":
        "Gravity is the fundamental force of attraction between all objects with mass. The Sun's immense mass creates a powerful gravitational pull that keeps all the planets, asteroids, and comets in our solar system in orbit."
  },
  {
    "category": "Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the 'Oort Cloud'?",
    "correct_answer":
        "A theoretical sphere of icy comets at the edge of the solar system",
    "incorrect_answers": [
      "A nebula where stars are born",
      "The asteroid belt between Mars and Jupiter",
      "A cluster of galaxies"
    ],
    "explanation":
        "The Oort Cloud is a theoretical, vast spherical shell of icy objects believed to exist at the outermost edge of our solar system, far beyond the orbit of Pluto. It is thought to be the source of long-period comets."
  },
  {
    "category": "Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question":
        "When the Moon passes between the Sun and Earth, blocking the Sun's light, what is this event called?",
    "correct_answer": "A Solar Eclipse",
    "incorrect_answers": ["A Lunar Eclipse", "An Equinox", "A Solstice"],
    "explanation":
        "A solar eclipse occurs when the Moon gets between Earth and the Sun, and the Moon casts a shadow over Earth. A lunar eclipse happens when Earth comes between the Sun and the Moon."
  },
  {
    "category": "Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is 'dark matter'?",
    "correct_answer":
        "A hypothetical form of matter that does not interact with light but has gravity",
    "incorrect_answers": [
      "The material that black holes are made of",
      "The empty space between stars",
      "A type of anti-particle"
    ],
    "explanation":
        "Dark matter is a hypothetical form of matter that is believed to make up about 85% of the matter in the universe. It is 'dark' because it does not appear to interact with the electromagnetic field, meaning it doesn't emit, absorb, or reflect light."
  },
  {
    "category": "Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "How many planets are in our solar system?",
    "correct_answer": "8",
    "incorrect_answers": ["9", "7", "10"],
    "explanation":
        "There are eight planets in our solar system: Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, and Neptune. Pluto was reclassified as a 'dwarf planet' in 2006 by the International Astronomical Union."
  },
  {
    "category": "Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the 'Big Bang Theory'?",
    "correct_answer":
        "The leading cosmological model for the observable universe from the earliest known periods",
    "incorrect_answers": [
      "A theory about how stars explode",
      "A theory about the formation of the solar system",
      "A popular TV show"
    ],
    "explanation":
        "The Big Bang Theory is the prevailing model explaining the origin of the universe. It states that the universe began as an extremely hot, dense point and has been expanding and cooling ever since. (It is also a popular TV show, but that's not the astronomical answer!)"
  },
  {
    "category": "Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Which planet is closest to the Sun?",
    "correct_answer": "Mercury",
    "incorrect_answers": ["Venus", "Mars", "Earth"],
    "explanation":
        "Mercury is the smallest planet in our solar system and the one closest to the Sun, with an average distance of about 58 million kilometers (36 million miles)."
  },
  {
    "category": "Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is the 'event horizon' of a black hole?",
    "correct_answer":
        "The boundary beyond which nothing, not even light, can escape",
    "incorrect_answers": [
      "The center of the black hole",
      "The ring of light around a black hole",
      "The point of maximum gravity"
    ],
    "explanation":
        "The event horizon is the 'point of no return' around a black hole. It is a boundary in spacetime where the gravitational pull is so strong that the escape velocity is equal to the speed of light. Once something crosses it, it cannot get out."
  },
  {
    "category": "Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is an 'Aurora' (like the Northern Lights)?",
    "correct_answer":
        "A natural light display caused by solar particles interacting with the Earth's magnetic field",
    "incorrect_answers": [
      "A reflection of moonlight off ice crystals in the atmosphere",
      "A type of weather phenomenon",
      "A man-made light show"
    ],
    "explanation":
        "Auroras are caused by charged particles (mainly electrons and protons) from the Sun's solar wind, which get trapped in the Earth's magnetic field. These particles collide with atoms in the upper atmosphere, exciting them and causing them to glow."
  },
  {
    "category": "Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is a 'supernova'?",
    "correct_answer": "The powerful and luminous explosion of a massive star",
    "incorrect_answers": [
      "The birth of a new star from a nebula",
      "The merging of two galaxies",
      "A star that rapidly pulsates in brightness"
    ],
    "explanation":
        "A supernova is a stellar explosion that occurs during the last evolutionary stages of a massive star or when a white dwarf is triggered into runaway nuclear fusion. The explosion is incredibly bright, often briefly outshining an entire galaxy."
  },
  {
    "category": "Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question": "Which two elements are most abundant in the universe?",
    "correct_answer": "Hydrogen and Helium",
    "incorrect_answers": [
      "Hydrogen and Oxygen",
      "Carbon and Nitrogen",
      "Iron and Silicon"
    ],
    "explanation":
        "Hydrogen is the most abundant element, making up about 75% of all matter in the universe. Helium is second, making up about 24%. All other elements (which astronomers call 'metals') make up only about 1%."
  },
  {
    "category": "Medicine",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the common term for the 'clavicle'?",
    "correct_answer": "Collarbone",
    "incorrect_answers": ["Shin bone", "Thigh bone", "Funny bone"],
    "explanation":
        "The clavicle, or collarbone, is a long, slender bone that connects the shoulder blade (scapula) to the breastbone (sternum)."
  },
  {
    "category": "Engineering",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is 'pasteurization'?",
    "correct_answer": "A process of heating a liquid to kill harmful bacteria",
    "incorrect_answers": [
      "A method of filtering particles from the air",
      "A way to build structures in open-pasture land",
      "The process of separating crude oil"
    ],
    "explanation":
        "Named after Louis Pasteur, pasteurization is a process in which packaged and non-packaged foods (like milk and juice) are treated with mild heat (usually below 100°C) to eliminate pathogens and extend shelf life."
  },

  {
    "category": "Entertainment: Film",
    "type": "multiple",
    "difficulty": "medium",
    "question":
        "What is the highest-grossing film of all time (unadjusted for inflation)?",
    "correct_answer": "Avatar (2009)",
    "incorrect_answers": [
      "Avengers: Endgame",
      "Titanic",
      "Star Wars: The Force Awakens"
    ],
    "explanation":
        "James Cameron's 'Avatar' (2009) is the highest-grossing film of all time at the worldwide box office, not accounting for inflation. It briefly lost the title to 'Avengers: Endgame' but regained it after a 2021 re-release."
  },
  {
    "category": "Physics",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is Newton's First Law of Motion commonly known as?",
    "correct_answer": "The Law of Inertia",
    "incorrect_answers": [
      "The Law of Gravity",
      "The Law of Action-Reaction",
      "The Law of Thermodynamics"
    ],
    "explanation":
        "Newton's First Law (the Law of Inertia) states that an object at rest will stay at rest, and an object in motion will stay in motion with the same speed and in the same direction unless acted upon by an unbalanced external force."
  },
  {
    "category": "Physics",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the unit of electric current?",
    "correct_answer": "Ampere (Amp)",
    "incorrect_answers": ["Volt", "Ohm", "Watt"],
    "explanation":
        "The Ampere (A), or amp, is the SI base unit of electric current. A volt is the unit of voltage, an ohm is the unit of resistance, and a watt is the unit of power."
  },
  {
    "category": "Physics",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What does E=mc² represent?",
    "correct_answer": "Mass-energy equivalence",
    "incorrect_answers": [
      "The formula for kinetic energy",
      "The law of universal gravitation",
      "The speed of a wave"
    ],
    "explanation":
        "Albert Einstein's famous equation E=mc² describes mass-energy equivalence. It states that energy (E) is equal to mass (m) times the speed of light (c) squared. This means a small amount of mass can be converted into a huge amount of energy."
  },
  {
    "category": "Physics",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What force pulls objects toward the center of the Earth?",
    "correct_answer": "Gravity",
    "incorrect_answers": ["Magnetism", "Friction", "Inertia"],
    "explanation":
        "Gravity is the fundamental force of attraction that all objects with mass have for one another. On Earth, this force pulls everything 'down' toward the planet's center."
  },
  {
    "category": "Physics",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the difference between speed and velocity?",
    "correct_answer": "Velocity includes direction, while speed does not",
    "incorrect_answers": [
      "Speed includes direction, while velocity does not",
      "They are the same thing",
      "Velocity is measured in m/s, speed is not"
    ],
    "explanation":
        "Speed is a scalar quantity (how fast something is moving, e.g., 60 mph). Velocity is a vector quantity (how fast *and in what direction* something is moving, e.g., 60 mph North)."
  },
  {
    "category": "Physics",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Newton's Third Law of Motion is best known as...",
    "correct_answer":
        "For every action, there is an equal and opposite reaction",
    "incorrect_answers": [
      "An object in motion stays in motion",
      "Force equals mass times acceleration",
      "Energy cannot be created or destroyed"
    ],
    "explanation":
        "This law states that when one body exerts a force on a second body, the second body simultaneously exerts a force equal in magnitude and opposite in direction on the first body. This is why a rocket is propelled forward by expelling gas backward."
  },
  {
    "category": "Physics",
    "type": "multiple",
    "difficulty": "hard",
    "question":
        "In quantum mechanics, what is the 'Heisenberg Uncertainty Principle'?",
    "correct_answer":
        "You cannot simultaneously know the exact position and momentum of a particle",
    "incorrect_answers": [
      "A particle can be in two places at once",
      "Energy can only exist in discrete packets (quanta)",
      "An electron behaves as both a particle and a wave"
    ],
    "explanation":
        "Formulated by Werner Heisenberg, this principle states there is a fundamental limit to the precision with which certain pairs of physical properties, such as position and momentum, can be known. The more precisely one is known, the less precisely the other can be."
  },
  {
    "category": "Physics",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What form of energy is stored in a battery?",
    "correct_answer": "Chemical energy",
    "incorrect_answers": [
      "Kinetic energy",
      "Potential energy",
      "Nuclear energy"
    ],
    "explanation":
        "A battery stores chemical energy, which is converted into electrical energy through a chemical reaction (an electrochemical reaction) when the battery is used."
  },
  {
    "category": "Physics",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is 'kinetic energy'?",
    "correct_answer": "The energy an object possesses due to its motion",
    "incorrect_answers": [
      "The energy stored in an object's position",
      "Energy stored in chemical bonds",
      "Heat energy"
    ],
    'explanation':
        r'Kinetic energy is the energy of motion. A moving car, a flying baseball, and a running person all possess kinetic energy. It is calculated as $$KE = \frac{1}{2}mv^2$$.',
  },
  {
    "category": "Physics",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the unit of power?",
    "correct_answer": "Watt",
    "incorrect_answers": ["Joule", "Volt", "Ampere"],
    "explanation":
        "The Watt (W) is the unit of power, which is the rate at which energy is used or transferred. A Joule is a unit of energy (Power = Energy / time)."
  },
  {
    "category": "Physics",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is 'superconductivity'?",
    "correct_answer": "A state where a material has zero electrical resistance",
    "incorrect_answers": [
      "A material that is stronger than diamond",
      "A material that conducts heat perfectly",
      "A material that is a perfect insulator"
    ],
    "explanation":
        "Superconductivity is a phenomenon where certain materials, when cooled below a critical temperature, exhibit exactly zero electrical resistance. This allows them to carry a current indefinitely without losing energy."
  },
  {
    "category": "Physics",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is 'refraction'?",
    "correct_answer":
        "The bending of light as it passes from one medium to another",
    "incorrect_answers": [
      "The bouncing of light off a surface",
      "The splitting of light into its component colors",
      "The absorption of light by a material"
    ],
    "explanation":
        "Refraction is the change in direction of a wave, like light, when it passes from one medium (like air) into another (like water). This is why a straw in a glass of water looks 'broken'."
  },
  {
    "category": "Physics",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What does a 'barometer' measure?",
    "correct_answer": "Atmospheric pressure",
    "incorrect_answers": ["Temperature", "Wind speed", "Humidity"],
    "explanation":
        "A barometer is a scientific instrument used to measure atmospheric pressure, also known as barometric pressure. Changes in this pressure can signal short-term changes in the weather."
  },
  {
    "category": "Physics",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the First Law of Thermodynamics also known as?",
    "correct_answer": "The Law of Conservation of Energy",
    "incorrect_answers": [
      "The Law of Entropy",
      "The Law of Inertia",
      "The Law of Universal Gravitation"
    ],
    "explanation":
        "The First Law of Thermodynamics states that energy cannot be created or destroyed in an isolated system; it can only be transferred or changed from one form to another. This is the principle of the conservation of energy."
  },
  {
    "category": "Physics",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is 'friction'?",
    "correct_answer":
        "A force that opposes motion between two surfaces in contact",
    "incorrect_answers": [
      "A force that pulls objects together",
      "The speed of an object",
      "A type of energy"
    ],
    "explanation":
        "Friction is a resistive force that acts between two surfaces that are sliding, or trying to slide, against each other. It always opposes the direction of motion or intended motion."
  },
  {
    "category": "Physics",
    "type": "multiple",
    "difficulty": "hard",
    "question": "Which of the four fundamental forces is the *weakest*?",
    "correct_answer": "Gravity",
    "incorrect_answers": [
      "Weak Nuclear Force",
      "Electromagnetism",
      "Strong Nuclear Force"
    ],
    "explanation":
        "Despite its obvious effects on a large scale (like holding planets in orbit), gravity is by far the weakest of the four fundamental forces. A simple refrigerator magnet (electromagnetism) can overcome the entire gravitational pull of the Earth to pick up a paperclip."
  },
  {
    "category": "Physics",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is 'potential energy'?",
    "correct_answer":
        "The energy stored in an object due to its position or arrangement",
    "incorrect_answers": [
      "The energy of a moving object",
      "The energy stored in a battery",
      "The energy from the sun"
    ],
    "explanation":
        "Potential energy is stored energy. A common example is gravitational potential energy: a book held high in the air has potential energy. If you let it go, that potential energy is converted into kinetic energy (energy of motion) as it falls."
  },
  {
    "category": "Physics",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is 'wave-particle duality'?",
    "correct_answer":
        "The concept that all matter exhibits both wave-like and particle-like properties",
    "incorrect_answers": [
      "The idea that waves and particles are opposites",
      "A particle that is made of a wave",
      "The theory that sound travels in waves"
    ],
    "explanation":
        "A central concept of quantum mechanics, wave-particle duality describes how quantum entities like photons and electrons can be described as *both* particles (with a specific location) and waves (spread out in space) depending on how they are measured."
  },
  {
    "category": "Physics",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the speed of light in a vacuum?",
    "correct_answer": "Approximately 300,000,000 meters per second",
    "incorrect_answers": [
      "Approximately 300,000,000 miles per hour",
      "Approximately 343 meters per second",
      "It is infinitely fast"
    ],
    "explanation":
        "The speed of light in a vacuum, commonly denoted as 'c', is a universal constant. Its exact value is 299,792,458 meters per second. 343 m/s is the approximate speed of sound in air."
  },
  {
    "category": "Physics",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is 'Archimedes' Principle'?",
    "correct_answer":
        "The buoyant force on an object is equal to the weight of the fluid it displaces",
    "incorrect_answers": [
      "Give me a lever long enough, and I shall move the world",
      "The shortest distance between two points is a straight line",
      "For every action, there is an equal and opposite reaction"
    ],
    "explanation":
        "Archimedes' Principle explains buoyancy. It states that any body completely or partially submerged in a fluid (gas or liquid) at rest is acted upon by an upward, or buoyant, force. This is why a massive steel ship can float."
  },
  {
    "category": "Geography",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Which country is also a continent?",
    "correct_answer": "Australia",
    "incorrect_answers": ["Brazil", "India", "Russia"],
    "explanation":
        "Australia is the only country in the world that is also a continent. It is part of the larger continental region of Oceania, but the landmass of Australia itself is considered a continent."
  },
  // ========================================
  // Mathematics Questions
  // ========================================
  {
    'category': 'Mathematics',
    'difficulty': 'easy',
    'question': r'What is $$2 + 2$$?',
    'correct_answer': '4',
    'incorrect_answers': ['3', '5', '22'],
    'explanation': r'Basic addition: $$2 + 2 = 4$$',
    'type': 'multiple',
  },
  {
    'category': 'Mathematics',
    'difficulty': 'medium',
    'question': r'Solve for x: $$x^2 = 16$$',
    'correct_answer': r'$$\pm 4$$',
    'incorrect_answers': ['4', '8', '2'],
    'explanation':
        r'Taking the square root of both sides: $$x = \pm \sqrt{16} = \pm 4$$',
    'type': 'multiple',
  },
  {
    'category': 'Mathematics',
    'difficulty': 'hard',
    'question': r'What is the derivative of $$f(x) = x^3$$?',
    'correct_answer': r'$$3x^2$$',
    'incorrect_answers': [r'$$x^2$$', r'$$3x$$', r'$$x^3$$'],
    'explanation':
        r'Using the power rule: $$\frac{d}{dx}(x^n) = nx^{n-1}$$, so $$\frac{d}{dx}(x^3) = 3x^2$$',
    'type': 'multiple',
  },
  {
    'category': 'Mathematics',
    'difficulty': 'medium',
    'question': r'What is the value of $$\sin(90°)$$?',
    'correct_answer': '1',
    'incorrect_answers': ['0', '0.5', '-1'],
    'explanation':
        r'On the unit circle, at 90 degrees (or $$\pi/2$$ radians), the y-coordinate is 1.',
    'type': 'multiple',
  },
  {
    'category': 'Mathematics',
    'difficulty': 'easy',
    'question': r'What is $$\pi$$ approximately equal to?',
    'correct_answer': '3.14159',
    'incorrect_answers': ['2.71828', '1.41421', '3.33333'],
    'explanation':
        r'$$\pi$$ (pi) is approximately 3.14159, representing the ratio of a circle circumference to its diameter.',
    'type': 'multiple',
  },
  // ========================================
  // Engineering Questions
  // ========================================
  {
    'category': 'Electrical Engineering',
    'difficulty': 'medium',
    'question': r'Which law states that $$V = IR$$?',
    'correct_answer': r"Ohm's Law",
    'incorrect_answers': [
      r"Kirchhoff's Law",
      r"Newton's Law",
      r"Faraday's Law"
    ],
    'explanation':
        r"Ohm's Law relates Voltage (V), Current (I), and Resistance (R).",
    'type': 'multiple',
  },
  {
    'category': 'Mechanical Engineering',
    'difficulty': 'hard',
    'question':
        r'Calculate the stress ($$\sigma$$) if a force of 100N is applied to an area of 2m$$^2$$. Formula: $$\sigma = \frac{F}{A}$$',
    'correct_answer': '50 Pa',
    'incorrect_answers': ['200 Pa', '100 Pa', '20 Pa'],
    'explanation': r'$$\sigma = \frac{100}{2} = 50$$ Pascals (Pa).',
    'type': 'multiple',
  },
  {
    'category': 'Mechanical Engineering',
    'difficulty': 'hard',
    'question':
        'In thermodynamics, what does the First Law state regarding energy?',
    'correct_answer': r'$$\Delta U = Q - W$$',
    'incorrect_answers': [r'$$F = ma$$', r'$$E = mc^2$$', r'$$PV = nRT$$'],
    'explanation':
        r'The change in internal energy ($$\Delta U$$) equals heat added (Q) minus work done (W).',
    'type': 'multiple',
  },
  {
    'category': 'Electrical Engineering',
    'difficulty': 'medium',
    'question': 'Identify this component symbol:',
    'correct_answer': 'Resistor',
    'incorrect_answers': ['Capacitor', 'Inductor', 'Diode'],
    'explanation': 'The zig-zag line is the standard US symbol for a resistor.',
    'type': 'multiple',
    'imageUrl':
        'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/Resistor_symbol_America.svg/1200px-Resistor_symbol_America.svg.png',
  },
  {
    'category': 'Electrical Engineering',
    'difficulty': 'easy',
    'question': 'What does AC stand for in electrical engineering?',
    'correct_answer': 'Alternating Current',
    'incorrect_answers': [
      'Absolute Current',
      'Active Circuit',
      'Amplified Charge'
    ],
    'explanation':
        'AC (Alternating Current) is an electric current that periodically reverses direction, unlike DC (Direct Current).',
    'type': 'multiple',
  },
  // ========================================
  // ADVANCED MATHEMATICS - CALCULUS
  // ========================================
  {
    'category': 'Mathematics',
    'difficulty': 'medium',
    'question': r'Find the integral: $$\int x^2 dx$$',
    'correct_answer': r'$$\frac{x^3}{3} + C$$',
    'incorrect_answers': [
      r'$$\frac{x^2}{2} + C$$',
      r'$$x^3 + C$$',
      r'$$2x + C$$'
    ],
    'explanation':
        r'Using the power rule for integration: $$\int x^n dx = \frac{x^{n+1}}{n+1} + C$$',
    'type': 'multiple',
  },
  {
    'category': 'Mathematics',
    'difficulty': 'hard',
    'question': r'Evaluate: $$\lim_{x \to 0} \frac{\sin(x)}{x}$$',
    'correct_answer': '1',
    'incorrect_answers': ['0', r'$$\infty$$', 'undefined'],
    'explanation':
        r'This is a fundamental limit in calculus: $$\lim_{x \to 0} \frac{\sin(x)}{x} = 1$$',
    'type': 'multiple',
  },
  {
    'category': 'Mathematics',
    'difficulty': 'hard',
    'question': r'Find $$\frac{d}{dx}[\ln(x)]$$',
    'correct_answer': r'$$\frac{1}{x}$$',
    'incorrect_answers': [r'$$\ln(x)$$', r'$$x$$', r'$$e^x$$'],
    'explanation':
        r'The derivative of the natural logarithm is $$\frac{d}{dx}[\ln(x)] = \frac{1}{x}$$',
    'type': 'multiple',
  },
  {
    'category': 'Mathematics',
    'difficulty': 'medium',
    'question': r'What is the second derivative of $$f(x) = e^{2x}$$?',
    'correct_answer': r'$$4e^{2x}$$',
    'incorrect_answers': [r'$$2e^{2x}$$', r'$$e^{2x}$$', r'$$2xe^{2x}$$'],
    'explanation':
        r'First derivative: $$2e^{2x}$$. Second derivative: $$4e^{2x}$$',
    'type': 'multiple',
  },
  // ========================================
  // ADVANCED MATHEMATICS - LINEAR ALGEBRA
  // ========================================
  {
    'category': 'Mathematics',
    'difficulty': 'medium',
    'question':
        r'What is the determinant of $$\begin{bmatrix} 2 & 1 \\ 4 & 3 \end{bmatrix}$$?',
    'correct_answer': '2',
    'incorrect_answers': ['6', '10', '5'],
    'explanation':
        r'For a 2x2 matrix $$\begin{bmatrix} a & b \\ c & d \end{bmatrix}$$, det = $$ad - bc = 2(3) - 1(4) = 2$$',
    'type': 'multiple',
  },
  {
    'category': 'Mathematics',
    'difficulty': 'hard',
    'question': 'What is the rank of a 3x3 identity matrix?',
    'correct_answer': '3',
    'incorrect_answers': ['1', '2', '0'],
    'explanation':
        'The identity matrix has full rank equal to its dimension. All rows/columns are linearly independent.',
    'type': 'multiple',
  },
  {
    'category': 'Mathematics',
    'difficulty': 'medium',
    'question':
        r'If $$A$$ is a 3x2 matrix and $$B$$ is a 2x4 matrix, what is the dimension of $$AB$$?',
    'correct_answer': '3x4',
    'incorrect_answers': ['2x2', '3x2', '2x4'],
    'explanation':
        r'Matrix multiplication: $$(m \times n)(n \times p) = (m \times p)$$, so $$(3 \times 2)(2 \times 4) = 3 \times 4$$',
    'type': 'multiple',
  },
  // ========================================
  // ADVANCED MATHEMATICS - DIFFERENTIAL EQUATIONS
  // ========================================
  {
    'category': 'Mathematics',
    'difficulty': 'hard',
    'question': r'Solve: $$\frac{dy}{dx} = ky$$ where $$k$$ is constant',
    'correct_answer': r'$$y = Ce^{kx}$$',
    'incorrect_answers': [r'$$y = Ckx$$', r'$$y = C\ln(kx)$$', r'$$y = Cx^k$$'],
    'explanation':
        r'This is exponential growth/decay. Solution: $$y = Ce^{kx}$$ where $$C$$ is the initial condition.',
    'type': 'multiple',
  },
  {
    'category': 'Mathematics',
    'difficulty': 'hard',
    'question': r"What is the general solution to $$y'' + 4y = 0$$?",
    'correct_answer': r'$$y = C_1\cos(2x) + C_2\sin(2x)$$',
    'incorrect_answers': [
      r'$$y = C_1e^{2x} + C_2e^{-2x}$$',
      r'$$y = C_1x + C_2$$',
      r'$$y = Ce^{4x}$$'
    ],
    'explanation':
        r'Characteristic equation: $$r^2 + 4 = 0$$, so $$r = \pm 2i$$. Solution involves sin and cos.',
    'type': 'multiple',
  },
  // ========================================
  // ADVANCED MATHEMATICS - STATISTICS
  // ========================================
  {
    'category': 'Mathematics',
    'difficulty': 'medium',
    'question': 'What is the variance formula for a sample?',
    'correct_answer': r'$$s^2 = \frac{\sum(x_i - \bar{x})^2}{n-1}$$',
    'incorrect_answers': [
      r'$$s^2 = \frac{\sum(x_i - \bar{x})^2}{n}$$',
      r'$$s^2 = \sum(x_i - \bar{x})^2$$',
      r'$$s^2 = \sqrt{\frac{\sum(x_i - \bar{x})^2}{n}}$$'
    ],
    'explanation':
        r'Sample variance uses $$n-1$$ (Bessel correction) for unbiased estimation.',
    'type': 'multiple',
  },
  {
    'category': 'Mathematics',
    'difficulty': 'easy',
    'question':
        r'In a normal distribution, what percentage of data falls within 1 standard deviation of the mean?',
    'correct_answer': '68%',
    'incorrect_answers': ['95%', '99.7%', '50%'],
    'explanation':
        r'The empirical rule: 68% within 1$$\sigma$$, 95% within 2$$\sigma$$, 99.7% within 3$$\sigma$$',
    'type': 'multiple',
  },
  // ========================================
  // ENGINEERING - ELECTRICAL
  // ========================================
  {
    'category': 'Electrical Engineering',
    'difficulty': 'medium',
    'question':
        r'Calculate total resistance for resistors in parallel: $$R_1 = 4\Omega$$, $$R_2 = 6\Omega$$',
    'correct_answer': r'$$2.4\Omega$$',
    'incorrect_answers': [r'$$10\Omega$$', r'$$5\Omega$$', r'$$1.2\Omega$$'],
    'explanation':
        r'Parallel: $$\frac{1}{R_T} = \frac{1}{R_1} + \frac{1}{R_2} = \frac{1}{4} + \frac{1}{6} = \frac{5}{12}$$, so $$R_T = 2.4\Omega$$',
    'type': 'multiple',
  },
  {
    'category': 'Electrical Engineering',
    'difficulty': 'hard',
    'question': 'What is the impedance of a series RLC circuit at resonance?',
    'correct_answer': r'$$Z = R$$ (minimum, purely resistive)',
    'incorrect_answers': [
      r'$$Z = \infty$$',
      r'$$Z = 0$$',
      r'$$Z = \sqrt{R^2 + (X_L - X_C)^2}$$'
    ],
    'explanation':
        r'At resonance, $$X_L = X_C$$, so they cancel. Impedance $$Z = R$$ (minimum).',
    'type': 'multiple',
  },
  {
    'category': 'Electrical Engineering',
    'difficulty': 'medium',
    'question':
        r'Calculate power: $$V = 120V$$, $$I = 5A$$, power factor = 0.8',
    'correct_answer': '480W',
    'incorrect_answers': ['600W', '96W', '750W'],
    'explanation':
        r'Real power: $$P = VI\cos(\theta) = 120 \times 5 \times 0.8 = 480W$$',
    'type': 'multiple',
  },
  {
    'category': 'Electrical Engineering',
    'difficulty': 'hard',
    'question': r'What is the time constant $$\tau$$ for an RC circuit?',
    'correct_answer': r'$$\tau = RC$$',
    'incorrect_answers': [
      r'$$\tau = \frac{R}{C}$$',
      r'$$\tau = \frac{C}{R}$$',
      r'$$\tau = \frac{1}{RC}$$'
    ],
    'explanation':
        r'Time constant $$\tau = RC$$ determines charging/discharging rate. After $$5\tau$$, capacitor is ~99% charged.',
    'type': 'multiple',
  },
  // ========================================
  // ENGINEERING - MECHANICAL
  // ========================================
  {
    'category': 'Mechanical Engineering',
    'difficulty': 'medium',
    'question':
        r'Calculate kinetic energy: mass = 10kg, velocity = 5 m/s. Formula: $$KE = \frac{1}{2}mv^2$$',
    'correct_answer': '125 J',
    'incorrect_answers': ['250 J', '50 J', '25 J'],
    'explanation':
        r'$$KE = \frac{1}{2}(10)(5)^2 = \frac{1}{2}(10)(25) = 125$$ Joules',
    'type': 'multiple',
  },
  {
    'category': 'Mechanical Engineering',
    'difficulty': 'hard',
    'question':
        r'What is the moment of inertia for a solid cylinder about its central axis? (mass $$m$$, radius $$r$$)',
    'correct_answer': r'$$I = \frac{1}{2}mr^2$$',
    'incorrect_answers': [
      r'$$I = mr^2$$',
      r'$$I = \frac{2}{5}mr^2$$',
      r'$$I = \frac{1}{3}mr^2$$'
    ],
    'explanation':
        r'For a solid cylinder rotating about its central axis: $$I = \frac{1}{2}mr^2$$',
    'type': 'multiple',
  },
  {
    'category': 'Mechanical Engineering',
    'difficulty': 'medium',
    'question':
        r'Calculate torque: Force = 50N, distance = 2m, angle = 90°. Formula: $$\tau = rF\sin(\theta)$$',
    'correct_answer': '100 Nm',
    'incorrect_answers': ['50 Nm', '25 Nm', '200 Nm'],
    'explanation': r'$$\tau = (2)(50)\sin(90°) = 100 \times 1 = 100$$ Nm',
    'type': 'multiple',
  },
  {
    'category': 'Mechanical Engineering',
    'difficulty': 'hard',
    'question': 'What is the efficiency formula for a heat engine?',
    'correct_answer': r'$$\eta = 1 - \frac{T_C}{T_H}$$ (Carnot)',
    'incorrect_answers': [
      r'$$\eta = \frac{T_C}{T_H}$$',
      r'$$\eta = \frac{T_H - T_C}{T_C}$$',
      r'$$\eta = \frac{W}{Q_H + Q_C}$$'
    ],
    'explanation':
        r'Carnot efficiency: $$\eta = 1 - \frac{T_C}{T_H}$$ where $$T_C$$ is cold reservoir, $$T_H$$ is hot reservoir (in Kelvin).',
    'type': 'multiple',
  },
  // ========================================
  // ENGINEERING - CIVIL
  // ========================================
  {
    'category': 'Civil Engineering',
    'difficulty': 'medium',
    'question':
        r'Calculate bending stress: $$M = 1000$$ Nm, $$y = 0.05$$ m, $$I = 0.0001$$ m$$^4$$. Formula: $$\sigma = \frac{My}{I}$$',
    'correct_answer': '500 kPa',
    'incorrect_answers': ['1000 kPa', '250 kPa', '50 kPa'],
    'explanation':
        r'$$\sigma = \frac{1000 \times 0.05}{0.0001} = 500,000$$ Pa = 500 kPa',
    'type': 'multiple',
  },
  {
    'category': 'Mechanical Engineering',
    'difficulty': 'hard',
    'question': 'What is the Euler buckling load formula for a column?',
    'correct_answer': r'$$P_{cr} = \frac{\pi^2 EI}{(KL)^2}$$',
    'incorrect_answers': [
      r'$$P_{cr} = \frac{EI}{L^2}$$',
      r'$$P_{cr} = \pi EI$$',
      r'$$P_{cr} = \frac{\pi EI}{L}$$'
    ],
    'explanation':
        r'Euler buckling: $$P_{cr} = \frac{\pi^2 EI}{(KL)^2}$$ where $$K$$ is effective length factor.',
    'type': 'multiple',
  },
  {
    'category': 'Civil Engineering',
    'difficulty': 'medium',
    'question':
        r'Calculate shear stress: Force = 5000N, Area = 0.01 m$$^2$$. Formula: $$\tau = \frac{F}{A}$$',
    'correct_answer': '500 kPa',
    'incorrect_answers': ['50 kPa', '5000 kPa', '5 MPa'],
    'explanation': r'$$\tau = \frac{5000}{0.01} = 500,000$$ Pa = 500 kPa',
    'type': 'multiple',
  },
  // ========================================
  // ENGINEERING - CHEMICAL
  // ========================================
  {
    'category': 'Chemical Engineering',
    'difficulty': 'medium',
    'question': 'What is the ideal gas law?',
    'correct_answer': r'$$PV = nRT$$',
    'incorrect_answers': [
      r'$$PV = RT$$',
      r'$$P = nRT$$',
      r'$$V = \frac{nRT}{P^2}$$'
    ],
    'explanation':
        r'Ideal gas law: $$PV = nRT$$ where $$P$$ = pressure, $$V$$ = volume, $$n$$ = moles, $$R$$ = gas constant, $$T$$ = temperature',
    'type': 'multiple',
  },
  {
    'category': 'Chemical Engineering',
    'difficulty': 'hard',
    'question': 'What is the Arrhenius equation for reaction rate?',
    'correct_answer': r'$$k = Ae^{-E_a/RT}$$',
    'incorrect_answers': [
      r'$$k = Ae^{E_a/RT}$$',
      r'$$k = A\ln(E_a/RT)$$',
      r'$$k = \frac{A}{E_a}RT$$'
    ],
    'explanation':
        r'Arrhenius equation: $$k = Ae^{-E_a/RT}$$ where $$E_a$$ is activation energy.',
    'type': 'multiple',
  },
  {
    'category': 'Chemical Engineering',
    'difficulty': 'medium',
    'question':
        r'Calculate molar mass of water (H$$_2$$O). H = 1 g/mol, O = 16 g/mol',
    'correct_answer': '18 g/mol',
    'incorrect_answers': ['17 g/mol', '20 g/mol', '16 g/mol'],
    'explanation': r'H$$_2$$O: $$2(1) + 16 = 18$$ g/mol',
    'type': 'multiple',
  },
  // ========================================
  // ENGINEERING - COMPUTER/SOFTWARE
  // ========================================
  {
    'category': 'Computer Engineering',
    'difficulty': 'medium',
    'question': 'What is the time complexity of binary search?',
    'correct_answer': r'$$O(\log n)$$',
    'incorrect_answers': [r'$$O(n)$$', r'$$O(n^2)$$', r'$$O(1)$$'],
    'explanation':
        r'Binary search halves the search space each iteration, giving $$O(\log n)$$ complexity.',
    'type': 'multiple',
  },
  {
    'category': 'Computer Engineering',
    'difficulty': 'hard',
    'question': 'What is the Shannon entropy formula?',
    'correct_answer': r'$$H(X) = -\sum p(x)\log_2 p(x)$$',
    'incorrect_answers': [
      r'$$H(X) = \sum p(x)$$',
      r'$$H(X) = \log_2 n$$',
      r'$$H(X) = -\log_2 p(x)$$'
    ],
    'explanation':
        r'Shannon entropy measures information content: $$H(X) = -\sum p(x)\log_2 p(x)$$',
    'type': 'multiple',
  },
  {
    'category': 'Computer Engineering',
    'difficulty': 'medium',
    'question': 'How many bits in 1 byte?',
    'correct_answer': '8',
    'incorrect_answers': ['16', '4', '32'],
    'explanation':
        '1 byte = 8 bits. This is a fundamental unit in computer science.',
    'type': 'multiple',
  },
  {
    'category': 'Mathematics',
    'difficulty': 'hard',
    'question': r'''Find: $$\int \frac{1}{x^2 + 1} dx$$''',
    'correct_answer': r'''$$\arctan(x) + C$$''',
    'incorrect_answers': [
      r'''$$\ln(x^2 + 1) + C$$''',
      r'''$$\frac{x}{x^2 + 1} + C$$''',
      r'''$$\frac{1}{2}\ln(x^2 + 1) + C$$'''
    ],
    'explanation':
        r'''The integral of 1/(x² + 1) is arctan(x) + C, a standard integral formula.''',
    'type': 'multiple',
  },

  {
    'category': 'Mathematics',
    'difficulty': 'hard',
    'question': r'''Evaluate: $$\lim_{x \to 0} \frac{\sin(x)}{x}$$''',
    'correct_answer': r'''$$1$$''',
    'incorrect_answers': [
      r'''$$0$$''',
      r'''$$\infty$$''',
      r'''$$\frac{1}{2}$$'''
    ],
    'explanation':
        r'''This is a fundamental limit: $$\lim_{x \to 0} \frac{\sin(x)}{x} = 1$$''',
    'type': 'multiple',
  },

  {
    'category': 'Mathematics',
    'difficulty': 'medium',
    'question': r'''Find the derivative: $$\frac{d}{dx}(e^{2x})$$''',
    'correct_answer': r'''$$2e^{2x}$$''',
    'incorrect_answers': [
      r'''$$e^{2x}$$''',
      r'''$$2xe^{2x}$$''',
      r'''$$e^{2x} + 2$$'''
    ],
    'explanation': r'''Using chain rule: d/dx(e^(2x)) = e^(2x) · 2 = 2e^(2x)''',
    'type': 'multiple',
  },

  {
    'category': 'Mathematics',
    'difficulty': 'hard',
    'question': r'''Solve: $$\int x \cdot e^x dx$$''',
    'correct_answer': r'''$$xe^x - e^x + C$$''',
    'incorrect_answers': [
      r'''$$\frac{x^2 e^x}{2} + C$$''',
      r'''$$e^{x^2} + C$$''',
      r'''$$\frac{e^x}{x} + C$$'''
    ],
    'explanation':
        r'''Using integration by parts: $$\int x e^x dx = xe^x - e^x + C$$''',
    'type': 'multiple',
  },

  {
    'category': 'Mathematics',
    'difficulty': 'medium',
    'question': r'''Find: $$\frac{d}{dx}(\ln(x^2))$$''',
    'correct_answer': r'''$$\frac{2}{x}$$''',
    'incorrect_answers': [
      r'''$$\frac{1}{x^2}$$''',
      r'''$$\frac{2x}{x^2}$$''',
      r'''$$2\ln(x)$$'''
    ],
    'explanation':
        r'''Using chain rule: $$\frac{d}{dx}(\ln(x^2)) = \frac{1}{x^2} \cdot 2x = \frac{2}{x}$$''',
    'type': 'multiple',
  },

  {
    'category': 'Mathematics',
    'difficulty': 'medium',
    'question':
        r'''What is the determinant of $$\begin{pmatrix} 2 & 3 \\ 1 & 4 \end{pmatrix}$$?''',
    'correct_answer': r'''$$5$$''',
    'incorrect_answers': [r'''$$8$$''', r'''$$11$$''', r'''$$-5$$'''],
    'explanation':
        r'''For a 2×2 matrix, $$\det = (2 \times 4) - (3 \times 1) = 8 - 3 = 5$$''',
    'type': 'multiple',
  },

  {
    'category': 'Mathematics',
    'difficulty': 'hard',
    'question':
        r'''Find the eigenvalues of $$\begin{pmatrix} 3 & 1 \\ 0 & 2 \end{pmatrix}$$''',
    'correct_answer': r'''$$\lambda = 3, 2$$''',
    'incorrect_answers': [
      r'''$$\lambda = 5, 0$$''',
      r'''$$\lambda = 3, 3$$''',
      r'''$$\lambda = 2, 1$$'''
    ],
    'explanation':
        r'''For upper triangular matrix, eigenvalues are diagonal elements: 3 and 2''',
    'type': 'multiple',
  },

  {
    'category': 'Mathematics',
    'difficulty': 'hard',
    'question': r'''Solve: $$\frac{dy}{dx} = ky$$ where k is constant''',
    'correct_answer': r'''$$y = Ce^{kx}$$''',
    'incorrect_answers': [
      r'''$$y = Ckx$$''',
      r'''$$y = C + kx$$''',
      r'''$$y = Ce^x$$'''
    ],
    'explanation':
        r'''This is exponential growth/decay: dy/dx = ky has solution y = Ce^(kx)''',
    'type': 'multiple',
  },

  {
    'category': 'Mathematics',
    'difficulty': 'medium',
    'question':
        r'''What is the general solution to $$\frac{d^2y}{dx^2} + y = 0$$?''',
    'correct_answer': r'''$$y = A\cos(x) + B\sin(x)$$''',
    'incorrect_answers': [
      r'''$$y = Ae^x + Be^{-x}$$''',
      r'''$$y = Ax + B$$''',
      r'''$$y = Ae^{ix}$$'''
    ],
    'explanation':
        r'''This is simple harmonic motion: $$y = A\cos(x) + B\sin(x)$$''',
    'type': 'multiple',
  },

  {
    'category': 'Mathematics',
    'difficulty': 'easy',
    'question': r'''What is $$\sin^2(x) + \cos^2(x)$$?''',
    'correct_answer': r'''$$1$$''',
    'incorrect_answers': [r'''$$0$$''', r'''$$2$$''', r'''$$\tan^2(x)$$'''],
    'explanation': r'''Pythagorean identity: sin²(x) + cos²(x) = 1 for all x''',
    'type': 'multiple',
  },

  {
    'category': 'Mathematics',
    'difficulty': 'medium',
    'question': r'''Find: $$\frac{d}{dx}(\sin(x))$$''',
    'correct_answer': r'''$$\cos(x)$$''',
    'incorrect_answers': [
      r'''$$-\cos(x)$$''',
      r'''$$\sin(x)$$''',
      r'''$$\tan(x)$$'''
    ],
    'explanation': r'''The derivative of $$\sin(x)$$ is $$\cos(x)$$''',
    'type': 'multiple',
  },

  {
    'category': 'Mathematics',
    'difficulty': 'medium',
    'question': r'''What is $$i^2$$ where i is the imaginary unit?''',
    'correct_answer': r'''$$-1$$''',
    'incorrect_answers': [r'''$$1$$''', r'''$$i$$''', r'''$$0$$'''],
    'explanation': r'''By definition, i² = -1 where i = √(-1)''',
    'type': 'multiple',
  },

  {
    'category': 'Mathematics',
    'difficulty': 'hard',
    'question': r'''Express in polar form: $$1 + i$$''',
    'correct_answer': r'''$$\sqrt{2} e^{i\pi/4}$$''',
    'incorrect_answers': [
      r'''$$2e^{i\pi/2}$$''',
      r'''$$e^{i\pi/4}$$''',
      r'''$$\sqrt{2}e^{i\pi/2}$$'''
    ],
    'explanation': r'''Magnitude = √2, angle = π/4, so 1+i = √2·e^(iπ/4)''',
    'type': 'multiple',
  },

  {
    'category': 'Mathematics',
    'difficulty': 'medium',
    'question':
        r'''Sum of geometric series: $$\sum_{n=0}^{\infty} \frac{1}{2^n}$$''',
    'correct_answer': r'''$$2$$''',
    'incorrect_answers': [
      r'''$$1$$''',
      r'''$$\infty$$''',
      r'''$$\frac{1}{2}$$'''
    ],
    'explanation':
        r'''Geometric series with a=1, r=1/2: $$\text{sum} = \frac{a}{1-r} = \frac{1}{1-\frac{1}{2}} = 2$$''',
    'type': 'multiple',
  },

  {
    'category': 'Mathematics',
    'difficulty': 'hard',
    'question': r'''Taylor series of $$e^x$$ at x=0:''',
    'correct_answer': r'''$$\sum_{n=0}^{\infty} \frac{x^n}{n!}$$''',
    'incorrect_answers': [
      r'''$$\sum_{n=0}^{\infty} x^n$$''',
      r'''$$\sum_{n=0}^{\infty} \frac{x^{2n}}{(2n)!}$$''',
      r'''$$\sum_{n=0}^{\infty} nx^{n-1}$$'''
    ],
    'explanation':
        r'''$$e^x = 1 + x + \frac{x^2}{2!} + \frac{x^3}{3!} + ... = \sum \frac{x^n}{n!}$$''',
    'type': 'multiple',
  },

  {
    'category': 'Electrical Engineering',
    'difficulty': 'easy',
    'question': r'''Ohm\'s Law states: $$V = ?$$''',
    'correct_answer': r'''$$I \times R$$''',
    'incorrect_answers': [
      r'''$$\frac{I}{R}$$''',
      r'''$$I + R$$''',
      r'''$$\frac{R}{I}$$'''
    ],
    'explanation': r'''Ohm\'s Law: Voltage = Current × Resistance (V = I×R)''',
    'type': 'multiple',
  },

  {
    'category': 'Electrical Engineering',
    'difficulty': 'medium',
    'question': r'''Power in AC circuit: $$P = ?$$ (for resistive load)''',
    'correct_answer': r'''$$V_{rms} \times I_{rms}$$''',
    'incorrect_answers': [
      r'''$$V_{peak} \times I_{peak}$$''',
      r'''$$\frac{V}{I}$$''',
      r'''$$V^2 + I^2$$'''
    ],
    'explanation': r'''For AC resistive load: P = V_rms × I_rms''',
    'type': 'multiple',
  },

  {
    'category': 'Electrical Engineering',
    'difficulty': 'hard',
    'question': r'''Impedance of series RLC circuit: $$Z = ?$$''',
    'correct_answer': r'''$$\sqrt{R^2 + (X_L - X_C)^2}$$''',
    'incorrect_answers': [
      r'''$$R + X_L + X_C$$''',
      r'''$$\sqrt{R^2 + X_L^2 + X_C^2}$$''',
      r'''$$R(X_L - X_C)$$'''
    ],
    'explanation': r'''Series RLC impedance: Z = √(R² + (X_L - X_C)²)''',
    'type': 'multiple',
  },

  {
    'category': 'Electrical Engineering',
    'difficulty': 'medium',
    'question': r'''Capacitive reactance: $$X_C = ?$$''',
    'correct_answer': r'''$$\frac{1}{2\pi fC}$$''',
    'incorrect_answers': [
      r'''$$2\pi fC$$''',
      r'''$$\frac{C}{2\pi f}$$''',
      r'''$$2\pi fL$$'''
    ],
    'explanation': r'''Capacitive reactance: X_C = 1/(2πfC)''',
    'type': 'multiple',
  },

  {
    'category': 'Electrical Engineering',
    'difficulty': 'medium',
    'question': r'''Inductive reactance: $$X_L = ?$$''',
    'correct_answer': r'''$$2\pi fL$$''',
    'incorrect_answers': [
      r'''$$\frac{1}{2\pi fL}$$''',
      r'''$$\frac{L}{2\pi f}$$''',
      r'''$$2\pi fC$$'''
    ],
    'explanation': r'''Inductive reactance: X_L = 2πfL''',
    'type': 'multiple',
  },

  {
    'category': 'Electrical Engineering',
    'difficulty': 'hard',
    'question': r'''Resonant frequency of LC circuit: $$f_0 = ?$$''',
    'correct_answer': r'''$$\frac{1}{2\pi\sqrt{LC}}$$''',
    'incorrect_answers': [
      r'''$$2\pi\sqrt{LC}$$''',
      r'''$$\frac{1}{\sqrt{LC}}$$''',
      r'''$$\sqrt{\frac{L}{C}}$$'''
    ],
    'explanation': r'''Resonant frequency: f₀ = 1/(2π√(LC))''',
    'type': 'multiple',
  },

  {
    'category': 'Electrical Engineering',
    'difficulty': 'easy',
    'question': r'''Energy stored in capacitor: $$E = ?$$''',
    'correct_answer': r'''$$\frac{1}{2}CV^2$$''',
    'incorrect_answers': [
      r'''$$CV$$''',
      r'''$$\frac{1}{2}C^2V$$''',
      r'''$$CV^2$$'''
    ],
    'explanation': r'''Energy in capacitor: $$E = \frac{1}{2}CV^2$$''',
    'type': 'multiple',
  },

  {
    'category': 'Mechanical Engineering',
    'difficulty': 'easy',
    'question': r'''Kinetic energy: $$KE = ?$$''',
    'correct_answer': r'''$$\frac{1}{2}mv^2$$''',
    'incorrect_answers': [
      r'''$$mv$$''',
      r'''$$mv^2$$''',
      r'''$$\frac{1}{2}m^2v$$'''
    ],
    'explanation': r'''Kinetic energy: $$KE = \frac{1}{2}mv^2$$''',
    'type': 'multiple',
  },

  {
    'category': 'Mechanical Engineering',
    'difficulty': 'medium',
    'question': r'''Moment of inertia of solid cylinder: $$I = ?$$''',
    'correct_answer': r'''$$\frac{1}{2}mr^2$$''',
    'incorrect_answers': [
      r'''$$mr^2$$''',
      r'''$$\frac{2}{5}mr^2$$''',
      r'''$$\frac{1}{3}mr^2$$'''
    ],
    'explanation':
        r'''For solid cylinder about central axis: $$I = \frac{1}{2}mr^2$$''',
    'type': 'multiple',
  },

  {
    'category': 'Mechanical Engineering',
    'difficulty': 'hard',
    'question': r'''Euler buckling load: $$P_{cr} = ?$$''',
    'correct_answer': r'''$$\frac{\pi^2 EI}{L^2}$$''',
    'incorrect_answers': [
      r'''$$\frac{EI}{L^2}$$''',
      r'''$$\frac{\pi EI}{L}$$''',
      r'''$$\frac{2\pi^2 EI}{L^2}$$'''
    ],
    'explanation': r'''Critical buckling load: P_cr = π²EI/L²''',
    'type': 'multiple',
  },

  {
    'category': 'Mechanical Engineering',
    'difficulty': 'medium',
    'question': r'''Stress formula: $$\sigma = ?$$''',
    'correct_answer': r'''$$\frac{F}{A}$$''',
    'incorrect_answers': [
      r'''$$F \times A$$''',
      r'''$$\frac{A}{F}$$''',
      r'''$$F + A$$'''
    ],
    'explanation': r'''Stress = Force/Area: σ = F/A''',
    'type': 'multiple',
  },

  {
    'category': 'Mechanical Engineering',
    'difficulty': 'medium',
    'question': r'''Strain formula: $$\epsilon = ?$$''',
    'correct_answer': r'''$$\frac{\Delta L}{L_0}$$''',
    'incorrect_answers': [
      r'''$$\frac{L_0}{\Delta L}$$''',
      r'''$$\Delta L \times L_0$$''',
      r'''$$L_0 - \Delta L$$'''
    ],
    'explanation': r'''Strain = Change in length/Original length: ε = ΔL/L₀''',
    'type': 'multiple',
  },

  {
    'category': 'Mechanical Engineering',
    'difficulty': 'hard',
    'question': r'''Hooke\'s Law: $$\sigma = ?$$''',
    'correct_answer': r'''$$E \times \epsilon$$''',
    'incorrect_answers': [
      r'''$$\frac{E}{\epsilon}$$''',
      r'''$$E + \epsilon$$''',
      r'''$$\frac{\epsilon}{E}$$'''
    ],
    'explanation':
        r'''Hooke\'s Law: Stress = Young\'s modulus × Strain (σ = E×ε)''',
    'type': 'multiple',
  },

  {
    'category': 'Mechanical Engineering',
    'difficulty': 'medium',
    'question': r'''Power transmitted by shaft: $$P = ?$$''',
    'correct_answer': r'''$$T \times \omega$$''',
    'incorrect_answers': [
      r'''$$\frac{T}{\omega}$$''',
      r'''$$T + \omega$$''',
      r'''$$\frac{\omega}{T}$$'''
    ],
    'explanation': r'''Power = Torque × Angular velocity: P = T×ω''',
    'type': 'multiple',
  },

  {
    'category': 'Civil Engineering',
    'difficulty': 'medium',
    'question': r'''Bending stress in beam: $$\sigma = ?$$''',
    'correct_answer': r'''$$\frac{My}{I}$$''',
    'incorrect_answers': [
      r'''$$\frac{M}{I}$$''',
      r'''$$\frac{Iy}{M}$$''',
      r'''$$MyI$$'''
    ],
    'explanation': r'''Bending stress: σ = My/I (flexure formula)''',
    'type': 'multiple',
  },

  {
    'category': 'Civil Engineering',
    'difficulty': 'hard',
    'question': r'''Deflection of cantilever beam: $$\delta = ?$$''',
    'correct_answer': r'''$$\frac{PL^3}{3EI}$$''',
    'incorrect_answers': [
      r'''$$\frac{PL^2}{2EI}$$''',
      r'''$$\frac{PL^3}{EI}$$''',
      r'''$$\frac{3PL^3}{EI}$$'''
    ],
    'explanation': r'''Cantilever deflection at free end: δ = PL³/(3EI)''',
    'type': 'multiple',
  },

  {
    'category': 'Civil Engineering',
    'difficulty': 'medium',
    'question': r'''Shear stress in beam: $$\tau = ?$$''',
    'correct_answer': r'''$$\frac{VQ}{Ib}$$''',
    'incorrect_answers': [
      r'''$$\frac{V}{A}$$''',
      r'''$$\frac{Vb}{IQ}$$''',
      r'''$$\frac{VI}{Qb}$$'''
    ],
    'explanation':
        r'''Shear stress: τ = VQ/(Ib) where V=shear force, Q=first moment''',
    'type': 'multiple',
  },

  {
    'category': 'Civil Engineering',
    'difficulty': 'easy',
    'question': r'''Pressure in fluid: $$P = ?$$ (at depth h)''',
    'correct_answer': r'''$$\rho gh$$''',
    'incorrect_answers': [
      r'''$$\rho h$$''',
      r'''$$gh$$''',
      r'''$$\frac{\rho g}{h}$$'''
    ],
    'explanation':
        r'''Hydrostatic pressure: P = ρgh where ρ=density, g=gravity, h=depth''',
    'type': 'multiple',
  },

  {
    'category': 'Civil Engineering',
    'difficulty': 'medium',
    'question':
        r'''Bernoulli equation: $$P + \frac{1}{2}\rho v^2 + \rho gh = ?$$''',
    'correct_answer': r'''$$constant$$''',
    'incorrect_answers': [r'''$$0$$''', r'''$$P_0$$''', r'''$$\rho$$'''],
    'explanation':
        r'''Bernoulli: P + (1/2)ρv² + ρgh = constant along streamline''',
    'type': 'multiple',
  },

  {
    'category': 'Civil Engineering',
    'difficulty': 'easy',
    'question': r'''Ideal Gas Law: $$PV = ?$$''',
    'correct_answer': r'''$$nRT$$''',
    'incorrect_answers': [
      r'''$$RT$$''',
      r'''$$nT$$''',
      r'''$$\frac{nR}{T}$$'''
    ],
    'explanation': r'''Ideal Gas Law: PV = nRT''',
    'type': 'multiple',
  },

  {
    'category': 'Chemical Engineering',
    'difficulty': 'hard',
    'question': r'''Arrhenius equation: $$k = ?$$''',
    'correct_answer': r'''$$Ae^{-E_a/RT}$$''',
    'incorrect_answers': [
      r'''$$Ae^{E_a/RT}$$''',
      r'''$$A - E_a/RT$$''',
      r'''$$\frac{A}{E_a}RT$$'''
    ],
    'explanation':
        r'''Arrhenius: k = A·e^(-E_a/RT) for reaction rate constant''',
    'type': 'multiple',
  },

  {
    'category': 'Chemical Engineering',
    'difficulty': 'medium',
    'question': r'''Reynolds number: $$Re = ?$$''',
    'correct_answer': r'''$$\frac{\rho vD}{\mu}$$''',
    'incorrect_answers': [
      r'''$$\frac{\mu vD}{\rho}$$''',
      r'''$$\rho vD\mu$$''',
      r'''$$\frac{vD}{\rho\mu}$$'''
    ],
    'explanation': r'''Reynolds number: Re = ρvD/μ (dimensionless)''',
    'type': 'multiple',
  },

  {
    'category': 'Chemical Engineering',
    'difficulty': 'medium',
    'question': r'''Mass balance: $$\frac{dm}{dt} = ?$$''',
    'correct_answer': r'''$$\dot{m}_{in} - \dot{m}_{out}$$''',
    'incorrect_answers': [
      r'''$$\dot{m}_{in} + \dot{m}_{out}$$''',
      r'''$$\dot{m}_{in} \times \dot{m}_{out}$$''',
      r'''$$0$$'''
    ],
    'explanation': r'''Mass accumulation = mass in - mass out''',
    'type': 'multiple',
  },

  {
    'category': 'Chemical Engineering',
    'difficulty': 'hard',
    'question': r'''Fick\'s first law: $$J = ?$$''',
    'correct_answer': r'''$$-D\frac{dC}{dx}$$''',
    'incorrect_answers': [
      r'''$$D\frac{dC}{dx}$$''',
      r'''$$-\frac{D}{dC/dx}$$''',
      r'''$$DdC$$'''
    ],
    'explanation': r'''Fick\'s law for diffusion: J = -D(dC/dx)''',
    'type': 'multiple',
  },

  {
    'category': 'Chemical Engineering',
    'difficulty': 'easy',
    'question': r'''Time complexity of binary search: $$O(?)$$''',
    'correct_answer': r'''$$\log n$$''',
    'incorrect_answers': [r'''$$n$$''', r'''$$n^2$$''', r'''$$1$$'''],
    'explanation': r'''Binary search has O(log n) time complexity''',
    'type': 'multiple',
  },

  {
    'category': 'Computer Engineering',
    'difficulty': 'medium',
    'question': r'''Shannon entropy: $$H = ?$$''',
    'correct_answer': r'''$$-\sum p_i \log_2(p_i)$$''',
    'incorrect_answers': [
      r'''$$\sum p_i \log_2(p_i)$$''',
      r'''$$-\sum p_i$$''',
      r'''$$\log_2(\sum p_i)$$'''
    ],
    'explanation': r'''Shannon entropy: H = -Σ p_i·log₂(p_i)''',
    'type': 'multiple',
  },

  {
    'category': 'Computer Engineering',
    'difficulty': 'easy',
    'question': r'''How many bits in 1 byte?''',
    'correct_answer': r'''$$8$$''',
    'incorrect_answers': [r'''$$4$$''', r'''$$16$$''', r'''$$32$$'''],
    'explanation': r'''1 byte = 8 bits''',
    'type': 'multiple',
  },

  {
    'category': 'Computer Engineering',
    'difficulty': 'medium',
    'question': r'''Big-O of quicksort (average): $$O(?)$$''',
    'correct_answer': r'''$$n \log n$$''',
    'incorrect_answers': [r'''$$n^2$$''', r'''$$n$$''', r'''$$\log n$$'''],
    'explanation': r'''Quicksort average case: O(n log n)''',
    'type': 'multiple',
  },

  {
    'category': 'Computer Engineering',
    'difficulty': 'hard',
    'question': r'''Nyquist sampling theorem: $$f_s \ge ?$$''',
    'correct_answer': r'''$$2f_{max}$$''',
    'incorrect_answers': [
      r'''$$f_{max}$$''',
      r'''$$\frac{f_{max}}{2}$$''',
      r'''$$4f_{max}$$'''
    ],
    'explanation':
        r'''Sampling frequency must be ≥ 2×max frequency (Nyquist rate)''',
    'type': 'multiple',
  },

  {
    'category': 'Aerospace Engineering',
    'difficulty': 'medium',
    'question': r'''Lift force: $$L = ?$$''',
    'correct_answer': r'''$$\frac{1}{2}\rho v^2 S C_L$$''',
    'incorrect_answers': [
      r'''$$\rho v^2 S$$''',
      r'''$$\frac{1}{2}\rho v S C_L$$''',
      r'''$$\rho v S C_L$$'''
    ],
    'explanation': r'''Lift: L = (1/2)ρv²SC_L where C_L is lift coefficient''',
    'type': 'multiple',
  },

  {
    'category': 'Aerospace Engineering',
    'difficulty': 'hard',
    'question': r'''Rocket equation: $$\Delta v = ?$$''',
    'correct_answer': r'''$$v_e \ln\frac{m_0}{m_f}$$''',
    'incorrect_answers': [
      r'''$$v_e \frac{m_0}{m_f}$$''',
      r'''$$v_e (m_0 - m_f)$$''',
      r'''$$\frac{v_e m_0}{m_f}$$'''
    ],
    'explanation': r'''Tsiolkovsky equation: Δv = v_e·ln(m₀/m_f)''',
    'type': 'multiple',
  },

  {
    'category': 'Aerospace Engineering',
    'difficulty': 'medium',
    'question': r'''Mach number: $$M = ?$$''',
    'correct_answer': r'''$$\frac{v}{a}$$''',
    'incorrect_answers': [
      r'''$$\frac{a}{v}$$''',
      r'''$$v \times a$$''',
      r'''$$v - a$$'''
    ],
    'explanation': r'''Mach number = velocity/speed of sound: M = v/a''',
    'type': 'multiple',
  },

  {
    'category': 'Aerospace Engineering',
    'difficulty': 'medium',
    'question': r'''Poiseuille\'s law for blood flow: $$Q = ?$$''',
    'correct_answer': r'''$$\frac{\pi r^4 \Delta P}{8\mu L}$$''',
    'incorrect_answers': [
      r'''$$\frac{\pi r^2 \Delta P}{8\mu L}$$''',
      r'''$$\frac{r^4 \Delta P}{\mu L}$$''',
      r'''$$\pi r^4 \Delta P$$'''
    ],
    'explanation': r'''Poiseuille: Q = πr⁴ΔP/(8μL) for laminar flow''',
    'type': 'multiple',
  },

  {
    'category': 'Biomedical Engineering',
    'difficulty': 'easy',
    'question': r'''Ohm\'s law for current in tissue: $$I = ?$$''',
    'correct_answer': r'''$$\frac{V}{R}$$''',
    'incorrect_answers': [
      r'''$$VR$$''',
      r'''$$\frac{R}{V}$$''',
      r'''$$V + R$$'''
    ],
    'explanation': r'''Current = Voltage/Resistance: I = V/R''',
    'type': 'multiple',
  },

  {
    'category': 'Biomedical Engineering',
    'difficulty': 'hard',
    'question':
        r'''Nernst equation: $$E = E_0 + \frac{RT}{nF}\ln\frac{[ox]}{[red]}$$ at 25°C simplifies to:''',
    'correct_answer': r'''$$E_0 + \frac{0.059}{n}\log\frac{[ox]}{[red]}$$''',
    'incorrect_answers': [
      r'''$$E_0 + 0.059\log\frac{[ox]}{[red]}$$''',
      r'''$$E_0 - \frac{0.059}{n}\log\frac{[ox]}{[red]}$$''',
      r'''$$\frac{0.059}{n}E_0$$'''
    ],
    'explanation': r'''Nernst at 25°C: E = E₀ + (0.059/n)·log([ox]/[red])''',
    'type': 'multiple',
  },

  {
    'category': 'Electrical Engineering',
    'difficulty': 'medium',
    'question': r'''Transformer turns ratio: $$\frac{V_p}{V_s} = ?$$''',
    'correct_answer': r'''$$\frac{N_p}{N_s}$$''',
    'incorrect_answers': [
      r'''$$\frac{N_s}{N_p}$$''',
      r'''$$N_p \times N_s$$''',
      r'''$$N_p + N_s$$'''
    ],
    'explanation': r'''Voltage ratio equals turns ratio: V_p/V_s = N_p/N_s''',
    'type': 'multiple',
  },
  {
    'category': 'Electrical Engineering',
    'difficulty': 'hard',
    'question': r'''Three-phase power: $$P = ?$$ (balanced load)''',
    'correct_answer': r'''$$\sqrt{3} V_L I_L \cos(\phi)$$''',
    'incorrect_answers': [
      r'''$$3 V_L I_L$$''',
      r'''$$V_L I_L \cos(\phi)$$''',
      r'''$$\sqrt{3} V_L I_L$$'''
    ],
    'explanation': r'''Three-phase power: P = √3·V_L·I_L·cos(φ)''',
    'type': 'multiple',
  },
  {
    'category': 'Electrical Engineering',
    'difficulty': 'medium',
    'question': r'''Thevenin equivalent resistance is found by:''',
    'correct_answer':
        r'''Short-circuiting voltage sources and open-circuiting current sources''',
    'incorrect_answers': [
      r'''Open-circuiting all sources''',
      r'''Short-circuiting all sources''',
      r'''Removing the load only'''
    ],
    'explanation':
        r'''Thevenin resistance: deactivate sources (V→short, I→open)''',
    'type': 'multiple',
  },
  {
    'category': 'Electrical Engineering',
    'difficulty': 'easy',
    'question': r'''Kirchhoff\'s Current Law (KCL) states:''',
    'correct_answer': r'''$$\sum I_{in} = \sum I_{out}$$''',
    'incorrect_answers': [
      r'''$$\sum V = 0$$''',
      r'''$$I = V/R$$''',
      r'''$$P = VI$$'''
    ],
    'explanation': r'''KCL: Sum of currents entering = sum leaving a node''',
    'type': 'multiple',
  },
  {
    'category': 'Electrical Engineering',
    'difficulty': 'easy',
    'question': r'''Kirchhoff\'s Voltage Law (KVL) states:''',
    'correct_answer': r'''$$\sum V = 0$$ around a closed loop''',
    'incorrect_answers': [
      r'''$$\sum I = 0$$''',
      r'''$$V = IR$$''',
      r'''$$\sum P = 0$$'''
    ],
    'explanation': r'''KVL: Sum of voltages around any closed loop is zero''',
    'type': 'multiple',
  },
  {
    'category': 'Electrical Engineering',
    'difficulty': 'hard',
    'question': r'''Quality factor of RLC circuit: $$Q = ?$$''',
    'correct_answer': r'''$$\frac{\omega_0 L}{R}$$''',
    'incorrect_answers': [
      r'''$$\frac{R}{\omega_0 L}$$''',
      r'''$$\omega_0 LC$$''',
      r'''$$\frac{1}{\omega_0 RC}$$'''
    ],
    'explanation': r'''Quality factor: Q = ω₀L/R = 1/(ω₀RC)''',
    'type': 'multiple',
  },
  {
    'category': 'Electrical Engineering',
    'difficulty': 'medium',
    'question': r'''Bandwidth of RLC circuit: $$BW = ?$$''',
    'correct_answer': r'''$$\frac{\omega_0}{Q}$$''',
    'incorrect_answers': [
      r'''$$\omega_0 Q$$''',
      r'''$$\frac{Q}{\omega_0}$$''',
      r'''$$\omega_0 + Q$$'''
    ],
    'explanation': r'''Bandwidth: BW = ω₀/Q where Q is quality factor''',
    'type': 'multiple',
  },
  {
    'category': 'Electrical Engineering',
    'difficulty': 'medium',
    'question': r'''Norton equivalent current is:''',
    'correct_answer': r'''Short-circuit current at terminals''',
    'incorrect_answers': [
      r'''Open-circuit voltage''',
      r'''Load current''',
      r'''Source current'''
    ],
    'explanation': r'''Norton current = short-circuit current (I_sc)''',
    'type': 'multiple',
  },
  {
    'category': 'Electrical Engineering',
    'difficulty': 'hard',
    'question': r'''Skin effect causes:''',
    'correct_answer':
        r'''Current to concentrate near conductor surface at high frequency''',
    'incorrect_answers': [
      r'''Uniform current distribution''',
      r'''Current to flow in center''',
      r'''Voltage drop'''
    ],
    'explanation':
        r'''Skin effect: AC current concentrates at surface, increases with frequency''',
    'type': 'multiple',
  },
  {
    'category': 'Electrical Engineering',
    'difficulty': 'medium',
    'question': r'''Superposition theorem applies to:''',
    'correct_answer': r'''Linear circuits only''',
    'incorrect_answers': [
      r'''All circuits''',
      r'''Nonlinear circuits''',
      r'''AC circuits only'''
    ],
    'explanation': r'''Superposition works only for linear circuits''',
    'type': 'multiple',
  },
  {
    'category': 'Mechanical Engineering',
    'difficulty': 'medium',
    'question': r'''Angular momentum: $$L = ?$$''',
    'correct_answer': r'''$$I \omega$$''',
    'incorrect_answers': [
      r'''$$m v$$''',
      r'''$$I \alpha$$''',
      r'''$$\frac{1}{2}I\omega^2$$'''
    ],
    'explanation':
        r'''Angular momentum: L = I·ω (moment of inertia × angular velocity)''',
    'type': 'multiple',
  },
  {
    'category': 'Mechanical Engineering',
    'difficulty': 'hard',
    'question': r'''Parallel axis theorem: $$I = ?$$''',
    'correct_answer': r'''$$I_{cm} + md^2$$''',
    'incorrect_answers': [
      r'''$$I_{cm} - md^2$$''',
      r'''$$I_{cm} \times md^2$$''',
      r'''$$I_{cm}/md^2$$'''
    ],
    'explanation':
        r'''Parallel axis: I = I_cm + md² where d is distance from CM''',
    'type': 'multiple',
  },
  {
    'category': 'Mechanical Engineering',
    'difficulty': 'medium',
    'question': r'''Coefficient of restitution: $$e = ?$$''',
    'correct_answer': r'''$$\frac{v_{separation}}{v_{approach}}$$''',
    'incorrect_answers': [
      r'''$$\frac{v_{approach}}{v_{separation}}$$''',
      r'''$$v_1 - v_2$$''',
      r'''$$\frac{m_1}{m_2}$$'''
    ],
    'explanation':
        r'''e = relative velocity of separation / approach (0=inelastic, 1=elastic)''',
    'type': 'multiple',
  },
  {
    'category': 'Mechanical Engineering',
    'difficulty': 'easy',
    'question': r'''Potential energy: $$PE = ?$$''',
    'correct_answer': r'''$$mgh$$''',
    'incorrect_answers': [
      r'''$$\frac{1}{2}mv^2$$''',
      r'''$$Fd$$''',
      r'''$$\frac{1}{2}kx^2$$'''
    ],
    'explanation': r'''Gravitational potential energy: PE = mgh''',
    'type': 'multiple',
  },
  {
    'category': 'Mechanical Engineering',
    'difficulty': 'medium',
    'question': r'''Spring potential energy: $$U = ?$$''',
    'correct_answer': r'''$$\frac{1}{2}kx^2$$''',
    'incorrect_answers': [
      r'''$$kx$$''',
      r'''$$\frac{1}{2}mv^2$$''',
      r'''$$mgh$$'''
    ],
    'explanation': r'''Elastic potential energy: U = (1/2)kx²''',
    'type': 'multiple',
  },
  {
    'category': 'Mechanical Engineering',
    'difficulty': 'hard',
    'question': r'''Poisson\'s ratio: $$\nu = ?$$''',
    'correct_answer': r'''$$-\frac{\epsilon_{lateral}}{\epsilon_{axial}}$$''',
    'incorrect_answers': [
      r'''$$\frac{\epsilon_{axial}}{\epsilon_{lateral}}$$''',
      r'''$$\frac{\sigma}{\epsilon}$$''',
      r'''$$\frac{E}{G}$$'''
    ],
    'explanation': r'''Poisson\'s ratio: ν = -ε_lateral/ε_axial''',
    'type': 'multiple',
  },
  {
    'category': 'Mechanical Engineering',
    'difficulty': 'medium',
    'question': r'''Shear modulus: $$G = ?$$ (in terms of E and ν)''',
    'correct_answer': r'''$$\frac{E}{2(1+\nu)}$$''',
    'incorrect_answers': [
      r'''$$\frac{E}{1-\nu}$$''',
      r'''$$E(1+\nu)$$''',
      r'''$$\frac{E}{\nu}$$'''
    ],
    'explanation': r'''Shear modulus: G = E/[2(1+ν)]''',
    'type': 'multiple',
  },
  {
    'category': 'Mechanical Engineering',
    'difficulty': 'hard',
    'question': r'''Bulk modulus: $$K = ?$$''',
    'correct_answer': r'''$$\frac{E}{3(1-2\nu)}$$''',
    'incorrect_answers': [
      r'''$$\frac{E}{2(1+\nu)}$$''',
      r'''$$E\nu$$''',
      r'''$$\frac{E}{1-\nu^2}$$'''
    ],
    'explanation': r'''Bulk modulus: K = E/[3(1-2ν)]''',
    'type': 'multiple',
  },
  {
    'category': 'Mechanical Engineering',
    'difficulty': 'medium',
    'question': r'''Centripetal acceleration: $$a_c = ?$$''',
    'correct_answer': r'''$$\frac{v^2}{r}$$''',
    'incorrect_answers': [
      r'''$$vr$$''',
      r'''$$\frac{r}{v^2}$$''',
      r'''$$v^2r$$'''
    ],
    'explanation': r'''Centripetal acceleration: a_c = v²/r = ω²r''',
    'type': 'multiple',
  },
  {
    'category': 'Mechanical Engineering',
    'difficulty': 'easy',
    'question': r'''Work done: $$W = ?$$''',
    'correct_answer': r'''$$F \cdot d \cos(\theta)$$''',
    'incorrect_answers': [
      r'''$$F \cdot d \sin(\theta)$$''',
      r'''$$F/d$$''',
      r'''$$F + d$$'''
    ],
    'explanation': r'''Work: W = F·d·cos(θ) where θ is angle between F and d''',
    'type': 'multiple',
  },
  {
    'category': 'Civil Engineering',
    'difficulty': 'medium',
    'question':
        r'''Simply supported beam max deflection: $$\delta_{max} = ?$$''',
    'correct_answer': r'''$$\frac{5wL^4}{384EI}$$''',
    'incorrect_answers': [
      r'''$$\frac{wL^4}{8EI}$$''',
      r'''$$\frac{wL^3}{48EI}$$''',
      r'''$$\frac{wL^4}{384EI}$$'''
    ],
    'explanation': r'''Max deflection at center: δ = 5wL⁴/(384EI) for UDL''',
    'type': 'multiple',
  },
  {
    'category': 'Civil Engineering',
    'difficulty': 'hard',
    'question': r'''Section modulus: $$S = ?$$''',
    'correct_answer': r'''$$\frac{I}{c}$$''',
    'incorrect_answers': [
      r'''$$Ic$$''',
      r'''$$\frac{c}{I}$$''',
      r'''$$I + c$$'''
    ],
    'explanation':
        r'''Section modulus: S = I/c where c is distance to extreme fiber''',
    'type': 'multiple',
  },
  {
    'category': 'Civil Engineering',
    'difficulty': 'medium',
    'question': r'''Radius of gyration: $$r = ?$$''',
    'correct_answer': r'''$$\sqrt{\frac{I}{A}}$$''',
    'incorrect_answers': [
      r'''$$\frac{I}{A}$$''',
      r'''$$\sqrt{IA}$$''',
      r'''$$\frac{A}{I}$$'''
    ],
    'explanation': r'''Radius of gyration: r = √(I/A)''',
    'type': 'multiple',
  },
  {
    'category': 'Civil Engineering',
    'difficulty': 'easy',
    'question': r'''Continuity equation: $$A_1 v_1 = ?$$''',
    'correct_answer': r'''$$A_2 v_2$$''',
    'incorrect_answers': [
      r'''$$\frac{A_2}{v_2}$$''',
      r'''$$A_2 + v_2$$''',
      r'''$$constant$$'''
    ],
    'explanation': r'''Continuity: A₁v₁ = A₂v₂ (conservation of mass)''',
    'type': 'multiple',
  },
  {
    'category': 'Civil Engineering',
    'difficulty': 'medium',
    'question': r'''Manning\'s equation for flow: $$v = ?$$''',
    'correct_answer': r'''$$\frac{1}{n}R^{2/3}S^{1/2}$$''',
    'incorrect_answers': [
      r'''$$nRS$$''',
      r'''$$\frac{R}{nS}$$''',
      r'''$$\frac{n}{RS}$$'''
    ],
    'explanation': r'''Manning: v = (1/n)R^(2/3)S^(1/2) where n=roughness''',
    'type': 'multiple',
  },
  {
    'category': 'Civil Engineering',
    'difficulty': 'hard',
    'question': r'''Slenderness ratio: $$\lambda = ?$$''',
    'correct_answer': r'''$$\frac{L_e}{r}$$''',
    'incorrect_answers': [
      r'''$$\frac{r}{L_e}$$''',
      r'''$$L_e \times r$$''',
      r'''$$\frac{L_e}{I}$$'''
    ],
    'explanation':
        r'''Slenderness ratio: λ = L_e/r (effective length/radius of gyration)''',
    'type': 'multiple',
  },
  {
    'category': 'Civil Engineering',
    'difficulty': 'medium',
    'question': r'''Darcy-Weisbach equation: $$h_f = ?$$''',
    'correct_answer': r'''$$f\frac{L}{D}\frac{v^2}{2g}$$''',
    'incorrect_answers': [
      r'''$$\frac{fLv}{Dg}$$''',
      r'''$$\frac{fDv^2}{Lg}$$''',
      r'''$$fLDv$$'''
    ],
    'explanation':
        r'''Head loss: h_f = f(L/D)(v²/2g) where f=friction factor''',
    'type': 'multiple',
  },
  {
    'category': 'Civil Engineering',
    'difficulty': 'easy',
    'question': r'''Archimedes principle: Buoyant force = ?''',
    'correct_answer': r'''Weight of displaced fluid''',
    'incorrect_answers': [
      r'''Weight of object''',
      r'''Volume of object''',
      r'''Density of object'''
    ],
    'explanation': r'''Buoyancy = weight of fluid displaced by object''',
    'type': 'multiple',
  },
  {
    'category': 'Civil Engineering',
    'difficulty': 'medium',
    'question': r'''Froude number: $$Fr = ?$$''',
    'correct_answer': r'''$$\frac{v}{\sqrt{gL}}$$''',
    'incorrect_answers': [
      r'''$$\frac{\sqrt{gL}}{v}$$''',
      r'''$$vgL$$''',
      r'''$$\frac{v}{gL}$$'''
    ],
    'explanation':
        r'''Froude number: Fr = v/√(gL) (inertial/gravitational forces)''',
    'type': 'multiple',
  },
  {
    'category': 'Civil Engineering',
    'difficulty': 'hard',
    'question': r'''Plastic section modulus: $$Z = ?$$ (rectangular)''',
    'correct_answer': r'''$$\frac{bh^2}{4}$$''',
    'incorrect_answers': [
      r'''$$\frac{bh^2}{6}$$''',
      r'''$$\frac{bh^3}{12}$$''',
      r'''$$bh^2$$'''
    ],
    'explanation': r'''Plastic modulus (rectangle): Z = bh²/4''',
    'type': 'multiple',
  },
  {
    'category': 'Civil Engineering',
    'difficulty': 'medium',
    'question': r'''Hazen-Williams equation coefficient C for:''',
    'correct_answer': r'''Smooth pipes: C ≈ 140''',
    'incorrect_answers': [r'''C ≈ 50''', r'''C ≈ 200''', r'''C ≈ 10'''],
    'explanation': r'''Hazen-Williams C: smooth pipes ~140, rough ~100''',
    'type': 'multiple',
  },
  {
    'category': 'Civil Engineering',
    'difficulty': 'easy',
    'question': r'''Specific gravity: $$SG = ?$$''',
    'correct_answer': r'''$$\frac{\rho_{substance}}{\rho_{water}}$$''',
    'incorrect_answers': [
      r'''$$\rho_{substance}$$''',
      r'''$$\frac{\rho_{water}}{\rho_{substance}}$$''',
      r'''$$\rho_{substance} + \rho_{water}$$'''
    ],
    'explanation':
        r'''Specific gravity = density of substance / density of water''',
    'type': 'multiple',
  },
  {
    'category': 'Civil Engineering',
    'difficulty': 'hard',
    'question': r'''Torsional shear stress: $$\tau = ?$$''',
    'correct_answer': r'''$$\frac{Tr}{J}$$''',
    'incorrect_answers': [
      r'''$$\frac{T}{Jr}$$''',
      r'''$$TrJ$$''',
      r'''$$\frac{J}{Tr}$$'''
    ],
    'explanation':
        r'''Torsion: τ = Tr/J where T=torque, r=radius, J=polar moment''',
    'type': 'multiple',
  },
  {
    'category': 'Civil Engineering',
    'difficulty': 'medium',
    'question': r'''Polar moment of inertia (solid circle): $$J = ?$$''',
    'correct_answer': r'''$$\frac{\pi r^4}{2}$$''',
    'incorrect_answers': [
      r'''$$\frac{\pi r^4}{4}$$''',
      r'''$$\pi r^4$$''',
      r'''$$\frac{\pi r^2}{2}$$'''
    ],
    'explanation': r'''Polar moment (solid circle): J = πr⁴/2''',
    'type': 'multiple',
  },
  {
    'category': 'Civil Engineering',
    'difficulty': 'medium',
    'question': r'''Discharge through orifice: $$Q = ?$$''',
    'correct_answer': r'''$$C_d A \sqrt{2gh}$$''',
    'incorrect_answers': [
      r'''$$A\sqrt{gh}$$''',
      r'''$$C_d Agh$$''',
      r'''$$\frac{C_d A}{h}$$'''
    ],
    'explanation':
        r'''Orifice discharge: Q = C_d·A·√(2gh) where C_d=discharge coeff''',
    'type': 'multiple',
  },
  {
    'category': 'Chemical Engineering',
    'difficulty': 'medium',
    'question': r'''Raoult\'s Law: $$P_i = ?$$''',
    'correct_answer': r'''$$x_i P_i^*$$''',
    'incorrect_answers': [
      r'''$$\frac{P_i^*}{x_i}$$''',
      r'''$$x_i + P_i^*$$''',
      r'''$$\frac{x_i}{P_i^*}$$'''
    ],
    'explanation':
        r'''Raoult: Partial pressure P_i = mole fraction × vapor pressure''',
    'type': 'multiple',
  },
  {
    'category': 'Chemical Engineering',
    'difficulty': 'hard',
    'question': r'''Antoine equation: $$\log P = ?$$''',
    'correct_answer': r'''$$A - \frac{B}{C+T}$$''',
    'incorrect_answers': [
      r'''$$A + BT$$''',
      r'''$$\frac{A}{B+T}$$''',
      r'''$$A - BT$$'''
    ],
    'explanation': r'''Antoine: log(P) = A - B/(C+T) for vapor pressure''',
    'type': 'multiple',
  },
  {
    'category': 'Chemical Engineering',
    'difficulty': 'medium',
    'question': r'''Hagen-Poiseuille for laminar flow: $$\Delta P = ?$$''',
    'correct_answer': r'''$$\frac{8\mu LQ}{\pi r^4}$$''',
    'incorrect_answers': [
      r'''$$\frac{\mu LQ}{r^2}$$''',
      r'''$$\frac{8\mu Q}{\pi r^4}$$''',
      r'''$$\mu LQr$$'''
    ],
    'explanation': r'''Pressure drop: ΔP = 8μLQ/(πr⁴) for laminar pipe flow''',
    'type': 'multiple',
  },
  {
    'category': 'Chemical Engineering',
    'difficulty': 'easy',
    'question': r'''Dalton\'s Law: $$P_{total} = ?$$''',
    'correct_answer': r'''$$\sum P_i$$''',
    'incorrect_answers': [
      r'''$$\prod P_i$$''',
      r'''$$\frac{1}{\sum P_i}$$''',
      r'''$$P_1 - P_2$$'''
    ],
    'explanation': r'''Dalton: Total pressure = sum of partial pressures''',
    'type': 'multiple',
  },
  {
    'category': 'Chemical Engineering',
    'difficulty': 'hard',
    'question': r'''Sherwood number: $$Sh = ?$$''',
    'correct_answer': r'''$$\frac{k_c L}{D}$$''',
    'incorrect_answers': [
      r'''$$\frac{D}{k_c L}$$''',
      r'''$$k_c LD$$''',
      r'''$$\frac{L}{k_c D}$$'''
    ],
    'explanation': r'''Sherwood: Sh = k_c·L/D (mass transfer coefficient)''',
    'type': 'multiple',
  },
  {
    'category': 'Chemical Engineering',
    'difficulty': 'medium',
    'question': r'''Schmidt number: $$Sc = ?$$''',
    'correct_answer': r'''$$\frac{\mu}{\rho D}$$''',
    'incorrect_answers': [
      r'''$$\frac{\rho D}{\mu}$$''',
      r'''$$\mu \rho D$$''',
      r'''$$\frac{D}{\mu \rho}$$'''
    ],
    'explanation':
        r'''Schmidt: Sc = μ/(ρD) = ν/D (momentum/mass diffusivity)''',
    'type': 'multiple',
  },
  {
    'category': 'Chemical Engineering',
    'difficulty': 'hard',
    'question': r'''Prandtl number: $$Pr = ?$$''',
    'correct_answer': r'''$$\frac{\mu c_p}{k}$$''',
    'incorrect_answers': [
      r'''$$\frac{k}{\mu c_p}$$''',
      r'''$$\mu c_p k$$''',
      r'''$$\frac{c_p}{k}$$'''
    ],
    'explanation': r'''Prandtl: Pr = μc_p/k (momentum/thermal diffusivity)''',
    'type': 'multiple',
  },
  {
    'category': 'Chemical Engineering',
    'difficulty': 'medium',
    'question': r'''Nusselt number: $$Nu = ?$$''',
    'correct_answer': r'''$$\frac{hL}{k}$$''',
    'incorrect_answers': [
      r'''$$\frac{k}{hL}$$''',
      r'''$$hLk$$''',
      r'''$$\frac{L}{hk}$$'''
    ],
    'explanation':
        r'''Nusselt: Nu = hL/k (convective/conductive heat transfer)''',
    'type': 'multiple',
  },
  {
    'category': 'Chemical Engineering',
    'difficulty': 'easy',
    'question': r'''Henry\'s Law: $$P_i = ?$$''',
    'correct_answer': r'''$$H x_i$$''',
    'incorrect_answers': [
      r'''$$\frac{H}{x_i}$$''',
      r'''$$H + x_i$$''',
      r'''$$\frac{x_i}{H}$$'''
    ],
    'explanation':
        r'''Henry: Partial pressure = Henry constant × mole fraction''',
    'type': 'multiple',
  },
  {
    'category': 'Chemical Engineering',
    'difficulty': 'hard',
    'question': r'''Ergun equation for packed bed: $$\Delta P/L = ?$$''',
    'correct_answer':
        r'''$$150\frac{(1-\epsilon)^2}{\epsilon^3}\frac{\mu v}{d_p^2} + 1.75\frac{1-\epsilon}{\epsilon^3}\frac{\rho v^2}{d_p}$$''',
    'incorrect_answers': [
      r'''$$\frac{\mu v}{d_p}$$''',
      r'''$$\frac{\rho v^2}{d_p}$$''',
      r'''$$\mu v d_p$$'''
    ],
    'explanation':
        r'''Ergun: combines viscous and kinetic energy losses in packed beds''',
    'type': 'multiple',
  },
  {
    'category': 'Chemical Engineering',
    'difficulty': 'medium',
    'question': r'''Grashof number: $$Gr = ?$$''',
    'correct_answer': r'''$$\frac{g\beta \Delta T L^3}{\nu^2}$$''',
    'incorrect_answers': [
      r'''$$\frac{\nu^2}{g\beta \Delta T L^3}$$''',
      r'''$$g\beta \Delta T L$$''',
      r'''$$\frac{L^3}{\nu^2}$$'''
    ],
    'explanation': r'''Grashof: Gr = gβΔTL³/ν² (buoyancy/viscous forces)''',
    'type': 'multiple',
  },
  {
    'category': 'Chemical Engineering',
    'difficulty': 'medium',
    'question': r'''Peclet number: $$Pe = ?$$''',
    'correct_answer': r'''$$Re \times Pr$$''',
    'incorrect_answers': [
      r'''$$Re + Pr$$''',
      r'''$$Re/Pr$$''',
      r'''$$Re - Pr$$'''
    ],
    'explanation': r'''Peclet: Pe = Re×Pr (advection/diffusion)''',
    'type': 'multiple',
  },
  {
    'category': 'Chemical Engineering',
    'difficulty': 'easy',
    'question': r'''Conversion in reactor: $$X = ?$$''',
    'correct_answer': r'''$$\frac{N_{A0} - N_A}{N_{A0}}$$''',
    'incorrect_answers': [
      r'''$$\frac{N_A}{N_{A0}}$$''',
      r'''$$N_{A0} - N_A$$''',
      r'''$$\frac{N_{A0}}{N_A}$$'''
    ],
    'explanation': r'''Conversion: X = (moles reacted)/(initial moles)''',
    'type': 'multiple',
  },
  {
    'category': 'Chemical Engineering',
    'difficulty': 'hard',
    'question': r'''CSTR design equation: $$V = ?$$''',
    'correct_answer': r'''$$\frac{F_{A0} X}{-r_A}$$''',
    'incorrect_answers': [
      r'''$$F_{A0} X r_A$$''',
      r'''$$\frac{-r_A}{F_{A0} X}$$''',
      r'''$$F_{A0}/X$$'''
    ],
    'explanation':
        r'''CSTR volume: V = F_A0·X/(-r_A) where r_A=reaction rate''',
    'type': 'multiple',
  },
  {
    'category': 'Chemical Engineering',
    'difficulty': 'medium',
    'question': r'''Space time: $$\tau = ?$$''',
    'correct_answer': r'''$$\frac{V}{v_0}$$''',
    'incorrect_answers': [
      r'''$$\frac{v_0}{V}$$''',
      r'''$$Vv_0$$''',
      r'''$$V + v_0$$'''
    ],
    'explanation':
        r'''Space time: τ = V/v₀ (reactor volume/volumetric flow rate)''',
    'type': 'multiple',
  },
  {
    'category': 'Computer Engineering',
    'difficulty': 'medium',
    'question': r'''Time complexity of merge sort: $$O(?)$$''',
    'correct_answer': r'''$$n \log n$$''',
    'incorrect_answers': [r'''$$n^2$$''', r'''$$n$$''', r'''$$\log n$$'''],
    'explanation': r'''Merge sort: O(n log n) in all cases''',
    'type': 'multiple',
  },
  {
    'category': 'Computer Engineering',
    'difficulty': 'hard',
    'question': r'''Master theorem for $$T(n) = aT(n/b) + f(n)$$:''',
    'correct_answer': r'''Compare $$f(n)$$ with $$n^{\log_b a}$$''',
    'incorrect_answers': [
      r'''Always $$O(n \log n)$$''',
      r'''Always $$O(n^2)$$''',
      r'''Sum all terms'''
    ],
    'explanation':
        r'''Master theorem compares f(n) with n^(log_b a) to determine complexity''',
    'type': 'multiple',
  },
  {
    'category': 'Computer Engineering',
    'difficulty': 'easy',
    'question': r'''Boolean algebra: $$A + \overline{A} = ?$$''',
    'correct_answer': r'''$$1$$''',
    'incorrect_answers': [r'''$$0$$''', r'''$$A$$''', r'''$$\overline{A}$$'''],
    'explanation': r'''Complement law: A + Ā = 1''',
    'type': 'multiple',
  },
  {
    'category': 'Computer Engineering',
    'difficulty': 'easy',
    'question': r'''De Morgan\'s Law: $$\overline{A \cdot B} = ?$$''',
    'correct_answer': r'''$$\overline{A} + \overline{B}$$''',
    'incorrect_answers': [
      r'''$$\overline{A} \cdot \overline{B}$$''',
      r'''$$A + B$$''',
      r'''$$A \cdot B$$'''
    ],
    'explanation': r'''De Morgan: NOT(A AND B) = (NOT A) OR (NOT B)''',
    'type': 'multiple',
  },
  {
    'category': 'Computer Engineering',
    'difficulty': 'medium',
    'question': r'''Cache hit rate formula: $$H = ?$$''',
    'correct_answer': r'''$$\frac{hits}{hits + misses}$$''',
    'incorrect_answers': [
      r'''$$\frac{misses}{hits}$$''',
      r'''$$hits - misses$$''',
      r'''$$\frac{hits}{misses}$$'''
    ],
    'explanation': r'''Hit rate = hits / total accesses''',
    'type': 'multiple',
  },
  {
    'category': 'Computer Engineering',
    'difficulty': 'hard',
    'question': r'''Amdahl\'s Law speedup: $$S = ?$$''',
    'correct_answer': r'''$$\frac{1}{(1-P) + P/N}$$''',
    'incorrect_answers': [
      r'''$$N$$''',
      r'''$$\frac{N}{P}$$''',
      r'''$$1 + P \times N$$'''
    ],
    'explanation':
        r'''Amdahl: S = 1/[(1-P) + P/N] where P=parallel fraction, N=processors''',
    'type': 'multiple',
  },
  {
    'category': 'Computer Engineering',
    'difficulty': 'medium',
    'question': r'''CPI (Cycles Per Instruction): $$CPI = ?$$''',
    'correct_answer': r'''$$\frac{cycles}{instructions}$$''',
    'incorrect_answers': [
      r'''$$\frac{instructions}{cycles}$$''',
      r'''$$cycles \times instructions$$''',
      r'''$$\frac{time}{cycles}$$'''
    ],
    'explanation': r'''CPI = total cycles / instruction count''',
    'type': 'multiple',
  },
  {
    'category': 'Computer Engineering',
    'difficulty': 'easy',
    'question': r'''CPU time: $$T = ?$$''',
    'correct_answer': r'''$$IC \times CPI \times T_{cycle}$$''',
    'incorrect_answers': [
      r'''$$\frac{IC}{CPI}$$''',
      r'''$$IC + CPI$$''',
      r'''$$\frac{CPI}{IC}$$'''
    ],
    'explanation': r'''CPU time = instruction count × CPI × clock cycle time''',
    'type': 'multiple',
  },
  {
    'category': 'Computer Engineering',
    'difficulty': 'medium',
    'question': r'''Hamming distance between 1010 and 1100:''',
    'correct_answer': r'''$$2$$''',
    'incorrect_answers': [r'''$$1$$''', r'''$$3$$''', r'''$$4$$'''],
    'explanation':
        r'''Hamming distance = number of bit positions that differ (2 bits)''',
    'type': 'multiple',
  },
  {
    'category': 'Computer Engineering',
    'difficulty': 'hard',
    'question':
        r'''Parity bits needed for Hamming code (n data bits): $$p = ?$$''',
    'correct_answer': r'''$$\lceil \log_2(n+p+1) \rceil$$''',
    'incorrect_answers': [r'''$$n/2$$''', r'''$$\log_2 n$$''', r'''$$n$$'''],
    'explanation': r'''Hamming: 2^p ≥ n + p + 1, solve for p''',
    'type': 'multiple',
  },
  {
    'category': 'Computer Engineering',
    'difficulty': 'medium',
    'question': r'''Throughput: $$\lambda = ?$$''',
    'correct_answer': r'''$$\frac{1}{service\_time}$$''',
    'incorrect_answers': [
      r'''$$service\_time$$''',
      r'''$$\frac{1}{arrival\_rate}$$''',
      r'''$$queue\_length$$'''
    ],
    'explanation': r'''Throughput = 1/service time (requests per unit time)''',
    'type': 'multiple',
  },
  {
    'category': 'Computer Engineering',
    'difficulty': 'easy',
    'question': r'''IPv4 address size:''',
    'correct_answer': r'''$$32$$ bits''',
    'incorrect_answers': [
      r'''$$16$$ bits''',
      r'''$$64$$ bits''',
      r'''$$128$$ bits'''
    ],
    'explanation': r'''IPv4 uses 32-bit addresses (4 octets)''',
    'type': 'multiple',
  },
  {
    'category': 'Computer Engineering',
    'difficulty': 'medium',
    'question': r'''Little\'s Law: $$L = ?$$''',
    'correct_answer': r'''$$\lambda W$$''',
    'incorrect_answers': [
      r'''$$\frac{\lambda}{W}$$''',
      r'''$$\lambda + W$$''',
      r'''$$\frac{W}{\lambda}$$'''
    ],
    'explanation':
        r'''Little: L = λW (avg items = arrival rate × avg wait time)''',
    'type': 'multiple',
  },
  {
    'category': 'Computer Engineering',
    'difficulty': 'hard',
    'question': r'''Channel capacity (Shannon): $$C = ?$$''',
    'correct_answer': r'''$$B \log_2(1 + SNR)$$''',
    'incorrect_answers': [
      r'''$$B \times SNR$$''',
      r'''$$\log_2(B \times SNR)$$''',
      r'''$$\frac{B}{SNR}$$'''
    ],
    'explanation': r'''Shannon capacity: C = B·log₂(1+SNR) bits/sec''',
    'type': 'multiple',
  },
  {
    'category': 'Computer Engineering',
    'difficulty': 'medium',
    'question': r'''MIPS (Million Instructions Per Second): $$MIPS = ?$$''',
    'correct_answer': r'''$$\frac{IC}{T \times 10^6}$$''',
    'incorrect_answers': [
      r'''$$\frac{T}{IC}$$''',
      r'''$$IC \times T$$''',
      r'''$$\frac{10^6}{IC}$$'''
    ],
    'explanation': r'''MIPS = instruction count / (time × 10⁶)''',
    'type': 'multiple',
  },
  {
    'category': 'Aerospace Engineering',
    'difficulty': 'medium',
    'question': r'''Drag force: $$D = ?$$''',
    'correct_answer': r'''$$\frac{1}{2}\rho v^2 S C_D$$''',
    'incorrect_answers': [
      r'''$$\rho v^2 S$$''',
      r'''$$\frac{1}{2}\rho v S C_D$$''',
      r'''$$C_D \rho v$$'''
    ],
    'explanation': r'''Drag: D = (1/2)ρv²SC_D where C_D is drag coefficient''',
    'type': 'multiple',
  },
  {
    'category': 'Aerospace Engineering',
    'difficulty': 'hard',
    'question': r'''Lift-to-drag ratio: $$L/D = ?$$''',
    'correct_answer': r'''$$\frac{C_L}{C_D}$$''',
    'incorrect_answers': [
      r'''$$C_L \times C_D$$''',
      r'''$$\frac{C_D}{C_L}$$''',
      r'''$$C_L + C_D$$'''
    ],
    'explanation': r'''L/D ratio = C_L/C_D (aerodynamic efficiency)''',
    'type': 'multiple',
  },
  {
    'category': 'Aerospace Engineering',
    'difficulty': 'medium',
    'question': r'''Thrust-to-weight ratio: $$T/W = ?$$''',
    'correct_answer': r'''$$\frac{T}{mg}$$''',
    'incorrect_answers': [
      r'''$$\frac{mg}{T}$$''',
      r'''$$T \times mg$$''',
      r'''$$T - mg$$'''
    ],
    'explanation': r'''T/W = thrust / weight (acceleration capability)''',
    'type': 'multiple',
  },
  {
    'category': 'Aerospace Engineering',
    'difficulty': 'easy',
    'question': r'''Standard atmosphere pressure at sea level:''',
    'correct_answer': r'''$$101.325$$ kPa''',
    'incorrect_answers': [
      r'''$$100$$ kPa''',
      r'''$$1$$ atm = $$10$$ kPa''',
      r'''$$1000$$ kPa'''
    ],
    'explanation': r'''Standard pressure: 101.325 kPa = 1 atm''',
    'type': 'multiple',
  },
  {
    'category': 'Aerospace Engineering',
    'difficulty': 'hard',
    'question': r'''Specific impulse: $$I_{sp} = ?$$''',
    'correct_answer': r'''$$\frac{v_e}{g_0}$$''',
    'incorrect_answers': [
      r'''$$v_e \times g_0$$''',
      r'''$$\frac{g_0}{v_e}$$''',
      r'''$$v_e - g_0$$'''
    ],
    'explanation':
        r'''Specific impulse: I_sp = v_e/g₀ (exhaust velocity/gravity)''',
    'type': 'multiple',
  },
  {
    'category': 'Aerospace Engineering',
    'difficulty': 'medium',
    'question': r'''Orbital velocity: $$v = ?$$''',
    'correct_answer': r'''$$\sqrt{\frac{GM}{r}}$$''',
    'incorrect_answers': [
      r'''$$\frac{GM}{r}$$''',
      r'''$$\sqrt{GMr}$$''',
      r'''$$\frac{r}{GM}$$'''
    ],
    'explanation': r'''Circular orbit velocity: v = √(GM/r)''',
    'type': 'multiple',
  },
  {
    'category': 'Aerospace Engineering',
    'difficulty': 'hard',
    'question': r'''Escape velocity: $$v_e = ?$$''',
    'correct_answer': r'''$$\sqrt{\frac{2GM}{r}}$$''',
    'incorrect_answers': [
      r'''$$\sqrt{\frac{GM}{r}}$$''',
      r'''$$\frac{2GM}{r}$$''',
      r'''$$2\sqrt{\frac{GM}{r}}$$'''
    ],
    'explanation':
        r'''Escape velocity: v_e = √(2GM/r) = √2 × orbital velocity''',
    'type': 'multiple',
  },
  {
    'category': 'Aerospace Engineering',
    'difficulty': 'medium',
    'question': r'''Wing loading: $$W/S = ?$$''',
    'correct_answer': r'''$$\frac{Weight}{Wing\_area}$$''',
    'incorrect_answers': [
      r'''$$Weight \times Wing\_area$$''',
      r'''$$\frac{Wing\_area}{Weight}$$''',
      r'''$$Weight - Wing\_area$$'''
    ],
    'explanation': r'''Wing loading = aircraft weight / wing area''',
    'type': 'multiple',
  },
  {
    'category': 'Aerospace Engineering',
    'difficulty': 'easy',
    'question': r'''Four forces on aircraft in level flight:''',
    'correct_answer': r'''Lift, Weight, Thrust, Drag''',
    'incorrect_answers': [
      r'''Only Lift and Weight''',
      r'''Only Thrust and Drag''',
      r'''Lift, Weight, Pressure'''
    ],
    'explanation':
        r'''Four forces: Lift (up), Weight (down), Thrust (forward), Drag (back)''',
    'type': 'multiple',
  },
  {
    'category': 'Aerospace Engineering',
    'difficulty': 'hard',
    'question': r'''Reynolds number for aircraft: $$Re = ?$$''',
    'correct_answer': r'''$$\frac{\rho v L}{\mu}$$''',
    'incorrect_answers': [
      r'''$$\frac{\mu v}{\rho L}$$''',
      r'''$$\rho v L \mu$$''',
      r'''$$\frac{v}{\rho \mu L}$$'''
    ],
    'explanation': r'''Reynolds: Re = ρvL/μ (inertial/viscous forces)''',
    'type': 'multiple',
  },
  {
    'category': 'Aerospace Engineering',
    'difficulty': 'medium',
    'question': r'''Stall occurs when:''',
    'correct_answer': r'''Angle of attack exceeds critical value''',
    'incorrect_answers': [
      r'''Speed is too high''',
      r'''Altitude is too low''',
      r'''Engine fails'''
    ],
    'explanation':
        r'''Stall: airflow separates when angle of attack too large''',
    'type': 'multiple',
  },
  {
    'category': 'Aerospace Engineering',
    'difficulty': 'hard',
    'question': r'''Prandtl-Glauert rule: $$C_{p,M} = ?$$''',
    'correct_answer': r'''$$\frac{C_{p,0}}{\sqrt{1-M^2}}$$''',
    'incorrect_answers': [
      r'''$$C_{p,0}\sqrt{1-M^2}$$''',
      r'''$$\frac{C_{p,0}}{1-M^2}$$''',
      r'''$$C_{p,0}(1-M^2)$$'''
    ],
    'explanation': r'''Compressibility correction: C_p,M = C_p,0/√(1-M²)''',
    'type': 'multiple',
  },
  {
    'category': 'Aerospace Engineering',
    'difficulty': 'medium',
    'question': r'''Aspect ratio: $$AR = ?$$''',
    'correct_answer': r'''$$\frac{b^2}{S}$$''',
    'incorrect_answers': [
      r'''$$\frac{S}{b^2}$$''',
      r'''$$b \times S$$''',
      r'''$$\frac{b}{S}$$'''
    ],
    'explanation': r'''Aspect ratio: AR = b²/S (wingspan²/wing area)''',
    'type': 'multiple',
  },
  {
    'category': 'Aerospace Engineering',
    'difficulty': 'easy',
    'question':
        r'''Bernoulli for incompressible flow: $$P + \frac{1}{2}\rho v^2 + \rho gh = ?$$''',
    'correct_answer': r'''$$constant$$''',
    'incorrect_answers': [r'''$$0$$''', r'''$$P_0$$''', r'''$$\rho$$'''],
    'explanation': r'''Bernoulli: P + (1/2)ρv² + ρgh = constant''',
    'type': 'multiple',
  },
  {
    'category': 'Aerospace Engineering',
    'difficulty': 'hard',
    'question': r'''Hohmann transfer Δv total: $$\Delta v_{total} = ?$$''',
    'correct_answer': r'''$$\Delta v_1 + \Delta v_2$$''',
    'incorrect_answers': [
      r'''$$\Delta v_1 \times \Delta v_2$$''',
      r'''$$\sqrt{\Delta v_1^2 + \Delta v_2^2}$$''',
      r'''$$\Delta v_1 - \Delta v_2$$'''
    ],
    'explanation':
        r'''Hohmann: total Δv = burn at periapsis + burn at apoapsis''',
    'type': 'multiple',
  },
  {
    'category': 'Aerospace Engineering',
    'difficulty': 'medium',
    'question': r'''Induced drag coefficient: $$C_{D,i} = ?$$''',
    'correct_answer': r'''$$\frac{C_L^2}{\pi e AR}$$''',
    'incorrect_answers': [
      r'''$$\frac{C_L}{\pi AR}$$''',
      r'''$$C_L^2 \pi AR$$''',
      r'''$$\frac{\pi AR}{C_L^2}$$'''
    ],
    'explanation': r'''Induced drag: C_D,i = C_L²/(πeAR) where e=efficiency''',
    'type': 'multiple',
  },
  {
    'category': 'Aerospace Engineering',
    'difficulty': 'medium',
    'question': r'''Glide ratio equals:''',
    'correct_answer': r'''$$L/D$$''',
    'incorrect_answers': [
      r'''$$D/L$$''',
      r'''$$L \times D$$''',
      r'''$$\sqrt{L/D}$$'''
    ],
    'explanation':
        r'''Glide ratio = L/D (horizontal distance / altitude lost)''',
    'type': 'multiple',
  },
  {
    'category': 'Aerospace Engineering',
    'difficulty': 'hard',
    'question': r'''Oblique shock angle relation: $$\tan(\theta) = ?$$''',
    'correct_answer':
        r'''$$2\cot(\beta)\frac{M_1^2\sin^2(\beta)-1}{M_1^2(\gamma+\cos(2\beta))+2}$$''',
    'incorrect_answers': [
      r'''$$M_1 \sin(\beta)$$''',
      r'''$$\frac{1}{M_1}$$''',
      r'''$$\beta/\theta$$'''
    ],
    'explanation':
        r'''Oblique shock: relates flow deflection θ to shock angle β''',
    'type': 'multiple',
  },
  {
    'category': 'Biomedical Engineering',
    'difficulty': 'medium',
    'question': r'''Cardiac output: $$CO = ?$$''',
    'correct_answer': r'''$$HR \times SV$$''',
    'incorrect_answers': [
      r'''$$\frac{HR}{SV}$$''',
      r'''$$HR + SV$$''',
      r'''$$\frac{SV}{HR}$$'''
    ],
    'explanation': r'''Cardiac output = heart rate × stroke volume''',
    'type': 'multiple',
  },
  {
    'category': 'Biomedical Engineering',
    'difficulty': 'hard',
    'question': r'''Starling equation (capillary filtration): $$J_v = ?$$''',
    'correct_answer': r'''$$K_f[(P_c - P_i) - \sigma(\pi_c - \pi_i)]$$''',
    'incorrect_answers': [
      r'''$$K_f(P_c - P_i)$$''',
      r'''$$\sigma(\pi_c - \pi_i)$$''',
      r'''$$K_f P_c$$'''
    ],
    'explanation':
        r'''Starling: fluid filtration = hydraulic - oncotic pressure''',
    'type': 'multiple',
  },
  {
    'category': 'Biomedical Engineering',
    'difficulty': 'medium',
    'question': r'''Blood pressure: $$MAP = ?$$''',
    'correct_answer': r'''$$\frac{SBP + 2DBP}{3}$$''',
    'incorrect_answers': [
      r'''$$\frac{SBP + DBP}{2}$$''',
      r'''$$SBP - DBP$$''',
      r'''$$\frac{2SBP + DBP}{3}$$'''
    ],
    'explanation': r'''Mean arterial pressure ≈ (systolic + 2×diastolic)/3''',
    'type': 'multiple',
  },
  {
    'category': 'Biomedical Engineering',
    'difficulty': 'easy',
    'question': r'''Normal body temperature:''',
    'correct_answer': r'''$$37°C$$ (98.6°F)''',
    'incorrect_answers': [r'''$$35°C$$''', r'''$$40°C$$''', r'''$$32°C$$'''],
    'explanation': r'''Normal human body temperature: 37°C or 98.6°F''',
    'type': 'multiple',
  },
  {
    'category': 'Biomedical Engineering',
    'difficulty': 'hard',
    'question': r'''Goldman-Hodgkin-Katz equation: $$V_m = ?$$''',
    'correct_answer':
        r'''$$\frac{RT}{F}\ln\frac{P_K[K^+]_o + P_{Na}[Na^+]_o}{P_K[K^+]_i + P_{Na}[Na^+]_i}$$''',
    'incorrect_answers': [
      r'''$$\frac{RT}{F}\ln\frac{[K^+]_o}{[K^+]_i}$$''',
      r'''$$E_K + E_{Na}$$''',
      r'''$$\frac{[Na^+]}{[K^+]}$$'''
    ],
    'explanation':
        r'''GHK: membrane potential considering multiple ions and permeabilities''',
    'type': 'multiple',
  },
  {
    'category': 'Biomedical Engineering',
    'difficulty': 'medium',
    'question': r'''Oxygen saturation: $$SaO_2 = ?$$''',
    'correct_answer': r'''$$\frac{HbO_2}{HbO_2 + Hb} \times 100\%$$''',
    'incorrect_answers': [
      r'''$$\frac{Hb}{HbO_2}$$''',
      r'''$$HbO_2 + Hb$$''',
      r'''$$\frac{PO_2}{100}$$'''
    ],
    'explanation':
        r'''O₂ saturation = oxyhemoglobin / total hemoglobin × 100%''',
    'type': 'multiple',
  },
  {
    'category': 'Biomedical Engineering',
    'difficulty': 'easy',
    'question': r'''Normal resting heart rate (adult):''',
    'correct_answer': r'''60-100 bpm''',
    'incorrect_answers': [
      r'''40-60 bpm''',
      r'''100-120 bpm''',
      r'''120-140 bpm'''
    ],
    'explanation': r'''Normal adult resting HR: 60-100 beats per minute''',
    'type': 'multiple',
  },
  {
    'category': 'Biomedical Engineering',
    'difficulty': 'medium',
    'question': r'''Fick principle for cardiac output: $$CO = ?$$''',
    'correct_answer': r'''$$\frac{VO_2}{C_a - C_v}$$''',
    'incorrect_answers': [
      r'''$$VO_2 \times (C_a - C_v)$$''',
      r'''$$\frac{C_a - C_v}{VO_2}$$''',
      r'''$$VO_2 + C_a - C_v$$'''
    ],
    'explanation':
        r'''Fick: CO = O₂ consumption / arteriovenous O₂ difference''',
    'type': 'multiple',
  },
  {
    'category': 'Biomedical Engineering',
    'difficulty': 'hard',
    'question': r'''Windkessel model resistance: $$R = ?$$''',
    'correct_answer': r'''$$\frac{\Delta P}{Q}$$''',
    'incorrect_answers': [
      r'''$$\frac{Q}{\Delta P}$$''',
      r'''$$\Delta P \times Q$$''',
      r'''$$C \times \Delta P$$'''
    ],
    'explanation': r'''Vascular resistance: R = pressure drop / flow rate''',
    'type': 'multiple',
  },
  {
    'category': 'Biomedical Engineering',
    'difficulty': 'medium',
    'question': r'''Compliance (vessel): $$C = ?$$''',
    'correct_answer': r'''$$\frac{\Delta V}{\Delta P}$$''',
    'incorrect_answers': [
      r'''$$\frac{\Delta P}{\Delta V}$$''',
      r'''$$\Delta V \times \Delta P$$''',
      r'''$$\frac{V}{P}$$'''
    ],
    'explanation': r'''Compliance = change in volume / change in pressure''',
    'type': 'multiple',
  },
  {
    'category': 'Biomedical Engineering',
    'difficulty': 'easy',
    'question': r'''ECG measures:''',
    'correct_answer': r'''Electrical activity of the heart''',
    'incorrect_answers': [
      r'''Blood pressure''',
      r'''Heart sounds''',
      r'''Blood flow'''
    ],
    'explanation':
        r'''Electrocardiogram (ECG) records heart\'s electrical signals''',
    'type': 'multiple',
  },
  {
    'category': 'Biomedical Engineering',
    'difficulty': 'hard',
    'question': r'''Laplace\'s law (vessel): $$T = ?$$''',
    'correct_answer': r'''$$\frac{Pr}{h}$$''',
    'incorrect_answers': [
      r'''$$\frac{Ph}{r}$$''',
      r'''$$Prh$$''',
      r'''$$\frac{h}{Pr}$$'''
    ],
    'explanation':
        r'''Wall tension: T = Pr/h (pressure × radius / wall thickness)''',
    'type': 'multiple',
  },
  {
    'category': 'Biomedical Engineering',
    'difficulty': 'medium',
    'question': r'''Hematocrit is:''',
    'correct_answer': r'''Percentage of blood volume occupied by RBCs''',
    'incorrect_answers': [
      r'''Number of white blood cells''',
      r'''Hemoglobin concentration''',
      r'''Platelet count'''
    ],
    'explanation':
        r'''Hematocrit: % of blood volume that is red blood cells (~45%)''',
    'type': 'multiple',
  },
  {
    'category': 'Biomedical Engineering',
    'difficulty': 'medium',
    'question': r'''Systemic vascular resistance: $$SVR = ?$$''',
    'correct_answer': r'''$$\frac{MAP - CVP}{CO}$$''',
    'incorrect_answers': [
      r'''$$\frac{CO}{MAP}$$''',
      r'''$$MAP \times CO$$''',
      r'''$$\frac{CVP}{CO}$$'''
    ],
    'explanation':
        r'''SVR = (mean arterial - central venous pressure) / cardiac output''',
    'type': 'multiple',
  },
  {
    'category': 'Biomedical Engineering',
    'difficulty': 'hard',
    'question': r'''Alveolar gas equation: $$P_AO_2 = ?$$''',
    'correct_answer': r'''$$P_IO_2 - \frac{P_ACO_2}{R}$$''',
    'incorrect_answers': [
      r'''$$P_IO_2 + P_ACO_2$$''',
      r'''$$\frac{P_IO_2}{P_ACO_2}$$''',
      r'''$$P_IO_2 \times R$$'''
    ],
    'explanation': r'''Alveolar O₂: P_AO₂ = inspired O₂ - alveolar CO₂/R''',
    'type': 'multiple',
  },
  {
    'category': 'Biomedical Engineering',
    'difficulty': 'easy',
    'question': r'''Normal blood pH:''',
    'correct_answer': r'''7.35-7.45''',
    'incorrect_answers': [r'''6.5-7.0''', r'''7.0-7.2''', r'''7.5-8.0'''],
    'explanation':
        r'''Normal arterial blood pH: 7.35-7.45 (slightly alkaline)''',
    'type': 'multiple',
  },
  {
    'category': 'Biomedical Engineering',
    'difficulty': 'medium',
    'question': r'''Ejection fraction: $$EF = ?$$''',
    'correct_answer': r'''$$\frac{SV}{EDV} \times 100\%$$''',
    'incorrect_answers': [
      r'''$$\frac{EDV}{SV}$$''',
      r'''$$SV - EDV$$''',
      r'''$$\frac{SV}{ESV}$$'''
    ],
    'explanation': r'''EF = stroke volume / end-diastolic volume × 100%''',
    'type': 'multiple',
  },
  {
    'category': 'Biomedical Engineering',
    'difficulty': 'hard',
    'question': r'''Henderson-Hasselbalch equation: $$pH = ?$$''',
    'correct_answer': r'''$$pK_a + \log\frac{[A^-]}{[HA]}$$''',
    'incorrect_answers': [
      r'''$$pK_a - \log\frac{[A^-]}{[HA]}$$''',
      r'''$$\frac{[A^-]}{[HA]}$$''',
      r'''$$pK_a \times [A^-]$$'''
    ],
    'explanation': r'''pH = pKa + log([base]/[acid]) for buffer solutions''',
    'type': 'multiple',
  },
  {
    'category': 'Biomedical Engineering',
    'difficulty': 'medium',
    'question': r'''Clearance (renal): $$C = ?$$''',
    'correct_answer': r'''$$\frac{U \times V}{P}$$''',
    'incorrect_answers': [
      r'''$$\frac{P}{U \times V}$$''',
      r'''$$U + V + P$$''',
      r'''$$\frac{V}{U \times P}$$'''
    ],
    'explanation':
        r'''Renal clearance = (urine conc. × urine flow) / plasma conc.''',
    'type': 'multiple',
  },
  {
    'category': 'Biomedical Engineering',
    'difficulty': 'easy',
    'question': r'''Pulse pressure: $$PP = ?$$''',
    'correct_answer': r'''$$SBP - DBP$$''',
    'incorrect_answers': [
      r'''$$SBP + DBP$$''',
      r'''$$\frac{SBP}{DBP}$$''',
      r'''$$\frac{SBP + DBP}{2}$$'''
    ],
    'explanation': r'''Pulse pressure = systolic - diastolic blood pressure''',
    'type': 'multiple',
  },
  // Astronomy - Easy (Batch 2)
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the star at the center of our Solar System?",
    "correct_answer": "Sun",
    "incorrect_answers": ["Moon", "Earth", "Proxima Centauri"],
    "explanation":
        "The Sun is the star at the center of the Solar System. It is a nearly perfect sphere of hot plasma, heated to incandescence by nuclear fusion reactions in its core."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Which planet do we live on?",
    "correct_answer": "Earth",
    "incorrect_answers": ["Mars", "Venus", "Jupiter"],
    "explanation":
        "Earth is the third planet from the Sun and the only astronomical object known to harbor life."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "How many planets are in our Solar System?",
    "correct_answer": "8",
    "incorrect_answers": ["7", "9", "10"],
    "explanation":
        "There are 8 planets in our Solar System: Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, and Neptune. Pluto was reclassified as a dwarf planet in 2006."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the shape of the Milky Way galaxy?",
    "correct_answer": "Spiral",
    "incorrect_answers": ["Elliptical", "Irregular", "Rectangular"],
    "explanation":
        "The Milky Way is a barred spiral galaxy, meaning it has a central bar-shaped structure composed of stars."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Which planet is farthest from the Sun?",
    "correct_answer": "Neptune",
    "incorrect_answers": ["Uranus", "Saturn", "Pluto"],
    "explanation":
        "Neptune is the eighth and farthest-known Solar planet from the Sun. In the Solar System, it is the fourth-largest planet by diameter."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What provides light to the Earth during the day?",
    "correct_answer": "Sun",
    "incorrect_answers": ["Moon", "Stars", "Asteroids"],
    "explanation":
        "The Sun provides daylight to Earth. Its light takes about 8 minutes to reach us."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Which constellation contains the Big Dipper?",
    "correct_answer": "Ursa Major",
    "incorrect_answers": ["Ursa Minor", "Orion", "Cassiopeia"],
    "explanation":
        "The Big Dipper is an asterism (a pattern of stars) that is part of the constellation Ursa Major (The Great Bear)."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Which planet has the Great Red Spot?",
    "correct_answer": "Jupiter",
    "incorrect_answers": ["Mars", "Saturn", "Neptune"],
    "explanation":
        "The Great Red Spot is a persistent high-pressure region in the atmosphere of Jupiter, producing an anticyclonic storm that is the largest in the Solar System."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What color is the planet Neptune?",
    "correct_answer": "Blue",
    "incorrect_answers": ["Red", "Green", "Yellow"],
    "explanation":
        "Neptune's atmosphere is made of hydrogen, helium, and methane. The methane absorbs red light, which makes the planet appear blue."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "How long does it take for Earth to orbit the Sun?",
    "correct_answer": "365 days",
    "incorrect_answers": ["24 hours", "30 days", "10 years"],
    "explanation":
        "Earth orbits the Sun once every 365.25 days, which is why we have a leap year every four years."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "How long does it take for Earth to rotate once on its axis?",
    "correct_answer": "24 hours",
    "incorrect_answers": ["365 days", "1 month", "12 hours"],
    "explanation":
        "Earth rotates on its axis once every 24 hours, causing the cycle of day and night."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the Moon?",
    "correct_answer": "A natural satellite",
    "incorrect_answers": ["A star", "A planet", "An asteroid"],
    "explanation":
        "The Moon is Earth's only natural satellite. It orbits the Earth."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question":
        "Which planet is known as the 'Morning Star' or 'Evening Star'?",
    "correct_answer": "Venus",
    "incorrect_answers": ["Mars", "Mercury", "Jupiter"],
    "explanation":
        "Venus is often visible just before sunrise or just after sunset, earning it these nicknames."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What are Saturn's rings mostly made of?",
    "correct_answer": "Ice and rock",
    "incorrect_answers": ["Gas", "Liquid water", "Metal"],
    "explanation":
        "Saturn's rings are composed primarily of water ice, with trace amounts of rocky material."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the name of the galaxy closest to the Milky Way?",
    "correct_answer": "Andromeda",
    "incorrect_answers": ["Triangulum", "Whirlpool", "Sombrero"],
    "explanation":
        "The Andromeda Galaxy is the nearest major galaxy to the Milky Way."
  },

  // Astronomy - Medium (Batch 2)
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Which dwarf planet was formerly considered the ninth planet?",
    "correct_answer": "Pluto",
    "incorrect_answers": ["Eris", "Ceres", "Haumea"],
    "explanation":
        "Pluto was considered the ninth planet from its discovery in 1930 until 2006, when the IAU reclassified it as a dwarf planet."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What will the Sun eventually become at the end of its life?",
    "correct_answer": "White Dwarf",
    "incorrect_answers": ["Black Hole", "Neutron Star", "Red Supergiant"],
    "explanation":
        "The Sun is not massive enough to become a black hole or neutron star. After its red giant phase, it will shed its outer layers and the core will become a white dwarf."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What force keeps the planets in orbit around the Sun?",
    "correct_answer": "Gravity",
    "incorrect_answers": ["Magnetism", "Friction", "Nuclear force"],
    "explanation":
        "Gravity is the force of attraction that keeps planets in orbit around the Sun and moons in orbit around planets."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the approximate speed of light?",
    "correct_answer": "300,000 km/s",
    "incorrect_answers": ["150,000 km/s", "1,000,000 km/s", "30,000 km/s"],
    "explanation":
        "The speed of light in a vacuum is exactly 299,792,458 meters per second, often approximated as 300,000 km/s."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is an Astronomical Unit (AU)?",
    "correct_answer": "Distance from Earth to Sun",
    "incorrect_answers": [
      "Distance from Sun to Pluto",
      "Distance light travels in a year",
      "Diameter of the Sun"
    ],
    "explanation":
        "An Astronomical Unit (AU) is the average distance between the Earth and the Sun, approximately 150 million kilometers."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What are the names of Mars' two moons?",
    "correct_answer": "Phobos and Deimos",
    "incorrect_answers": [
      "Io and Europa",
      "Titan and Rhea",
      "Ganymede and Callisto"
    ],
    "explanation":
        "Mars has two small, irregularly shaped moons named Phobos and Deimos."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the largest moon in the Solar System?",
    "correct_answer": "Ganymede",
    "incorrect_answers": ["Titan", "Callisto", "Io"],
    "explanation":
        "Ganymede, a moon of Jupiter, is the largest moon in the Solar System, even larger than the planet Mercury."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the largest moon of Saturn?",
    "correct_answer": "Titan",
    "incorrect_answers": ["Rhea", "Iapetus", "Enceladus"],
    "explanation":
        "Titan is Saturn's largest moon and the second-largest in the Solar System. It is the only moon known to have a dense atmosphere."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Which planet rotates on its side?",
    "correct_answer": "Uranus",
    "incorrect_answers": ["Neptune", "Saturn", "Venus"],
    "explanation":
        "Uranus has an axial tilt of 98 degrees, meaning it essentially spins on its side relative to its orbital plane."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Where is the Asteroid Belt located?",
    "correct_answer": "Between Mars and Jupiter",
    "incorrect_answers": [
      "Between Earth and Mars",
      "Beyond Neptune",
      "Between Jupiter and Saturn"
    ],
    "explanation":
        "The main asteroid belt is located roughly between the orbits of the planets Mars and Jupiter."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What are comets mostly made of?",
    "correct_answer": "Ice and dust",
    "incorrect_answers": ["Rock and iron", "Gas and plasma", "Liquid water"],
    "explanation":
        "Comets are often described as 'dirty snowballs' because they are composed primarily of ice, dust, and rocky particles."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the difference between a meteor and a meteorite?",
    "correct_answer": "A meteorite hits the ground",
    "incorrect_answers": [
      "A meteor is larger",
      "A meteorite is made of ice",
      "There is no difference"
    ],
    "explanation":
        "A meteor is the streak of light seen when a space rock burns up in the atmosphere. If it survives and hits the ground, it is called a meteorite."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What space telescope was launched in 1990?",
    "correct_answer": "Hubble Space Telescope",
    "incorrect_answers": [
      "James Webb Space Telescope",
      "Spitzer Space Telescope",
      "Chandra X-ray Observatory"
    ],
    "explanation":
        "The Hubble Space Telescope was launched into low Earth orbit in 1990 and remains in operation."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the visible surface of the Sun called?",
    "correct_answer": "Photosphere",
    "incorrect_answers": ["Corona", "Chromosphere", "Core"],
    "explanation":
        "The photosphere is the visible surface of the Sun from which most of its light is emitted."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Which planet has the fastest winds in the Solar System?",
    "correct_answer": "Neptune",
    "incorrect_answers": ["Jupiter", "Saturn", "Uranus"],
    "explanation":
        "Neptune has the strongest sustained winds of any planet in the Solar System, reaching speeds of 2,100 km/h."
  },

  // Astronomy - Hard (Batch 2)
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is the estimated age of the Universe?",
    "correct_answer": "13.8 billion years",
    "incorrect_answers": [
      "4.5 billion years",
      "10 billion years",
      "20 billion years"
    ],
    "explanation":
        "Measurements of the cosmic microwave background radiation suggest the Universe is approximately 13.8 billion years old."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is the Chandrasekhar limit?",
    "correct_answer": "Max mass of a white dwarf",
    "incorrect_answers": [
      "Max mass of a neutron star",
      "Min mass of a black hole",
      "Speed of light limit"
    ],
    "explanation":
        "The Chandrasekhar limit (approx. 1.4 solar masses) is the maximum mass of a stable white dwarf star."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is a Pulsar?",
    "correct_answer": "Rotating neutron star",
    "incorrect_answers": [
      "Exploding star",
      "Active black hole",
      "Binary star system"
    ],
    "explanation":
        "A pulsar is a highly magnetized rotating neutron star that emits beams of electromagnetic radiation out of its magnetic poles."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is a Quasar?",
    "correct_answer": "Active galactic nucleus",
    "incorrect_answers": [
      "Type of supernova",
      "Star cluster",
      "Dark matter halo"
    ],
    "explanation":
        "A quasar is an extremely luminous active galactic nucleus (AGN), powered by a supermassive black hole."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question": "Which method has discovered the most exoplanets?",
    "correct_answer": "Transit method",
    "incorrect_answers": [
      "Radial velocity",
      "Direct imaging",
      "Gravitational microlensing"
    ],
    "explanation":
        "The transit method, which detects the dip in brightness as a planet passes in front of its star, has been the most successful detection method."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question": "Where is the Oort Cloud located?",
    "correct_answer": "Outer limits of Solar System",
    "incorrect_answers": [
      "Between Mars and Jupiter",
      "Inside Mercury's orbit",
      "Around Saturn"
    ],
    "explanation":
        "The Oort Cloud is a theoretical cloud of predominantly icy planetesimals proposed to surround the Sun at distances ranging from 2,000 to 200,000 AU."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is the Fermi Paradox?",
    "correct_answer": "Lack of evidence for aliens",
    "incorrect_answers": [
      "Speed of light limit",
      "Quantum entanglement",
      "Black hole information loss"
    ],
    "explanation":
        "The Fermi Paradox is the discrepancy between the lack of conclusive evidence of advanced extraterrestrial life and the apparently high a priori probability of its existence."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is the Cosmic Microwave Background (CMB)?",
    "correct_answer": "Radiation from Big Bang",
    "incorrect_answers": [
      "Radio waves from stars",
      "Light from galaxies",
      "Hawking radiation"
    ],
    "explanation":
        "The CMB is electromagnetic radiation which is a remnant from an early stage of the universe, also known as 'relic radiation'."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What does 'Redshift' indicate about a galaxy?",
    "correct_answer": "It is moving away",
    "incorrect_answers": [
      "It is moving closer",
      "It is spinning fast",
      "It is very hot"
    ],
    "explanation":
        "Redshift happens when light or other electromagnetic radiation from an object is increased in wavelength, or shifted to the red end of the spectrum. In astronomy, it generally indicates an object is moving away."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What type of Supernova is used as a 'standard candle'?",
    "correct_answer": "Type Ia",
    "incorrect_answers": ["Type II", "Type Ib", "Type Ic"],
    "explanation":
        "Type Ia supernovae have a consistent peak luminosity, allowing astronomers to use them as standard candles to measure distances to their host galaxies."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is the Schwarzschild radius?",
    "correct_answer": "Radius of event horizon",
    "incorrect_answers": [
      "Radius of a neutron star",
      "Radius of the observable universe",
      "Radius of an atom"
    ],
    "explanation":
        "The Schwarzschild radius is the radius of a sphere such that, if all the mass of an object were to be compressed within that sphere, the escape velocity from the surface of the sphere would equal the speed of light."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is the Roche limit?",
    "correct_answer": "Distance where tidal forces disintegrate a body",
    "incorrect_answers": [
      "Speed limit of a rocket",
      "Max mass of a star",
      "Edge of the solar system"
    ],
    "explanation":
        "The Roche limit is the minimum distance to which a large satellite can approach its primary body without being torn apart by tidal forces."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What are Lagrangian points?",
    "correct_answer": "Points of stable orbit",
    "incorrect_answers": [
      "Points of zero gravity",
      "Points of max gravity",
      "Points of collision"
    ],
    "explanation":
        "Lagrangian points are positions in an orbital configuration of two large bodies where a small object affected only by gravity can maintain a stable position relative to the two large bodies."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is Dark Energy?",
    "correct_answer": "Force accelerating expansion",
    "incorrect_answers": [
      "Invisible matter",
      "Black hole energy",
      "Antimatter"
    ],
    "explanation":
        "Dark energy is an unknown form of energy that affects the universe on the largest scales. The first observational evidence for its existence came from measurements of supernovae, which showed that the universe does not expand at a constant rate; rather, the expansion of the universe is accelerating."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is the Great Attractor?",
    "correct_answer": "Gravitational anomaly",
    "incorrect_answers": [
      "A massive black hole",
      "A supercluster",
      "A magnetar"
    ],
    "explanation":
        "The Great Attractor is a gravitational anomaly in intergalactic space and the apparent central gravitational point of the Laniakea Supercluster."
  },
  // Astronomy - Easy (First batch)
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Which planet is closest to the Sun?",
    "correct_answer": "Mercury",
    "incorrect_answers": ["Venus", "Mars", "Earth"],
    "explanation":
        "Mercury is the smallest and innermost planet in the Solar System. Its orbit around the Sun takes 87.97 Earth days, the shortest of all the planets in the Solar System."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the name of our galaxy?",
    "correct_answer": "Milky Way",
    "incorrect_answers": ["Andromeda", "Triangulum", "Whirlpool"],
    "explanation":
        "The Milky Way is the galaxy that contains our Solar System, with the name describing the galaxy's appearance from Earth: a hazy band of light seen in the night sky formed from stars that cannot be individually distinguished by the naked eye."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Which planet is known as the Red Planet?",
    "correct_answer": "Mars",
    "incorrect_answers": ["Jupiter", "Saturn", "Venus"],
    "explanation":
        "Mars is often referred to as the 'Red Planet' because the reddish iron oxide prevalent on its surface gives it a reddish appearance that is distinctive among the astronomical bodies visible to the naked eye."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What celestial body orbits the Earth?",
    "correct_answer": "Moon",
    "incorrect_answers": ["Sun", "Mars", "Venus"],
    "explanation":
        "The Moon is Earth's only proper natural satellite. It is one quarter the diameter of Earth (comparable to the width of Australia), making it the largest natural satellite in the Solar System relative to the size of its planet."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the largest planet in our solar system?",
    "correct_answer": "Jupiter",
    "incorrect_answers": ["Saturn", "Neptune", "Uranus"],
    "explanation":
        "Jupiter is the fifth planet from the Sun and the largest in the Solar System. It is a gas giant with a mass one-thousandth that of the Sun, but two-and-a-half times that of all the other planets in the Solar System combined."
  },

  // Astronomy - Medium
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question":
        "What is the term for a star that suddenly increases greatly in brightness?",
    "correct_answer": "Supernova",
    "incorrect_answers": ["Nebula", "Quasar", "Pulsar"],
    "explanation":
        "A supernova is a powerful and luminous stellar explosion. This transient astronomical event occurs during the last evolutionary stages of a massive star or when a white dwarf is triggered into runaway nuclear fusion."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Which planet has the most extensive ring system?",
    "correct_answer": "Saturn",
    "incorrect_answers": ["Jupiter", "Uranus", "Neptune"],
    "explanation":
        "Saturn is famous for its prominent ring system, which consists of nine continuous main rings and three discontinuous arcs and that is composed mostly of ice particles with a smaller amount of rocky debris and dust."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the name of the first satellite sent into space?",
    "correct_answer": "Sputnik 1",
    "incorrect_answers": ["Explorer 1", "Vostok 1", "Apollo 11"],
    "explanation":
        "Sputnik 1 was the first artificial Earth satellite. The Soviet Union launched it into an elliptical low Earth orbit on 4 October 1957, orbiting for three weeks before its batteries died."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Who was the first human to travel into space?",
    "correct_answer": "Yuri Gagarin",
    "incorrect_answers": ["Neil Armstrong", "Buzz Aldrin", "John Glenn"],
    "explanation":
        "Yuri Alekseyevich Gagarin was a Soviet Air Forces pilot and cosmonaut who became the first human to journey into outer space, achieving a major milestone in the Space Race; his capsule, Vostok 1, completed one orbit of Earth on 12 April 1961."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the hottest planet in our solar system?",
    "correct_answer": "Venus",
    "incorrect_answers": ["Mercury", "Mars", "Jupiter"],
    "explanation":
        "Venus is the hottest planet in the Solar System, with a mean surface temperature of 735 K (462 °C; 863 °F), even though Mercury is closer to the Sun. This is due to a dense atmosphere rich in carbon dioxide, which creates a strong greenhouse effect."
  },

  // Astronomy - Hard
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question":
        "What is the name of the boundary around a black hole beyond which no light can escape?",
    "correct_answer": "Event Horizon",
    "incorrect_answers": ["Singularity", "Accretion Disk", "Photon Sphere"],
    "explanation":
        "The event horizon is the boundary defining the region of space around a black hole from which nothing (not even light) can escape. In other words, the escape velocity for an object within the event horizon exceeds the speed of light."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question":
        "Which moon of Jupiter is the most volcanically active body in the solar system?",
    "correct_answer": "Io",
    "incorrect_answers": ["Europa", "Ganymede", "Callisto"],
    "explanation":
        "Io is the innermost of the four Galilean moons of the planet Jupiter. It is the fourth-largest moon, has the highest density of all the moons, and has the least amount of relative water of any known astronomical object in the Solar System. It is the most geologically active object in the Solar System, with over 400 active volcanoes."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question":
        "What is the name of the largest asteroid in the asteroid belt?",
    "correct_answer": "Ceres",
    "incorrect_answers": ["Vesta", "Pallas", "Hygiea"],
    "explanation":
        "Ceres is the largest object in the asteroid belt that lies between the orbits of Mars and Jupiter, slightly closer to Mars's orbit. It is the only dwarf planet located in the inner solar system."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question": "Who discovered the four largest moons of Jupiter?",
    "correct_answer": "Galileo Galilei",
    "incorrect_answers": [
      "Johannes Kepler",
      "Isaac Newton",
      "Nicolaus Copernicus"
    ],
    "explanation":
        "Galileo Galilei discovered the four largest moons of Jupiter—Io, Europa, Ganymede, and Callisto—in January 1610. They are now known as the Galilean moons in his honor."
  },
  {
    "category": "Science: Astronomy",
    "type": "multiple",
    "difficulty": "hard",
    "question":
        "What is the term for the point in an orbit that is furthest from the sun?",
    "correct_answer": "Aphelion",
    "incorrect_answers": ["Perihelion", "Apogee", "Perigee"],
    "explanation":
        "The aphelion is the point in the orbit of a planet, asteroid, or comet at which it is furthest from the Sun. The opposite point, the nearest to the Sun, is the perihelion."
  },
];

List<Question> getLocalQuestions() {
  return localQuestions.map((json) => Question.fromLocalJson(json)).toList();
}
