#!/usr/bin/env python3
"""
Comprehensive Quiz Question Generator
Generates 20 questions per difficulty level for all categories
Output format: Dart-compatible for direct insertion into local_questions.dart
"""

import json
import sys

# All questions organized by category and difficulty
# Format: (question, correct_answer, [incorrect_answers], explanation)

QUESTIONS = {
    "History": {
        "easy": [
            ("In which year did World War I begin?", "1914", ["1918", "1939", "1945"], "World War I began in 1914 after the assassination of Archduke Franz Ferdinand."),
            ("Who was the first woman to fly solo across the Atlantic Ocean?", "Amelia Earhart", ["Bessie Coleman", "Harriet Quimby", "Jacqueline Cochran"], "Amelia Earhart became the first woman to fly solo across the Atlantic in 1932."),
            ("What ancient wonder of the world still stands today?", "Great Pyramid of Giza", ["Hanging Gardens of Babylon", "Colossus of Rhodes", "Lighthouse of Alexandria"], "The Great Pyramid of Giza is the only ancient wonder still standing."),
            ("Who invented the telephone?", "Alexander Graham Bell", ["Thomas Edison", "Nikola Tesla", "Guglielmo Marconi"], "Alexander Graham Bell is credited with inventing the telephone in 1876."),
            ("What year did the Berlin Wall fall?", "1989", ["1985", "1991", "1987"], "The Berlin Wall fell on November 9, 1989, marking the end of the Cold War era."),
            ("Who was the first person to set foot on the moon?", "Neil Armstrong", ["Buzz Aldrin", "Yuri Gagarin", "John Glenn"], "Neil Armstrong was the first person to walk on the moon on July 20, 1969."),
            ("In which city was the Declaration of Independence signed?", "Philadelphia", ["Boston", "New York", "Washington D.C."], "The Declaration of Independence was signed in Philadelphia in 1776."),
            ("Who was known as the 'Iron Lady'?", "Margaret Thatcher", ["Queen Victoria", "Golda Meir", "Indira Gandhi"], "Margaret Thatcher, the British Prime Minister, was known as the 'Iron Lady'."),
            ("What year did Christopher Columbus first reach the Americas?", "1492", ["1776", "1620", "1607"], "Christopher Columbus reached the Americas in 1492."),
            ("Who was the first emperor of China?", "Qin Shi Huang", ["Kublai Khan", "Emperor Wu", "Confucius"], "Qin Shi Huang unified China and became its first emperor in 221 BC."),
            ("What ancient civilization built Machu Picchu?", "Inca", ["Maya", "Aztec", "Olmec"], "Machu Picchu was built by the Inca civilization in the 15th century."),
            ("Who wrote the 95 Theses?", "Martin Luther", ["John Calvin", "Henry VIII", "Pope Leo X"], "Martin Luther wrote the 95 Theses in 1517, sparking the Protestant Reformation."),
            ("What year did the Titanic sink?", "1912", ["1910", "1915", "1920"], "The RMS Titanic sank on April 15, 1912, after hitting an iceberg."),
            ("Who was the first President of South Africa after apartheid?", "Nelson Mandela", ["Desmond Tutu", "F.W. de Klerk", "Thabo Mbeki"], "Nelson Mandela became the first President of South Africa after apartheid in 1994."),
            ("What ancient city was buried by the eruption of Mount Vesuvius?", "Pompeii", ["Herculaneum", "Rome", "Athens"], "Pompeii was buried by the eruption of Mount Vesuvius in 79 AD."),
            ("Who was the longest-reigning British monarch before Elizabeth II?", "Queen Victoria", ["King George III", "Queen Elizabeth I", "King Henry VIII"], "Queen Victoria reigned for 63 years before being surpassed by Elizabeth II."),
            ("What year did India gain independence from Britain?", "1947", ["1945", "1950", "1942"], "India gained independence from Britain on August 15, 1947."),
            ("Who was the first female Prime Minister of the United Kingdom?", "Margaret Thatcher", ["Theresa May", "Queen Elizabeth II", "Indira Gandhi"], "Margaret Thatcher became the UK's first female Prime Minister in 1979."),
            ("What ancient empire was ruled by Julius Caesar?", "Roman Empire", ["Greek Empire", "Persian Empire", "Egyptian Empire"], "Julius Caesar was a leader of the Roman Empire."),
            ("Who discovered America for Spain?", "Christopher Columbus", ["Amerigo Vespucci", "Ferdinand Magellan", "Hernán Cortés"], "Christopher Columbus discovered America for Spain in 1492."),
        ],
        "medium": [
            ("What year did the French Revolution begin?", "1789", ["1776", "1799", "1804"], "The French Revolution began in 1789 with the storming of the Bastille."),
            ("Who was the last Tsar of Russia?", "Nicholas II", ["Alexander III", "Peter the Great", "Ivan the Terrible"], "Nicholas II was the last Tsar of Russia, executed in 1918."),
            ("What treaty ended World War I?", "Treaty of Versailles", ["Treaty of Paris", "Treaty of Ghent", "Treaty of Tordesillas"], "The Treaty of Versailles ended World War I in 1919."),
            ("Who led the Mongol Empire at its peak?", "Genghis Khan", ["Kublai Khan", "Tamerlane", "Attila the Hun"], "Genghis Khan founded and led the Mongol Empire to its greatest extent."),
            ("What year did the American Civil War end?", "1865", ["1861", "1870", "1877"], "The American Civil War ended in 1865 with the surrender at Appomattox."),
            ("Who was the first Holy Roman Emperor?", "Charlemagne", ["Otto I", "Frederick Barbarossa", "Napoleon"], "Charlemagne was crowned the first Holy Roman Emperor in 800 AD."),
            ("What ancient library was destroyed by fire?", "Library of Alexandria", ["Library of Pergamum", "Library of Ephesus", "Library of Athens"], "The Library of Alexandria was one of the largest libraries of the ancient world, destroyed by fire."),
            ("Who led the Haitian Revolution?", "Toussaint Louverture", ["Jean-Jacques Dessalines", "Henri Christophe", "Alexandre Pétion"], "Toussaint Louverture led the Haitian Revolution against French colonial rule."),
            ("What year did the Ottoman Empire fall?", "1922", ["1918", "1920", "1924"], "The Ottoman Empire officially ended in 1922 after World War I."),
            ("Who was the first woman to win a Nobel Prize?", "Marie Curie", ["Mother Teresa", "Jane Addams", "Bertha von Suttner"], "Marie Curie was the first woman to win a Nobel Prize in 1903."),
            ("What ancient civilization invented paper?", "China", ["Egypt", "Mesopotamia", "India"], "Paper was invented in ancient China around 105 AD."),
            ("Who was the youngest US President?", "Theodore Roosevelt", ["John F. Kennedy", "Bill Clinton", "Barack Obama"], "Theodore Roosevelt became president at age 42 after McKinley's assassination."),
            ("What year did the Spanish Armada attempt to invade England?", "1588", ["1492", "1600", "1620"], "The Spanish Armada attempted to invade England in 1588 but was defeated."),
            ("Who was the first woman to serve as Prime Minister of India?", "Indira Gandhi", ["Benazir Bhutto", "Sirimavo Bandaranaike", "Golda Meir"], "Indira Gandhi became India's first female Prime Minister in 1966."),
            ("What ancient trade route connected East and West?", "Silk Road", ["Spice Route", "Amber Road", "Incense Route"], "The Silk Road was an ancient network of trade routes connecting East and West."),
            ("Who wrote 'The Communist Manifesto'?", "Karl Marx", ["Vladimir Lenin", "Joseph Stalin", "Leon Trotsky"], "Karl Marx and Friedrich Engels wrote 'The Communist Manifesto' in 1848."),
            ("What year did the Suez Canal open?", "1869", ["1859", "1879", "1889"], "The Suez Canal opened in 1869, connecting the Mediterranean and Red Seas."),
            ("Who was the first woman in space?", "Valentina Tereshkova", ["Sally Ride", "Mae Jemison", "Svetlana Savitskaya"], "Valentina Tereshkova became the first woman in space in 1963."),
            ("What ancient city was the capital of the Byzantine Empire?", "Constantinople", ["Rome", "Athens", "Alexandria"], "Constantinople (modern Istanbul) was the capital of the Byzantine Empire."),
            ("Who led the Protestant Reformation in Switzerland?", "John Calvin", ["Martin Luther", "Huldrych Zwingli", "John Knox"], "John Calvin was a key figure in the Protestant Reformation in Switzerland."),
        ],
        "hard": [
            ("What year was the Battle of Hastings?", "1066", ["1215", "1415", "1588"], "The Battle of Hastings in 1066 led to the Norman conquest of England."),
            ("Who was the first Caliph after Muhammad's death?", "Abu Bakr", ["Umar", "Uthman", "Ali"], "Abu Bakr became the first Caliph after Prophet Muhammad's death in 632 AD."),
            ("What treaty divided the New World between Spain and Portugal?", "Treaty of Tordesillas", ["Treaty of Utrecht", "Treaty of Westphalia", "Treaty of Paris"], "The Treaty of Tordesillas in 1494 divided the New World between Spain and Portugal."),
            ("Who was the Byzantine Emperor during the construction of Hagia Sophia?", "Justinian I", ["Constantine I", "Theodosius I", "Heraclius"], "Justinian I commissioned the construction of Hagia Sophia in 537 AD."),
            ("What year did the Hundred Years' War begin?", "1337", ["1215", "1415", "1453"], "The Hundred Years' War between England and France began in 1337."),
            ("Who was the first Ming Dynasty emperor?", "Hongwu Emperor", ["Yongle Emperor", "Kangxi Emperor", "Qianlong Emperor"], "The Hongwu Emperor founded the Ming Dynasty in 1368."),
            ("What ancient battle is considered the turning point of the Persian Wars?", "Battle of Salamis", ["Battle of Marathon", "Battle of Thermopylae", "Battle of Plataea"], "The Battle of Salamis in 480 BC was the decisive naval battle of the Persian Wars."),
            ("Who was the last Western Roman Emperor?", "Romulus Augustulus", ["Constantine XI", "Justinian I", "Theodosius I"], "Romulus Augustulus was the last Western Roman Emperor, deposed in 476 AD."),
            ("What year did the Taiping Rebellion begin in China?", "1850", ["1839", "1860", "1870"], "The Taiping Rebellion, one of the deadliest conflicts in history, began in 1850."),
            ("Who was the first Shogun of Japan?", "Minamoto no Yoritomo", ["Tokugawa Ieyasu", "Oda Nobunaga", "Toyotomi Hideyoshi"], "Minamoto no Yoritomo became the first Shogun of Japan in 1192."),
            ("What ancient civilization created the first known writing system?", "Sumerians", ["Egyptians", "Phoenicians", "Chinese"], "The Sumerians created cuneiform, the first known writing system, around 3400 BC."),
            ("Who led the Zulu Kingdom during the Anglo-Zulu War?", "Cetshwayo", ["Shaka", "Dingane", "Mpande"], "Cetshwayo led the Zulu Kingdom during the Anglo-Zulu War of 1879."),
            ("What year was the Edict of Milan issued?", "313 AD", ["325 AD", "380 AD", "395 AD"], "The Edict of Milan in 313 AD granted religious tolerance to Christians in the Roman Empire."),
            ("Who was the first Mughal Emperor of India?", "Babur", ["Akbar", "Humayun", "Shah Jahan"], "Babur founded the Mughal Empire in India in 1526."),
            ("What ancient city-state was led by Pericles during its Golden Age?", "Athens", ["Sparta", "Thebes", "Corinth"], "Pericles led Athens during its Golden Age in the 5th century BC."),
            ("Who was the first Pharaoh of unified Egypt?", "Narmer", ["Khufu", "Ramesses II", "Tutankhamun"], "Narmer (also known as Menes) is credited with unifying Egypt around 3100 BC."),
            ("What year did the Glorious Revolution occur in England?", "1688", ["1642", "1660", "1707"], "The Glorious Revolution of 1688 overthrew King James II of England."),
            ("Who was the founder of the Achaemenid Persian Empire?", "Cyrus the Great", ["Darius I", "Xerxes I", "Artaxerxes I"], "Cyrus the Great founded the Achaemenid Persian Empire in 550 BC."),
            ("What year did the War of the Roses begin?", "1455", ["1399", "1485", "1509"], "The War of the Roses began in 1455 between the Houses of Lancaster and York."),
            ("Who was the last emperor of the Aztec Empire?", "Cuauhtémoc", ["Moctezuma II", "Cuitláhuac", "Itzcoatl"], "Cuauhtémoc was the last Aztec emperor, defeated by Cortés in 1521."),
        ],
    },
    
    "Geography": {
        "easy": [
            ("What is the capital of France?", "Paris", ["London", "Berlin", "Madrid"], "Paris is the capital and largest city of France."),
            ("Which is the largest ocean on Earth?", "Pacific Ocean", ["Atlantic Ocean", "Indian Ocean", "Arctic Ocean"], "The Pacific Ocean is the largest and deepest ocean on Earth."),
            ("What is the longest river in the world?", "Nile River", ["Amazon River", "Yangtze River", "Mississippi River"], "The Nile River in Africa is generally considered the longest river at 6,650 km."),
            ("Which continent is the Sahara Desert located on?", "Africa", ["Asia", "Australia", "South America"], "The Sahara Desert is located in North Africa."),
            ("What is the smallest country in the world?", "Vatican City", ["Monaco", "San Marino", "Liechtenstein"], "Vatican City is the smallest country with an area of 0.44 square kilometers."),
            ("Which mountain range separates Europe and Asia?", "Ural Mountains", ["Alps", "Himalayas", "Rockies"], "The Ural Mountains form a natural boundary between Europe and Asia."),
            ("What is the capital of Japan?", "Tokyo", ["Kyoto", "Osaka", "Hiroshima"], "Tokyo is the capital and most populous city of Japan."),
            ("Which country has the most natural lakes?", "Canada", ["USA", "Russia", "Finland"], "Canada has more natural lakes than any other country in the world."),
            ("What is the largest island in the world?", "Greenland", ["New Guinea", "Borneo", "Madagascar"], "Greenland is the world's largest island with an area of 2.16 million km²."),
            ("Which river flows through London?", "Thames", ["Seine", "Rhine", "Danube"], "The River Thames flows through London and southern England."),
            ("What is the capital of Australia?", "Canberra", ["Sydney", "Melbourne", "Brisbane"], "Canberra is the capital city of Australia, not Sydney."),
            ("Which desert is the driest in the world?", "Atacama Desert", ["Sahara Desert", "Gobi Desert", "Kalahari Desert"], "The Atacama Desert in Chile is the driest non-polar desert on Earth."),
            ("What is the tallest mountain in North America?", "Denali", ["Mount Logan", "Mount Whitney", "Pikes Peak"], "Denali (formerly Mount McKinley) in Alaska is North America's highest peak at 6,190 m."),
            ("Which sea is the saltiest?", "Dead Sea", ["Red Sea", "Mediterranean Sea", "Baltic Sea"], "The Dead Sea has a salinity of about 34%, making it one of the saltiest bodies of water."),
            ("What is the capital of Canada?", "Ottawa", ["Toronto", "Montreal", "Vancouver"], "Ottawa is the capital city of Canada, located in Ontario."),
            ("Which continent has no permanent human population?", "Antarctica", ["Arctic", "Greenland", "Iceland"], "Antarctica has no permanent human residents, only research station personnel."),
            ("What is the largest country by land area?", "Russia", ["Canada", "China", "United States"], "Russia is the largest country with an area of 17.1 million km²."),
            ("Which waterfall is the tallest in the world?", "Angel Falls", ["Niagara Falls", "Victoria Falls", "Iguazu Falls"], "Angel Falls in Venezuela is the world's tallest waterfall at 979 meters."),
            ("What is the capital of Brazil?", "Brasília", ["Rio de Janeiro", "São Paulo", "Salvador"], "Brasília has been the capital of Brazil since 1960."),
            ("Which strait separates Africa from Europe?", "Strait of Gibraltar", ["Bosphorus Strait", "Strait of Hormuz", "Bering Strait"], "The Strait of Gibraltar separates Spain from Morocco."),
        ],
        "medium": [
            ("What is the deepest point in the ocean?", "Mariana Trench", ["Puerto Rico Trench", "Java Trench", "Philippine Trench"], "The Mariana Trench reaches a depth of about 11,000 meters."),
            ("Which African country was formerly known as Abyssinia?", "Ethiopia", ["Eritrea", "Somalia", "Sudan"], "Ethiopia was historically known as Abyssinia."),
            ("What is the only country that borders both the Atlantic and Indian Oceans?", "South Africa", ["Namibia", "Mozambique", "Tanzania"], "South Africa's coastline touches both the Atlantic and Indian Oceans."),
            ("Which city is located on two continents?", "Istanbul", ["Cairo", "Moscow", "Jerusalem"], "Istanbul straddles both Europe and Asia across the Bosphorus Strait."),
            ("What is the largest lake in Africa?", "Lake Victoria", ["Lake Tanganyika", "Lake Malawi", "Lake Chad"], "Lake Victoria is Africa's largest lake by area."),
            ("Which country has the most time zones?", "France", ["Russia", "United States", "Australia"], "France has 12 time zones due to its overseas territories."),
            ("What is the highest capital city in the world?", "La Paz", ["Quito", "Bogotá", "Addis Ababa"], "La Paz, Bolivia sits at 3,640 meters above sea level."),
            ("Which European country has the longest coastline?", "Norway", ["Greece", "Italy", "United Kingdom"], "Norway has a coastline of about 25,000 km including fjords."),
            ("What is the largest desert in Asia?", "Gobi Desert", ["Arabian Desert", "Thar Desert", "Karakum Desert"], "The Gobi Desert spans parts of China and Mongolia."),
            ("Which river forms part of the border between Mexico and the United States?", "Rio Grande", ["Colorado River", "Columbia River", "Mississippi River"], "The Rio Grande forms a natural border between Texas and Mexico."),
            ("What is the smallest ocean?", "Arctic Ocean", ["Southern Ocean", "Indian Ocean", "Atlantic Ocean"], "The Arctic Ocean is the smallest and shallowest of the world's oceans."),
            ("Which country is known as the Land of a Thousand Lakes?", "Finland", ["Sweden", "Norway", "Canada"], "Finland has approximately 188,000 lakes."),
            ("What is the longest mountain range in the world?", "Andes", ["Rockies", "Himalayas", "Alps"], "The Andes stretch about 7,000 km along South America's western coast."),
            ("Which sea has no coastline?", "Sargasso Sea", ["Dead Sea", "Caspian Sea", "Aral Sea"], "The Sargasso Sea is bounded by ocean currents rather than land."),
            ("What is the largest peninsula in the world?", "Arabian Peninsula", ["Indian Peninsula", "Iberian Peninsula", "Indochina Peninsula"], "The Arabian Peninsula covers about 3.2 million km²."),
            ("Which country has the most volcanoes?", "Indonesia", ["Japan", "Philippines", "Chile"], "Indonesia has more than 130 active volcanoes."),
            ("What is the southernmost capital city in the world?", "Wellington", ["Canberra", "Buenos Aires", "Cape Town"], "Wellington, New Zealand is the southernmost capital city."),
            ("Which lake is the deepest in the world?", "Lake Baikal", ["Lake Tanganyika", "Crater Lake", "Lake Superior"], "Lake Baikal in Russia reaches depths of 1,642 meters."),
            ("What is the largest gulf in the world?", "Gulf of Mexico", ["Persian Gulf", "Gulf of Alaska", "Bay of Bengal"], "The Gulf of Mexico has an area of about 1.6 million km²."),
            ("Which country is the flattest on Earth?", "Maldives", ["Netherlands", "Denmark", "Bangladesh"], "The Maldives has an average elevation of just 1.5 meters above sea level."),
        ],
        "hard": [
            ("What is the tripoint where Argentina, Brazil, and Paraguay meet?", "Triple Frontier", ["Tri-Border Area", "Three Nations Point", "Southern Junction"], "The Triple Frontier is where the Iguazu and Paraná rivers converge."),
            ("Which country has the most UNESCO World Heritage Sites?", "Italy", ["China", "Spain", "France"], "Italy has 58 UNESCO World Heritage Sites as of 2023."),
            ("What is the only sea without any coastline?", "Sargasso Sea", ["Dead Sea", "Aral Sea", "Salton Sea"], "The Sargasso Sea is defined by ocean currents in the North Atlantic."),
            ("Which African country has Spanish as an official language?", "Equatorial Guinea", ["Western Sahara", "Morocco", "Angola"], "Equatorial Guinea is the only African country with Spanish as an official language."),
            ("What is the most remote inhabited island in the world?", "Tristan da Cunha", ["Easter Island", "Pitcairn Islands", "St. Helena"], "Tristan da Cunha is 2,400 km from the nearest inhabited land."),
            ("Which country has the highest percentage of its land covered by forests?", "Suriname", ["Finland", "Gabon", "Sweden"], "About 93% of Suriname is covered by forests."),
            ("What is the only country that lies entirely above 1,000 meters elevation?", "Lesotho", ["Bhutan", "Andorra", "Nepal"], "Lesotho is the only country entirely above 1,000 meters."),
            ("Which strait separates New Zealand's North and South Islands?", "Cook Strait", ["Bass Strait", "Torres Strait", "Foveaux Strait"], "Cook Strait was named after Captain James Cook."),
            ("What is the largest landlocked country in the world?", "Kazakhstan", ["Mongolia", "Chad", "Niger"], "Kazakhstan has an area of 2.7 million km² with no ocean access."),
            ("Which country has the most islands?", "Sweden", ["Finland", "Norway", "Canada"], "Sweden has approximately 267,570 islands."),
            ("What is the only country with a non-rectangular flag?", "Nepal", ["Switzerland", "Vatican City", "Monaco"], "Nepal's flag consists of two stacked triangular pennants."),
            ("Which river has the largest drainage basin?", "Amazon River", ["Congo River", "Mississippi River", "Nile River"], "The Amazon basin covers about 7 million km²."),
            ("What is the lowest point on Earth's land surface?", "Dead Sea shore", ["Death Valley", "Lake Assal", "Turpan Depression"], "The Dead Sea shore is 430 meters below sea level."),
            ("Which country has the longest land border with China?", "Mongolia", ["Russia", "India", "Kazakhstan"], "Mongolia shares a 4,677 km border with China."),
            ("What is the only country that borders both the Caspian Sea and the Persian Gulf?", "Iran", ["Azerbaijan", "Turkmenistan", "Iraq"], "Iran has coastlines on both the Caspian Sea and Persian Gulf."),
            ("Which European country has the most lakes?", "Finland", ["Sweden", "Norway", "Russia"], "Finland has about 188,000 lakes larger than 500 m²."),
            ("What is the largest atoll in the world?", "Kwajalein Atoll", ["Maldives Atoll", "Rangiroa", "Aldabra"], "Kwajalein Atoll in the Marshall Islands has a land area of 16.4 km²."),
            ("Which country has the most pyramids?", "Sudan", ["Egypt", "Mexico", "Peru"], "Sudan has approximately 255 pyramids, more than Egypt."),
            ("What is the only river that flows both north and south of the equator?", "Congo River", ["Amazon River", "Nile River", "Niger River"], "The Congo River crosses the equator twice."),
            ("Which country has the highest number of active volcanoes per square kilometer?", "Iceland", ["Japan", "Indonesia", "Philippines"], "Iceland has about 30 active volcanic systems in a relatively small area."),
        ],
    },
}

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

def main():
    """Generate all questions in Dart format"""
    print("// AUTO-GENERATED QUIZ QUESTIONS")
    print("// Add these to the localQuestions list in local_questions.dart\n")
    
    all_questions = []
    stats = {}
    
    for category, difficulties in QUESTIONS.items():
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
    print(f"// GRAND TOTAL: {total} questions")

if __name__ == "__main__":
    main()
