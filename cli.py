import sys, pathlib
from api import Translator

basedir = pathlib.Path('~/.local/share/argos-translate/packages').expanduser()
t = Translator(basedir / "en_de")

while True:
    to_translate = ""

    while True:
        line = sys.stdin.readline()
        if len(line) == 0:
            break
        to_translate += line
    
    for guess in t.translate(to_translate):
        print(guess)
