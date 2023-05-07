This is a cli application for Argos Translate.

## Download Models

Download from [Direct Link/IPFS: JSON](https://github.com/argosopentech/argospm-index/blob/main/index.json). Also see [Web Index](https://www.argosopentech.com/argospm/index/).

The file extension is `.argosmodel` but it's a Zip file. Extract it under for example `models/ar_en`.

## Usage

```
pip install ctranslate2 sentencepiece
python cli.py
```

After entering text, press Ctrl+D on an **empty line** to submit.

Press Ctrl+C to exit.

## TODO

Python is too heavy weight for this. Can swap it out later.
