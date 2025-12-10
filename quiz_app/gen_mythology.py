#!/usr/bin/env python3
"""
BATCH GENERATOR - Mythology, Entertainment: Film, Music
Generates 160 questions for these 3 categories
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
# MYTHOLOGY - Need 19 easy, 18 medium, 19 hard (56 total)
# ============================================================================
cat = "Mythology"

# Easy (19)
myth_easy = [
    ("Who is the king of the Greek gods?", "Zeus", ["Poseidon", "Hades", "Apollo"], "Zeus is the king of the Greek gods, known for wielding a lightning bolt."),
    ("Who is the Greek goddess of wisdom?", "Athena", ["Aphrodite", "Hera", "Artemis"], "Athena is the Greek goddess of wisdom and warfare, often depicted with an owl."),
    ("What is the name of the three-headed dog guarding the Underworld?", "Cerberus", ["Orthrus", "Chimera", "Hydra"], "Cerberus is the three-headed dog that guards the entrance to the Underworld."),
    ("Who is the Greek god of the sea?", "Poseidon", ["Zeus", "Hades", "Apollo"], "Poseidon is the Greek god of the sea, often depicted with a trident."),
    ("Where did the Olympian gods reside?", "Mount Olympus", ["Mount Parnassus", "Mount Etna", "Mount Vesuvius"], "The Olympian gods resided on Mount Olympus, the highest mountain in Greece."),
    ("Who is the Norse god of thunder?", "Thor", ["Odin", "Loki", "Heimdall"], "Thor is the Norse god of thunder, wielding the hammer Mjolnir."),
    ("What is the name of Thor's hammer?", "Mjolnir", ["Gungnir", "Gram", "Tyrfing"], "Mjolnir is Thor's magical hammer in Norse mythology."),
    ("Who is the trickster god in Norse mythology?", "Loki", ["Thor", "Odin", "Freyr"], "Loki is the mischievous trickster god in Norse mythology."),
    ("Who is the Allfather in Norse mythology?", "Odin", ["Thor", "Loki", "Freyr"], "Odin is the primary father god in Norse mythology, known as the Allfather."),
    ("What is the name of the heavenly home of the gods in Norse mythology?", "Asgard", ["Valhalla", "Midgard", "Jotunheim"], "Asgard is the heavenly home of the gods in Norse mythology."),
    ("Who is the Roman king of the gods?", "Jupiter", ["Mars", "Neptune", "Apollo"], "Jupiter is the king of the gods in Roman mythology, equivalent to Greek Zeus."),
    ("Who is the Roman goddess of love?", "Venus", ["Juno", "Diana", "Minerva"], "Venus is the Roman goddess of love and beauty, equivalent to Greek Aphrodite."),
    ("Who is the Roman messenger god?", "Mercury", ["Mars", "Apollo", "Vulcan"], "Mercury is the Roman messenger god, depicted with winged sandals."),
    ("Who is the Egyptian sun god?", "Ra", ["Osiris", "Anubis", "Horus"], "Ra (or Re) is the ancient Egyptian sun god, often depicted with a sun disk."),
    ("Who is the Egyptian god of the afterlife?", "Osiris", ["Ra", "Anubis", "Horus"], "Osiris is the Egyptian god of the afterlife and judge of the dead."),
    ("Who is the Egyptian goddess of magic?", "Isis", ["Hathor", "Bastet", "Sekhmet"], "Isis is the Egyptian goddess of magic, motherhood, and healing."),
    ("Which god is depicted with a jackal head?", "Anubis", ["Osiris", "Horus", "Set"], "Anubis, the god of mummification, is depicted with the head of a jackal."),
    ("Which day of the week is named after Thor?", "Thursday", ["Tuesday", "Wednesday", "Friday"], "Thursday is named after Thor, the Norse god of thunder."),
    ("What creature was sacred to the goddess Bastet?", "Cats", ["Dogs", "Birds", "Snakes"], "Cats were considered sacred and associated with the goddess Bastet."),
]

# Medium (18)
myth_medium = [
    ("Who slew the Minotaur in the labyrinth?", "Theseus", ["Perseus", "Heracles", "Jason"], "Theseus was the hero who slayed the Minotaur in the labyrinth of Crete."),
    ("What did Persephone eat in the Underworld?", "Pomegranate seeds", ["Apple", "Grapes", "Figs"], "Persephone ate pomegranate seeds, forcing her to stay in the Underworld part of each year."),
    ("Who is the Greek god of wine?", "Dionysus", ["Apollo", "Hermes", "Ares"], "Dionysus is the Greek god of wine, revelry, and ecstasy."),
    ("Who is the father of Zeus?", "Cronus", ["Uranus", "Oceanus", "Hyperion"], "Cronus is the Titan who fathered Zeus, Poseidon, and Hades."),
    ("What winged horse sprang from Medusa's blood?", "Pegasus", ["Sleipnir", "Arion", "Xanthus"], "Pegasus, the winged horse, sprang from Medusa's blood when Perseus slew her."),
    ("What is the rainbow bridge in Norse mythology?", "Bifrost", ["Yggdrasil", "Gjallarbrú", "Ásbrú"], "Bifrost is the rainbow bridge connecting Asgard and Midgard."),
    ("What serpent encircles Midgard?", "Jormungand", ["Nidhogg", "Fafnir", "Níðhöggr"], "Jormungand, the Midgard Serpent, encircles the world and is fated to fight Thor."),
    ("What is the Norse apocalypse called?", "Ragnarok", ["Valhalla", "Fimbulwinter", "Götterdämmerung"], "Ragnarok is the apocalyptic battle signifying the end of the world in Norse mythology."),
    ("Who is the Norse goddess of love?", "Freyja", ["Frigg", "Sif", "Idunn"], "Freyja is the Norse goddess of love, beauty, and fertility."),
    ("What is the world tree in Norse mythology?", "Yggdrasil", ["Bifrost", "Glasir", "Læraðr"], "Yggdrasil is the world tree that connects all nine realms of Norse cosmology."),
    ("Who is the Roman goddess of the hunt?", "Diana", ["Venus", "Juno", "Minerva"], "Diana is the Roman goddess of the hunt, equivalent to Greek Artemis."),
    ("Who is the Roman queen of the gods?", "Juno", ["Venus", "Diana", "Vesta"], "Juno is the Roman queen of the gods, presiding over marriage and childbirth."),
    ("Who is the Roman god of the underworld?", "Pluto", ["Neptune", "Mars", "Vulcan"], "Pluto is the Roman god of the underworld, equivalent to Greek Hades."),
    ("Which goddess has 'cereal' derived from her name?", "Ceres", ["Vesta", "Juno", "Diana"], "Ceres is the Roman goddess of agriculture, and 'cereal' is derived from her name."),
    ("Who were the twin founders of Rome?", "Romulus and Remus", ["Castor and Pollux", "Amphion and Zethus", "Idas and Lynceus"], "Romulus and Remus were twin brothers raised by a she-wolf, legendary founders of Rome."),
    ("Who is the Egyptian goddess of truth?", "Ma'at", ["Isis", "Hathor", "Nut"], "Ma'at is the goddess of truth, justice, and harmony, depicted with an ostrich feather."),
    ("Who is the Egyptian god of writing?", "Thoth", ["Anubis", "Horus", "Set"], "Thoth is the Egyptian god of writing, knowledge, and the moon."),
    ("What is the Egyptian funerary text called?", "The Book of the Dead", ["The Book of Life", "The Pyramid Texts", "The Coffin Texts"], "The Book of the Dead contains spells to guide the deceased through the afterlife."),
]

# Hard (19)
myth_hard = [
    ("Who was the blind prophet of Thebes?", "Tiresias", ["Calchas", "Melampus", "Cassandra"], "Tiresias was the blind prophet of Thebes who was transformed into a woman for seven years."),
    ("Whose golden apple started the Trojan War?", "Eris", ["Aphrodite", "Hera", "Athena"], "Eris, goddess of discord, threw a golden apple inscribed 'To the Fairest', starting the Trojan War."),
    ("Who tried to bring Eurydice back from the Underworld?", "Orpheus", ["Theseus", "Heracles", "Odysseus"], "Orpheus, the legendary musician, tried to bring his wife Eurydice back but looked back too soon."),
    ("Who performed twelve labors as penance?", "Heracles", ["Theseus", "Perseus", "Jason"], "Heracles (Hercules) performed twelve seemingly impossible labors as penance."),
    ("Who rivaled Athena for Athens?", "Poseidon", ["Apollo", "Ares", "Hermes"], "Poseidon and Athena competed for Athens; Athena won by offering the olive tree."),
    ("Who was the blind god tricked by Loki?", "Hod", ["Baldur", "Heimdall", "Tyr"], "Hod was the blind god tricked by Loki into killing his brother Baldur."),
    ("What is Odin's eight-legged horse called?", "Sleipnir", ["Gullfaxi", "Hófvarpnir", "Skinfaxi"], "Sleipnir is Odin's eight-legged steed, the fastest horse in Norse mythology."),
    ("What is the realm of the dead in Norse mythology?", "Niflheim", ["Helheim", "Svartalfheim", "Muspelheim"], "Niflheim is the cold, misty world of the dead, ruled by the goddess Hel."),
    ("What are Odin's two ravens called?", "Huginn and Muninn", ["Geri and Freki", "Tanngrisnir and Tanngnjóstr", "Arvak and Alsvid"], "Huginn (Thought) and Muninn (Memory) are Odin's ravens who bring him information."),
    ("Who is the watchman of the gods?", "Heimdall", ["Tyr", "Baldur", "Vidar"], "Heimdall guards the entrance to Asgard and will sound a horn at Ragnarok."),
    ("Who is the Roman goddess of the dawn?", "Aurora", ["Luna", "Diana", "Vesta"], "Aurora is the Roman goddess personifying the dawn."),
    ("Who is the Roman goddess of the hearth?", "Vesta", ["Juno", "Ceres", "Diana"], "Vesta is the Roman goddess of the hearth, whose sacred fire was tended by Vestal Virgins."),
    ("Which god is January named after?", "Janus", ["Jupiter", "Mars", "Mercury"], "January is named after Janus, the Roman god of doorways and beginnings."),
    ("Who is the Roman equivalent of Athena?", "Minerva", ["Diana", "Venus", "Juno"], "Minerva is the Roman goddess equivalent to Greek Athena, associated with wisdom."),
    ("Who is the Egyptian sky goddess?", "Nut", ["Isis", "Hathor", "Sekhmet"], "Nut is the sky goddess who arches over the earth and swallows the sun each evening."),
    ("Whose feather was used in the weighing ceremony?", "Ma'at", ["Isis", "Thoth", "Anubis"], "Ma'at's feather was used to weigh against the heart of the deceased."),
    ("Who is the Egyptian god of storms?", "Set", ["Horus", "Anubis", "Thoth"], "Set (or Seth) is the god of storms and the desert."),
    ("What was the primordial mound in Egyptian mythology?", "Benben", ["Nun", "Atum", "Khepri"], "Benben was the primordial mound that emerged from chaos upon which creation began."),
    ("Which dwarf god drove away evil spirits?", "Bes", ["Ptah", "Khnum", "Sobek"], "Bes is the dwarf god known for driving away evil spirits and protecting households."),
]

for quest, ans, wrong, exp in myth_easy:
    all_q.append(q(cat, "easy", quest, ans, wrong, exp))
for quest, ans, wrong, exp in myth_medium:
    all_q.append(q(cat, "medium", quest, ans, wrong, exp))
for quest, ans, wrong, exp in myth_hard:
    all_q.append(q(cat, "hard", quest, ans, wrong, exp))

# Print all questions
for i, quest in enumerate(all_q):
    print(quest, end="")
    if i < len(all_q) - 1:
        print(",")
    else:
        print()

print(f"\n// Generated {len(all_q)} Mythology questions")
print("// Mythology: 19 easy, 18 medium, 19 hard")
