# Chenwei (Sky) Wan — LaTeX CV

A two-page research CV with a quiet editorial layout: Newsreader display type, Inter body text, deep navy accents, linked publication references and a single BibTeX database.

## Compile

### Overleaf

1. Upload the ZIP as a new project.
2. Set the main document to `main.tex`.
3. In project settings, select **XeLaTeX**.
4. Recompile. Overleaf runs BibTeX automatically when needed.

Fonts are bundled under `fonts/`; no external fonts or web requests are needed.

### Local TeX Live / MiKTeX

```sh
latexmk -xelatex main.tex
```

Or run manually:

```sh
xelatex main.tex
bibtex main
xelatex main.tex
xelatex main.tex
```

Uses BibTeX, not Biber. Required standard packages: geometry, fontspec, xcolor, enumitem, titlesec, fancyhdr, needspace, hyperref. Validated with XeLaTeX and BibTeX from TeX Live 2023.

## Project files

- `main.tex`: CV content, section order and experience-to-paper citations.
- `cv-style.sty`: typography, colors, margins, spacing and reusable entry commands.
- `publications.bib`: publication metadata; edit this to maintain publications.
- `cv-publications.bst`: custom BibTeX display style, automatic type-based labels and name highlighting.
- `.latexmkrc`: compilation settings.
- `fonts/`: bundled static Newsreader and Inter fonts and their SIL Open Font Licenses.
- `main.pdf`: compiled preview.

## Cite a publication inside an experience

```tex
Two long papers accepted to EMNLP 2026:
main conference \pubcite{wan2026grammar} and
Findings \pubcite{hou2026grounding}.
```

These references render as `[c2]` and `[c3]` and link to the corresponding publication. Each bibliography title links to the paper when the entry has a `url` field. There is no fabricated link for entries without a public URL.

## Add or update papers

1. Add a normal BibTeX entry to `publications.bib`.
2. Add its key to the `\nocite{...}` list near the top of `main.tex` in the desired display order. Entries are automatically grouped by first authorship; the order within each group follows this list.
3. Use `\pubcite{your-key}` wherever the work is relevant.
4. Recompile with BibTeX. Labels renumber automatically by publication type across both sections, and citations stay synchronized.

### Automatic sections and numbering

The first author is detected from the standard `author` field. Entries whose first author is Chenwei Wan or Sky Chenwei Wan appear under **Lead-Author Publications**; other papers appear under **Contributing-Author Publications**. Use `cvselected = {true}` for a verified co-first-author contribution that is not first in the author list. Empty sections are omitted automatically. Names in published author lists remain as published; the CV heading and PDF metadata use **Chenwei (Sky) Wan**.

| BibTeX entry type | Label |
| --- | --- |
| `@inproceedings`, `@conference` | `c1`, `c2`, … |
| `@article` | `j1`, `j2`, … |
| `@patent` | `p1`, `p2`, … |
| `@book`, `@incollection` | `b1`, `b2`, … |
| Other supported entries | `o1`, `o2`, … |

Each type has its own counter. Counters continue across sections to prevent duplicate citation labels. Patents may use the `number` field for the patent identifier and `cvvenue` for the patent office/jurisdiction; their number is printed automatically. The current database contains no patents and does not invent any.

### Per-paper highlights

Add a highlight to any entry in `publications.bib`:

```bibtex
cvhighlight = {Oral},
cvhighlightcolor = {oral},
```

This produces a colored badge beside the venue line. It can also contain `Spotlight`, `Best Paper`, or another verified distinction. Omit the field to remove the badge. The color and padding are controlled by `\pubhighlight` in `cv-style.sty`. EmoDynamiX uses this feature for its NAACL oral presentation.

The optional `cvvenue` field controls the short venue displayed on the CV. Keep `booktitle` for the full bibliographic venue name. Without `cvvenue`, the style uses `booktitle` (or `journal`) and `year`. The `note` field displays acceptance status, paper type or oral presentation. Do not add the year twice to `cvvenue`.

The style highlights the author names `Chenwei Wan` and `Sky Chenwei Wan` automatically; normal author metadata is retained in the `.bib` file. To reuse this project for another person, change the name comparisons in `cv-publications.bst`.

The publication list is deliberately a compact CV format: it does not print pages, publisher, DOI or abstracts, though these fields can remain in the database. Use a journal/conference bibliography style when reusing the database for a manuscript.

## Layout adjustments

Edit the `ink`, `accent`, `muted` and `hairline` colors in `cv-style.sty`. Body font and leading are set in `\AtBeginDocument`; section spacing and entry spacing are also centralized there. Pagination is automatic, with entry headers kept with their following content. As experience grows, allow additional pages rather than shrinking text excessively. The footer date is intentionally fixed and should be updated when revising the CV.

## Content sources and items to verify

Prepared on 10 September 2026.

- Experience titles, locations, supervisors, contact details, education dates, thesis grade, oral presentation and awards come from the supplied `Profile.pdf`.
- Research summary and doctoral topic are editorially condensed from the supplied profile and previously shared doctoral research context. They do not imply additional experimental outcomes.
- The uploaded profile gives **September 2023–October 2025** for the MSc and **November 2025–February 2026** for the Research Engineer role. These dates are preserved. Earlier conversation summaries mention diploma completion in early 2026 and an October 2025 employment start; verify the intended CV dates against official records before application.
- The duplicated “The Top Prize Scholarship of Excellence” lines in LinkedIn are consolidated into one entry because distinct dates/award instances were not supplied. No award years or language proficiency levels were invented.
- Grammar of the Wave: title and author order follow arXiv v4; accepted EMNLP 2026 main, long paper. Source: https://arxiv.org/abs/2603.11479 (accessed 10 September 2026).
- EmoDynamiX: title, author order, proceedings and DOI follow ACL Anthology. Source: https://aclanthology.org/2025.naacl-long.81/ (accessed 10 September 2026). Oral status is from the uploaded profile.
- **Language-Guided Time-Series Event Detection with Zero-Shot Cross-Modal Grounding**: title and author order (Tianjun Hou, Xiqing Chang, Sky Chenwei Wan) were recovered from the earlier LinkedIn-post draft in conversation history. Findings acceptance follows the previously shared acceptance summary. This metadata was not independently verified against a public camera-ready record. Its public link was TBA and is omitted; confirm title and authors against the final accepted manuscript and add the URL when available.

No expected PhD graduation year, programming proficiency claims, award dates or unpublished identifiers were inferred.

## Academic service update

The user-supplied LinkedIn volunteering screenshot supplies the reviewer roles: Association for Computational Linguistics (February 2025–present), reviewing for ACL, EMNLP and EACL; IEEE (July 2025–present), reviewing for IEEE Transactions on Affective Computing and IEEE Transactions on Audio, Speech and Language Processing. Venue names follow the supplied screenshot. Impact factors are omitted from the CV.

## Reference-inspired typography update

The type pairing and restrained palette follow the design language of [Danqi Chen’s homepage](https://www.cs.princeton.edu/~danqic/index.html): Newsreader for the name and section headings, Inter for body text, navy-charcoal text, pale blue-gray rules, and deep navy accents (`#24486B`). The layout is adapted for an A4 CV rather than reproducing a webpage. The fonts are bundled as static instances derived from their Google Fonts variable releases; accompanying SIL OFL licenses are included. No online font service is required when compiling.

All three honors are explicitly associated with **Soochow University**, as confirmed by the user. Education is the first section, followed by Research Experience, Lead-Author Publications, Contributing-Author Publications, Academic Service and Honors & Awards. The separate Research Interests section has been removed.

Highlight labels are automatically uppercased. `cvhighlightcolor` accepts a named LaTeX color: `oral` (deep navy), `award` (slate blue), or `spotlight` (steel blue). Its default is `oral`. Define additional colors in `cv-style.sty` as needed. For example:

```bibtex
cvhighlight = {Best Paper},
cvhighlightcolor = {award},
```

Only use award labels when the distinction is confirmed. An omitted `cvhighlight` produces no tag.

## Venue emphasis

Venue names use deep navy semibold text, controlled by `\pubvenue`. Acceptance and paper-type notes use smaller neutral gray text, controlled by `\pubnote`. Publication highlights remain independent colored tags. Venue content still comes from `cvvenue` in the BibTeX database.

## User-supplied bibliography revision

The current `publications.bib` is the exact replacement supplied by the user. It supersedes the earlier metadata notes where they differ: venue display labels are `EMNLP 2026 Main`, `EMNLP 2026 Findings`, and `NAACL 2025 Main`; all notes read `Long paper`. EmoDynamiX now uses Sky Chenwei Wan in its author list and links to the supplied HAL record. The complete HAL and PDF fields are retained in the database, while the compact CV style prints only its selected fields.

Education uses `\degreefield{degree}{discipline}`: Inter semibold for the degree and Inter italic for the discipline, separated by a light vertical bar. Font styles use the bundled real font files.

## Consecutive positions

Use `positiongroup` for consecutive appointments at the same institution, and `\careerrole{title}{dates}{description}` for each appointment. A shared institution heading with its location on the right and a subtle vertical timeline connect the roles, each retaining its own dates and linked publications. The group is kept on one page. Non-consecutive appointments (e.g. the SLB internship and subsequent doctorate) retain individual entries in chronological order. This component uses the standard `tikz` package.

```tex
\begin{positiongroup}{Institution}{Location}
\careerrole{Most recent position}{Dates}{Description.}
\careerrole{Earlier position}{Dates}{Description.}
\end{positiongroup}
```

The Inria / Télécom Paris internship lists the supervisors supplied by the user: Prof. Matthieu Labeau (S2A, Télécom Paris) and Prof. Chloé Clavel (ALMAnaCH, Inria Paris).

## Chronological numbering

Publication numbers increase with the `year` field within each type, across both publication sections. Earlier publications get smaller numbers. Equal-year entries follow their order in the `\nocite` list; undated entries come last. Display order remains grouped by authorship and follows the curated order within each group, independently of numbering. Thus the current entries are NAACL 2025 `[c1]`, EMNLP 2026 Main `[c2]`, and EMNLP 2026 Findings `[c3]`. Experience citations update automatically.


## November 2026 CV update

- Education logos are in `assets/`; the vector IP Paris source and PDF plus the Soochow PNG are included for compilation. The logos span only the institution and degree lines.
- MSc: grade 18.0/20.0, Mention Très Bien (with highest honors); IP Paris PhD Track full tuition waiver (€14,000). BEng: grade 3.9/4.0, rank 1/79. These details come from the supplied education screenshot.
- Talk labels use `(Talk)`. Journal reviewing precedes conference reviewing. TAFFC: since 2026; TASLP and conference reviewing: since 2025, as confirmed by the user.
- Journal metrics: 2025 JIF 11.3 (TAFFC) and 5.2 (TASLP), published in June 2026. Source: IEEE Title List, September 2026, pages 2–3, https://open.ieee.org/wp-content/uploads/IEEE-Title-List-September-2026-CAPES.pdf (checked 18 November 2026). The source attributes TASLP metrics to its former IEEE/ACM title. Values in the CV link to this source.
- Awards: Excellent Undergraduate Thesis, June 2023; Chu Ching-wen Scholarship, October 2022; The Top Prize Scholarship of Excellence, October 2022 and October 2020. Dates follow the supplied screenshot.


## Summary and layout refinement

The research summary now states the vision of trustworthy AI for sustainable human–AI co-evolution, followed by multimodal and neuro-symbolic methods, multi-agent collaboration, knowledge base construction and retrieval, and industrial applications. Education annotations align with the page text margin; the PhD research-focus annotation is removed. Journal impact factors sit on the same line as each journal name.


## Current color and contact settings

The palette uses deep navy headings (#18324D), navy accents (#24486B), charcoal body text (#202C3A), slate-blue secondary text (#66788A), and pale blue-gray rules (#D9E2EA). Official university logos retain their original colors. Education annotations are indented 12 mm to align with institution and degree text. The contact email and mailto link are cwan5@slb.com.


## Unified date typography

All standalone dates use `\cvdate{...}`, defined once in `cv-style.sty`: Inter Regular, 9 pt with 12 pt line spacing, muted blue-gray (#66788A). This applies to education, experience (including grouped roles), talk years, reviewing start years, award dates, and the footer date. Change this macro to update date styling throughout the CV. Publication years embedded in venue names and JIF metric years keep their surrounding text style.


## Education clarification

The PhD in Computer Science starts in September 2026; this is distinct from the SLB CIFRE contract, which starts in May 2026 in Research Experience. The MSc field is Computer Science (Data and Artificial Intelligence).
