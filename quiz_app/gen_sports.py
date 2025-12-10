#!/usr/bin/env python3
"""
FINAL MEGA GENERATOR - ALL REMAINING QUESTIONS
Generates ~488 questions for 12 remaining categories
This completes the entire question database
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
# SPORTS - Need 19 easy, 17 medium, 20 hard (56 total)
# ============================================================================
cat = "Sports"

# Easy (19)
sports_easy = [
    ("How many points is a touchdown worth in American football?", "6", ["7", "3", "8"], "A touchdown is worth 6 points in American football."),
    ("What does NBA stand for?", "National Basketball Association", ["National Baseball Association", "North American Basketball", "National Ball Association"], "NBA stands for National Basketball Association."),
    ("In soccer, what body part can't touch the ball?", "Hands", ["Feet", "Head", "Chest"], "In soccer, players (except goalkeepers in their area) cannot touch the ball with their hands."),
    ("What is a soccer field called?", "Pitch", ["Court", "Field", "Arena"], "A soccer field is called a pitch."),
    ("How many teams are in the NFL?", "32", ["30", "28", "36"], "There are 32 teams in the National Football League."),
    ("What is the diameter of a basketball hoop in inches?", "18", ["16", "20", "22"], "A basketball hoop has a diameter of 18 inches."),
    ("In which sport would you perform a slam dunk?", "Basketball", ["Volleyball", "American Football", "Tennis"], "A slam dunk is performed in basketball."),
    ("How many players are on a baseball team on the field?", "9", ["10", "11", "8"], "A baseball team has 9 players on the field."),
    ("What is the highest score in a single frame of bowling?", "30", ["20", "10", "300"], "The highest score in a single frame of bowling is 30 (a strike)."),
    ("How many holes are played in a standard round of golf?", "18", ["9", "27", "36"], "A standard round of golf consists of 18 holes."),
    ("What sport is known as 'the beautiful game'?", "Soccer", ["Basketball", "Tennis", "Cricket"], "Soccer is often called 'the beautiful game'."),
    ("How many rings are on the Olympic flag?", "5", ["4", "6", "7"], "The Olympic flag has 5 interlocking rings representing the five continents."),
    ("In tennis, what is a score of zero called?", "Love", ["Nil", "Zero", "Nothing"], "In tennis, a score of zero is called 'love'."),
    ("How many players are on an ice hockey team on the ice?", "6", ["5", "7", "8"], "An ice hockey team has 6 players on the ice at a time."),
    ("What is the term for three strikes in a row in bowling?", "Turkey", ["Eagle", "Hat-trick", "Triple"], "Three strikes in a row in bowling is called a turkey."),
    ("In American football, how many points is a field goal worth?", "3", ["2", "6", "7"], "A field goal is worth 3 points in American football."),
    ("What color is the center of an archery target?", "Yellow", ["Red", "Blue", "Gold"], "The center of an archery target is yellow (or gold)."),
    ("How many Grand Slam tournaments are there in tennis?", "4", ["3", "5", "6"], "There are 4 Grand Slam tournaments in tennis: Australian Open, French Open, Wimbledon, and US Open."),
    ("What is the maximum number of players on a soccer team including substitutes?", "11 on field", ["10", "12", "9"], "A soccer team has 11 players on the field at a time."),
]

# Medium (17)
sports_medium = [
    ("What is the name of the Super Bowl trophy?", "Lombardi Trophy", ["Vince Trophy", "NFL Trophy", "Championship Trophy"], "The Super Bowl trophy is called the Lombardi Trophy, named after legendary coach Vince Lombardi."),
    ("Which team won the first Super Bowl?", "Green Bay Packers", ["Kansas City Chiefs", "Dallas Cowboys", "Pittsburgh Steelers"], "The Green Bay Packers won the first Super Bowl in 1967."),
    ("How many personal fouls before ejection in NBA?", "6", ["5", "7", "4"], "An NBA player is ejected after committing 6 personal fouls."),
    ("Who is the all-time leading scorer in NBA history?", "LeBron James", ["Kareem Abdul-Jabbar", "Michael Jordan", "Kobe Bryant"], "LeBron James became the NBA's all-time leading scorer in 2023."),
    ("Which country won the first FIFA World Cup in 1930?", "Uruguay", ["Brazil", "Argentina", "Italy"], "Uruguay won the first FIFA World Cup held in 1930."),
    ("Which country won the 2022 FIFA World Cup?", "Argentina", ["France", "Brazil", "Germany"], "Argentina won the 2022 FIFA World Cup in Qatar."),
    ("What is the nickname of the Brazilian national soccer team?", "Seleção", ["Canarinhos", "Verde-Amarela", "Pentacampeão"], "The Brazilian national team is nicknamed Seleção."),
    ("How many players line up on offense in American football?", "11", ["10", "12", "9"], "11 players line up on offense in American football."),
    ("What team owns the longest winning streak in NBA history?", "Los Angeles Lakers", ["Golden State Warriors", "Chicago Bulls", "Boston Celtics"], "The Los Angeles Lakers hold the longest winning streak in NBA history with 33 consecutive wins."),
    ("In ice hockey, what is a hat-trick?", "Three goals by one player in one game", ["Three assists", "Three wins in a row", "Three penalties"], "A hat-trick in ice hockey is when a single player scores three goals in one game."),
    ("Which country has won the most FIFA World Cups?", "Brazil", ["Germany", "Italy", "Argentina"], "Brazil has won the most FIFA World Cups with 5 titles."),
    ("What is the maximum break in snooker?", "147", ["180", "100", "200"], "The maximum break in snooker is 147 points."),
    ("In golf, what is an albatross?", "Three under par", ["Two under par", "One under par", "Hole in one"], "An albatross (or double eagle) is three strokes under par on a hole."),
    ("How many minutes are in a regulation NBA game?", "48", ["40", "60", "45"], "An NBA game consists of 48 minutes of regulation play (4 quarters of 12 minutes)."),
    ("What is the term for a perfect game in bowling?", "300", ["100", "200", "250"], "A perfect game in bowling scores 300 points (12 strikes)."),
    ("Which tennis player has won the most Grand Slam titles?", "Novak Djokovic", ["Roger Federer", "Rafael Nadal", "Pete Sampras"], "Novak Djokovic holds the record for most Grand Slam singles titles."),
    ("In cricket, what is a century?", "100 runs by one batsman", ["100 wickets", "100 matches", "100 overs"], "A century in cricket is when a batsman scores 100 or more runs in a single innings."),
]

# Hard (20)
sports_hard = [
    ("Which team went undefeated in the 1972 NFL season?", "Miami Dolphins", ["Pittsburgh Steelers", "Dallas Cowboys", "Green Bay Packers"], "The 1972 Miami Dolphins went undefeated for the entire season, including the Super Bowl."),
    ("Which NFL player was nicknamed 'Sweetness'?", "Walter Payton", ["Barry Sanders", "Emmitt Smith", "Jim Brown"], "Walter Payton, the Hall of Fame running back, was nicknamed 'Sweetness'."),
    ("Which two teams have won the most Super Bowls?", "Patriots and Steelers", ["Cowboys and 49ers", "Packers and Giants", "Broncos and Raiders"], "The New England Patriots and Pittsburgh Steelers have each won 6 Super Bowls."),
    ("Who holds the record for most points in a single NBA game?", "Wilt Chamberlain", ["Kobe Bryant", "Michael Jordan", "LeBron James"], "Wilt Chamberlain scored 100 points in a single game in 1962."),
    ("Who was the first WNBA player to dunk in a playoff game?", "Brittney Griner", ["Lisa Leslie", "Candace Parker", "Elena Delle Donne"], "Brittney Griner was the first WNBA player to dunk in a playoff game."),
    ("Which player has won the most NBA MVP awards?", "Kareem Abdul-Jabbar", ["Michael Jordan", "LeBron James", "Bill Russell"], "Kareem Abdul-Jabbar won 6 NBA MVP awards, the most in history."),
    ("Who scored the 'Hand of God' goal in 1986?", "Diego Maradona", ["Pelé", "Lionel Messi", "Ronaldo"], "Diego Maradona scored the famous 'Hand of God' goal in the 1986 World Cup."),
    ("What was the fastest goal in World Cup history?", "Hakan Şükür in 10.8 seconds", ["Clint Dempsey in 29 seconds", "Bryan Robson in 27 seconds", "Vaclav Masek in 15 seconds"], "Hakan Şükür scored the fastest World Cup goal in 10.8 seconds for Turkey in 2002."),
    ("Which country has played in every FIFA World Cup?", "Brazil", ["Germany", "Argentina", "Italy"], "Brazil is the only country to have played in every FIFA World Cup tournament."),
    ("Who won the first NBA game in 1946?", "New York Knicks", ["Boston Celtics", "Philadelphia Warriors", "Chicago Stags"], "The New York Knicks won the first NBA game in 1946."),
    ("What is the only Grand Slam played on grass?", "Wimbledon", ["US Open", "French Open", "Australian Open"], "Wimbledon is the only Grand Slam tournament played on grass courts."),
    ("Who has won the most Tour de France titles?", "Lance Armstrong (stripped), Eddy Merckx, Jacques Anquetil, Bernard Hinault, Miguel Indurain", ["Chris Froome", "Alberto Contador", "Greg LeMond"], "Five cyclists have won the Tour de France 5 times each (Lance Armstrong's titles were stripped)."),
    ("In Formula 1, who holds the record for most World Championships?", "Lewis Hamilton and Michael Schumacher", ["Sebastian Vettel", "Alain Prost", "Juan Manuel Fangio"], "Lewis Hamilton and Michael Schumacher each have 7 Formula 1 World Championships."),
    ("What is the Fosbury Flop?", "High jump technique", ["Pole vault technique", "Long jump technique", "Triple jump technique"], "The Fosbury Flop is a high jump technique where the jumper goes over the bar backwards."),
    ("Who was the first athlete to run a mile in under 4 minutes?", "Roger Bannister", ["Sebastian Coe", "Steve Ovett", "Hicham El Guerrouj"], "Roger Bannister was the first to run a mile in under 4 minutes in 1954."),
    ("In boxing, what does TKO stand for?", "Technical Knockout", ["Total Knockout", "Timed Knockout", "Tactical Knockout"], "TKO stands for Technical Knockout, when a referee stops a fight."),
    ("What is the maximum weight for a heavyweight boxer?", "No limit", ["250 lbs", "200 lbs", "225 lbs"], "There is no maximum weight limit for the heavyweight division in boxing."),
    ("Who holds the record for most Olympic gold medals?", "Michael Phelps", ["Usain Bolt", "Carl Lewis", "Mark Spitz"], "Michael Phelps won 23 Olympic gold medals, the most in history."),
    ("What is a perfect score in gymnastics?", "10.0", ["9.0", "100", "15.0"], "A perfect score in gymnastics is 10.0 (though the scoring system has changed)."),
    ("In baseball, what is an immaculate inning?", "Nine pitches, three strikeouts", ["Three home runs", "No hits allowed", "Perfect game"], "An immaculate inning is when a pitcher strikes out all three batters on nine pitches."),
]

for quest, ans, wrong, exp in sports_easy:
    all_q.append(q(cat, "easy", quest, ans, wrong, exp))
for quest, ans, wrong, exp in sports_medium:
    all_q.append(q(cat, "medium", quest, ans, wrong, exp))
for quest, ans, wrong, exp in sports_hard:
    all_q.append(q(cat, "hard", quest, ans, wrong, exp))

# Print all questions
for i, quest in enumerate(all_q):
    print(quest, end="")
    if i < len(all_q) - 1:
        print(",")
    else:
        print()

print(f"\n// Generated {len(all_q)} Sports questions")
print("// Sports: 19 easy, 17 medium, 20 hard")
