#!/usr/bin/env python3
"""
CULTURE BATCH GENERATOR - Film, Music, Art
Generates ~150 questions for these 3 categories
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
# ENTERTAINMENT: FILM - Need 19 easy, 17 medium, 18 hard (54 total)
# ============================================================================
cat = "Entertainment: Film"

# Easy (19)
film_easy = [
    ("Who painted the portrait of Rose in 'Titanic'?", "James Cameron", ["Leonardo DiCaprio", "Kate Winslet", "Billy Zane"], "Director James Cameron actually drew the sketch of Rose wearing the Heart of the Ocean."),
    ("What was the first feature-length animated movie?", "Snow White and the Seven Dwarfs", ["Fantasia", "Bambi", "Pinocchio"], "Released in 1937, Snow White and the Seven Dwarfs was the first full-length cel-animated feature."),
    ("In 'Finding Nemo', what type of fish is Nemo?", "Clownfish", ["Goldfish", "Pufferfish", "Blue Tang"], "Nemo and his father Marlin are clownfish."),
    ("What is the name of the cowboy in 'Toy Story'?", "Woody", ["Buzz", "Andy", "Sid"], "Sheriff Woody is the cowboy doll and Andy's favorite toy."),
    ("Who played the character of Harry Potter?", "Daniel Radcliffe", ["Rupert Grint", "Tom Felton", "Elijah Wood"], "Daniel Radcliffe played the title character in the Harry Potter film series."),
    ("What color is the pill that Neo takes in 'The Matrix'?", "Red", ["Blue", "Green", "Yellow"], "Neo takes the red pill to see how deep the rabbit hole goes."),
    ("Which movie features a character named Darth Vader?", "Star Wars", ["Star Trek", "Alien", "Blade Runner"], "Darth Vader is the primary antagonist in the original Star Wars trilogy."),
    ("What animal is the main character in 'Ratatouille'?", "Rat", ["Mouse", "Hamster", "Guinea Pig"], "Remy, the main character in Ratatouille, is a rat who dreams of becoming a chef."),
    ("Who is the voice of the Genie in 'Aladdin' (1992)?", "Robin Williams", ["Eddie Murphy", "Will Smith", "Jim Carrey"], "Robin Williams provided the iconic voice for the Genie."),
    ("What is the name of Shrek's wife?", "Fiona", ["Farquaad", "Dragon", "Snow White"], "Princess Fiona is Shrek's wife."),
    ("In 'The Lion King', who is Simba's father?", "Mufasa", ["Scar", "Timon", "Rafiki"], "Mufasa is the King of the Pride Lands and Simba's father."),
    ("Which superhero is known as the 'Man of Steel'?", "Superman", ["Batman", "Iron Man", "Spider-Man"], "Superman is often referred to as the Man of Steel."),
    ("What kind of dinosaur is the main attraction in 'Jurassic Park'?", "T-Rex", ["Velociraptor", "Triceratops", "Brachiosaurus"], "The Tyrannosaurus Rex is the most fearsome dinosaur in the park."),
    ("Who directed 'E.T. the Extra-Terrestrial'?", "Steven Spielberg", ["George Lucas", "James Cameron", "Tim Burton"], "Steven Spielberg directed the 1982 classic E.T."),
    ("What is the name of the hobbit played by Elijah Wood?", "Frodo Baggins", ["Samwise Gamgee", "Bilbo Baggins", "Merry Brandybuck"], "Elijah Wood plays Frodo Baggins in The Lord of the Rings trilogy."),
    ("Which movie features the song 'Let It Go'?", "Frozen", ["Moana", "Tangled", "Brave"], "Let It Go is the hit song from Disney's Frozen."),
    ("Who plays Jack Sparrow in 'Pirates of the Caribbean'?", "Johnny Depp", ["Orlando Bloom", "Brad Pitt", "Tom Cruise"], "Johnny Depp famously portrays Captain Jack Sparrow."),
    ("What is the name of the fictional country in 'Black Panther'?", "Wakanda", ["Zamunda", "Genosha", "Latveria"], "Black Panther is set in the technologically advanced African nation of Wakanda."),
    ("In 'Back to the Future', what type of car is the time machine?", "DeLorean", ["Mustang", "Corvette", "Ferrari"], "Doc Brown builds a time machine out of a DeLorean DMC-12."),
]

# Medium (17)
film_medium = [
    ("What are the dying words of Charles Foster Kane?", "Rosebud", ["Xanadu", "Susan", "Mother"], "Kane's dying word, 'Rosebud', drives the plot of Citizen Kane."),
    ("What 1927 musical was the first 'talkie'?", "The Jazz Singer", ["Singin' in the Rain", "The Wizard of Oz", "Metropolis"], "The Jazz Singer was the first feature-length motion picture with synchronized dialogue."),
    ("What fictional mineral was sought in 'Avatar'?", "Unobtainium", ["Kryptonite", "Vibranium", "Adamantium"], "The humans in Avatar are mining for a mineral called Unobtainium."),
    ("In which film do people stop aging at 25?", "In Time", ["Looper", "Surrogates", "Gattaca"], "In the movie In Time, time is currency and people stop aging at 25."),
    ("Who directed 'Pulp Fiction'?", "Quentin Tarantino", ["Martin Scorsese", "Stanley Kubrick", "Francis Ford Coppola"], "Quentin Tarantino directed the 1994 cult classic Pulp Fiction."),
    ("Which movie won the first Best Animated Feature Oscar?", "Shrek", ["Toy Story", "Monsters, Inc.", "Ice Age"], "Shrek won the first Academy Award for Best Animated Feature in 2001."),
    ("What is the name of the island in 'Jurassic Park'?", "Isla Nublar", ["Isla Sorna", "Skull Island", "Shutter Island"], "Jurassic Park is built on the fictional island of Isla Nublar."),
    ("Who played the Joker in 'The Dark Knight'?", "Heath Ledger", ["Jack Nicholson", "Jared Leto", "Joaquin Phoenix"], "Heath Ledger won a posthumous Oscar for his portrayal of the Joker."),
    ("What is the highest-grossing film of all time (unadjusted)?", "Avatar", ["Avengers: Endgame", "Titanic", "Star Wars: The Force Awakens"], "Avatar holds the record for the highest-grossing film worldwide."),
    ("In 'The Matrix', what is the name of the ship?", "Nebuchadnezzar", ["Enterprise", "Millennium Falcon", "Serenity"], "Morpheus captains the hovercraft Nebuchadnezzar."),
    ("Which film features the quote 'You can't handle the truth!'?", "A Few Good Men", ["Top Gun", "Rain Man", "The Firm"], "Jack Nicholson delivers this famous line in A Few Good Men."),
    ("Who directed 'The Godfather'?", "Francis Ford Coppola", ["Martin Scorsese", "Sergio Leone", "Brian De Palma"], "Francis Ford Coppola directed the crime masterpiece The Godfather."),
    ("What is the name of the hotel in 'The Shining'?", "Overlook Hotel", ["Bates Motel", "Hotel California", "Grand Budapest Hotel"], "The Shining takes place at the isolated Overlook Hotel."),
    ("Which movie stars Tom Hanks as a castaway?", "Cast Away", ["The Terminal", "Captain Phillips", "Sully"], "Tom Hanks plays a FedEx employee stranded on an island in Cast Away."),
    ("What is the name of the fictional company in 'RoboCop'?", "OCP", ["Cyberdyne", "Weyland-Yutani", "Umbrella Corp"], "Omni Consumer Products (OCP) is the mega-corporation in RoboCop."),
    ("Who played the lead role in 'Forrest Gump'?", "Tom Hanks", ["Robin Williams", "Kevin Costner", "John Travolta"], "Tom Hanks won an Oscar for his role as Forrest Gump."),
    ("Which film is set in the fictional city of Metropolis?", "Metropolis", ["Blade Runner", "Dark City", "Brazil"], "Fritz Lang's 1927 masterpiece is set in the futuristic city of Metropolis (also Superman's home)."),
]

# Hard (18)
film_hard = [
    ("What was the first horror movie to win Best Picture?", "The Silence of the Lambs", ["The Exorcist", "Jaws", "Get Out"], "The Silence of the Lambs (1991) is the only horror film to win the Best Picture Oscar."),
    ("What was the first sports film to win Best Picture?", "Rocky", ["Chariots of Fire", "Million Dollar Baby", "Raging Bull"], "Rocky (1976) was the first sports movie to win the Academy Award for Best Picture."),
    ("What is the number on the bus roof in 'Speed'?", "2525", ["101", "33", "5050"], "The number 2525 is visible on the roof of the bus in the movie Speed."),
    ("Which director has won the most Best Director Oscars?", "John Ford", ["Steven Spielberg", "Frank Capra", "William Wyler"], "John Ford won the Academy Award for Best Director four times."),
    ("Who was the first film critic to win a Pulitzer Prize?", "Roger Ebert", ["Gene Siskel", "Pauline Kael", "Leonard Maltin"], "Roger Ebert became the first film critic to win the Pulitzer Prize for Criticism in 1975."),
    ("What is the name of the sled in 'Citizen Kane'?", "Rosebud", ["Snowy", "Lightning", "Thunder"], "Rosebud is the trade name of the sled Kane had as a child."),
    ("Which film won the 'Big Five' Academy Awards in 1975?", "One Flew Over the Cuckoo's Nest", ["The Godfather Part II", "Network", "Chinatown"], "It won Best Picture, Director, Actor, Actress, and Screenplay."),
    ("Who is the only actor to win three Best Actor Oscars?", "Daniel Day-Lewis", ["Jack Nicholson", "Marlon Brando", "Tom Hanks"], "Daniel Day-Lewis won Best Actor for My Left Foot, There Will Be Blood, and Lincoln."),
    ("What was the first PG-13 movie?", "Red Dawn", ["Indiana Jones and the Temple of Doom", "Gremlins", "Ghostbusters"], "Red Dawn (1984) was the first film released with the PG-13 rating."),
    ("Who voiced the computer HAL 9000 in '2001: A Space Odyssey'?", "Douglas Rain", ["Arthur C. Clarke", "Stanley Kubrick", "Keir Dullea"], "Douglas Rain provided the calm, chilling voice of HAL 9000."),
    ("In 'Casablanca', what is the name of the cafe?", "Rick's Café Américain", ["The Blue Parrot", "La Belle Aurore", "Café de Paris"], "Humphrey Bogart's character owns Rick's Café Américain."),
    ("Which film features the 'Odessa Steps' sequence?", "Battleship Potemkin", ["October", "Strike", "Mother"], "Sergei Eisenstein's Battleship Potemkin features the famous montage on the Odessa Steps."),
    ("Who directed 'The Seventh Seal'?", "Ingmar Bergman", ["Federico Fellini", "Akira Kurosawa", "Jean-Luc Godard"], "Swedish director Ingmar Bergman directed The Seventh Seal."),
    ("What is the name of the demon in 'The Exorcist'?", "Pazuzu", ["Azazel", "Beelzebub", "Mammon"], "The demon that possesses Regan MacNeil is named Pazuzu."),
    ("Which movie was falsely advertised as a true story?", "Fargo", ["The Blair Witch Project", "Paranormal Activity", "Texas Chainsaw Massacre"], "The Coen Brothers' Fargo claims to be a true story, but it is entirely fictional."),
    ("Who played the Wicked Witch of the West in 'The Wizard of Oz'?", "Margaret Hamilton", ["Judy Garland", "Billie Burke", "Agnes Moorehead"], "Margaret Hamilton played the iconic villain."),
    ("What is the name of the fictional language in 'Avatar'?", "Na'vi", ["Klingon", "Elvish", "Dothraki"], "The language spoken by the indigenous people of Pandora is Na'vi."),
    ("Which Alfred Hitchcock film was shot to look like one continuous take?", "Rope", ["Rear Window", "Vertigo", "Psycho"], "Rope (1948) was edited to appear as a single continuous shot."),
]

# ============================================================================
# MUSIC - Need 17 easy, 15 medium, 18 hard (50 total)
# ============================================================================
cat = "Music"

# Easy (17)
music_easy = [
    ("Who was the first American Idol winner?", "Kelly Clarkson", ["Carrie Underwood", "Fantasia", "Ruben Studdard"], "Kelly Clarkson won the first season of American Idol in 2002."),
    ("Which British band recorded 'Hey Jude'?", "The Beatles", ["The Rolling Stones", "The Who", "Queen"], "The Beatles released 'Hey Jude' in 1968."),
    ("Who sings 'Man! I Feel Like a Woman'?", "Shania Twain", ["Faith Hill", "Dolly Parton", "Reba McEntire"], "Shania Twain released this hit country-pop song in 1999."),
    ("Which country are ABBA from?", "Sweden", ["Norway", "Denmark", "Germany"], "ABBA is a Swedish pop supergroup formed in Stockholm."),
    ("Who is known as the 'King of Pop'?", "Michael Jackson", ["Elvis Presley", "Prince", "Madonna"], "Michael Jackson is globally referred to as the King of Pop."),
    ("How many strings does a standard guitar have?", "6", ["4", "5", "7"], "A standard guitar has 6 strings."),
    ("Who sang 'I Will Always Love You' in 'The Bodyguard'?", "Whitney Houston", ["Mariah Carey", "Celine Dion", "Dolly Parton"], "Whitney Houston's cover became one of the best-selling singles of all time."),
    ("Which band performs 'Bohemian Rhapsody'?", "Queen", ["Led Zeppelin", "Pink Floyd", "The Beatles"], "Queen released the operatic rock masterpiece 'Bohemian Rhapsody'."),
    ("Who is the lead singer of U2?", "Bono", ["The Edge", "Sting", "Mick Jagger"], "Bono is the lead vocalist of the Irish rock band U2."),
    ("What instrument does Lizzo play?", "Flute", ["Violin", "Piano", "Saxophone"], "Lizzo is a classically trained flutist."),
    ("Who released the album '1989'?", "Taylor Swift", ["Katy Perry", "Adele", "Ariana Grande"], "Taylor Swift released the pop album '1989' in 2014."),
    ("Which Beatle was known as 'The Cute One'?", "Paul McCartney", ["John Lennon", "George Harrison", "Ringo Starr"], "Paul McCartney was often called 'The Cute One' by fans and press."),
    ("What is the name of the spice girl known as 'Baby Spice'?", "Emma Bunton", ["Geri Halliwell", "Victoria Beckham", "Mel B"], "Emma Bunton is known as Baby Spice."),
    ("Who sang 'Rolling in the Deep'?", "Adele", ["Beyoncé", "Rihanna", "Lady Gaga"], "Adele had a massive global hit with 'Rolling in the Deep'."),
    ("What genre of music is Bob Marley associated with?", "Reggae", ["Jazz", "Blues", "Rock"], "Bob Marley is the most famous pioneer of Reggae music."),
    ("Which pop star is known as the 'Material Girl'?", "Madonna", ["Cyndi Lauper", "Cher", "Britney Spears"], "Madonna is often referred to as the Material Girl after her hit song."),
    ("Who is the rapper behind 'Lose Yourself'?", "Eminem", ["Jay-Z", "Kanye West", "Drake"], "Eminem won an Oscar for 'Lose Yourself' from the movie 8 Mile."),
]

# Medium (15)
music_medium = [
    ("What was Freddie Mercury's real name?", "Farrokh Bulsara", ["Rami Malek", "Brian May", "Roger Taylor"], "Freddie Mercury was born Farrokh Bulsara in Zanzibar."),
    ("What was the first music video on MTV?", "Video Killed the Radio Star", ["Money for Nothing", "Take on Me", "Thriller"], "The Buggles' 'Video Killed the Radio Star' launched MTV in 1981."),
    ("Stevie Nicks is a member of which band?", "Fleetwood Mac", ["Heart", "The Bangles", "Blondie"], "Stevie Nicks joined Fleetwood Mac in 1975."),
    ("What is Beyoncé's fanbase called?", "The Beyhive", ["The Navy", "Little Monsters", "Swifties"], "Beyoncé's dedicated fans are known as the Beyhive."),
    ("Which band released the album 'Dark Side of the Moon'?", "Pink Floyd", ["Led Zeppelin", "The Doors", "The Who"], "Pink Floyd's 'Dark Side of the Moon' is one of the best-selling albums ever."),
    ("Who is the drummer for The Beatles?", "Ringo Starr", ["John Bonham", "Keith Moon", "Charlie Watts"], "Ringo Starr was the drummer for The Beatles."),
    ("Which artist is known as 'The Boss'?", "Bruce Springsteen", ["Billy Joel", "Tom Petty", "Bob Seger"], "Bruce Springsteen is nicknamed 'The Boss'."),
    ("What is the real name of Lady Gaga?", "Stefani Germanotta", ["Katheryn Hudson", "Robyn Fenty", "Onika Maraj"], "Lady Gaga was born Stefani Joanne Angelina Germanotta."),
    ("Which city is considered the birthplace of Jazz?", "New Orleans", ["Chicago", "New York", "Memphis"], "New Orleans is widely recognized as the birthplace of Jazz."),
    ("Who wrote the song 'Hallelujah'?", "Leonard Cohen", ["Jeff Buckley", "Bob Dylan", "Paul Simon"], "Leonard Cohen wrote and originally performed 'Hallelujah'."),
    ("Which band has a logo featuring a tongue and lips?", "The Rolling Stones", ["KISS", "Aerosmith", "Nirvana"], "The 'Tongue and Lips' logo is synonymous with The Rolling Stones."),
    ("Who was the lead singer of Nirvana?", "Kurt Cobain", ["Dave Grohl", "Eddie Vedder", "Chris Cornell"], "Kurt Cobain was the frontman of the grunge band Nirvana."),
    ("What is the best-selling album of all time?", "Thriller", ["Back in Black", "The Bodyguard", "Eagles' Greatest Hits"], "Michael Jackson's 'Thriller' is the best-selling album in history."),
    ("Which classical composer was deaf in his later years?", "Ludwig van Beethoven", ["Wolfgang Amadeus Mozart", "Johann Sebastian Bach", "Frederic Chopin"], "Beethoven composed some of his greatest works while almost completely deaf."),
    ("Who is the 'Godfather of Soul'?", "James Brown", ["Ray Charles", "Otis Redding", "Sam Cooke"], "James Brown is known as the Godfather of Soul."),
]

# Hard (18)
music_hard = [
    ("Who was the first woman inducted into the Rock and Roll Hall of Fame?", "Aretha Franklin", ["Janis Joplin", "Tina Turner", "Diana Ross"], "Aretha Franklin was the first woman inducted in 1987."),
    ("What artists made up The Traveling Wilburys?", "Harrison, Orbison, Lynne, Petty, Dylan", ["Lennon, McCartney, Starr, Harrison", "Jagger, Richards, Watts, Wood", "Bono, Edge, Clayton, Mullen"], "The supergroup consisted of George Harrison, Roy Orbison, Jeff Lynne, Tom Petty, and Bob Dylan."),
    ("What was the first band to have a billboard album ad?", "The Doors", ["The Beatles", "The Rolling Stones", "The Who"], "The Doors were the first band to advertise an album on a billboard in LA."),
    ("Who taught Paul McCartney 'everything he knows'?", "Little Richard", ["Chuck Berry", "Buddy Holly", "Elvis Presley"], "Paul McCartney has credited Little Richard as a major influence."),
    ("What is the only band to have a diamond album in 4 different decades?", "Aerosmith", ["The Rolling Stones", "U2", "Metallica"], "Aerosmith has had diamond or multi-platinum success across four decades."),
    ("Which composer wrote 'The Four Seasons'?", "Antonio Vivaldi", ["Johann Sebastian Bach", "George Frideric Handel", "Claudio Monteverdi"], "Vivaldi wrote the famous violin concertos 'The Four Seasons'."),
    ("What is the name of the scale with five notes?", "Pentatonic", ["Diatonic", "Chromatic", "Whole Tone"], "The pentatonic scale consists of five notes per octave."),
    ("Who was the original drummer for The Beatles before Ringo?", "Pete Best", ["Stuart Sutcliffe", "Andy White", "Jimmy Nicol"], "Pete Best was the drummer before being replaced by Ringo Starr."),
    ("Which Pink Floyd album features a flying pig on the cover?", "Animals", ["The Wall", "Wish You Were Here", "Meddle"], "The cover of 'Animals' depicts a pig floating between the chimneys of Battersea Power Station."),
    ("Who is the only artist to have a number one single in six consecutive decades?", "Cher", ["Madonna", "Elton John", "Barbra Streisand"], "Cher has had a #1 single on a Billboard chart in six consecutive decades."),
    ("What is the longest-running Broadway show?", "The Phantom of the Opera", ["Chicago", "The Lion King", "Cats"], "The Phantom of the Opera is the longest-running show in Broadway history."),
    ("Which rapper's real name is Marshall Mathers?", "Eminem", ["50 Cent", "Dr. Dre", "Snoop Dogg"], "Eminem's birth name is Marshall Bruce Mathers III."),
    ("Who composed the 'Ring Cycle' operas?", "Richard Wagner", ["Giuseppe Verdi", "Giacomo Puccini", "Richard Strauss"], "Richard Wagner composed the epic four-opera cycle 'Der Ring des Nibelungen'."),
    ("What year was Woodstock held?", "1969", ["1967", "1970", "1971"], "The Woodstock Music & Art Fair took place in August 1969."),
    ("Who was the bassist for Metallica who died in 1986?", "Cliff Burton", ["Jason Newsted", "Robert Trujillo", "Dave Mustaine"], "Cliff Burton died in a tragic bus accident in Sweden."),
    ("Which jazz musician was nicknamed 'Bird'?", "Charlie Parker", ["Dizzy Gillespie", "Miles Davis", "John Coltrane"], "Saxophonist Charlie Parker was known as 'Bird' or 'Yardbird'."),
    ("What is the name of the final unfinished symphony by Mozart?", "Requiem", ["Symphony No. 40", "The Magic Flute", "Don Giovanni"], "Mozart died before completing his Requiem Mass in D minor."),
    ("Who recorded the best-selling jazz album of all time, 'Kind of Blue'?", "Miles Davis", ["John Coltrane", "Dave Brubeck", "Duke Ellington"], "Miles Davis's 'Kind of Blue' is the best-selling jazz record ever."),
]

# ============================================================================
# ART - Need 18 easy, 11 medium, 17 hard (46 total)
# ============================================================================
cat = "Art"

# Easy (18)
art_easy = [
    ("Who painted the 'Mona Lisa'?", "Leonardo da Vinci", ["Michelangelo", "Raphael", "Donatello"], "Leonardo da Vinci painted the Mona Lisa in the early 16th century."),
    ("In which city is The Louvre museum located?", "Paris", ["London", "Rome", "New York"], "The Louvre is located in Paris, France."),
    ("Who painted 'The Starry Night'?", "Vincent van Gogh", ["Claude Monet", "Pablo Picasso", "Salvador Dalí"], "Vincent van Gogh painted The Starry Night in 1889."),
    ("Which artist is known for painting Campbell's Soup Cans?", "Andy Warhol", ["Jackson Pollock", "Roy Lichtenstein", "Keith Haring"], "Andy Warhol is a leading figure in the Pop Art movement."),
    ("Who sculpted the statue of David?", "Michelangelo", ["Bernini", "Rodin", "Donatello"], "Michelangelo created the marble statue of David."),
    ("What art style is Pablo Picasso famous for co-founding?", "Cubism", ["Impressionism", "Surrealism", "Realism"], "Picasso co-founded the Cubist movement."),
    ("Who painted the ceiling of the Sistine Chapel?", "Michelangelo", ["Leonardo da Vinci", "Raphael", "Botticelli"], "Michelangelo painted the Sistine Chapel ceiling between 1508 and 1512."),
    ("What is the primary color mixed with red to make orange?", "Yellow", ["Blue", "Green", "White"], "Red and yellow are primary colors that mix to create orange."),
    ("Which Mexican artist is known for her self-portraits?", "Frida Kahlo", ["Diego Rivera", "Georgia O'Keeffe", "Mary Cassatt"], "Frida Kahlo is famous for her many self-portraits."),
    ("What is the name of the famous screaming figure painting?", "The Scream", ["The Cry", "The Shout", "The Fear"], "Edvard Munch painted The Scream."),
    ("Who painted 'The Last Supper'?", "Leonardo da Vinci", ["Michelangelo", "Rembrandt", "Caravaggio"], "Leonardo da Vinci painted The Last Supper mural."),
    ("What flower did Vincent van Gogh paint a series of?", "Sunflowers", ["Roses", "Lilies", "Tulips"], "Van Gogh is famous for his series of Sunflowers."),
    ("Which artist cut off part of his own ear?", "Vincent van Gogh", ["Paul Gauguin", "Claude Monet", "Salvador Dalí"], "Van Gogh famously severed part of his left ear."),
    ("What is the art of folding paper called?", "Origami", ["Kirigami", "Calligraphy", "Ikebana"], "Origami is the Japanese art of paper folding."),
    ("Who painted 'The Birth of Venus'?", "Sandro Botticelli", ["Titian", "Caravaggio", "Masaccio"], "Botticelli painted The Birth of Venus."),
    ("What is a painting of a person's face called?", "Portrait", ["Landscape", "Still Life", "Abstract"], "A painting of a person's face is called a portrait."),
    ("Which artist is known for melting clocks?", "Salvador Dalí", ["René Magritte", "Max Ernst", "Joan Miró"], "Dalí's 'The Persistence of Memory' features melting clocks."),
    ("What color do you get when you mix blue and yellow?", "Green", ["Purple", "Orange", "Brown"], "Blue and yellow mix to create green."),
]

# Medium (11)
art_medium = [
    ("Which painting features a farmer holding a pitchfork?", "American Gothic", ["The Gleaners", "Nighthawks", "Whistler's Mother"], "Grant Wood painted American Gothic."),
    ("Who is known for his 'Water Lilies' series?", "Claude Monet", ["Edouard Manet", "Pierre-Auguste Renoir", "Edgar Degas"], "Monet painted approximately 250 oil paintings of water lilies."),
    ("What technique uses tiny dots to create an image?", "Pointillism", ["Cubism", "Fauvism", "Dadaism"], "Pointillism uses small, distinct dots of color applied in patterns."),
    ("Who painted 'Girl with a Pearl Earring'?", "Johannes Vermeer", ["Rembrandt", "Jan van Eyck", "Peter Paul Rubens"], "Vermeer painted the Girl with a Pearl Earring."),
    ("Which artist is known for his drip paintings?", "Jackson Pollock", ["Mark Rothko", "Willem de Kooning", "Franz Kline"], "Jackson Pollock was a major figure in the abstract expressionist movement."),
    ("What is the name of the statue without arms in the Louvre?", "Venus de Milo", ["Winged Victory", "The Thinker", "Discobolus"], "The Venus de Milo is an ancient Greek statue depicting Aphrodite."),
    ("Who painted 'Guernica'?", "Pablo Picasso", ["Salvador Dalí", "Francisco Goya", "Joan Miró"], "Picasso painted Guernica as a response to the bombing of Guernica."),
    ("Which art movement is Claude Monet associated with?", "Impressionism", ["Expressionism", "Romanticism", "Baroque"], "Monet was a founder of French Impressionist painting."),
    ("Who created the mobile as a type of kinetic sculpture?", "Alexander Calder", ["Henry Moore", "Alberto Giacometti", "Constantin Brancusi"], "Calder is known for inventing the mobile."),
    ("What is the term for a painting of inanimate objects?", "Still Life", ["Landscape", "Portrait", "Genre"], "A still life depicts mostly inanimate subject matter."),
    ("Which artist is known for his graffiti-inspired works?", "Jean-Michel Basquiat", ["Keith Haring", "Banksy", "Shepard Fairey"], "Basquiat started as a graffiti artist before becoming a neo-expressionist painter."),
]

# Hard (17)
art_hard = [
    ("What was Sandro Botticelli's birth name?", "Alessandro di Mariano di Vanni Filipepi", ["Leonardo da Vinci", "Michelangelo Buonarroti", "Raffaello Sanzio"], "Botticelli was born Alessandro di Mariano di Vanni Filipepi."),
    ("What exotic pet did Salvador Dalí own?", "Ocelot", ["Tiger", "Cheetah", "Leopard"], "Dalí had a pet ocelot named Babou."),
    ("How many times has the Mona Lisa been stolen?", "Once", ["Twice", "Three times", "Never"], "It was stolen once in 1911 by Vincenzo Peruggia."),
    ("Who designed the Statue of Liberty?", "Frédéric Auguste Bartholdi", ["Gustave Eiffel", "Auguste Rodin", "Claude Monet"], "Bartholdi designed the statue, while Eiffel designed the framework."),
    ("Which artist is known for 'The Garden of Earthly Delights'?", "Hieronymus Bosch", ["Pieter Bruegel the Elder", "Jan van Eyck", "Albrecht Dürer"], "Bosch painted the famous triptych."),
    ("Who painted 'The Night Watch'?", "Rembrandt", ["Vermeer", "Frans Hals", "Rubens"], "Rembrandt painted The Night Watch in 1642."),
    ("What is the name of the technique used by Da Vinci to create a smoky effect?", "Sfumato", ["Chiaroscuro", "Impasto", "Tenebrism"], "Sfumato is the technique of allowing tones and colors to shade gradually into one another."),
    ("Which artist created the 'Campbell's Soup Cans' series?", "Andy Warhol", ["Roy Lichtenstein", "Jasper Johns", "Robert Rauschenberg"], "Warhol created the series in 1962."),
    ("Who painted 'Las Meninas'?", "Diego Velázquez", ["Francisco Goya", "El Greco", "Bartolomé Esteban Murillo"], "Velázquez painted Las Meninas, a complex and enigmatic composition."),
    ("Which artist is associated with the 'Blue Period'?", "Pablo Picasso", ["Henri Matisse", "Vincent van Gogh", "Paul Cézanne"], "Picasso's Blue Period lasted from 1901 to 1904."),
    ("Who created the sculpture 'The Thinker'?", "Auguste Rodin", ["Camille Claudel", "Constantin Brancusi", "Alberto Giacometti"], "Rodin created The Thinker."),
    ("What movement was Salvador Dalí a part of?", "Surrealism", ["Dada", "Futurism", "Constructivism"], "Dalí was a prominent figure in the Surrealist group."),
    ("Who painted 'The School of Athens'?", "Raphael", ["Michelangelo", "Leonardo da Vinci", "Donatello"], "Raphael painted this fresco in the Vatican."),
    ("Which artist is known for his large-scale photorealistic portraits?", "Chuck Close", ["Richard Estes", "Ralph Goings", "Audrey Flack"], "Chuck Close is famous for his massive photorealistic portraits."),
    ("Who painted 'Nighthawks'?", "Edward Hopper", ["Grant Wood", "Andrew Wyeth", "Thomas Hart Benton"], "Edward Hopper painted the famous diner scene Nighthawks."),
    ("What is the name of the art movement founded by Piet Mondrian?", "De Stijl", ["Bauhaus", "Suprematism", "Constructivism"], "Mondrian was a key member of the De Stijl movement."),
    ("Who painted 'The Kiss' (1907-1908)?", "Gustav Klimt", ["Egon Schiele", "Oskar Kokoschka", "Edvard Munch"], "Gustav Klimt painted the golden masterpiece The Kiss."),
]

for quest, ans, wrong, exp in film_easy:
    all_q.append(q("Entertainment: Film", "easy", quest, ans, wrong, exp))
for quest, ans, wrong, exp in film_medium:
    all_q.append(q("Entertainment: Film", "medium", quest, ans, wrong, exp))
for quest, ans, wrong, exp in film_hard:
    all_q.append(q("Entertainment: Film", "hard", quest, ans, wrong, exp))

for quest, ans, wrong, exp in music_easy:
    all_q.append(q("Music", "easy", quest, ans, wrong, exp))
for quest, ans, wrong, exp in music_medium:
    all_q.append(q("Music", "medium", quest, ans, wrong, exp))
for quest, ans, wrong, exp in music_hard:
    all_q.append(q("Music", "hard", quest, ans, wrong, exp))

for quest, ans, wrong, exp in art_easy:
    all_q.append(q("Art", "easy", quest, ans, wrong, exp))
for quest, ans, wrong, exp in art_medium:
    all_q.append(q("Art", "medium", quest, ans, wrong, exp))
for quest, ans, wrong, exp in art_hard:
    all_q.append(q("Art", "hard", quest, ans, wrong, exp))

# Print all questions
for i, quest in enumerate(all_q):
    print(quest, end="")
    if i < len(all_q) - 1:
        print(",")
    else:
        print()

print(f"\n// Generated {len(all_q)} Culture questions")
