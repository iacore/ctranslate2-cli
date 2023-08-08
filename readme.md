Disclaimer: the tokenizer treats `\n` as ` `. I do not endorse CTranslate2 for this reason.

## What

This is a cli application for Argos Translate models. It is much faster and lighter than argostranslategui.

[![demo](https://asciinema.org/a/kwYbzYMjZqwPDtHCvRezPcXEb.svg)](https://asciinema.org/a/kwYbzYMjZqwPDtHCvRezPcXEb?autoplay=1)

## Download Models

Download from [Direct Link/IPFS: JSON](https://github.com/argosopentech/argospm-index/blob/main/index.json). Also see [Web Index](https://www.argosopentech.com/argospm/index/).

The file extension is `.argosmodel` but it's a Zip file. Extract it under for example `models/ar_en`.

## Usage - Python Version

```
pip install ctranslate2 sentencepiece
# $PWD must be repo root
python cli.py
```

After entering text, press Ctrl+D **on an empty line** to submit. (This sends EOF.)

Press Ctrl+C to exit.

## Usage - Nim Version

```shell
pip install ctranslate2 sentencepiece # yes, you still need to install the python packages

# you need a recent Nim version
nimble install nimpy
nimble install noise
nim c cli.nim
./cli
```

The usage is similar to that of the Python version.

`.help` shows help. `.en_ar` changes the current language pair.

## TODO

Python is too heavy weight for this. Can swap it out later.
