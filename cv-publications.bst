% Number chronologically within each type; display newest year first.
% Equal-year entries retain their curated \nocite order in both passes.
% cvequal/cvcorresponding are comma-separated, one-based author indices.
ENTRY { author title booktitle journal year note url cvvenue cvhighlight cvhighlightcolor cvselected cvequal cvcorresponding number } {} { cvyear cvdisplaykey cvlabel cvlead }
INTEGERS { nameptr numnames pubcount ccount jcount pcount bcount ocount leadflag indexpos indexfound yearpos yearcode }
STRINGS { namestr fullname lastyear prefix pubnumber orderkey authorsuffix indexlist indexneedle indextoken indexchar yearkey yearchar }
FUNCTION {not} { { #0 } { #1 } if$ }
FUNCTION {and} { { } { pop$ #0 } if$ }
FUNCTION {or} { { pop$ #1 } { } if$ }

FUNCTION {is.owner}
{ duplicate$ "Sky~Chenwei Wan" =
  swap$ duplicate$ "Chenwei Wan" =
  swap$ "Sky Chenwei Wan" = or or
}

% Stack: an index string, then the comma-separated list -> a boolean.
% Compare whole tokens, so author 1 cannot match 11 or 21. Whitespace
% is ignored; a trailing sentinel comma also checks the final token.
FUNCTION {index.list.contains}
{ "," * 'indexlist :=
  'indexneedle :=
  #0 'indexfound :=
  #1 'indexpos :=
  "" 'indextoken :=
  { indexlist indexpos #1 substring$ "" = not }
  { indexlist indexpos #1 substring$ 'indexchar :=
    indexchar "," =
      { indextoken indexneedle = { #1 'indexfound := } 'skip$ if$
        "" 'indextoken :=
      }
      { indexchar chr.to.int$ #32 >
          { indextoken indexchar * 'indextoken := }
          'skip$
        if$
      }
    if$
    indexpos #1 + 'indexpos :=
  }
  while$
  indexfound
}
FUNCTION {is.equal.author}
{ cvequal empty$
    { #0 }
    { nameptr int.to.str$ cvequal index.list.contains }
  if$
}
FUNCTION {is.corresponding.author}
{ cvcorresponding empty$
    { #0 }
    { nameptr int.to.str$ cvcorresponding index.list.contains }
  if$
}
FUNCTION {format.authors}
{ author empty$
    { "" }
    { author 'namestr :=
      #1 'nameptr :=
      namestr num.names$ 'numnames :=
      ""
      { nameptr numnames > not }
      { namestr nameptr "{ff~}{vv~}{ll}{, jj}" format.name$ 'fullname :=
        nameptr #1 >
          { nameptr numnames = { " \& " * } { ", " * } if$ }
          'skip$
        if$
        fullname is.owner
          { "\textbf{" * fullname * "}" * }
          { namestr nameptr "{vv~}{ll}{, f.}{, jj}" format.name$ * }
        if$
        "" 'authorsuffix :=
        is.equal.author { "*" 'authorsuffix := } 'skip$ if$
        is.corresponding.author
          { authorsuffix empty$
              { "\textdagger" }
              { authorsuffix ",\textdagger" * }
            if$ 'authorsuffix :=
          }
          'skip$
        if$
        authorsuffix empty$ 'skip$
          { "\textsuperscript{" * authorsuffix * "}" * }
        if$
        nameptr #1 + 'nameptr :=
      }
      while$
    }
  if$
}

% Complement each year digit to reverse the ordering of standard YYYY years.
FUNCTION {descending.year.key}
{ "" 'yearkey :=
  #1 'yearpos :=
  { year yearpos #1 substring$ empty$ not }
  { year yearpos #1 substring$ 'yearchar :=
    yearchar chr.to.int$ 'yearcode :=
    yearcode #47 > yearcode #58 < and
      { #105 yearcode - int.to.chr$ 'yearchar := }
      'skip$
    if$
    yearkey yearchar * 'yearkey :=
    yearpos #1 + 'yearpos :=
  }
  while$
  yearkey
}
FUNCTION {presort}
{ pubcount #1 + 'pubcount :=
  "000000" pubcount int.to.str$ * #-6 #6 substring$ 'orderkey :=
  #0 'leadflag :=
  author empty$ 'skip$
    { author 'namestr :=
      #1 'nameptr :=
      namestr num.names$ 'numnames :=
      { nameptr numnames > not }
      { namestr nameptr "{ff~}{vv~}{ll}{, jj}" format.name$ is.owner
          { nameptr #1 = is.equal.author or
              { #1 'leadflag := } 'skip$ if$
          }
          'skip$
        if$
        nameptr #1 + 'nameptr :=
      }
      while$
    }
  if$
  cvselected empty$ 'skip$
    { cvselected "true" = { #1 'leadflag := } 'skip$ if$ }
  if$
  leadflag { "1" } { "0" } if$ 'cvlead :=
  year empty$
    { "Undated" 'cvyear :=
      "1" orderkey * 'cvdisplaykey :=
      "9999" orderkey * 'sort.key$ :=
    }
    { year 'cvyear :=
      "0" descending.year.key * orderkey * 'cvdisplaykey :=
      year orderkey * 'sort.key$ :=
    }
  if$
}
FUNCTION {initialize}
{ #0 'pubcount :=
  #0 'ccount := #0 'jcount := #0 'pcount := #0 'bcount := #0 'ocount :=
}
FUNCTION {begin.bib}
{ "" 'lastyear :=
  "\section{Publications}" write$ newline$
  "\publicationlegend" write$ newline$
}
FUNCTION {open.group}
{ cvyear lastyear = 'skip$
    { lastyear empty$ 'skip$ { "\end{thebibliography}" write$ newline$ } if$
      "\pubyear{" write$ cvyear write$ "}" write$ newline$
      "\begin{thebibliography}{C99}" write$ newline$
      cvyear 'lastyear :=
    }
  if$
}
FUNCTION {number.entry}
{ type$ "inproceedings" = type$ "conference" = or
  { "C" 'prefix := ccount #1 + 'ccount := ccount }
  { type$ "article" =
    { "J" 'prefix := jcount #1 + 'jcount := jcount }
    { type$ "patent" =
      { "P" 'prefix := pcount #1 + 'pcount := pcount }
      { type$ "book" = type$ "incollection" = or
        { "B" 'prefix := bcount #1 + 'bcount := bcount }
        { "O" 'prefix := ocount #1 + 'ocount := ocount }
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
FUNCTION {format.venue}
{ cvvenue empty$
    { booktitle empty$ { journal empty$ { "" } { journal } if$ } { booktitle } if$ }
    { "\mbox{" cvvenue * "}" * }
  if$
}
FUNCTION {output.entry}
{ open.group
  "\bibitem[" write$ cvlabel write$ "]{" write$ cite$ write$ "}" write$ newline$
  "\begin{pubentry}{" write$ cvlead write$ "}" write$ newline$
  author empty$ 'skip$
    { "\pubauthors{" write$ format.authors add.period$ write$ "}\space" write$ newline$ }
  if$
  title empty$ 'skip$
    { "\pubtitle{" write$ url empty$ { "" } { url } if$ write$
      "}{" write$ title write$ "}" write$ newline$
    }
  if$
  format.venue duplicate$ empty$ 'pop$
    { "\newline In~\pubvenue{" write$ write$ "}" write$ }
  if$
  type$ "patent" = number empty$ not and
    { "\enspace\textbullet\enspace Patent " write$ number write$ } 'skip$ if$
  note empty$ 'skip$
    { note "Long paper" = 'skip$
        { "\enspace\pubnote{\textbullet\enspace " write$ note write$ "}" write$ }
      if$
    }
  if$
  "." write$
  cvhighlight empty$ 'skip$ { "~\pubhighlight[" write$ cvhighlightcolor empty$ { "oral" } { cvhighlightcolor } if$ write$ "]{" write$ cvhighlight write$ "}" write$ } if$
  newline$
  "\end{pubentry}" write$ newline$ newline$
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
FUNCTION {end.bib}
{ lastyear empty$ 'skip$ { "\end{thebibliography}" write$ newline$ } if$ }
READ
EXECUTE {initialize}
ITERATE {presort}
SORT
ITERATE {assign.label}
ITERATE {display.sort}
SORT
EXECUTE {begin.bib}
ITERATE {call.type$}
EXECUTE {end.bib}
