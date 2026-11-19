% Number chronologically within each type; display by authorship group and curated order.
% Supports conventional BibTeX fields plus optional cvvenue.
ENTRY { author title booktitle journal year note url cvvenue cvhighlight cvhighlightcolor cvselected number } {} { cvgroup cvdisplaykey cvlabel }
INTEGERS { nameptr numnames pubcount ccount jcount pcount bcount ocount }
STRINGS { namestr fullname lastgroup prefix pubnumber }
FUNCTION {not} { { #0 } { #1 } if$ }
FUNCTION {and} { { } { pop$ #0 } if$ }
FUNCTION {or} { { pop$ #1 } { } if$ }
FUNCTION {format.authors}
{ author empty$
    { "" }
    { author 'namestr :=
      #1 'nameptr :=
      namestr num.names$ 'numnames :=
      ""
      { nameptr numnames > not }
      { namestr nameptr "{ff~}{vv~}{ll}{, jj}" format.name$ 'fullname :=
        nameptr #1 > { ", " * } 'skip$ if$
        fullname "Sky~Chenwei Wan" = fullname "Chenwei Wan" = or
        fullname "Sky Chenwei Wan" = or
          { "\textbf{" * fullname * "}" * }
          { fullname * }
        if$
        nameptr #1 + 'nameptr :=
      }
      while$
    }
  if$
}
FUNCTION {is.owner}
{ duplicate$ "Sky~Chenwei Wan" =
  swap$ duplicate$ "Chenwei Wan" =
  swap$ "Sky Chenwei Wan" = or or
}
FUNCTION {presort}
{ pubcount #1 + 'pubcount :=
  author empty$
    { #0 }
    { author #1 "{ff~}{vv~}{ll}{, jj}" format.name$ is.owner }
  if$
  cvselected empty$ 'skip$ { cvselected "true" = or } if$
    { "0" } { "1" } if$ 'cvgroup :=
  cvgroup "00000" pubcount int.to.str$ * #-5 #5 substring$ * 'cvdisplaykey :=
  year empty$ { "9999" } { year } if$
  "00000" pubcount int.to.str$ * #-5 #5 substring$ * 'sort.key$ :=
}
FUNCTION {begin.bib}
{ "" 'lastgroup :=
  #0 'ccount := #0 'jcount := #0 'pcount := #0 'bcount := #0 'ocount :=
}
FUNCTION {open.group}
{ cvgroup lastgroup = 'skip$
    { lastgroup empty$ 'skip$ { "\end{thebibliography}" write$ newline$ } if$
      cvgroup "0" =
        { "\section{Lead-Author Publications}" }
        { "\section{Contributing-Author Publications}" }
      if$ write$ newline$
      "\begin{thebibliography}{c99}" write$ newline$
      cvgroup 'lastgroup :=
    }
  if$
}
FUNCTION {number.entry}
{ type$ "inproceedings" = type$ "conference" = or
  { "c" 'prefix := ccount #1 + 'ccount := ccount }
  { type$ "article" =
    { "j" 'prefix := jcount #1 + 'jcount := jcount }
    { type$ "patent" =
      { "p" 'prefix := pcount #1 + 'pcount := pcount }
      { type$ "book" = type$ "incollection" = or
        { "b" 'prefix := bcount #1 + 'bcount := bcount }
        { "o" 'prefix := ocount #1 + 'ocount := ocount }
        if$
      }
      if$
    }
    if$
  }
  if$
  int.to.str$ 'pubnumber :=
}
FUNCTION {assign.label}
{ number.entry prefix pubnumber * 'cvlabel := }
FUNCTION {display.sort}
{ cvdisplaykey 'sort.key$ := }
FUNCTION {output.entry}
{ open.group
  "\bibitem[" write$ cvlabel write$ "]{" write$ cite$ write$ "}" write$ newline$
  "\pubtitle{" write$ url empty$ { "" } { url } if$ write$
  "}{" write$ title write$ "}\par" write$ newline$
  "\pubauthors{" write$ format.authors write$ "}\par" write$ newline$
  "\pubvenue{" write$
  cvvenue empty$
    { booktitle empty$ { journal empty$ { "" } { journal } if$ } { booktitle } if$
      write$ year empty$ 'skip$ { " (" write$ year write$ ")" write$ } if$
    }
    { cvvenue write$ }
  if$
  "}" write$
  type$ "patent" = number empty$ not and
    { "\enspace\textbullet\enspace Patent " write$ number write$ } 'skip$ if$
  note empty$ 'skip$ { "\enspace\pubnote{\textbullet\enspace " write$ note write$ "}" write$ } if$
  cvhighlight empty$ 'skip$ { "\quad\pubhighlight[" write$ cvhighlightcolor empty$ { "oral" } { cvhighlightcolor } if$ write$ "]{" write$ cvhighlight write$ "}" write$ } if$
  newline$ newline$
}
FUNCTION {patent} { output.entry }
FUNCTION {article} { output.entry }
FUNCTION {inproceedings} { output.entry }
FUNCTION {conference} { output.entry }
FUNCTION {misc} { output.entry }
FUNCTION {book} { output.entry }
FUNCTION {incollection} { output.entry }
FUNCTION {phdthesis} { output.entry }
FUNCTION {techreport} { output.entry }
FUNCTION {unpublished} { output.entry }
FUNCTION {default.type} { output.entry }
FUNCTION {end.bib} { "\end{thebibliography}" write$ newline$ }
READ
ITERATE {presort}
SORT
EXECUTE {begin.bib}
ITERATE {assign.label}
ITERATE {display.sort}
SORT
ITERATE {call.type$}
EXECUTE {end.bib}
