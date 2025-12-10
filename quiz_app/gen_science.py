#!/usr/bin/env python3
"""
SCIENCE BATCH GENERATOR - Biology, Chemistry, Physics, Astronomy, Medicine
Generates ~217 questions for these 5 categories
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
# SCIENCE: BIOLOGY - Need 16 easy, 13 medium, 17 hard (46 total)
# ============================================================================
cat = "Science: Biology"

# Easy (16)
bio_easy = [
    ("What is the powerhouse of the cell?", "Mitochondria", ["Nucleus", "Ribosome", "Golgi Apparatus"], "Mitochondria generate most of the chemical energy needed to power the cell's biochemical reactions."),
    ("What is the largest organ in the human body?", "Skin", ["Liver", "Heart", "Lungs"], "The skin is the body's largest organ, protecting it from the external environment."),
    ("What process do plants use to make food?", "Photosynthesis", ["Respiration", "Digestion", "Fermentation"], "Photosynthesis is the process by which plants use sunlight to synthesize foods from carbon dioxide and water."),
    ("What is the genetic material in humans?", "DNA", ["RNA", "Protein", "Lipid"], "Deoxyribonucleic acid (DNA) carries genetic instructions for development and function."),
    ("How many chambers does the human heart have?", "4", ["2", "3", "5"], "The human heart has four chambers: two atria and two ventricles."),
    ("What gas do humans breathe out?", "Carbon Dioxide", ["Oxygen", "Nitrogen", "Hydrogen"], "Humans exhale carbon dioxide as a waste product of cellular respiration."),
    ("What is the basic unit of life?", "Cell", ["Atom", "Molecule", "Tissue"], "The cell is the smallest structural and functional unit of an organism."),
    ("Which animal is known as the 'King of the Jungle'?", "Lion", ["Tiger", "Elephant", "Gorilla"], "The lion is traditionally called the King of the Jungle."),
    ("What do bees collect from flowers?", "Nectar", ["Honey", "Wax", "Seeds"], "Bees collect nectar to make honey."),
    ("What is the largest land animal?", "African Elephant", ["Blue Whale", "Giraffe", "Hippopotamus"], "The African elephant is the largest living land animal."),
    ("Which blood cells fight infection?", "White blood cells", ["Red blood cells", "Platelets", "Plasma"], "White blood cells are part of the immune system and fight infection."),
    ("What is the hard outer covering of an insect called?", "Exoskeleton", ["Endoskeleton", "Shell", "Skin"], "Insects have a tough outer covering called an exoskeleton."),
    ("What do caterpillars turn into?", "Butterflies", ["Moths", "Beetles", "Flies"], "Caterpillars metamorphose into butterflies."),
    ("Which organ pumps blood around the body?", "Heart", ["Brain", "Liver", "Kidney"], "The heart pumps blood through the circulatory system."),
    ("What green pigment allows plants to absorb sunlight?", "Chlorophyll", ["Melanin", "Hemoglobin", "Carotene"], "Chlorophyll is the green pigment essential for photosynthesis."),
    ("What is the fastest land animal?", "Cheetah", ["Lion", "Gazelle", "Leopard"], "The cheetah is the fastest land animal, capable of reaching speeds up to 70 mph."),
]

# Medium (13)
bio_medium = [
    ("How many chromosomes do humans typically have?", "46", ["23", "44", "48"], "Humans typically have 23 pairs of chromosomes, for a total of 46."),
    ("What is the study of fungi called?", "Mycology", ["Botany", "Zoology", "Virology"], "Mycology is the branch of biology concerned with the study of fungi."),
    ("Which part of the brain controls balance?", "Cerebellum", ["Cerebrum", "Brainstem", "Thalamus"], "The cerebellum plays an important role in motor control and balance."),
    ("What is the largest bone in the human body?", "Femur", ["Tibia", "Humerus", "Pelvis"], "The femur, or thigh bone, is the longest and strongest bone in the human body."),
    ("Which vitamin is produced when skin is exposed to sunlight?", "Vitamin D", ["Vitamin C", "Vitamin A", "Vitamin B12"], "The skin produces Vitamin D when exposed to ultraviolet B (UVB) radiation."),
    ("What is the scientific name for the voice box?", "Larynx", ["Pharynx", "Trachea", "Esophagus"], "The larynx is commonly known as the voice box."),
    ("Which blood type is the universal donor?", "O Negative", ["A Positive", "AB Negative", "O Positive"], "O Negative blood can be transfused to almost any patient."),
    ("What is the process of cell division called?", "Mitosis", ["Meiosis", "Fusion", "Fission"], "Mitosis is the process where a single cell divides into two identical daughter cells."),
    ("Which organ produces insulin?", "Pancreas", ["Liver", "Kidney", "Spleen"], "The pancreas produces insulin to regulate blood sugar levels."),
    ("What is the main function of red blood cells?", "Transport oxygen", ["Fight infection", "Clot blood", "Regulate temperature"], "Red blood cells carry oxygen from the lungs to the rest of the body."),
    ("Which animal has the longest lifespan?", "Greenland Shark", ["Blue Whale", "Galapagos Tortoise", "Bowhead Whale"], "Greenland sharks can live for upwards of 400 years."),
    ("What is the term for animals that eat both plants and meat?", "Omnivores", ["Carnivores", "Herbivores", "Insectivores"], "Omnivores consume both plant and animal matter."),
    ("What is the smallest bone in the human body?", "Stapes", ["Incus", "Malleus", "Phalanges"], "The stapes, located in the middle ear, is the smallest bone."),
]

# Hard (17)
bio_hard = [
    ("What is the term for the creation of light by living organisms?", "Bioluminescence", ["Fluorescence", "Phosphorescence", "Incandescence"], "Bioluminescence is the production and emission of light by a living organism."),
    ("What is the programmed cell death called?", "Apoptosis", ["Necrosis", "Lysis", "Mitosis"], "Apoptosis is a form of programmed cell death that occurs in multicellular organisms."),
    ("Which scientist is known as the father of genetics?", "Gregor Mendel", ["Charles Darwin", "Louis Pasteur", "James Watson"], "Gregor Mendel's experiments with pea plants established many of the rules of heredity."),
    ("What is the protein that makes up hair and nails?", "Keratin", ["Collagen", "Elastin", "Actin"], "Keratin is a fibrous structural protein that makes up hair, nails, and the outer layer of skin."),
    ("Which part of the cell contains digestive enzymes?", "Lysosome", ["Ribosome", "Vacuole", "Endoplasmic Reticulum"], "Lysosomes contain enzymes that break down waste materials and cellular debris."),
    ("What is the largest artery in the human body?", "Aorta", ["Carotid", "Femoral", "Pulmonary"], "The aorta is the main artery that carries blood away from the heart."),
    ("Which phylum do insects belong to?", "Arthropoda", ["Mollusca", "Chordata", "Annelida"], "Insects belong to the phylum Arthropoda."),
    ("What is the scientific name for the common cold virus?", "Rhinovirus", ["Influenza", "Coronavirus", "Adenovirus"], "Rhinovirus is the most common viral infectious agent in humans."),
    ("Which enzyme breaks down starch in the mouth?", "Amylase", ["Pepsin", "Lipase", "Trypsin"], "Amylase is found in saliva and begins the digestion of starch."),
    ("What is the term for the symbiotic relationship where both organisms benefit?", "Mutualism", ["Commensalism", "Parasitism", "Amensalism"], "Mutualism is a relationship where both species benefit."),
    ("Which part of the eye controls the amount of light entering?", "Iris", ["Cornea", "Retina", "Lens"], "The iris adjusts the size of the pupil to control light entry."),
    ("What is the rarest blood type in the US?", "AB Negative", ["B Negative", "O Negative", "A Negative"], "AB Negative is the rarest blood type in the United States."),
    ("Which molecule carries amino acids to the ribosome?", "tRNA", ["mRNA", "rRNA", "DNA"], "Transfer RNA (tRNA) brings amino acids to the ribosome during protein synthesis."),
    ("What is the study of insects called?", "Entomology", ["Etymology", "Ornithology", "Herpetology"], "Entomology is the scientific study of insects."),
    ("Which hormone regulates sleep-wake cycles?", "Melatonin", ["Serotonin", "Dopamine", "Cortisol"], "Melatonin is a hormone that regulates the sleep-wake cycle."),
    ("What is the largest internal organ?", "Liver", ["Lungs", "Heart", "Stomach"], "The liver is the largest internal organ in the human body."),
    ("Which scientist proposed the theory of evolution by natural selection?", "Charles Darwin", ["Alfred Russel Wallace", "Jean-Baptiste Lamarck", "Stephen Jay Gould"], "Charles Darwin published his theory of evolution in 'On the Origin of Species'."),
]

# ============================================================================
# CHEMISTRY - Need 17 easy, 15 medium, 18 hard (50 total)
# ============================================================================
cat = "Chemistry"

# Easy (17)
chem_easy = [
    ("What is the chemical formula for water?", "H2O", ["CO2", "O2", "NaCl"], "Water is composed of two hydrogen atoms and one oxygen atom."),
    ("What is the chemical symbol for Oxygen?", "O", ["Ox", "Og", "Om"], "The symbol for Oxygen is O."),
    ("What is the chemical symbol for Gold?", "Au", ["Ag", "Fe", "Cu"], "The symbol for Gold is Au, from the Latin 'aurum'."),
    ("What is the pH of pure water?", "7", ["0", "14", "1"], "Pure water is neutral, with a pH of 7."),
    ("Which gas do plants absorb from the atmosphere?", "Carbon Dioxide", ["Oxygen", "Nitrogen", "Helium"], "Plants absorb carbon dioxide for photosynthesis."),
    ("What is the most abundant gas in Earth's atmosphere?", "Nitrogen", ["Oxygen", "Carbon Dioxide", "Argon"], "Nitrogen makes up about 78% of Earth's atmosphere."),
    ("What is the center of an atom called?", "Nucleus", ["Proton", "Electron", "Shell"], "The nucleus is the central part of an atom."),
    ("What charge does a proton have?", "Positive", ["Negative", "Neutral", "Variable"], "Protons have a positive electric charge."),
    ("What charge does an electron have?", "Negative", ["Positive", "Neutral", "Variable"], "Electrons have a negative electric charge."),
    ("What is the chemical symbol for Sodium?", "Na", ["So", "Sd", "Nu"], "The symbol for Sodium is Na, from the Latin 'natrium'."),
    ("What is the common name for Sodium Chloride?", "Table Salt", ["Sugar", "Baking Soda", "Vinegar"], "Sodium Chloride is commonly known as table salt."),
    ("Which element is a diamond made of?", "Carbon", ["Silicon", "Iron", "Gold"], "Diamonds are made of pure carbon arranged in a crystal lattice."),
    ("What is the lightest element?", "Hydrogen", ["Helium", "Lithium", "Oxygen"], "Hydrogen is the lightest and first element on the periodic table."),
    ("What state of matter is ice?", "Solid", ["Liquid", "Gas", "Plasma"], "Ice is the solid state of water."),
    ("What happens when you mix an acid and a base?", "Neutralization", ["Explosion", "Evaporation", "Sublimation"], "Mixing an acid and a base results in a neutralization reaction."),
    ("What is the chemical symbol for Iron?", "Fe", ["Ir", "In", "Io"], "The symbol for Iron is Fe, from the Latin 'ferrum'."),
    ("Which gas makes balloons float?", "Helium", ["Hydrogen", "Oxygen", "Nitrogen"], "Helium is lighter than air, causing balloons to float."),
]

# Medium (15)
chem_medium = [
    ("What are electrons in the outer shell called?", "Valence electrons", ["Core electrons", "Free electrons", "Orbital electrons"], "Valence electrons are involved in chemical bonding."),
    ("What is the only metal that is liquid at room temperature?", "Mercury", ["Gallium", "Bromine", "Francium"], "Mercury is the only metal that is liquid at standard room temperature."),
    ("What is the atomic number of Carbon?", "6", ["12", "14", "8"], "Carbon has an atomic number of 6."),
    ("What is the term for atoms of the same element with different neutrons?", "Isotopes", ["Isomers", "Ions", "Allotropes"], "Isotopes have the same number of protons but different numbers of neutrons."),
    ("Which element is known as 'quicksilver'?", "Mercury", ["Silver", "Lead", "Tin"], "Mercury was historically referred to as quicksilver."),
    ("What is the main component of natural gas?", "Methane", ["Ethane", "Propane", "Butane"], "Methane (CH4) is the primary component of natural gas."),
    ("What is the chemical formula for Sulfuric Acid?", "H2SO4", ["HCl", "HNO3", "H2O"], "H2SO4 is the formula for sulfuric acid."),
    ("Which noble gas is used in light bulbs?", "Argon", ["Neon", "Helium", "Xenon"], "Argon is often used in incandescent light bulbs to prevent the filament from oxidizing."),
    ("What is the process of a solid turning directly into a gas?", "Sublimation", ["Evaporation", "Condensation", "Deposition"], "Sublimation is the transition from solid to gas without passing through the liquid phase."),
    ("What is the most reactive group of metals?", "Alkali metals", ["Alkaline earth metals", "Transition metals", "Noble gases"], "Alkali metals (Group 1) are highly reactive."),
    ("Who created the periodic table?", "Dmitri Mendeleev", ["Marie Curie", "Albert Einstein", "Isaac Newton"], "Mendeleev published the first recognizable periodic table in 1869."),
    ("What is the chemical formula for Ozone?", "O3", ["O2", "O", "O4"], "Ozone is a molecule composed of three oxygen atoms."),
    ("Which acid is found in the human stomach?", "Hydrochloric acid", ["Sulfuric acid", "Nitric acid", "Acetic acid"], "The stomach produces hydrochloric acid to aid digestion."),
    ("What is the hardest natural substance?", "Diamond", ["Graphite", "Quartz", "Corundum"], "Diamond is the hardest known natural material."),
    ("What is the chemical symbol for Potassium?", "K", ["P", "Po", "Pt"], "The symbol for Potassium is K, from the Latin 'kalium'."),
]

# Hard (18)
chem_hard = [
    ("What is the most abundant element in the universe?", "Hydrogen", ["Helium", "Oxygen", "Carbon"], "Hydrogen is the most abundant chemical substance in the universe."),
    ("What is the name of the process used to make ammonia?", "Haber process", ["Contact process", "Ostwald process", "Solvay process"], "The Haber process synthesizes ammonia from nitrogen and hydrogen."),
    ("Which element has the highest melting point?", "Tungsten", ["Carbon", "Titanium", "Platinum"], "Tungsten has the highest melting point of all metals."),
    ("What is the chemical name for 'laughing gas'?", "Nitrous Oxide", ["Nitric Oxide", "Nitrogen Dioxide", "Ammonia"], "Nitrous Oxide (N2O) is commonly known as laughing gas."),
    ("What is the rarest naturally occurring element?", "Astatine", ["Francium", "Polonium", "Radium"], "Astatine is the rarest naturally occurring element in the Earth's crust."),
    ("Which law states that pressure and volume are inversely proportional?", "Boyle's Law", ["Charles's Law", "Avogadro's Law", "Dalton's Law"], "Boyle's Law describes the inverse relationship between pressure and volume."),
    ("What is the main ore of aluminum?", "Bauxite", ["Hematite", "Magnetite", "Galena"], "Bauxite is the primary ore from which aluminum is extracted."),
    ("What is the chemical formula for Table Sugar?", "C12H22O11", ["C6H12O6", "NaCl", "CH3COOH"], "Sucrose (table sugar) has the formula C12H22O11."),
    ("Who discovered Radium and Polonium?", "Marie Curie", ["Pierre Curie", "Henri Becquerel", "Ernest Rutherford"], "Marie Curie discovered both elements and won Nobel Prizes for her work."),
    ("What is the term for a solution that resists changes in pH?", "Buffer", ["Acid", "Base", "Solvent"], "A buffer solution resists changes in pH when acid or alkali is added."),
    ("Which element is essential for thyroid function?", "Iodine", ["Iron", "Calcium", "Zinc"], "Iodine is required for the production of thyroid hormones."),
    ("What is the shape of a methane molecule?", "Tetrahedral", ["Linear", "Trigonal planar", "Octahedral"], "Methane (CH4) has a tetrahedral molecular geometry."),
    ("What is the heaviest naturally occurring element?", "Uranium", ["Plutonium", "Lead", "Gold"], "Uranium is the heaviest naturally occurring element found in significant quantities."),
    ("Which gas is produced when metals react with acid?", "Hydrogen", ["Oxygen", "Carbon Dioxide", "Nitrogen"], "Metals react with acids to produce hydrogen gas and a salt."),
    ("What is the chemical name for Vitamin C?", "Ascorbic acid", ["Citric acid", "Folic acid", "Acetic acid"], "Vitamin C is also known as ascorbic acid."),
    ("What is the most electronegative element?", "Fluorine", ["Oxygen", "Chlorine", "Nitrogen"], "Fluorine is the most electronegative element on the periodic table."),
    ("Which polymer is used to make non-stick pans?", "Teflon", ["Nylon", "Polyester", "PVC"], "Polytetrafluoroethylene (PTFE) is best known by the brand name Teflon."),
    ("What is the study of carbon compounds called?", "Organic Chemistry", ["Inorganic Chemistry", "Physical Chemistry", "Analytical Chemistry"], "Organic chemistry is the study of the structure, properties, and reactions of carbon-containing compounds."),
]

# ============================================================================
# PHYSICS - Need 15 easy, 9 medium, 16 hard (40 total)
# ============================================================================
cat = "Physics"

# Easy (15)
phys_easy = [
    ("What is the SI unit of force?", "Newton", ["Joule", "Watt", "Pascal"], "The Newton (N) is the SI unit of force."),
    ("What keeps planets in orbit around the sun?", "Gravity", ["Magnetism", "Friction", "Inertia"], "Gravity is the force that keeps planets in orbit."),
    ("What is the speed of light?", "299,792,458 m/s", ["300,000 km/h", "1,000 m/s", "Sound speed"], "The speed of light in a vacuum is approximately 300,000 km/s."),
    ("Who is famous for the equation E=mc²?", "Albert Einstein", ["Isaac Newton", "Galileo Galilei", "Nikola Tesla"], "Albert Einstein formulated the mass-energy equivalence equation."),
    ("What is the unit of electric current?", "Ampere", ["Volt", "Ohm", "Watt"], "The Ampere (Amp) is the unit of electric current."),
    ("What pulls objects toward the Earth?", "Gravity", ["Magnetism", "Wind", "Electricity"], "Gravity attracts objects with mass towards each other."),
    ("What is the freezing point of water in Celsius?", "0°C", ["100°C", "32°C", "-273°C"], "Water freezes at 0 degrees Celsius."),
    ("What is the boiling point of water in Celsius?", "100°C", ["0°C", "212°C", "50°C"], "Water boils at 100 degrees Celsius at sea level."),
    ("What is the unit of power?", "Watt", ["Joule", "Newton", "Volt"], "The Watt is the unit of power."),
    ("Which state of matter has no fixed shape or volume?", "Gas", ["Solid", "Liquid", "Plasma"], "A gas has no fixed shape or volume and fills its container."),
    ("What instrument measures temperature?", "Thermometer", ["Barometer", "Speedometer", "Voltmeter"], "A thermometer is used to measure temperature."),
    ("What is the force that opposes motion?", "Friction", ["Gravity", "Tension", "Thrust"], "Friction is the force that resists relative motion between surfaces."),
    ("Who discovered the laws of motion?", "Isaac Newton", ["Albert Einstein", "Galileo Galilei", "Johannes Kepler"], "Isaac Newton formulated the three laws of motion."),
    ("What is the flow of electrons called?", "Electricity", ["Magnetism", "Heat", "Light"], "Electricity is the flow of electric charge, carried by electrons."),
    ("What is the unit of energy?", "Joule", ["Watt", "Newton", "Pascal"], "The Joule is the SI unit of energy."),
]

# Medium (9)
phys_medium = [
    ("What is Newton's first law also known as?", "Law of Inertia", ["Law of Acceleration", "Law of Action-Reaction", "Law of Gravity"], "Newton's First Law states that an object at rest stays at rest unless acted upon."),
    ("What is the rate of change of velocity?", "Acceleration", ["Speed", "Momentum", "Force"], "Acceleration is the rate at which an object changes its velocity."),
    ("What is the SI unit of pressure?", "Pascal", ["Newton", "Joule", "Watt"], "The Pascal (Pa) is the SI unit of pressure."),
    ("Who discovered X-rays?", "Wilhelm Röntgen", ["Marie Curie", "Nikola Tesla", "Thomas Edison"], "Wilhelm Röntgen discovered X-rays in 1895."),
    ("What is the term for energy in motion?", "Kinetic Energy", ["Potential Energy", "Thermal Energy", "Chemical Energy"], "Kinetic energy is the energy an object possesses due to its motion."),
    ("What is the unit of electrical resistance?", "Ohm", ["Volt", "Ampere", "Watt"], "The Ohm is the unit of electrical resistance."),
    ("What is the bending of light called?", "Refraction", ["Reflection", "Diffraction", "Dispersion"], "Refraction is the bending of light as it passes from one medium to another."),
    ("Which particle has a positive charge?", "Proton", ["Electron", "Neutron", "Photon"], "Protons are positively charged subatomic particles."),
    ("What is the measure of disorder in a system?", "Entropy", ["Enthalpy", "Energy", "Heat"], "Entropy is a measure of the disorder or randomness in a system."),
]

# Hard (16)
phys_hard = [
    ("What is the SI unit of magnetic flux?", "Weber", ["Tesla", "Gauss", "Henry"], "The Weber (Wb) is the SI unit of magnetic flux."),
    ("What is the theoretical coldest possible temperature?", "Absolute Zero", ["Freezing Point", "Triple Point", "Critical Point"], "Absolute Zero (0 Kelvin) is the lowest theoretical temperature."),
    ("Who proposed the uncertainty principle?", "Werner Heisenberg", ["Niels Bohr", "Erwin Schrödinger", "Max Planck"], "Heisenberg's uncertainty principle states you cannot know both position and momentum precisely."),
    ("What particle mediates the electromagnetic force?", "Photon", ["Gluon", "Boson", "Graviton"], "Photons are the elementary particles of light and the force carrier for electromagnetism."),
    ("What is the study of motion without considering forces?", "Kinematics", ["Dynamics", "Statics", "Mechanics"], "Kinematics describes motion without reference to the forces that cause it."),
    ("Who discovered the electron?", "J.J. Thomson", ["Ernest Rutherford", "Niels Bohr", "James Chadwick"], "J.J. Thomson discovered the electron in 1897."),
    ("What is the SI unit of capacitance?", "Farad", ["Henry", "Ohm", "Volt"], "The Farad is the unit of capacitance."),
    ("What phenomenon causes the sky to appear blue?", "Rayleigh Scattering", ["Refraction", "Reflection", "Diffraction"], "Rayleigh scattering of sunlight by the atmosphere causes the blue color."),
    ("What is the speed of sound in air at 20°C?", "343 m/s", ["299,792 km/s", "1,235 km/h", "100 m/s"], "The speed of sound is approximately 343 meters per second at 20°C."),
    ("Which force holds the nucleus together?", "Strong Nuclear Force", ["Weak Nuclear Force", "Electromagnetic Force", "Gravity"], "The strong nuclear force binds protons and neutrons in the nucleus."),
    ("What is the unit of frequency?", "Hertz", ["Decibel", "Watt", "Second"], "The Hertz (Hz) is the unit of frequency, equal to one cycle per second."),
    ("Who formulated the laws of planetary motion?", "Johannes Kepler", ["Nicolaus Copernicus", "Tycho Brahe", "Galileo Galilei"], "Kepler described the motion of planets around the sun."),
    ("What is the antiparticle of the electron?", "Positron", ["Proton", "Neutron", "Neutrino"], "The positron is the antiparticle of the electron."),
    ("What is the term for a material with zero electrical resistance?", "Superconductor", ["Semiconductor", "Insulator", "Conductor"], "Superconductors conduct electricity with zero resistance."),
    ("What is the SI unit of luminous intensity?", "Candela", ["Lumen", "Lux", "Watt"], "The Candela is the base unit of luminous intensity."),
    ("Which physicist developed the exclusion principle?", "Wolfgang Pauli", ["Enrico Fermi", "Paul Dirac", "Max Born"], "The Pauli Exclusion Principle states that no two fermions can occupy the same quantum state."),
]

# ============================================================================
# ASTRONOMY - Need 15 easy, 10 medium, 15 hard (40 total)
# ============================================================================
cat = "Astronomy"

# Easy (15)
astro_easy = [
    ("What is the largest planet in our solar system?", "Jupiter", ["Saturn", "Neptune", "Earth"], "Jupiter is the largest planet in the Solar System."),
    ("Which planet is known as the 'Red Planet'?", "Mars", ["Venus", "Mercury", "Jupiter"], "Mars appears red due to iron oxide on its surface."),
    ("What star is at the center of our solar system?", "The Sun", ["Proxima Centauri", "Sirius", "Betelgeuse"], "The Sun is the star around which Earth and other planets orbit."),
    ("What is the name of our galaxy?", "Milky Way", ["Andromeda", "Triangulum", "Whirlpool"], "We live in the Milky Way galaxy."),
    ("Which planet has the most prominent rings?", "Saturn", ["Jupiter", "Uranus", "Neptune"], "Saturn is famous for its extensive ring system."),
    ("What is the closest planet to the Sun?", "Mercury", ["Venus", "Earth", "Mars"], "Mercury is the innermost planet in the Solar System."),
    ("What is the natural satellite of Earth?", "The Moon", ["Titan", "Europa", "Phobos"], "The Moon is Earth's only natural satellite."),
    ("Which planet is known as the 'Morning Star'?", "Venus", ["Mars", "Mercury", "Jupiter"], "Venus is often visible in the morning or evening sky."),
    ("How many planets are in our solar system?", "8", ["9", "7", "10"], "There are 8 recognized planets (Pluto is a dwarf planet)."),
    ("What causes the tides on Earth?", "The Moon's gravity", ["The Sun's gravity", "Earth's rotation", "Ocean currents"], "The gravitational pull of the Moon is the primary cause of tides."),
    ("What is a shooting star?", "Meteor", ["Comet", "Asteroid", "Star"], "A shooting star is a meteor burning up in Earth's atmosphere."),
    ("Which planet is the hottest?", "Venus", ["Mercury", "Mars", "Jupiter"], "Venus is the hottest planet due to its thick greenhouse atmosphere."),
    ("What do we call a group of stars forming a pattern?", "Constellation", ["Galaxy", "Nebula", "Cluster"], "A constellation is a recognizable pattern of stars."),
    ("Who was the first person to walk on the Moon?", "Neil Armstrong", ["Buzz Aldrin", "Yuri Gagarin", "John Glenn"], "Neil Armstrong was the first human to step on the Moon in 1969."),
    ("What is the Great Red Spot on Jupiter?", "A storm", ["A volcano", "A crater", "A lake"], "The Great Red Spot is a giant storm that has raged for centuries."),
]

# Medium (10)
astro_medium = [
    ("What is the nearest star to Earth besides the Sun?", "Proxima Centauri", ["Alpha Centauri A", "Sirius", "Barnard's Star"], "Proxima Centauri is the closest star to the Solar System."),
    ("Which planet rotates on its side?", "Uranus", ["Neptune", "Saturn", "Venus"], "Uranus has an axial tilt of 98 degrees, effectively rotating on its side."),
    ("What are planets outside our solar system called?", "Exoplanets", ["Dwarf planets", "Rogue planets", "Protoplanets"], "Exoplanets are planets that orbit stars other than our Sun."),
    ("What is the name of the galaxy closest to the Milky Way?", "Andromeda", ["Triangulum", "Magellanic Clouds", "Whirlpool"], "The Andromeda Galaxy is the nearest major galaxy to the Milky Way."),
    ("What is the boundary of a black hole called?", "Event Horizon", ["Singularity", "Accretion Disk", "Photon Sphere"], "The event horizon is the point of no return around a black hole."),
    ("Which planet has the most moons?", "Saturn", ["Jupiter", "Uranus", "Neptune"], "Saturn currently holds the record for the most confirmed moons."),
    ("What is the largest moon in the solar system?", "Ganymede", ["Titan", "Callisto", "Io"], "Ganymede, a moon of Jupiter, is the largest moon."),
    ("What is a light-year a measure of?", "Distance", ["Time", "Speed", "Brightness"], "A light-year is the distance light travels in one year."),
    ("Which dwarf planet was formerly considered the ninth planet?", "Pluto", ["Eris", "Ceres", "Haumea"], "Pluto was reclassified as a dwarf planet in 2006."),
    ("What is the name of the first artificial satellite?", "Sputnik 1", ["Explorer 1", "Vostok 1", "Telstar"], "The Soviet Union launched Sputnik 1 in 1957."),
]

# Hard (15)
astro_hard = [
    ("How old is the Universe believed to be?", "13.8 billion years", ["4.5 billion years", "10 billion years", "20 billion years"], "The Big Bang occurred approximately 13.8 billion years ago."),
    ("Which planet has a hexagonal storm at its north pole?", "Saturn", ["Jupiter", "Uranus", "Neptune"], "Saturn features a persistent hexagonal cloud pattern at its north pole."),
    ("What is the largest volcano in the solar system?", "Olympus Mons", ["Mauna Loa", "Maxwell Montes", "Mount Everest"], "Olympus Mons on Mars is the largest volcano."),
    ("What is the name of the theory describing the origin of the universe?", "Big Bang Theory", ["Steady State Theory", "String Theory", "Inflation Theory"], "The Big Bang Theory describes the early development of the Universe."),
    ("What type of star is the Sun?", "Yellow Dwarf", ["Red Giant", "White Dwarf", "Blue Supergiant"], "The Sun is a G-type main-sequence star, or yellow dwarf."),
    ("What is the term for the death of a massive star?", "Supernova", ["Nova", "Black Hole", "Nebula"], "A supernova is a powerful and luminous stellar explosion."),
    ("Which moon of Saturn has a thick atmosphere?", "Titan", ["Enceladus", "Rhea", "Iapetus"], "Titan is the only moon known to have a dense atmosphere."),
    ("What is the name of the cloud of icy objects surrounding the solar system?", "Oort Cloud", ["Kuiper Belt", "Asteroid Belt", "Scattered Disc"], "The Oort Cloud is a theoretical cloud of icy planetesimals."),
    ("Who discovered the four largest moons of Jupiter?", "Galileo Galilei", ["Johannes Kepler", "Nicolaus Copernicus", "Tycho Brahe"], "Galileo discovered Io, Europa, Ganymede, and Callisto in 1610."),
    ("What is the density of Saturn compared to water?", "Less than water", ["More than water", "Equal to water", "Twice as dense"], "Saturn is the only planet less dense than water; it would float."),
    ("What is the name of the first rover on Mars?", "Sojourner", ["Spirit", "Opportunity", "Curiosity"], "Sojourner was the first rover to operate on Mars in 1997."),
    ("What is the Chandrasekhar limit?", "Limit for white dwarf mass", ["Limit for black hole mass", "Limit for neutron star mass", "Speed of light limit"], "The Chandrasekhar limit is the maximum mass of a stable white dwarf star."),
    ("Which planet has the fastest winds?", "Neptune", ["Jupiter", "Saturn", "Uranus"], "Neptune has the fastest winds in the solar system, reaching 1,300 mph."),
    ("What is the name of the black hole at the center of our galaxy?", "Sagittarius A*", ["Cygnus X-1", "M87*", "Centaurus A"], "Sagittarius A* is the supermassive black hole at the Galactic Center."),
    ("What phenomenon occurs when the Moon passes between Earth and Sun?", "Solar Eclipse", ["Lunar Eclipse", "Transit", "Occultation"], "A solar eclipse happens when the Moon blocks the Sun."),
]

# ============================================================================
# MEDICINE - Need 14 easy, 12 medium, 15 hard (41 total)
# ============================================================================
cat = "Medicine"

# Easy (14)
med_easy = [
    ("How many bones are in the adult human body?", "206", ["200", "210", "250"], "An adult human has 206 bones."),
    ("What is the common name for the clavicle?", "Collarbone", ["Shoulder blade", "Breastbone", "Rib"], "The clavicle is commonly known as the collarbone."),
    ("Which organ pumps blood?", "Heart", ["Liver", "Lungs", "Kidney"], "The heart pumps blood throughout the body."),
    ("What is the largest organ of the body?", "Skin", ["Liver", "Brain", "Lungs"], "The skin is the largest organ."),
    ("What does a dentist treat?", "Teeth", ["Eyes", "Bones", "Skin"], "Dentists specialize in oral health and teeth."),
    ("What is the normal body temperature in Celsius?", "37°C", ["36°C", "38°C", "40°C"], "Normal body temperature is approximately 37 degrees Celsius."),
    ("What do you call a doctor who treats children?", "Pediatrician", ["Cardiologist", "Dermatologist", "Neurologist"], "Pediatricians specialize in the medical care of infants, children, and adolescents."),
    ("What is the medical term for a break in a bone?", "Fracture", ["Sprain", "Strain", "Bruise"], "A fracture is a broken bone."),
    ("Which organ filters blood?", "Kidney", ["Stomach", "Pancreas", "Gallbladder"], "Kidneys filter waste products from the blood."),
    ("What is the main function of the lungs?", "Breathing", ["Digestion", "Circulation", "Thinking"], "Lungs are responsible for gas exchange (breathing)."),
    ("What instrument does a doctor use to listen to the heart?", "Stethoscope", ["Microscope", "Thermometer", "Otoscope"], "A stethoscope is used to listen to internal body sounds."),
    ("What is the common name for the patella?", "Kneecap", ["Elbow", "Wrist", "Ankle"], "The patella is the kneecap."),
    ("What causes the flu?", "Virus", ["Bacteria", "Fungus", "Parasite"], "Influenza is caused by a virus."),
    ("What is the fluid that circulates in the body?", "Blood", ["Lymph", "Bile", "Saliva"], "Blood transports oxygen and nutrients."),
]

# Medium (12)
med_medium = [
    ("What is the medical term for high blood pressure?", "Hypertension", ["Hypotension", "Hyperglycemia", "Tachycardia"], "Hypertension is the medical term for high blood pressure."),
    ("What does DNA stand for?", "Deoxyribonucleic Acid", ["Ribonucleic Acid", "Deoxyribose Acid", "Dual Nitrogen Acid"], "DNA stands for Deoxyribonucleic Acid."),
    ("Who developed the first polio vaccine?", "Jonas Salk", ["Louis Pasteur", "Alexander Fleming", "Edward Jenner"], "Jonas Salk developed the first successful polio vaccine."),
    ("What is the medical term for a heart attack?", "Myocardial Infarction", ["Cardiac Arrest", "Stroke", "Angina"], "Myocardial Infarction is the technical term for a heart attack."),
    ("Which blood type is the universal recipient?", "AB Positive", ["O Negative", "A Positive", "B Negative"], "AB Positive individuals can receive blood from any type."),
    ("What is the inflammation of the liver called?", "Hepatitis", ["Gastritis", "Nephritis", "Dermatitis"], "Hepatitis is inflammation of the liver."),
    ("What is the largest part of the brain?", "Cerebrum", ["Cerebellum", "Brainstem", "Thalamus"], "The cerebrum is the largest part of the brain."),
    ("What condition is characterized by low blood sugar?", "Hypoglycemia", ["Hyperglycemia", "Diabetes", "Anemia"], "Hypoglycemia means low blood sugar."),
    ("What is the study of the skin called?", "Dermatology", ["Cardiology", "Neurology", "Oncology"], "Dermatology is the branch of medicine dealing with the skin."),
    ("Which vitamin is essential for blood clotting?", "Vitamin K", ["Vitamin C", "Vitamin A", "Vitamin D"], "Vitamin K is necessary for blood clotting."),
    ("What is the medical term for the voice box?", "Larynx", ["Pharynx", "Trachea", "Esophagus"], "The larynx is the voice box."),
    ("What is the body's first line of defense against infection?", "Skin", ["White blood cells", "Antibodies", "Lymph nodes"], "The skin acts as a physical barrier against pathogens."),
]

# Hard (15)
med_hard = [
    ("What is the medical term for the windpipe?", "Trachea", ["Esophagus", "Bronchus", "Larynx"], "The trachea is the windpipe."),
    ("Who is known as the 'Father of Medicine'?", "Hippocrates", ["Galen", "Avicenna", "Paracelsus"], "Hippocrates is considered the father of medicine."),
    ("What is the term for inflammation of the joints?", "Arthritis", ["Osteoporosis", "Tendinitis", "Bursitis"], "Arthritis is the swelling and tenderness of joints."),
    ("What is the smallest bone in the human body?", "Stapes", ["Incus", "Malleus", "Hyoid"], "The stapes in the ear is the smallest bone."),
    ("Which gland regulates metabolism?", "Thyroid", ["Pituitary", "Adrenal", "Pancreas"], "The thyroid gland produces hormones that regulate metabolism."),
    ("What is the medical term for the thigh bone?", "Femur", ["Tibia", "Fibula", "Humerus"], "The femur is the thigh bone."),
    ("What autoimmune disease affects the pancreas?", "Type 1 Diabetes", ["Type 2 Diabetes", "Lupus", "Multiple Sclerosis"], "Type 1 Diabetes is an autoimmune reaction that destroys insulin-producing cells."),
    ("What is the study of tumors called?", "Oncology", ["Pathology", "Radiology", "Hematology"], "Oncology is the study and treatment of tumors and cancer."),
    ("Which part of the brain controls breathing?", "Medulla Oblongata", ["Cerebellum", "Hippocampus", "Amygdala"], "The medulla oblongata regulates breathing and heart rate."),
    ("What is the medical term for a stroke?", "Cerebrovascular Accident", ["Myocardial Infarction", "Pulmonary Embolism", "Aneurysm"], "A stroke is medically known as a Cerebrovascular Accident (CVA)."),
    ("What is the longest muscle in the body?", "Sartorius", ["Quadriceps", "Gluteus Maximus", "Biceps"], "The sartorius muscle in the thigh is the longest."),
    ("Which scientist discovered penicillin?", "Alexander Fleming", ["Louis Pasteur", "Robert Koch", "Joseph Lister"], "Alexander Fleming discovered penicillin in 1928."),
    ("What is the master gland of the endocrine system?", "Pituitary Gland", ["Thyroid", "Adrenal", "Pineal"], "The pituitary gland controls many other glands."),
    ("What is the medical term for nearsightedness?", "Myopia", ["Hyperopia", "Presbyopia", "Astigmatism"], "Myopia is the condition of being nearsighted."),
    ("What is the hardest substance in the human body?", "Tooth Enamel", ["Bone", "Cartilage", "Nail"], "Tooth enamel is the hardest substance in the body."),
]

for quest, ans, wrong, exp in bio_easy:
    all_q.append(q("Science: Biology", "easy", quest, ans, wrong, exp))
for quest, ans, wrong, exp in bio_medium:
    all_q.append(q("Science: Biology", "medium", quest, ans, wrong, exp))
for quest, ans, wrong, exp in bio_hard:
    all_q.append(q("Science: Biology", "hard", quest, ans, wrong, exp))

for quest, ans, wrong, exp in chem_easy:
    all_q.append(q("Chemistry", "easy", quest, ans, wrong, exp))
for quest, ans, wrong, exp in chem_medium:
    all_q.append(q("Chemistry", "medium", quest, ans, wrong, exp))
for quest, ans, wrong, exp in chem_hard:
    all_q.append(q("Chemistry", "hard", quest, ans, wrong, exp))

for quest, ans, wrong, exp in phys_easy:
    all_q.append(q("Physics", "easy", quest, ans, wrong, exp))
for quest, ans, wrong, exp in phys_medium:
    all_q.append(q("Physics", "medium", quest, ans, wrong, exp))
for quest, ans, wrong, exp in phys_hard:
    all_q.append(q("Physics", "hard", quest, ans, wrong, exp))

for quest, ans, wrong, exp in astro_easy:
    all_q.append(q("Astronomy", "easy", quest, ans, wrong, exp))
for quest, ans, wrong, exp in astro_medium:
    all_q.append(q("Astronomy", "medium", quest, ans, wrong, exp))
for quest, ans, wrong, exp in astro_hard:
    all_q.append(q("Astronomy", "hard", quest, ans, wrong, exp))

for quest, ans, wrong, exp in med_easy:
    all_q.append(q("Medicine", "easy", quest, ans, wrong, exp))
for quest, ans, wrong, exp in med_medium:
    all_q.append(q("Medicine", "medium", quest, ans, wrong, exp))
for quest, ans, wrong, exp in med_hard:
    all_q.append(q("Medicine", "hard", quest, ans, wrong, exp))

# Print all questions
for i, quest in enumerate(all_q):
    print(quest, end="")
    if i < len(all_q) - 1:
        print(",")
    else:
        print()

print(f"\n// Generated {len(all_q)} Science questions")
