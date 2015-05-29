" Vim monokai color scheme

let g:colors_name="monokai"

" If at least 8 colors aren't supported exit now
" if !has("gui_running") && $t_Co < 8
"   finish
" endif

function s:gui_color(identifier, gui_dark, gui_light)
  if (&background == "light")
    exec "let " . a:identifier . "=" . a:gui_light
  else
    exec "let " . a:identifier . "=" . a:gui_dark
  endif
endfunction

function s:cterm_color(identifier, cterm256, cterm88, cterm16, cterm8)
  if &t_Co >=256
    exec "let " . a:identifier . "=" . a:cterm256
  else if &t_Co >=88
    exec "let " . a:identifier . "=" . a:cterm88
  else if &t_Co >=16
    exec "let " . a:identifier . "=" . a:cterm16
  else if $t_Co >=8
    exec "let " . a:identifier . "=" . a:cterm8
  endif
endfunction

" Define Colors
call s:gui_color("gui01", "#f8f8f0", "")
call s:gui_color("gui02", "#dfdfd9", "")
call s:gui_color("gui03", "#a59f85", "")
call s:gui_color("gui04", "#75715e", "")
call s:gui_color("gui05", "#49483e", "")
call s:gui_color("gui06", "#272822", "")
call s:gui_color("gui07", "#1b1c18", "")
call s:gui_color("gui08", "#e6db74", "")
call s:gui_color("gui09", "#fd971f", "")
call s:gui_color("gui10", "#f92672", "")
call s:gui_color("gui11", "#ae81ff", "")
call s:gui_color("gui12", "#66d9ef", "")
call s:gui_color("gui13", "#a6e22e", "")
call s:cterm_color("cterm01", "", "", "", "")
call s:cterm_color("cterm02", "", "", "", "")
call s:cterm_color("cterm03", "", "", "", "")
call s:cterm_color("cterm04", "", "", "", "")
call s:cterm_color("cterm05", "", "", "", "")
call s:cterm_color("cterm06", "", "", "", "")
call s:cterm_color("cterm07", "", "", "", "")
call s:cterm_color("cterm08", "222", "222", "", "")
call s:cterm_color("cterm09", "", "", "", "")
call s:cterm_color("cterm10", "161", "161", "", "")
call s:cterm_color("cterm11", "135", "135", "", "")
call s:cterm_color("cterm12", "", "", "", "")
call s:cterm_color("cterm13", "154", "154", "", "")

hi clear
syntax reset

" Highlighting function
function <sid>hi(group, guifg, guibg, ctermfg, ctermbg, attr)
  if a:guifg != ""
    exec "hi " . a:group . " guifg=#" . a:guifg
  endif
  if a:guibg != ""
    exec "hi " . a:group . " guibg=#" . a:guibg
  endif
  if a:ctermfg != ""
    exec "hi " . a:group . " ctermfg=" . a:ctermfg
  endif
  if a:ctermbg != ""
    exec "hi " . a:group . " ctermbg=" . a:ctermbg
  endif
  if a:attr != ""
    exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
  endif
endfunction

" Vim editor colors
call <sid>hi("Bold",          "", "", "", "", "bold")
call <sid>hi("Debug",         s:gui08, "", s:cterm08, "", "")
call <sid>hi("Directory",     s:gui09, "", s:cterm13, "", "")
call <sid>hi("ErrorMsg",      s:gui08, s:gui01, s:cterm08, s:cterm01, "")
call <sid>hi("Exception",     s:gui08, "", s:cterm08, "", "")
call <sid>hi("FoldColumn",    "", s:gui01, "", s:cterm01, "")
call <sid>hi("Folded",        s:gui03, s:gui01, s:cterm03, s:cterm01, "")
call <sid>hi("IncSearch",     s:gui01, s:gui09, s:cterm01, s:cterm09, "none")
call <sid>hi("Italic",        "", "", "", "", "none")
call <sid>hi("Macro",         s:gui08, "", s:cterm08, "", "")
call <sid>hi("MatchParen",    s:gui01, s:gui03, s:cterm01, s:cterm03,  "")
call <sid>hi("ModeMsg",       s:gui13, "", s:cterm13, "", "")
call <sid>hi("MoreMsg",       s:gui13, "", s:cterm13, "", "")
call <sid>hi("Question",      s:gui09, "", s:cterm13, "", "")
call <sid>hi("Search",        s:gui03, s:gui10, s:cterm03, s:cterm10,  "")
call <sid>hi("SpecialKey",    s:gui03, "", s:cterm03, "", "")
call <sid>hi("TooLong",       s:gui08, "", s:cterm08, "", "")
call <sid>hi("Underlined",    s:gui08, "", s:cterm08, "", "")
call <sid>hi("Visual",        "", s:gui02, "", s:cterm02, "")
call <sid>hi("VisualNOS",     s:gui08, "", s:cterm08, "", "")
call <sid>hi("WarningMsg",    s:gui08, "", s:cterm08, "", "")
call <sid>hi("WildMenu",      s:gui08, "", s:cterm08, "", "")
call <sid>hi("Title",         s:gui09, "", s:cterm13, "", "none")
call <sid>hi("Conceal",       s:gui09, s:gui01, s:cterm13, s:cterm01, "")
call <sid>hi("Cursor",        s:gui01, s:gui05, s:cterm01, s:cterm05, "")
call <sid>hi("NonText",       s:gui03, "", s:cterm03, "", "")
call <sid>hi("Normal",        s:gui05, s:gui01, s:cterm05, s:cterm01, "")
call <sid>hi("LineNr",        s:gui03, s:gui01, s:cterm03, s:cterm01, "")
call <sid>hi("SignColumn",    s:gui03, s:gui01, s:cterm03, s:cterm01, "")
call <sid>hi("SpecialKey",    s:gui03, "", s:cterm03, "", "")
call <sid>hi("StatusLine",    s:gui04, s:gui02, s:cterm04, s:cterm02, "none")
call <sid>hi("StatusLineNC",  s:gui03, s:gui01, s:cterm03, s:cterm01, "none")
call <sid>hi("VertSplit",     s:gui02, s:gui02, s:cterm02, s:cterm02, "none")
call <sid>hi("ColorColumn",   "", s:gui01, "", s:cterm01, "none")
call <sid>hi("CursorColumn",  "", s:gui01, "", s:cterm01, "none")
call <sid>hi("CursorLine",    "", s:gui01, "", s:cterm01, "none")
call <sid>hi("CursorLineNr",  s:gui03, s:gui01, s:cterm03, s:cterm01, "")
call <sid>hi("PMenu",         s:gui04, s:gui01, s:cterm04, s:cterm01, "none")
call <sid>hi("PMenuSel",      s:gui01, s:gui04, s:cterm01, s:cterm04, "")
call <sid>hi("TabLine",       s:gui03, s:gui01, s:cterm03, s:cterm01, "none")
call <sid>hi("TabLineFill",   s:gui03, s:gui01, s:cterm03, s:cterm01, "none")
call <sid>hi("TabLineSel",    s:gui13, s:gui01, s:cterm13, s:cterm01, "none")

" Standard syntax highlighting
call <sid>hi("Boolean",      s:gui09, "", s:cterm09, "", "")
call <sid>hi("Character",    s:gui08, "", s:cterm08, "", "")
call <sid>hi("Comment",      s:gui03, "", s:cterm03, "", "")
call <sid>hi("Conditional",  s:gui11, "", s:cterm11, "", "")
call <sid>hi("Constant",     s:gui09, "", s:cterm09, "", "")
call <sid>hi("Define",       s:gui11, "", s:cterm11, "", "none")
call <sid>hi("Delimiter",    s:gui13, "", s:cterm13, "", "")
call <sid>hi("Float",        s:gui09, "", s:cterm09, "", "")
call <sid>hi("Function",     s:gui13, "", s:cterm13, "", "")
call <sid>hi("Identifier",   s:gui08, "", s:cterm08, "", "none")
call <sid>hi("Include",      s:gui09, "", s:cterm13, "", "")
call <sid>hi("Keyword",      s:gui11, "", s:cterm11, "", "")
call <sid>hi("Label",        s:gui10, "", s:cterm10, "", "")
call <sid>hi("Number",       s:gui09, "", s:cterm09, "", "")
call <sid>hi("Operator",     s:gui05, "", s:cterm05, "", "none")
call <sid>hi("PreProc",      s:gui10, "", s:cterm10, "", "")
call <sid>hi("Repeat",       s:gui10, "", s:cterm10, "", "")
call <sid>hi("Special",      s:gui12, "", s:cterm12, "", "")
call <sid>hi("SpecialChar",  s:gui13, "", s:cterm13, "", "")
call <sid>hi("Statement",    s:gui08, "", s:cterm08, "", "")
call <sid>hi("StorageClass", s:gui10, "", s:cterm10, "", "")
call <sid>hi("String",       s:gui13, "", s:cterm13, "", "")
call <sid>hi("Structure",    s:gui11, "", s:cterm11, "", "")
call <sid>hi("Tag",          s:gui10, "", s:cterm10, "", "")
call <sid>hi("Todo",         s:gui10, s:gui01, s:cterm10, s:cterm01, "")
call <sid>hi("Type",         s:gui10, "", s:cterm10, "", "none")
call <sid>hi("Typedef",      s:gui10, "", s:cterm10, "", "")

" C highlighting
call <sid>hi("cOperator",   s:gui12, "", s:cterm12, "", "")
call <sid>hi("cPreCondit",  s:gui11, "", s:cterm11, "", "")

" CSS highlighting
call <sid>hi("cssBraces",      s:gui05, "", s:cterm05, "", "")
call <sid>hi("cssClassName",   s:gui11, "", s:cterm11, "", "")
call <sid>hi("cssColor",       s:gui12, "", s:cterm12, "", "")

" Diff highlighting
call <sid>hi("DiffAdd",      s:gui13, s:gui01,  s:cterm13, s:cterm01, "")
call <sid>hi("DiffChange",   s:gui03, s:gui01,  s:cterm03, s:cterm01, "")
call <sid>hi("DiffDelete",   s:gui08, s:gui01,  s:cterm08, s:cterm01, "")
call <sid>hi("DiffText",     s:gui09, s:gui01,  s:cterm13, s:cterm01, "")
call <sid>hi("DiffAdded",    s:gui13, s:gui01,  s:cterm13, s:cterm01, "")
call <sid>hi("DiffFile",     s:gui08, s:gui01,  s:cterm08, s:cterm01, "")
call <sid>hi("DiffNewFile",  s:gui13, s:gui01,  s:cterm13, s:cterm01, "")
call <sid>hi("DiffLine",     s:gui09, s:gui01,  s:cterm13, s:cterm01, "")
call <sid>hi("DiffRemoved",  s:gui08, s:gui01,  s:cterm08, s:cterm01, "")

" Git highlighting
call <sid>hi("gitCommitOverflow",  s:gui08, "", s:cterm08, "", "")
call <sid>hi("gitCommitSummary",   s:gui13, "", s:cterm13, "", "")
  
" GitGutter highlighting
call <sid>hi("GitGutterAdd",     s:gui13, s:gui01, s:cterm13, s:cterm01, "")
call <sid>hi("GitGutterChange",  s:gui09, s:gui01, s:cterm13, s:cterm01, "")
call <sid>hi("GitGutterDelete",  s:gui08, s:gui01, s:cterm08, s:cterm01, "")
call <sid>hi("GitGutterChangeDelete",  s:gui11, s:gui01, s:cterm11, s:cterm01, "")

" HTML highlighting
call <sid>hi("htmlBold",    s:gui10, "", s:cterm10, "", "")
call <sid>hi("htmlItalic",  s:gui11, "", s:cterm11, "", "")
call <sid>hi("htmlEndTag",  s:gui05, "", s:cterm05, "", "")
call <sid>hi("htmlTag",     s:gui05, "", s:cterm05, "", "")

" JavaScript highlighting
call <sid>hi("javaScript",        s:gui05, "", s:cterm05, "", "")
call <sid>hi("javaScriptBraces",  s:gui05, "", s:cterm05, "", "")
call <sid>hi("javaScriptNumber",  s:gui09, "", s:cterm09, "", "")

" Markdown highlighting
call <sid>hi("markdownCode",              s:gui13, "", s:cterm13, "", "")
call <sid>hi("markdownError",             s:gui05, s:gui01, s:cterm05, s:cterm01, "")
call <sid>hi("markdownCodeBlock",         s:gui13, "", s:cterm13, "", "")
call <sid>hi("markdownHeadingDelimiter",  s:gui09, "", s:cterm13, "", "")

" NERDTree highlighting
call <sid>hi("NERDTreeDirSlash",  s:gui09, "", s:cterm13, "", "")
call <sid>hi("NERDTreeExecFile",  s:gui05, "", s:cterm05, "", "")

" PHP highlighting
call <sid>hi("phpMemberSelector",  s:gui05, "", s:cterm05, "", "")
call <sid>hi("phpComparison",      s:gui05, "", s:cterm05, "", "")
call <sid>hi("phpParent",          s:gui05, "", s:cterm05, "", "")

" Python highlighting
call <sid>hi("pythonOperator",  s:gui11, "", s:cterm11, "", "")
call <sid>hi("pythonRepeat",    s:gui11, "", s:cterm11, "", "")

" Ruby highlighting
call <sid>hi("rubyAttribute",               s:gui09, "", s:cterm13, "", "")
call <sid>hi("rubyConstant",                s:gui10, "", s:cterm10, "", "")
call <sid>hi("rubyInterpolation",           s:gui13, "", s:cterm13, "", "")
call <sid>hi("rubyInterpolationDelimiter",  s:gui13, "", s:cterm13, "", "")
call <sid>hi("rubyRegexp",                  s:gui12, "", s:cterm12, "", "")
call <sid>hi("rubySymbol",                  s:gui13, "", s:cterm13, "", "")
call <sid>hi("rubyStringDelimiter",         s:gui13, "", s:cterm13, "", "")

" SASS highlighting
call <sid>hi("sassidChar",     s:gui08, "", s:cterm08, "", "")
call <sid>hi("sassClassChar",  s:gui09, "", s:cterm09, "", "")
call <sid>hi("sassInclude",    s:gui11, "", s:cterm11, "", "")
call <sid>hi("sassMixing",     s:gui11, "", s:cterm11, "", "")
call <sid>hi("sassMixinName",  s:gui09, "", s:cterm13, "", "")

" Signify highlighting
call <sid>hi("SignifySignAdd",     s:gui13, s:gui01, s:cterm13, s:cterm01, "")
call <sid>hi("SignifySignChange",  s:gui09, s:gui01, s:cterm13, s:cterm01, "")
call <sid>hi("SignifySignDelete",  s:gui08, s:gui01, s:cterm08, s:cterm01, "")

" Spelling highlighting
call <sid>hi("SpellBad",     "", s:gui01, "", s:cterm01, "undercurl")
call <sid>hi("SpellLocal",   "", s:gui01, "", s:cterm01, "undercurl")
call <sid>hi("SpellCap",     "", s:gui01, "", s:cterm01, "undercurl")
call <sid>hi("SpellRare",    "", s:gui01, "", s:cterm01, "undercurl")
