import std/os
import nimpy

let py = pyBuiltinsModule()
let ctranslate2 = pyImport("ctranslate2")
let sentencepiece = pyImport("sentencepiece")

type Translator* = object
  tr: PyObject
  tok: PyObject

proc initTranslator*(base_path: string): Translator =
  result.tr = ctranslate2.Translator(base_path / "model")
  result.tok = sentencepiece.SentencePieceProcessor(base_path / "sentencepiece.model")

proc translate*(self: Translator, s: string): string =
  let tokens = self.tok.encode(s, out_type=py.str)
  #echo tokens
  let choices = self.tr.translate_batch([tokens])[0].hypotheses
  doAssert py.len(choices).to(int) == 1
  self.tok.decode(choices[0]).to(string)

when isMainModule:
  let basedir = "~/.local/share/argos-translate/packages".expandTilde
  let t = initTranslator(basedir / "en_de")
  echo(t.translate("Hello"))
