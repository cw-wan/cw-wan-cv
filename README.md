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

Uses BibTeX, not Biber. Required standard packages: geometry, fontspec, xcolor, enumitem, titlesec, fancyhdr, needspace, hyperref, tikz and graphicx. Validated with XeLaTeX and BibTeX from TeX Live 2023 and MiKTeX 25.4.

## Project files

- `main.tex`: CV content, section order and experience-to-paper citations.
- `cv-style.sty`: typography, colors, margins, spacing and reusable entry commands.
- `publications.bib`: publication metadata; edit this to maintain publications.
- `cv-publications.bst`: custom BibTeX display style, year grouping, type-based labels, author-role markers and entry highlighting.
- `.latexmkrc`: compilation settings.
- `fonts/`: bundled static Newsreader and Inter fonts and their SIL Open Font Licenses.
- `main.pdf`: compiled preview.

## Cite a publication inside an experience

```tex
Two long papers accepted to EMNLP 2026:
main conference \pubcite{wan2026grammar} and
Findings \pubcite{hou2026grounding}.
```

These references render as `[C2]` and `[C3]` and link to the corresponding publication. Each bibliography title links to the paper when the entry has a `url` field. There is no fabricated link for entries without a public URL.

## Add or update papers

1. Add a normal BibTeX entry to `publications.bib`, preserving the published title, author order and standard metadata. For ACL-family papers, use the ACL Anthology BibTeX record.
2. Add its key to the `\nocite{...}` list near the top of `main.tex`. Papers are grouped by year in descending order; papers from the same year follow this list.
3. Use `\pubcite{your-key}` wherever the work is relevant.
4. Set the short `cvvenue` label and any verified author-role or presentation fields described below.
5. Recompile with BibTeX. Labels renumber automatically by publication type across all years, and citations stay synchronized.

### Year grouping and numbering

All papers appear in a single **Publications** section, grouped by year from newest to oldest. Its legend reads **C = Conference paper; J = Journal paper; * = Equal contribution; † = Corresponding author**. Within a year, the display order follows `\nocite`.

Numbering is independent of display order: earlier years receive smaller numbers within each publication type, and equal-year entries follow `\nocite` order. Labels use uppercase letters:

| BibTeX entry type | Label |
| --- | --- |
| `@inproceedings`, `@conference` | `C1`, `C2`, … |
| `@article` | `J1`, `J2`, … |
| `@patent` | `P1`, `P2`, … |
| `@book`, `@incollection` | `B1`, `B2`, … |
| Other supported entries | `O1`, `O2`, … |

Each type has its own counter, which continues across all year groups. Patents may use the `number` field for the patent identifier and `cvvenue` for the patent office/jurisdiction; their number is printed automatically. The current database contains no patents and does not invent any.

### Author roles and entry highlighting

Keep the standard `author` field in its published order, without inserting `*` or `†` into names. The style bolds `Chenwei Wan` and `Sky Chenwei Wan` automatically; the CV heading and PDF metadata use **Chenwei (Sky) Wan**.

Declare verified author roles with comma-separated, one-based author positions:

```bibtex
cvequal = {1,2},
cvcorresponding = {3},
```

In this example, the first and second authors receive `*` for equal contribution, and the third author receives `†` for corresponding authorship. Positions always refer to the order in the standard `author` field; update these fields if that order changes. Omit a field when that role is not established.

An entry receives a pale background when Chenwei Wan / Sky Chenwei Wan is its first author or is included in `cvequal`. The legacy `cvselected = {true}` field remains available for manual entry highlighting, but does not itself declare equal contribution or add an author marker. Prefer `cvequal` for a verified co-first-author contribution.

The current EMNLP Findings entry uses `cvcorresponding = {3}` to mark Sky Chenwei Wan as the corresponding author, per the user's confirmation. The asterisk attached to Yifei Wang in the EMNLP Main paper describes work done during an internship; it is **not** an equal-contribution marker. No unverified equal-contribution marks are added to the current entries.

### Per-paper highlights

Add a highlight to any entry in `publications.bib`:

```bibtex
cvhighlight = {Oral},
cvhighlightcolor = {oral},
```

This produces a colored badge beside the venue line, independently of the authorship-based entry background. It can also contain `Spotlight`, `Best Paper`, or another verified distinction. Omit the field to remove the badge. The color and padding are controlled by `\pubhighlight` in `cv-style.sty`. EmoDynamiX uses this feature for its NAACL oral presentation.

The optional `cvvenue` field controls the short venue displayed on the CV. Keep `booktitle` or `journal` for the full bibliographic venue name; that field is used when `cvvenue` is absent. Use concise labels without a year, such as `EMNLP Main`, `EMNLP Findings` and `NAACL Main`, because the publication year is already shown by the group heading. Retain the standard `year` field for grouping and numbering. The `note` field displays acceptance status, paper type or oral presentation.

To reuse this project for another person, change the owner-name comparisons in `cv-publications.bst`; these control both name bolding and automatic entry highlighting.

The publication list is deliberately a compact CV format: it does not print pages, publisher, DOI or abstracts, though these fields can remain in the database. Use a journal/conference bibliography style when reusing the database for a manuscript.

## Layout adjustments

Edit the `ink`, `accent`, `muted` and `hairline` colors in `cv-style.sty`; `pubshade` controls the first- and equal-first-author entry background. Body font and leading are set in `\AtBeginDocument`; section spacing and entry spacing are also centralized there. The first page includes the complete Inria experience, with an explicit page break before Fudan University. The Inria supervisor line wraps naturally instead of forcing an extra line. Publication entries stay together on one page. As experience grows, revisit the page break and allow additional pages rather than shrinking text excessively. The footer date is intentionally fixed and should be updated when revising the CV.

## Content sources and items to verify

Prepared on 10 September 2026.

- Experience titles, locations, supervisors, contact details, education dates, thesis grade, oral presentation and awards come from the supplied `Profile.pdf`.
- Research summary and doctoral topic are editorially condensed from the supplied profile and previously shared doctoral research context. They do not imply additional experimental outcomes.
- The uploaded profile gives **September 2023–October 2025** for the MSc and **November 2025–February 2026** for the Research Engineer role. These dates are preserved. Earlier conversation summaries mention diploma completion in early 2026 and an October 2025 employment start; verify the intended CV dates against official records before application.
- The duplicated “The Top Prize Scholarship of Excellence” lines in LinkedIn are consolidated into one entry because distinct dates/award instances were not supplied. No award years or language proficiency levels were invented.
- Grammar of the Wave: standard bibliography metadata now follows the [ACL Anthology EMNLP 2026 Main record](https://aclanthology.org/2026.emnlp-main.290/), superseding the earlier arXiv-based metadata. The arXiv identifier is retained as supplementary metadata.
- EmoDynamiX: title, author order, proceedings and DOI follow ACL Anthology. Source: https://aclanthology.org/2025.naacl-long.81/ (accessed 10 September 2026). Oral status is from the uploaded profile.
- **Language-Guided Time-Series Event Detection with Zero-Shot Cross-Modal Grounding**: standard bibliography metadata and the public link now follow the [ACL Anthology EMNLP 2026 Findings record](https://aclanthology.org/2026.findings-emnlp.229/), replacing the earlier provisional metadata. Per the user's confirmation, its third author, Sky Chenwei Wan, is the corresponding author; the CV records that role with `cvcorresponding = {3}`.

No expected PhD graduation year, programming proficiency claims, award dates or unpublished identifiers were inferred.

## Academic service update

The user-supplied LinkedIn volunteering screenshot supplies the reviewer roles: Association for Computational Linguistics (February 2025–present), reviewing for ACL, EMNLP and EACL; IEEE (July 2025–present), reviewing for IEEE Transactions on Affective Computing and IEEE Transactions on Audio, Speech and Language Processing. Venue names follow the supplied screenshot. Impact factors are omitted from the CV.

## Reference-inspired typography update

The type pairing and restrained palette follow the design language of [Danqi Chen’s homepage](https://www.cs.princeton.edu/~danqic/index.html): Newsreader for the name and section headings, Inter for body text, navy-charcoal text, pale blue-gray rules, and deep navy accents (`#24486B`). The layout is adapted for an A4 CV rather than reproducing a webpage. The fonts are bundled as static instances derived from their Google Fonts variable releases; accompanying SIL OFL licenses are included. No online font service is required when compiling.

All three honors are explicitly associated with **Soochow University**, as confirmed by the user. Education is the first section, followed by Professional Experience, Publications, Invited Talks, Academic Service and Honors & Awards. The separate Research Interests section has been removed.

Highlight labels are automatically uppercased. `cvhighlightcolor` accepts a named LaTeX color: `oral` (deep navy), `award` (slate blue), or `spotlight` (steel blue). Its default is `oral`. Define additional colors in `cv-style.sty` as needed. For example:

```bibtex
cvhighlight = {Best Paper},
cvhighlightcolor = {award},
```

Only use award labels when the distinction is confirmed. An omitted `cvhighlight` produces no tag.

## Venue emphasis

Venue names use deep navy semibold text, controlled by `\pubvenue`. Acceptance and paper-type notes use smaller neutral gray text, controlled by `\pubnote`. Publication highlights remain independent colored tags. Venue content still comes from `cvvenue` in the BibTeX database.

## Bibliography metadata and display labels

The two EMNLP records in `publications.bib` use the standard metadata exported by ACL Anthology, including titles, author order, editors, proceedings, dates, publisher, DOI, pages and ISBN. The custom CV fields are maintained separately: venue display labels are `EMNLP Main`, `EMNLP Findings` and `NAACL Main`; all notes read `Long paper`. EmoDynamiX retains the user-supplied Sky Chenwei Wan author name and HAL link. Its complete HAL and PDF fields remain in the database, while the compact CV style prints only its selected fields.

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

Publication numbers increase with the `year` field within each type, across the single Publications section. Earlier publications get smaller numbers. Equal-year entries follow their order in the `\nocite` list; undated entries come last. Display order is newest-year first, independently of numbering. Thus the current display is 2026: EMNLP Main `[C2]`, EMNLP Findings `[C3]`; then 2025: NAACL Main `[C1]`. Experience citations update automatically.


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

Standalone dates in education, experience (including grouped roles), talks, reviewing, awards and the footer use `\cvdate{...}`, defined once in `cv-style.sty`: Inter Regular, 9 pt with 12 pt line spacing, muted blue-gray (#66788A). Change this macro to update those dates throughout the CV. Publication year group headings and JIF metric years use their surrounding text style.


## Education clarification

The PhD in Computer Science starts in September 2026; this is distinct from the SLB CIFRE contract, which starts in May 2026 in Research Experience. The MSc field is Computer Science (Data and Artificial Intelligence).
