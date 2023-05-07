import pathlib
import ctranslate2, sentencepiece

# import logging
# logger = logging.getLogger("ctranslate2-gui")

class Translator:
    def __init__(self, base_path: str | pathlib.Path):
        base_path = pathlib.Path(base_path)
        self.translator = ctranslate2.Translator(str(base_path / "model"))
        self.tokenizer = sentencepiece.SentencePieceProcessor(str(base_path / "sentencepiece.model"))

    def translate(self, s: str) -> list[str]:
        p = self.tokenizer
        a = self.translator
        tokens = p.encode(s, out_type=str)
        choices = [p.decode(translated_tokens) for translated_tokens in a.translate_batch([tokens])[0].hypotheses]
        return choices


if __name__ == '__main__':
    basedir = pathlib.Path('~/.local/share/argos-translate/packages').expanduser()
    t = Translator(basedir / "en_de")
    print(t.translate("Hello"))
