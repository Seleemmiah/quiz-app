// A local data source for quiz questions.
// In a real app, this could be replaced by a database or a more extensive API.

final List<Map<String, dynamic>> localQuestions = [
  {
    "category": "History",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Who was the first Emperor of Rome?",
    "correct_answer": "Augustus",
    "incorrect_answers": ["Julius Caesar", "Nero", "Caligula"],
    "explanation":
        "While Julius Caesar was a pivotal figure in the demise of the Roman Republic, he was never emperor. His adopted son, Octavian, was given the title 'Augustus' by the Senate in 27 BC, marking the beginning of the Roman Empire. Augustus's reign, known as the Pax Romana, was a period of relative peace and stability that lasted for over two centuries. He reformed the military, established the Praetorian Guard, and initiated vast building projects in Rome, famously claiming he 'found Rome a city of bricks and left it a city of marble'."
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
    "type-": "multiple",
    "difficulty": "easy",
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
        "Poseidon was one of the Twelve Olympians in ancient Greek religion and myth, god of the Sea and other waters; of earthquakes; and of horses."
  },
  {
    "category": "Politics",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Who is the current Prime Minister of Canada?",
    "correct_answer": "Justin Trudeau",
    "incorrect_answers": ["Stephen Harper", "Jean Chrétien", "Paul Martin"],
    "explanation":
        "Justin Trudeau is a Canadian politician who has served as the 23rd prime minister of Canada since 2015 and has been the leader of the Liberal Party since 2013."
  },
  {
    "category": "Animals",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the largest mammal in the world?",
    "correct_answer": "Blue Whale",
    "incorrect_answers": ["Elephant", "Giraffe", "Hippopotamus"],
    "explanation":
        "The blue whale is a marine mammal belonging to the baleen whale parvorder Mysticeti. Reaching a maximum confirmed length of 29.9 meters and weight of 199 tonnes, it is the largest animal known to have ever existed."
  },
  {
    "category": "Celebrities",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Who is known as the 'King of Pop'?",
    "correct_answer": "Michael Jackson",
    "incorrect_answers": ["Elvis Presley", "Prince", "Madonna"],
    "explanation":
        "Michael Joseph Jackson was an American singer, songwriter, and dancer. Dubbed the 'King of Pop', he is regarded as one of the most significant cultural figures of the 20th century."
  },
  {
    "category": "Vehicles",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Which car company produces the Mustang?",
    "correct_answer": "Ford",
    "incorrect_answers": ["Chevrolet", "Dodge", "Toyota"],
    "explanation":
        "The Ford Mustang is a series of American automobiles manufactured by Ford. In continuous production since 1964, the Mustang is currently the longest-produced Ford car nameplate."
  },
  {
    "category": "Science & Nature",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the chemical symbol for gold?",
    "correct_answer": "Au",
    "incorrect_answers": ["Ag", "Go", "Gd"],
    "explanation":
        "The chemical symbol for gold is Au, from the Latin word 'aurum', meaning 'shining dawn'."
  },
  {
    "category": "Entertainment: Books",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Who wrote the 'Harry Potter' series?",
    "correct_answer": "J.K. Rowling",
    "incorrect_answers": [
      "Stephen King",
      "J.R.R. Tolkien",
      "George R.R. Martin"
    ],
    "explanation":
        "Joanne Rowling, better known by her pen name J. K. Rowling, is a British author, philanthropist, film producer, television producer, and screenwriter. She is best known for writing the Harry Potter fantasy series, which has won multiple awards and sold more than 500 million copies, becoming the best-selling book series in history."
  },
  {
    "category": "Entertainment: Music",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Which band released the album 'Abbey Road'?",
    "correct_answer": "The Beatles",
    "incorrect_answers": ["The Rolling Stones", "Led Zeppelin", "Pink Floyd"],
    "explanation":
        "Abbey Road is the eleventh studio album by the English rock band the Beatles, released on 26 September 1969 by Apple Records."
  },
  {
    "category": "Entertainment: Video Games",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Who is the main character in the 'Legend of Zelda' series?",
    "correct_answer": "Link",
    "incorrect_answers": ["Zelda", "Ganon", "Mario"],
    "explanation":
        "Link is the main protagonist of Nintendo's video game series The Legend of Zelda. He appears in several incarnations over the course of the games, and also features in other Nintendo media, including merchandising, comic books and an animated television series."
  },
  {
    "category": "Entertainment: Television",
    "type": "multiple",
    "difficulty": "medium",
    "question":
        "In the TV show 'Friends', what is the name of Ross's second wife?",
    "correct_answer": "Emily",
    "incorrect_answers": ["Rachel", "Phoebe", "Monica"],
    "explanation":
        "Emily Waltham is a recurring character on the U.S. television sitcom Friends, portrayed by Helen Baxendale. She is the second wife of Ross Geller."
  },
  {
    "category": "Entertainment: Board Games",
    "type": "multiple",
    "difficulty": "easy",
    "question": "How many squares are on a standard chessboard?",
    "correct_answer": "64",
    "incorrect_answers": ["32", "100", "49"],
    "explanation":
        "A chessboard is a game board used to play chess. It is square-shaped and divided into 64 squares (eight-by-eight) of alternating colors."
  },
  {
    "category": "History",
    "type": "multiple",
    "difficulty": "hard",
    "question": "In what year did the Titanic sink?",
    "correct_answer": "1912",
    "incorrect_answers": ["1905", "1915", "1920"],
    "explanation":
        "RMS Titanic was a British passenger liner that sank in the North Atlantic Ocean in the early hours of 15 April 1912, after striking an iceberg during her maiden voyage from Southampton to New York City."
  },
  {
    "category": "Science: Mathematics",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the value of Pi to two decimal places?",
    "correct_answer": "3.14",
    "incorrect_answers": ["3.15", "3.16", "3.13"],
    "explanation":
        "Pi (π) is the ratio of a circle's circumference to its diameter. Its value is approximately 3.14159, so to two decimal places, it is 3.14."
  },
  {
    "category": "Science: Mathematics",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the square root of 144?",
    "correct_answer": "12",
    "incorrect_answers": ["10", "14", "16"],
    "explanation":
        "The square root of a number is a value that, when multiplied by itself, gives the original number. 12 multiplied by 12 is 144."
  },
  {
    "category": "Geography",
    "type": "multiple",
    "difficulty": "medium",
    "question": "What is the longest river in the world?",
    "correct_answer": "The Nile",
    "incorrect_answers": ["The Amazon", "The Yangtze", "The Mississippi"],
    "explanation":
        "The Nile River in Africa is historically considered the longest river in the world, flowing for approximately 6,650 kilometers (4,132 miles) from its source in Burundi to the Mediterranean Sea."
  },
  {
    "category": "Science: Chemistry",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the chemical symbol for water?",
    "correct_answer": "H2O",
    "incorrect_answers": ["O2", "CO2", "NaCl"],
    "explanation":
        "Water is a chemical compound with the formula H2O, meaning one molecule of water contains two hydrogen atoms and one oxygen atom."
  },
  {
    "category": "History",
    "type": "multiple",
    "difficulty": "medium",
    "question": "In what year did World War II end?",
    "correct_answer": "1945",
    "incorrect_answers": ["1943", "1947", "1940"],
    "explanation":
        "World War II ended in 1945 with the surrender of the Axis powers. The war in Europe concluded in May, and the war in the Pacific ended in September after the atomic bombings of Hiroshima and Nagasaki."
  },
  {
    "category": "Literature",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Who wrote 'To Kill a Mockingbird'?",
    "correct_answer": "Harper Lee",
    "incorrect_answers": [
      "Mark Twain",
      "F. Scott Fitzgerald",
      "Ernest Hemingway"
    ],
    "explanation":
        "'To Kill a Mockingbird' is a novel by Harper Lee published in 1960. It was immediately successful, winning the Pulitzer Prize, and has become a classic of modern American literature."
  },
  {
    "category": "Science: Physics",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Who is credited with the theory of relativity?",
    "correct_answer": "Albert Einstein",
    "incorrect_answers": ["Isaac Newton", "Galileo Galilei", "Nikola Tesla"],
    "explanation":
        "Albert Einstein, a German-born theoretical physicist, developed the theory of relativity, one of the two pillars of modern physics (alongside quantum mechanics). His work is also known for its influence on the philosophy of science."
  },
  {
    "category": "General Knowledge",
    "type": "multiple",
    "difficulty": "easy",
    "question": "How many continents are there?",
    "correct_answer": "7",
    "incorrect_answers": ["5", "6", "8"],
    "explanation":
        "There are seven continents on Earth: Asia, Africa, North America, South America, Antarctica, Europe, and Australia. Each is a large landmass separated by major bodies of water."
  },
  {
    "category": "Entertainment: Music",
    "type": "multiple",
    "difficulty": "medium",
    "question": "Which artist is known as the 'Queen of Soul'?",
    "correct_answer": "Aretha Franklin",
    "incorrect_answers": ["Whitney Houston", "Diana Ross", "Tina Turner"],
    "explanation":
        "Aretha Franklin was an American singer, songwriter, and pianist. Referred to as the 'Queen of Soul', she has been placed in the number one spot on Rolling Stone magazine's '100 Greatest Singers of All Time' list."
  },
  {
    "category": "Science: Mathematics",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is the next prime number after 7?",
    "correct_answer": "11",
    "incorrect_answers": ["9", "10", "12"],
    "explanation":
        "A prime number is a natural number greater than 1 that has no positive divisors other than 1 and itself. The number 9 is divisible by 3, and 10 and 12 are even. The next prime number after 7 is 11."
  },
  {
    "category": "Geography",
    "type": "multiple",
    "difficulty": "hard",
    "question": "What is the capital of Brazil?",
    "correct_answer": "Brasília",
    "incorrect_answers": ["Rio de Janeiro", "São Paulo", "Salvador"],
    "explanation":
        "While Rio de Janeiro and São Paulo are Brazil's most famous cities, Brasília was purpose-built in the country's interior and inaugurated as the federal capital in 1960 to help develop the central regions of Brazil."
  }
];
