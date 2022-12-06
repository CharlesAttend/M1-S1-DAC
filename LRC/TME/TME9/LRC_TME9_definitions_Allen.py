"""

Dictionnaires décrivants les transposés et symétries de relations, 
ainsi que les listes de relations obtenues avec les compositions de base
dans le tableau donné en TD

"""

# transpose : dict[str:str]
transpose = {
    '<': '>',
    '>': '<',
    'e': 'et',
    's': 'st',
    'et': 'e',
    'st': 's',
    'd': 'dt',
    'm': 'mt',
    'dt': 'd',
    'mt': 'm',
    'o': 'ot',
    'ot': 'o',
    '=': '='
}

# symetrie : dict[str:str]
symetrie = {
    '<': '>',
    '>': '<',
    'e': 's',
    's': 'e',
    'et': 'st',
    'st': 'et',
    'd': 'd',
    'm': 'mt',
    'dt': 'dt',
    'mt': 'm',
    'o': 'ot',
    'ot': 'o',
    '=': '='
}

# compositionBase : dict[tuple[str,str]:set[str]]
compositionBase = {
    ('<', '<'): {'<'},
    ('<', 'm'): {'<'},
    ('<', 'o'): {'<'},
    ('<', 'et'): {'<'},
    ('<', 's'): {'<'},
    ('<', 'd'): {'<', 'm', 'o', 's', 'd'},
    ('<', 'dt'): {'<'},
    ('<', 'e'): {'<', 'm', 'o', 's', 'd'},
    ('<', 'st'): {'<'},
    ('<', 'ot'): {'<', 'm', 'o', 's', 'd'},
    ('<', 'mt'): {'<', 'm', 'o', 's', 'd'},
    ('<', '>'): {'<', '>', 'm', 'mt', 'o', 'ot', 'e', 'et', 's', 'st', 'd', 'dt', '='},
    ('m', 'm'): {'<'},
    ('m', 'o'): {'<'},
    ('m', 'et'): {'<'},
    ('m', 's'): {'m'},
    ('m', 'd'): {'o', 's', 'd'},
    ('m', 'dt'): {'<'},
    ('m', 'e'): {'o', 's', 'd'},
    ('m', 'st'): {'m'},
    ('m', 'ot'): {'o', 's', 'd'},
    ('m', 'mt'): {'e', 'et', '='},
    ('o', 'o'): {'<', 'm', 'o'},
    ('o', 'et'): {'<', 'm', 'o'},
    ('o', 's'): {'o'},
    ('o', 'd'): {'o', 's', 'd'},
    ('o', 'dt'): {'<', 'm', 'o', 'et', 'dt'},
    ('o', 'e'): {'o', 's', 'd'},
    ('o', 'st'): {'o', 'et', 'dt'},
    ('o', 'ot'): {'o', 'ot', 'e', 'et', 'd', 'dt', 'st', 's', '='},
    ('s', 'et'): {'<', 'm', 'o'},
    ('s', 's'): {'s'},
    ('s', 'd'): {'d'},
    ('s', 'dt'): {'<', 'm', 'o', 'et', 'dt'},
    ('s', 'e'): {'d'},
    ('s', 'st'): {'s', 'st', '='},
    ('et', 's'): {'o'},
    ('et', 'd'): {'o', 's', 'd'},
    ('et', 'dt'): {'dt'},
    ('et', 'e'): {'e', 'et', '='},
    ('d', 'd'): {'d'},
    ('d', 'dt'): {'<', '>', 'm', 'mt', 'o', 'ot', 'e', 'et', 's', 'st', 'd', 'dt', '='},
    ('dt', 'd'): {'o', 'ot', 'e', 'et', 'd', 'dt', 'st', 's', '='}
}   
