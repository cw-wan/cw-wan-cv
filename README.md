# Chenwei (Sky) Wan — LaTeX CV

A research CV with a restrained editorial layout: Newsreader for the name and section headings, Inter for readable content, and navy accents for hierarchy and navigation. The current [PDF](main.pdf) is two pages.

This document describes the current design and how to maintain it. CV content lives in [main.tex](main.tex); publication metadata lives in [publications.bib](publications.bib).

- [Design principles and structure](#design-principles-and-structure)
- [Global design system](#global-design-system)
- [Section and component patterns](#section-and-component-patterns)
- [Publication data and numbering](#publication-data-and-numbering)
- [Build](#build)
- [Maintenance and assets](#maintenance-and-assets)

## Design principles and structure

The layout uses a small set of shared styles so similar information looks consistent across sections. Institution names establish hierarchy; role and paper titles use italic; dates and supporting notes have a quieter secondary style. Substantive information stays at the body size, including education details, publication text and reviewer venues.

The section order presents qualifications and research output before the work that supports them:

| Order | Section | Purpose |
| --- | --- | --- |
| 1 | Education | Degrees, academic performance and funding |
| 2 | Publications | Research output, authorship and presentation distinctions |
| 3 | Professional Experience | Appointments, responsibilities and research contributions |
| 4 | Invited Talks | Presentations, hosts, dates and talk types |
| 5 | Academic Service | Journal and conference reviewing |
| 6 | Honors & Awards | Recognition and awarding institution |

An identity block and research summary precede these sections. Entries generally run from newest to oldest. Publications have separate chronological numbering rules, described below.

Content, presentation and bibliography formatting have separate responsibilities:

| File or directory | Responsibility |
| --- | --- |
| [main.tex](main.tex) | Identity, summary, section order, education, experience, talks, service and awards |
| [cv-style.sty](cv-style.sty) | Shared typography, colors, spacing, pagination and reusable components |
| [publications.bib](publications.bib) | Bibliographic records and CV-specific publication fields |
| [cv-publications.bst](cv-publications.bst) | Publication formatting, year groups, labels, author markers and highlighting |
| [.latexmkrc](.latexmkrc) | XeLaTeX build configuration |
| [fonts/](fonts/) | Bundled Inter and Newsreader fonts with SIL Open Font Licenses |
| [assets/](assets/) | University logos and vector contact icons |
| [scripts/prepare_logo.py](scripts/prepare_logo.py) | Optional raster-logo preparation utility |
| [main.pdf](main.pdf) | Tracked, compiled CV |

## Global design system

### Typography and emphasis

All sizes below are TeX points, expressed as font size / line spacing. Inter uses actual regular, semibold, italic and semibold-italic font files; Newsreader supplies the display style.

| Level | Size / spacing | Application |
| --- | --- | --- |
| Name | 34 / 39 | Newsreader, main identity heading |
| Section heading | 16 / 18 | Newsreader, with a pale rule below |
| Institution | 11 / 14 | Inter semibold, `\cvinstitution`; the identity subtitle uses the same size in regular weight |
| Body | 10.2 / 12.8 | `\cvbody`: summary, degrees, education details, experience, publications, talk hosts/titles, reviewer venues and award titles |
| Secondary | 9.3 / 11 | `\cvsmall`: contact labels, dates, locations, supervisor notes, award institutions, talk type labels, publication legend/labels and JIF annotations |
| Running header and page number | 8 / 10 | Page navigation |
| Publication distinction badge | 7.5 / 9 | Compact ORAL and similar tags |

`\cvrole{title}{department}` gives all experience titles the body size in regular-weight italic, followed by a muted vertical bar and an upright department in the body size and color. Paper and talk titles also use body-size italic; publication venues use semibold italic. Talk type badges use the secondary size with generous vertical padding. `\cvdate` applies the secondary size and muted color consistently to standalone dates, including the footer.

### Color and links

| Token | Color | Role |
| --- | --- | --- |
| `ink` | `#202C3A` | Body text and institution headings |
| `heading` | `#18324D` | Name, section headings and publication years |
| `accent` | `#24486B` | Links, bullets, publication venues and talk labels |
| `muted` | `#66788A` | Dates, locations and supporting notes |
| `hairline` | `#D9E2EA` | Section rules and grouped-position connectors |
| `pubshade` | `#F0F4F8` | First- and equal-first-author publication backgrounds |

Links are clickable text without visible borders. Paper titles retain the body color even when linked. Experience institutions and talk hosts likewise retain their heading color through `\href{url}{\color{ink}Name}`. Linked talk titles and JIF annotations use the accent color. University logos retain their original colors; contact icon PDFs have their own navy fill and need asset recoloring if the palette changes.

Publication distinction badges and talk type labels share `\cvbadge{background}{horizontal padding}{vertical padding}{text}`: a filled rounded rectangle with a 1.5 pt corner radius and text aligned to the surrounding baseline. Publication badges use 3.5 pt padding on all sides; talk labels use 3.5 pt horizontal and 3 pt vertical padding. Their respective font sizes and pale background colors preserve the existing hierarchy.

### Page geometry and adaptive whitespace

The A4 text area has 22 mm left/right margins, an 18 mm base top margin and a 17.5 mm bottom margin. The footer skip is 9 mm. The first page starts with the name; subsequent pages have a small running header. The footer shows the revision month at left and the page number at right. Its month is set explicitly in `cv-style.sty`.

The first page balances spare space above and below its content. **After LaTeX selects the page break**, the output hook measures the natural content height and adds this space above the name:

```text
extra top space = max(0, min(8 mm, 60% of unused page height))
```

The cap is `\cvheadroomlimit`. The effective first-page top margin therefore ranges from 18 to 26 mm and tightens automatically as content grows. The remaining slack stays at the bottom. This output-stage adjustment preserves internal spacing, footer placement and page-break selection; later pages use the base layout.

Pagination is automatic. Each publication, talk and consecutive-position group stays together. Ordinary experience headings reserve room for following content using `\Needspace`; the Inria experience also has an explicit `samepage` wrapper. With the current content, page one ends after the current CIFRE role and page two starts with the Télécom Paris group. These are layout outcomes, not fixed page breaks. As the CV grows, allow additional pages rather than reducing the body size.

### Alignment and spacing

Substantive paragraphs use justified alignment with English hyphenation. `\cvjustify` restores normal line-breaking rules inside minipages and TikZ nodes and allows 1 em of emergency stretch. First-line indentation is zero, default paragraph spacing is 1 pt, and final lines keep their natural length. Publication entries and lists set their own local paragraph spacing.

Institution/date and role/location rows share the same right edge. Section headings have 8 pt before and 7 pt after; their 0.45 pt rule sits below the title. Two shared lengths in `cv-style.sty` control the base spacing between entries and their internal items:

| Spacing level | Value | Application |
| --- | --- | --- |
| `\cventrysep` | 5 pt | Education, experience, publications, talks, awards, consecutive-role boxes, publication year groups and service categories |
| `\cvitemsep` | 2 pt | Bullet items and their list boundaries, reviewer venue rows, education detail separation and publication paragraph spacing |

The shared `itemize` style uses navy bullets and a 12 pt left margin. Block components use `\addvspace` to avoid stacking adjacent vertical skips; bibliography items and TikZ role boxes apply the same entry length through their own layout mechanisms. These are spacing controls in addition to text line height and the existing component padding.

Standalone supporting notes share `\detail`: muted secondary text (9.3/11 pt), with half of `\cvitemsep` (1 pt) moved from below the note to above it. This balances the gaps around the smaller text without increasing entry height. The same rule applies to experience supervisors and award institutions; each note stays with the preceding title.

Dates use compact forms such as `Sep 2026 -- Present`; talks use `D Mon YYYY`. Monetary amounts use compact k/m notation with a nonbreaking space before the currency, for example `14k~€`.

## Section and component patterns

### Identity and summary

The header stacks the name, professional subtitle and contact row. Vertical skips of 4 pt, 5 pt and 8 pt separate the name/subtitle, subtitle/contacts and contacts/summary respectively, in addition to normal paragraph spacing. Adaptive whitespace is added above the entire block.

`\contactitem{icon-name}{label}` pairs each label with a vector icon. `\contactsep` inserts 13 pt of whitespace between items. Wrap an item in `\href` to make both icon and label clickable. The current row contains location, email, LinkedIn, Google Scholar and GitHub. Icons and labels stay together. The research summary uses `\cvsummary{...}` and the standard body typography.

### Education

```tex
\educationentry{logo}{institution}{dates}
  {\degreefield{degree}{discipline}}{location}{details}
```

A 9 mm logo box and 3 mm gutter establish a text column inset by 12 mm. The logo spans the institution and degree rows. The first row pairs the institution with dates; the second pairs the degree and discipline with location. `\degreefield` uses a semibold degree, a light vertical bar and an italic discipline.

`\schoollogo` adds a soft crescent shadow that hugs the lower-right edge of each emblem. Low-opacity vector circles, offset 0.28 mm right and 0.36 mm down, taper from a subtle dark edge to the white page. The shadow is clipped outside the 4.5 mm emblem radius and excluded from layout measurements, preserving the original artwork, 9 mm logo size and existing text alignment. The effect is drawn in TikZ without modifying the logo assets or adding a frame.

Details sit below in the same text column and use the shared body-size bullet list. Grades, rankings, funding and doctoral collaboration information are substantive content. Their bullets and list spacing match experience descriptions; dates and locations retain the secondary style.

### Publications

The bibliography generates one **Publications** section with descending year groups. The legend defines C, J, `*` and `†`, separated by generous whitespace. Each entry follows this pattern:

```text
C2. Authors. Paper title
    In Venue. [optional distinction badge]
```

Authors and title flow together with natural wrapping. The owner name is full and semibold; other authors use surnames and initials, with an ampersand before the final author. Titles are italic and link to the record's `url`. `In Venue.` starts a new line; the short venue is semibold italic and omits the year because the year group already supplies it.

A pale background identifies first- and equal-first-author papers. Distinctions such as ORAL use a separate compact rounded badge after the venue, separated by one nonbreaking space. Publication entries use the shared `\cventrysep` list spacing and 3 pt background padding. The publication label remains outside the shaded text block.

### Professional experience

```tex
\entry{institution}{dates}{role}{department}{location}
\experiencenote{Supervised by ...}
\begin{itemize}
  \item Research contribution or responsibility.
\end{itemize}
```

Ordinary appointments pair a semibold institution with dates on the first row. The second row places the italic role, a muted vertical bar and the upright department at left, with location aligned right. Both role and department use the body size and color; dates and locations remain upright in the secondary style. Pass an empty department argument `{}` when none is specified, which also omits the separator. Supervisor notes use `\experiencenote`, list names without parenthetical affiliations and use `and` before the final name; contributions use body-size bullets. Current responsibilities use present-tense verbs, completed roles use past tense, and paper references use `\pubcite{key}`.

`\experiencenote` uses the shared `\detail` typography and spacing, matching award institution notes. It additionally keeps the note with the following contribution list.

Experience bullets use `\textbf` (Inter semibold) sparingly to emphasize a research focus, named contribution or result. Limit emphasis to one or two short phrases per role, counting existing distinctions such as thesis grades or oral presentations. Keep the surrounding prose at regular weight.

Consecutive appointments at one institution share an institution heading and overall date span:

```tex
\begin{positiongroup}{Institution}{Overall dates}
  \careerrole{Most recent role}{Department}{Role dates}{Location}{%
    \begin{itemize}
      \item Contribution.
    \end{itemize}}
  \careerrole{Earlier role}{Department}{Role dates}{Location}{Description.}
\end{positiongroup}
```

Each role uses the same title/department pattern on the left. Its dates and location form a single right-aligned group in the upright secondary style: `Mar 2026 -- May 2026; Palaiseau, France`. A semicolon separates these fields, and the group stays on one line. The institution heading retains the overall date span. A subtle timeline connects the roles within a 15 pt inset. The shared heading has a 2.5 pt gap before the first role; role boxes use the shared `\cventrysep`. The TikZ component restores the same body typography, justification and paragraph spacing as ordinary entries. The whole group stays on one page. Non-consecutive appointments at the same employer remain separate chronological entries.

### Invited talks

```tex
\talkentry{host and location}{date}{type}{title}
```

The first row pairs a semibold host/location with a right-aligned full date. The second row reserves `\linewidth - 28mm` for the italic title, followed by a 3 mm gutter and a 25 mm right-aligned type column. With the current margins, the title column is 138 mm wide. Long titles wrap within their own column.

Type labels have a pale blue rounded-rectangle background and no parentheses. The current Seminar label is semibold through `\textbf{Seminar}`; Talk labels are regular weight. Both use the secondary size (9.3/11 pt), with 3 pt vertical padding. Entries use the shared `\cventrysep` and stay together across page breaks.

Use full paper titles for paper presentations and the event title for standalone seminars. Hosts link to official websites; titles link to slides when a URL is available. A title without slides remains plain text.

### Academic service and honors

Academic Service places journal reviewing before conference reviewing. Reviewer category headings are semibold; venue names use the standard body size and color. Journal JIF annotations are smaller, linked to their source and kept on the venue line. Service start dates align at the right edge.

Honors & Awards pairs each semibold award title with its date, followed by the awarding institution in `\detail`, with the same note typography and spacing as experience supervisors. Entries use the shared `\cventrysep`. Multiple instances of the same award can share one title with semicolon-separated dates.

## Publication data and numbering

Maintain standard metadata in `publications.bib`, preserving the published title and author order. For ACL-family records, import the ACL Anthology BibTeX and maintain CV-specific display fields separately. Full proceedings names, DOI, pages and other metadata remain available in the database even when the compact CV does not print them.

| CV field | Meaning |
| --- | --- |
| `cvvenue` | Short venue without a year, e.g. `EMNLP Main`; falls back to `booktitle`, then `journal` |
| `cvequal` | Comma-separated, one-based author positions receiving `*`, e.g. `{1,2}` |
| `cvcorresponding` | One-based author positions receiving `†`, e.g. `{3}` |
| `cvhighlight` | Distinction badge text, automatically uppercased, e.g. `{Oral}` |
| `cvhighlightcolor` | Named LaTeX color; defaults to `oral`, with `award` and `spotlight` also defined |

Author positions refer to the standard `author` field. Keep contribution markers out of author names and update the position fields if author order changes. Declare equal contribution only when established; an internship footnote does not imply equal contribution. The current Findings record marks author 3 as corresponding author. Shading is automatic when the owner is first author or included in `cvequal`.

The owner-name matcher in `cv-publications.bst` recognizes Chenwei Wan and Sky Chenwei Wan. Change it when adapting the template to another person. The standard `note` field is displayed as a secondary note except for the redundant value `Long paper`, which is suppressed.

To add a paper:

1. Add its BibTeX record and applicable CV fields to `publications.bib`.
2. Add the key to the explicit `\nocite{...}` list at the start of `main.tex`. This list controls the order within each year.
3. Use `\pubcite{key}` for linked references from experience descriptions.
4. Rebuild with BibTeX so labels and citations update together.

Display order and numbering are independent: years display newest first, while numbers increase from older to newer papers within each type. Use a four-digit `year`; entries without one appear last under **Undated**. Equal-year ties follow the `\nocite` order. Counters continue across year groups.

| BibTeX type | Label prefix |
| --- | --- |
| `inproceedings`, `conference` | C |
| `article` | J |
| `patent` | P |
| `book`, `incollection` | B |
| Other supported entries | O |

The current display is C2 and C3 under 2026, followed by C1 under 2025. Printed entry labels end in a period; inline citations use brackets, such as `[C2]`. The visible legend currently explains C and J; extend it if other publication types are added.

## Build

Use **XeLaTeX and BibTeX**. Run from the repository root:

```sh
xelatex -interaction=nonstopmode -halt-on-error main.tex
bibtex main
xelatex -interaction=nonstopmode -halt-on-error main.tex
xelatex -interaction=nonstopmode -halt-on-error main.tex
```

With `latexmk` installed, the equivalent command is:

```sh
latexmk -xelatex main.tex
```

On Overleaf, import the project, select `main.tex` as the main document and choose XeLaTeX. Overleaf runs BibTeX as needed. Fonts and ready-to-use graphics are bundled; compilation needs no external font service or SVG conversion.

Required packages are `geometry`, `fontspec`, `babel` with English, `ragged2e`, `xcolor`, `enumitem`, `titlesec`, `fancyhdr`, `needspace`, `hyperref`, `tikz` and `graphicx`. LaTeX intermediates and local `tmp/` and `output/` directories are ignored; `main.pdf` is tracked.

## Maintenance and assets

Edit shared rules in `cv-style.sty` and content in `main.tex`, using the existing components. Update publication metadata in `publications.bib` and rendering logic in `cv-publications.bst`; the `.bbl` file is generated and should not be edited directly. Keep this README aligned with the resulting design; Git history records past iterations.

For content or layout changes, rebuild, inspect every rendered page and check for overflow, awkward breaks, stranded headings and misplaced links. Check the log for unresolved references and layout warnings, then refresh the tracked `main.pdf`. Update the footer month and time-dependent annotations when revising those details.

### Logos

Both university marks fit the same 9 mm box. IP Paris uses its vector PDF; Soochow uses a prepared PNG with excess canvas removed. Normalize visible artwork before comparing display sizes, keeping the source image and aspect ratio intact.

```sh
python -m pip install -r scripts/requirements.txt
python scripts/prepare_logo.py assets/soochow.png assets/soochow-trimmed.png --square
```

The utility trims transparent or near-white borders and writes a lossless RGBA PNG to a different path. `--square` centers the artwork without resizing it. Optional `--background`, `--tolerance`, `--alpha-threshold` and `--padding` control detection and canvas padding. Pillow is needed only for asset preparation, not for CV compilation. When modifying the utility, run its existing checks:

```sh
python -m unittest discover -s scripts -p 'test_prepare_logo.py'
```

### Icons and fonts

Contact icons are bundled Font Awesome Free 6.7.2 SVG sources and vector PDF derivatives. See [icon sources and attribution](assets/icons/README.md) for their license and conversion details. Font licenses are included in [Inter-OFL.txt](fonts/Inter-OFL.txt) and [Newsreader-OFL.txt](fonts/Newsreader-OFL.txt).
