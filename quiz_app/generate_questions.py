#!/usr/bin/env python3
"""
Generate quiz questions for all categories to reach 20 questions per difficulty level.
"""

# Question templates for each category
CATEGORY_QUESTIONS = {
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
            ("Who wrote 'The Communist Manifesto'?", "Karl Marx and Friedrich Engels", ["Vladimir Lenin", "Joseph Stalin", "Leon Trotsky"], "Karl Marx and Friedrich Engels wrote 'The Communist Manifesto' in 1848."),
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
            ("Who was the first Pharaoh of unified Egypt?", "Narmer (Menes)", ["Khufu", "Ramesses II", "Tutankhamun"], "Narmer (also known as Menes) is credited with unifying Egypt around 3100 BC."),
            ("What year did the Glorious Revolution occur in England?", "1688", ["1642", "1660", "1707"], "The Glorious Revolution of 1688 overthrew King James II of England."),
            ("Who was the founder of the Achaemenid Persian Empire?", "Cyrus the Great", ["Darius I", "Xerxes I", "Artaxerxes I"], "Cyrus the Great founded the Achaemenid Persian Empire in 550 BC."),
        ],
    },
}

# Print a sample to verify
if __name__ == "__main__":
    print("Sample questions generated successfully!")
    print(f"History Easy: {len(CATEGORY_QUESTIONS['History']['easy'])} questions")
    print(f"History Medium: {len(CATEGORY_QUESTIONS['History']['medium'])} questions")
    print(f"History Hard: {len(CATEGORY_QUESTIONS['History']['hard'])} questions")
