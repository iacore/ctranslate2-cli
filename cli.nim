# sentencepiece can't handle newline.
# https://github.com/google/sentencepiece/issues/101

{.define: nimExperimentalLinenoiseExtra.}

import std/[os, strformat, strutils, paths]
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

proc print_languages =
  var files: seq[string] = @[]
  for file in basedir.walkDir():
    files &= file.path.extractFilename()
  echo "Languages: " & files.join(" ")

set_lang("en_de")

var rl = Noise.init


print_languages()

var i = 0

while true:
  echo &">>>[{i}] {lang}"
  var translated = ""
  while true:
    if rl.readLine():
      let line = rl.getLine()
      if translated.len == 0:
        if line.len > 0 and line[0] == '.':
          let cmd = line[1..^1]
          if cmd == "help":
            echo ""
            echo ".help    Show this help"
            echo ".{lang}  Set Language"
            print_languages()
          else:
            set_lang(cmd)
            break
          continue
      # echo rl.getLine.repr
      translated &= t.translate(line)
      translated &= '\n'
    else:
      case rl.getKeyType
      of ktCtrlC:
        quit(0)
      of ktCtrlD:
        break
      else:
        discard

  echo &"<<<[{i}] {lang}"
  echo translated
  i += 1
