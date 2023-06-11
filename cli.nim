# sentencepiece can't handle newline.
# https://github.com/google/sentencepiece/issues/101

{.define: nimExperimentalLinenoiseExtra.}

import std/[os, strformat, strutils, paths, enumerate]
import noise
import api
import nimpy

const basedir = "~/.local/share/argos-translate/packages".expandTilde

var lang: string
var t: Translator

proc set_lang(newlang: string) =
  let langdir = basedir / newlang
  if langdir.dirExists.not:
    echo &"E: no language {newlang.repr}"
    return
  try:
    let tr = initTranslator(langdir)
    lang = newlang
    t = tr
  except Exception:
    discard
proc print_languages =
  var files: seq[string] = @[]
  for file in basedir.walkDir():
    files &= file.path.extractFilename()
  echo "Languages: " & files.join(" ")

#set_lang("en_de")
set_lang("de_en")

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
            echo ".        Reverse languages"
            echo ".help    Show this help"
            echo ".{lang}  Set Language"
            print_languages()
          elif cmd == "":
            break
          elif cmd.len == 5:
            set_lang(cmd)
            break
          else:
            echo &"E: invalid command: {cmd}"
            echo &"E: type .help for help"
          continue
      # echo rl.getLine.repr
      let parts = line.split(".")
      for i, part in enumerate(parts):
        if i != parts.len - 1:
          translated &= t.translate(part & ".")
        else:
          translated &= t.translate(part)
      translated &= '\n'
    else:
      case rl.getKeyType
      of ktCtrlC:
        quit(0)
      of ktCtrlD:
        break
      else:
        discard

  if translated == "":
    let tokens = lang.split("_")
    doAssert(tokens.len == 2)
    set_lang(tokens[1] & "_" & tokens[0])
  else:
    echo &"<<<[{i}] {lang}"
    echo translated
    i += 1
