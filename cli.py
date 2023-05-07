import sys, pathlib, argparse
from api import Translator

basedir = pathlib.Path("models")


def main(modeldir):
    t = Translator(modeldir)

    while True:
        print(">>>")
        to_translate = ""

        while True:
            line = sys.stdin.readline()
            if len(line) == 0:
                break
            to_translate += line

        for guess in t.translate(to_translate):
            print("<<<")
            print(guess)


def fail(s):
    print(s, file=sys.stderr)
    exit(1)


parser = argparse.ArgumentParser(
    description="CLI for Argos Translate",
)
parser.add_argument('lang', help="pair of language codes, e.g. en_ar")
args = parser.parse_args()

modeldir = basedir / args.lang

if not modeldir.exists():
    fail(f"No directory: {modeldir}\nlang={args.lang}")
try:
    main(modeldir=modeldir)
except KeyboardInterrupt:
    pass
