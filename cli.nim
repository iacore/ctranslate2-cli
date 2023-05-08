{.define: nimExperimentalLinenoiseExtra.}

import std/[os, strformat]
import noise
import api

const basedir = "~/.local/share/argos-translate/packages".expandTilde

var lang: string
var t: Translator

proc set_lang(newlang: string) =
  let langdir = basedir / newlang
  if langdir.dirExists.not:
    echo &"E: no language {newlang.repr}"
    return
  lang = newlang
  t = initTranslator(langdir)

set_lang("en_de")

var rl = Noise.init

# https://github.com/google/sentencepiece/issues/101

while true:
  echo &">>> {lang}"
  var translated = ""
  while true:
    if rl.readLine():
      # echo rl.getLine.repr
      translated &= t.translate(rl.getLine)
      translated &= '\n'
    else:
      case rl.getKeyType
      of ktCtrlC:
        quit(0)
      of ktCtrlD:
        break
      else:
        discard

  echo &"<<< {lang}"
  echo translated
