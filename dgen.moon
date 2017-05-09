
lgi = require 'lgi'
lpeg = require 'lpeg'
serpent = require 'serpent'
import Gtk,Gdk from lgi
import P,C,Ct,S,V from lpeg

local clipboard

signature = Gtk.Entry {
  placeholder_text: 'Signature'
}
description = Gtk.TextView {
  expand: true
  wrap_mode: 'WORD'
}
output = Gtk.TextView {
  expand: true
  wrap_mode: 'WORD'
}

make_lines = (n,data) ->
  txt = [[]]
  buf = {}
  for i=1,#data
    table.insert(buf,data[i])
    if i%n == 0
      txt ..= table.concat(buf," ")
      buf = {}
      txt ..= "\\n"
  txt

generate = Gtk.Button { label: 'Generate' }
generate.on_clicked = () =>
  grammar = P {
    'words'
    words: Ct((C(V'word') + V'notword')^0)
    notword: S' \n'
    word: (P(1) - V'notword')^1
  }
  data = grammar\match(description.buffer.text)
  pdata = make_lines(10,data)
  final_txt = "'KEY': { signature: '#{signature.text}', description: '# #{signature.text}\\n\\n#{pdata}' },"
  output.buffer.text = final_txt

entrybox = Gtk.Box {
  orientation: 'VERTICAL'
  signature
  Gtk.Frame {Gtk.ScrolledWindow {description}}
  generate
}

toclipboard = Gtk.Button { label: 'Copy' }
with toclipboard\get_style_context!
  \add_class 'destructive-action'

toclipboard.on_clicked = () =>
  clipboard\set_text output.buffer.text, -1
  output.buffer.text = ''
  signature.text = ''
  description.buffer.text = ''

outbox = Gtk.Box {
  margin_top: 5
  orientation: 'VERTICAL'
  Gtk.Frame {Gtk.ScrolledWindow {output}}
  toclipboard
}

with entrybox\get_style_context!
  \add_class 'linked'

with outbox\get_style_context!
  \add_class 'linked'

window = Gtk.Window {
  width_request: 500
  height_request: 500
  title: 'Description Generator'
  Gtk.Box {
    margin: 5
    orientation: 'VERTICAL'
    entrybox
    outbox
  }
}

display = window\get_display!
clipboard = Gtk.Clipboard.get_for_display(display, Gdk.SELECTION_CLIPBOARD)

window.on_destroy = () => Gtk.main_quit!

window\show_all!
Gtk\main!
