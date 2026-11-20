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
- `assets/icons/`: Font Awesome contact icons, original SVGs, vector PDFs and license/source notes.
- `scripts/prepare_logo.py`: optional raster-logo trimming and square-canvas utility.
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

This produces a colored badge after the venue, independently of the authorship-based entry background. It can also contain `Spotlight`, `Best Paper`, or another verified distinction. Omit the field to remove the badge. The color and padding are controlled by `\pubhighlight` in `cv-style.sty`. EmoDynamiX uses this feature for its NAACL oral presentation.

The optional `cvvenue` field controls the short venue displayed on the CV. Keep `booktitle` or `journal` for the full bibliographic venue name; that field is used when `cvvenue` is absent. Use concise labels without a year, such as `EMNLP Main`, `EMNLP Findings` and `NAACL Main`, because the publication year is already shown by the group heading. Retain the standard `year` field for grouping and numbering. The `note` field displays additional publication information; the repeated `Long paper` note is retained in the database but omitted from the CV.

To reuse this project for another person, change the owner-name comparisons in `cv-publications.bst`; these control both name bolding and automatic entry highlighting.

The publication list follows the supplied reference format: `C2. Authors. Title in Venue.` Each entry is one continuous paragraph with natural line wrapping. The owner retains a full, bold name; other authors use surnames and given-name initials from the BibTeX record, with an ampersand before the last author. Titles are italic and linked; venues are semibold italic. Short venue labels stay together, and no trailing year is added. Display labels have a final period, while inline citations remain `[C2]`. Author-role markers, year groups, entry backgrounds and highlight badges are preserved. Pages, publisher, DOI and abstracts remain in the database but are not printed. Use a journal/conference bibliography style when reusing the database for a manuscript.

## Layout adjustments

Edit the `ink`, `accent`, `muted` and `hairline` colors in `cv-style.sty`; `pubshade` controls the first- and equal-first-author entry background. Body font and leading are defined by `\cvbody`, applied at the start of the document and explicitly inside components. Section spacing is the same on both pages; no page-wide font reduction is applied. The first page includes the complete Inria experience, with an explicit page break before Fudan University. The Inria supervisor line wraps naturally instead of forcing an extra line. Publication entries stay together on one page. As experience grows, revisit the page break and allow additional pages rather than shrinking text excessively. The footer date is intentionally fixed and should be updated when revising the CV.

### Typography standard

| Level | Font size / line spacing (TeX pt) | Application |
| --- | --- | --- |
| Name | 34 / 39 | Newsreader name heading |
| Section heading | 16 / 18 | Newsreader section headings on both pages |
| Institution | 11 / 14 | `\cvinstitution`, semibold education/employment headings; the header subtitle uses regular weight |
| Main content | 10.2 / 12.8 | `\cvbody`: summary, all experience descriptions, publication text, talk event headings, reviewer venues and award titles |
| Secondary content | 9.3 / 11 | `\cvsmall`: dates, locations, contact labels, explanatory notes, talk titles, publication legend and labels, JIF annotations |
| Running header/page number | 8 / 10 | Page navigation only |
| Highlight badge | 7.5 / 9 | Compact ORAL and similar badges |

Role titles use the main-content size in italic. Paper titles use italic; venue names use semibold italic. Review journal/conference names use the main-content size and body color, with smaller dates and JIF annotations. Talk titles use the annotation size (9.3 pt) and the full width to the right of the year; event headings remain at the main-content size.

## Prepare raster logos

The original `assets/soochow.png` is preserved. Its 328 x 309 canvas contains 9 px of transparent space on the left and 11 px on the right, making the visible seal smaller than the IP Paris logo. The CV now uses `assets/soochow-trimmed.png`: the 308 x 304 artwork is centered on a transparent 308 x 308 square without scaling or distortion. School logos are centered in the same 9 mm box. IP Paris already fills its canvas and keeps its original vector PDF.

To regenerate the prepared PNG:

```sh
python -m pip install -r scripts/requirements.txt
python scripts/prepare_logo.py assets/soochow.png assets/soochow-trimmed.png --square
```

The script accepts raster formats supported by Pillow and writes a lossless RGBA PNG to a different path. It trims transparent borders, or near-white borders on opaque images, while retaining interior colors and transparency. Use `--background transparent` or `--background '#ffffff'` to select detection explicitly; `--tolerance` adjusts background-color tolerance, `--alpha-threshold` adjusts alpha detection, and `--padding` adds transparent pixels around the crop. `--square` centers the artwork without resizing it. Blank images are rejected. These tools are only needed when preparing a new logo; normal XeLaTeX compilation uses the bundled result.

Run the image-processing checks with:

```sh
python -m unittest discover -s scripts -p 'test_prepare_logo.py'
```

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

Venue names use deep navy semibold italic text, controlled by `\pubvenue`. Additional notes use smaller neutral gray text, controlled by `\pubnote`. Publication highlights remain independent colored tags. Venue content still comes from `cvvenue` in the BibTeX database.

## Bibliography metadata and display labels

The two EMNLP records in `publications.bib` use the standard metadata exported by ACL Anthology, including titles, author order, editors, proceedings, dates, publisher, DOI, pages and ISBN. The custom CV fields are maintained separately: venue display labels are `EMNLP Main`, `EMNLP Findings` and `NAACL Main`; all notes read `Long paper`. EmoDynamiX retains the user-supplied Sky Chenwei Wan author name and HAL link. Its complete HAL and PDF fields remain in the database, while the compact CV style prints only its selected fields.

Education uses `\degreefield{degree}{discipline}`: Inter semibold for the degree and Inter italic for the discipline, separated by a light vertical bar. Font styles use the bundled real font files.

## Consecutive positions

Use `\begin{positiongroup}{institution}{overall dates}` for consecutive appointments at the same institution, and `\careerrole{title}{dates}{location}{description}` for each appointment. The shared institution heading shows the overall employment span on the right, matching an ordinary entry's institution/date row. Each role shows its own dates in small upright parentheses after the title, with its own location at the right edge, preserving the ordinary role/location layout. Locations are specified per appointment even when they are the same. A subtle vertical timeline connects the roles, and the group is kept on one page. Non-consecutive appointments (e.g. the SLB internship and subsequent doctorate) retain individual entries in chronological order. This component uses the standard `tikz` package.

All work-experience titles use the shared `\cvrole{...}` style: Inter Italic at regular weight, 10.2 pt with 12.8 pt line spacing. Both `\entry` and `\careerrole` use it; institution headings stay semibold, while dates and locations remain upright.

The opening `\cvsummary{...}` and all experience bullet lists use `\cvbody`: Inter Regular, 10.2 pt with 12.8 pt line spacing, in the body color `ink`. This includes the Fudan entry on page two. Grouped positions explicitly use the same font and color inside TikZ, with normal font word spacing (`align=flush left`) and the document's 1 pt paragraph spacing restored after TikZ creates its minipage. The shared institution heading has a 2.5 pt gap before the first role, matching the ordinary entry's heading-to-role rhythm. Roles retain a 15 pt indent and the same right edge as other entries. The 6 pt separation between role boxes accounts for the restored paragraph/list spacing; outer spacing is 5 pt before and 1 pt after the group.

```tex
\begin{positiongroup}{Institution}{Overall dates}
\careerrole{Most recent position}{Dates}{Location}{Description.}
\careerrole{Earlier position}{Dates}{Location}{Description.}
\end{positiongroup}
```

The Inria / Télécom Paris internship lists the supervisors supplied by the user: Prof. Matthieu Labeau (S2A, Télécom Paris) and Prof. Chloé Clavel (ALMAnaCH, Inria Paris).

## Chronological numbering

Publication numbers increase with the `year` field within each type, across the single Publications section. Earlier publications get smaller numbers. Equal-year entries follow their order in the `\nocite` list; undated entries come last. Display order is newest-year first, independently of numbering. Thus the current display is 2026: EMNLP Main `[C2]`, EMNLP Findings `[C3]`; then 2025: NAACL Main `[C1]`. Experience citations update automatically.


## November 2026 CV update

- Education logos are in `assets/`; the vector IP Paris source and PDF plus the original and prepared Soochow PNGs are included. Compilation uses the prepared Soochow image. The logos span only the institution and degree lines.
- MSc: grade 18.0/20.0, Mention Très Bien (with highest honors); IP Paris PhD Track full tuition waiver (14k €). BEng: grade 3.9/4.0, rank 1/79. These details come from the supplied education screenshot; the waiver amount is presented as a rounded two-year figure using compact k/m notation at the user's request.
- Talk labels use `(Talk)`. Journal reviewing precedes conference reviewing. TAFFC: since 2026; TASLP and conference reviewing: since 2025, as confirmed by the user.
- Journal metrics: 2025 JIF 11.3 (TAFFC) and 5.2 (TASLP), published in June 2026. Source: IEEE Title List, September 2026, pages 2–3, https://open.ieee.org/wp-content/uploads/IEEE-Title-List-September-2026-CAPES.pdf (checked 18 November 2026). The source attributes TASLP metrics to its former IEEE/ACM title. Values in the CV link to this source.
- Awards: Excellent Undergraduate Thesis, June 2023; Chu Ching-wen Scholarship, October 2022; The Top Prize Scholarship of Excellence, October 2022 and October 2020. Dates follow the supplied screenshot.


## Summary and layout refinement

The research summary now states the vision of trustworthy AI for sustainable human–AI co-evolution, followed by multimodal and neuro-symbolic methods, multi-agent collaboration, knowledge base construction and retrieval, and industrial applications. Education annotations align with the page text margin; the PhD research-focus annotation is removed. Journal impact factors sit on the same line as each journal name.


## Current color and contact settings

The palette uses deep navy headings (#18324D), navy accents (#24486B), charcoal body text (#202C3A), slate-blue secondary text (#66788A), and pale blue-gray rules (#D9E2EA). Official university logos retain their original colors. Education annotations are indented 12 mm to align with institution and degree text. The contact email and mailto link are cwan5@slb.com.

The contact row pairs location, email, LinkedIn, Google Scholar and GitHub labels with navy vector icons from Font Awesome Free 6.7.2. The GitHub item links to https://github.com/cw-wan. Entries use whitespace instead of bullet separators. `\contactitem{icon-name}{label}` and `\contactsep` in `cv-style.sty` control icon size and spacing; wrap the entire item in `\href` to make both icon and label clickable. The original SVGs and preconverted PDF assets are bundled, so regular compilation needs no additional package, conversion tool or network access. See `assets/icons/README.md` for sources and attribution.


## Unified date typography

Standalone dates in education, experience (including grouped roles), talks, reviewing, awards and the footer use `\cvdate{...}`, defined once in `cv-style.sty`: Inter Regular, 9.3 pt with 11 pt line spacing, muted blue-gray (#66788A). This uses the shared secondary-text size `\cvsmall`. Publication year group headings use the main-content size; JIF annotations use the secondary-text size.


## Education clarification

The PhD in Computer Science starts in September 2026; this is distinct from the SLB CIFRE contract, which starts in May 2026 in Research Experience. The MSc field is Computer Science (Data and Artificial Intelligence).
