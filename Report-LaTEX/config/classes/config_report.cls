%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File Name: config_report.cls
% Description: <ADD Content>
% Version: 1.0
% Author: Bruno Axel Kamere
% Created Date: 2023-05-15
% Last Modified: 2023-05-16
% License: [Specify the license under which this script is distributed]
%
% Usage:
%   - Provide examples of how to use the script.
%   - Include any necessary command-line options or arguments.
%   - Specify any prerequisites or dependencies.
%
% Dependencies:
%   - List any external dependencies required by the script (e.g., software packages).
%   - Include specific versions if necessary.
%
% Notes:
%   - Add any additional notes or important information about the script.
%   - Mention any known issues or limitations.
%   - Include any troubleshooting tips, if applicable.
%
% References:
%   - List any references or resources that were used to develop the script.
%   - Include links or citations for easy access.
% ===============================================
% Changelog:
% ===============================================
% Version 1.0 [2023-05-15] [Bruno Axel Kamere]
% - Initial file.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ProvidesClass{config/classes/config_report}

\LoadClass[
    12pt,
    twoside
]{book}

%--------------------------------------
% Define class parameters
%--------------------------------------

\RequirePackage{kvoptions}
\SetupKeyvalOptions{
    family = config/classes/config_report.cls,
    prefix = config
}

\DeclareStringOption[2.5cm]{left}
\DeclareStringOption[2.5cm]{right}
\DeclareStringOption[2.5cm]{top}
\DeclareStringOption[2.5cm]{bottom}
\DeclareStringOption[6mm]{bindingoffset}
\DeclareBoolOption[false]{nohyphenation}
\ProcessKeyvalOptions*

%----------------------------------------------------------------------------
% Common Packages
%----------------------------------------------------------------------------
\RequirePackage{amsmath}    % Basic mathematical typesetting
\RequirePackage{amssymb}    % Advanced math symbols
\RequirePackage{amsthm}     % Theorems typesetting
\RequirePackage{array}      % Advanced table column formats
\RequirePackage[            % Custom figure and table captions
    font=small,
    labelfont=bf,
    labelsep=period
]{caption}
\RequirePackage{chngcntr}   % Per-section counters
\RequirePackage{enumitem}   % Itemize/enumrate
\RequirePackage{fancyhdr}   % Custom header/footer styles
\RequirePackage{fourier}    % Adobe Utopia font
\RequirePackage{graphicx}   % Enhanced images support
\RequirePackage{subcaption} 
\RequirePackage{ifluatex}   % LuaTeX-specific options
\RequirePackage{ifpdf}      % pdfTeX-specific options
\RequirePackage{ifxetex}    % XeTeX-specific options
\RequirePackage{kantlipsum} % English kantian-style lipsum
\RequirePackage{lipsum}     % Lorem ipsum
\RequirePackage{longtable}  % Multi-page tables
\RequirePackage{multirow}   % Advanced table cells
\RequirePackage{setspace}   % Set space between lines
\RequirePackage{scrextend}  % Allows \addmargin environment
\RequirePackage{tocloft}    % Custom ToC/LoF/LoT
\RequirePackage{url}        % URL-sensitive line breaks
\RequirePackage{xkeyval}    % Keys and class parameters
\RequirePackage{xspace}     % Remove duplicated spaces
\RequirePackage[intoc]{nomencl} % Nomenclature
\RequirePackage[nottoc]{tocbibind}
\RequirePackage[title,titletoc]{appendix}
\RequirePackage{minted}     % Highlighted code listing
\RequirePackage{xcolor}     % to access the named colour LightGray

%--------------------------------------
% Code listing
%--------------------------------------
\RequirePackage{listings}   % Code listings
\usepackage{realboxes}      % For colorbox.
\lstset{
  columns=fullflexible,
  frame=single,
  breaklines=true,
  postbreak=\mbox{\textcolor{red}{$\hookrightarrow$}\space},
}

%--------------------------------------
% Code listing with mint package
%--------------------------------------
\definecolor{LightGray}{gray}{0.9}
\renewcommand\listoflistingscaption{List of Listings}
\renewcommand{\listoflistings}{
  \addcontentsline{toc}{chapter}{\listoflistingscaption}
  \listof{listing}{\listoflistingscaption}
}

%--------------------------------------
% PdfTeX specific configuration
%--------------------------------------
\ifpdf
    \RequirePackage[T1]{fontenc}
    \RequirePackage[utf8]{inputenc}
    \RequirePackage[
        protrusion=true,
        expansion=true
    ]{microtype}
\fi

%--------------------------------------
% XeTeX specific configuration
%--------------------------------------
\ifxetex
    \RequirePackage{fontspec-xetex}
    \RequirePackage[
        protrusion=true,
    ]{microtype}
\fi

%--------------------------------------
% LuaTeX specific configuration
%--------------------------------------
\ifluatex
    \RequirePackage[T1]{fontenc}
    \RequirePackage[utf8]{luainputenc}
    \RequirePackage{luatexbase}
    \RequirePackage{luacode}
    \RequirePackage[
        protrusion=true,
        expansion=true
    ]{microtype}
    % In LuaTeX, we can prevent one-letter words
    % from beging at the end of the line.
    \begin{luacode}
        local debug = false
        local glyph_id = node.id "glyph"
        local glue_id  = node.id "glue"
        local hlist_id = node.id "hlist"

        local prevent_single_letter = function (head)
        while head do
        if head.id == glyph_id then
        if unicode.utf8.match(unicode.utf8.char(head.char),"%a") then     -- is a letter
        if head.prev.id == glue_id and head.next.id == glue_id then   -- is one letter word

        local p = node.new("penalty")
        p.penalty = 10000

        if debug then
        local w = node.new("whatsit","pdf_literal")
        w.data = "q 1 0 1 RG 1 0 1 rg 0 0 m 0 5 l 2 5 l 2 0 l b Q"
        node.insert_after(head,head,w)
        node.insert_after(head,w,p)
        else
        node.insert_after(head,head,p)
        end
        end
        end
        end
        head = head.next
        end
        return true
        end

        luatexbase.add_to_callback("pre_linebreak_filter",prevent_single_letter,"~")

    \end{luacode}
\fi

\RequirePackage[            % Bibliography in biber. It has to be loaded after the inputenc package.
    backend=biber,
    style=ieee,
    dateabbrev=false
]{biblatex}
\RequirePackage{csquotes}  % Load csquotes package. It has to be loaded after the inputenc package.

%--------------------------------
% Produce clickable hyperlinks
% in ToC, LoF and LoT
%--------------------------------
\RequirePackage{hyperref}
\hypersetup{
    colorlinks,
    citecolor=black,
    filecolor=black,
    linkcolor=black,
    urlcolor=black
}

%--------------------------------------
% Create new source command.
%--------------------------------------
\newcommand{\source}[1]{\caption*{\textbf{Source}: {#1}} }

%--------------------------------------
% Default margin is 2.5 cm
%--------------------------------------
\RequirePackage[
    a4paper,
    left=\configleft,
    right=\configright,
    top=\configtop,
    bottom=\configbottom,
    bindingoffset=\configbindingoffset
]{geometry}

%--------------------------------
% Turn off hyphenation
%--------------------------------
\ifconfignohyphenation
    \tolerance=1
    \emergencystretch=\maxdimen
    \hyphenpenalty=10000
    \hbadness=10000
\fi

%--------------------------------
% Initial setup
%--------------------------------
\setstretch{1.2}
\counterwithin{figure}{section}
\counterwithin{table}{section}

%--------------------------------
% Table of Contents setup
%--------------------------------
\renewcommand{\contentsname}{Table of contents}
\renewcommand{\listfigurename}{List of figures}
\renewcommand{\listtablename}{List of tables}

% Hides Contents appearing from TOC, but adds it to bookmarks
\let\temptableofcontents\tableofcontents
\renewcommand{\tableofcontents}{
  \cleardoublepage
  \pdfbookmark[0]{\contentsname}{Contents}
  \temptableofcontents
}

\fancypagestyle{plain}{
    \fancyhf{}
    \renewcommand{\headrulewidth}{0pt}
    \fancyfoot[LE,RO]{\thepage}
}

\fancypagestyle{headings}{
    \fancyhead{}
    \renewcommand{\headrulewidth}{1pt}
    \fancyheadoffset{0cm}
    \fancyhead[RO]{\nouppercase{\thesection.\hspace{8pt}\rightmark}}
    \fancyhead[LE]{\nouppercase{\thechapter.\hspace{8pt}\leftmark}}
    \fancyfoot{}
    \fancyfoot[LE,RO]{\thepage}
}
\setlength{\headheight}{15pt}
\pagestyle{headings}

\renewcommand{\chaptermark}[1]{\markboth{#1}{}}
\renewcommand{\sectionmark}[1]{\markright{#1}{}}

%--------------------------------
% Set default list style
%--------------------------------
\setlist[itemize,1]{topsep=2pt,label=\large$\bullet$, leftmargin=28pt}
\setlist[itemize,2]{topsep=2pt,leftmargin=18pt}
\setlist[itemize,3]{topsep=2pt,leftmargin=18pt}

\setlist[enumerate,1]{topsep=2pt,leftmargin=24pt}
\setlist[enumerate,2]{topsep=2pt,leftmargin=16pt}
\setlist[enumerate,3]{topsep=2pt,leftmargin=16pt}

%--------------------------------
% Choose language to work in
%--------------------------------
\newcommand{\langeng}{
    \newcommand{\@lang}{english}
    \usepackage[australian, british]{babel}

    \newtheorem{theorem}{Theorem}
    \newtheorem{lemma}{Lemma}
    \newtheorem{corollary}{Corollary}
    \newtheorem{definition}{Definition}
    \newtheorem{axiom}{Axiom}
    \newtheorem{assumption}{Assumption}

    \AtBeginDocument{
        \renewcommand{\listfigurename}{List of Figures}
        \renewcommand{\listtablename}{List of Tables}
        \renewcommand{\tablename}{Table}
    }
}

%--------------------------------
% Dedication
%--------------------------------
% This environment creates a dedication page centered on its own.
\newenvironment{dedication}
{
    \vspace*{0.2\textheight}
    \thispagestyle{empty}
    \centering
}

%--------------------------------
% Acknowledgements
%--------------------------------
% This environment creates an acknowledgements with a header in the middle.
\newenvironment{acknowledgements}{
    \thispagestyle{empty}
}

%--------------------------------
% Abstract
%--------------------------------
\newcommand{\abstract}{
    \thispagestyle{plain}
    \begin{center}\textbf{\Large\@title}\end{center}
    \textbf{\\ Abstract.\xspace}
}
\newcommand{\keywords}{\vspace{0.5cm}\par\noindent \textbf{Keywords: \xspace}}

%--------------------------------
% Nomenclature
%--------------------------------
\makenomenclature
\renewcommand{\nomgroup}[1]{%
\ifthenelse{\equal{#1}{A}}{\item[\textbf{Roman Symbols}]}{%
\ifthenelse{\equal{#1}{G}}{\item[\textbf{Greek Symbols}]}{%
\ifthenelse{\equal{#1}{Z}}{\item[\textbf{Acronyms / Abbreviations}]}{%
\ifthenelse{\equal{#1}{R}}{\item[\textbf{Superscripts}]}{%
\ifthenelse{\equal{#1}{S}}{\item[\textbf{Subscripts}]}{%
\ifthenelse{\equal{#1}{X}}{\item[\textbf{Other Symbols}]}
{}
}% matches mathematical symbols > X
}% matches Subscripts           > S
}% matches Superscripts         > R
}% matches Abbreviations        > Z
}% matches Greek Symbols        > G
}% matches Roman Symbols        > A

% To add nomenclature in the header
\renewcommand{\nompreamble}{\markboth{\nomname}{\nomname}}

% Add nomenclature to contents and print out nomenclature
\newcommand{\printnomencl}[1][]{
\ifthenelse{\equal {#1}{}}
{\printnomenclature}
{\printnomenclature[#1]}
%\addcontentsline{toc}{chapter}{\nomname}
}

%--------------------------------
% Declaration of author's will
%--------------------------------
\newcommand{\makeauthorship}{
    \ifnum \pdf@strcmp{\@lang}{english} = 0
        \thispagestyle{plain}
        \begin{figure}[ht]
            \vspace{-55pt}
            \noindent\makebox[\textwidth]{
                \includegraphics[width=1.19\textwidth]{config/pdf/declaration_of_authors_will-eng.pdf}
            }
        \end{figure}
    \fi
}

%--------------------------------
% Cover Page - Macros
%--------------------------------
\newcommand{\Report}{
    \newcommand{\DocumentType}{ProjectReport}
}
\newcommand{\MasterThesis}{
    \newcommand{\DocumentType}{Master}
}
\newcommand{\institute}[1]{
    \newcommand{\@institute}{#1}
}
\newcommand{\field}[1]{
    \newcommand{\@field}{#1}
}
\newcommand{\specialization}[1]{
    \newcommand{\@specialization}{#1}
}
\newcommand{\course}[1]{
    \newcommand{\@course}{#1}
}
\newcommand{\studentnumber}[1]{
    \newcommand{\@studentnumber}{#1}
}
\newcommand{\professor}[1]{
    \newcommand{\@professor}{#1}
}
\newcommand{\supervisor}[1]{
    \newcommand{\@supervisor}{#1}
}
\newcommand{\engtitle}[1]{
    \newcommand{\@engtitle}{#1}
}
\newcommand{\universityname}[1]{
    \newcommand{\@universityname}{#1}
}

%--------------------------------
% Strona tytułowa - makra
%--------------------------------

\newcommand{\reportDescription}[1]{
    \newcommand{\@reportDescription}{#1}
}
\newcommand{\instytut}[1]{
    \newcommand{\@instytut}{#1}
}
\newcommand{\przedmiot}[1]{
    \newcommand{\@przedmiot}{#1}
}
\newcommand{\specjalnosc}[1]{
    \newcommand{\@specjalnosc}{#1}
}
\newcommand{\album}[1]{
    \newcommand{\@album}{#1}
}
\newcommand{\prowadzacy}[1]{
    \newcommand{\@prowadzacy}{#1}
}

%--------------------------------
% Front Page
%--------------------------------
\let\oldmaketitle\maketitle
\renewcommand{\maketitle}{
    \linespread{1.15}

    \thispagestyle{empty}
    \pagenumbering{gobble}

    \begin{center}
        %\sffamily
        \ifnum \pdf@strcmp{\@lang}{polish} = 0
            \includegraphics[width=\textwidth ]{config/images/header.png} \\
        \fi
        \ifnum \pdf@strcmp{\@lang}{english} = 0
            \includegraphics[width=\textwidth]{config/images/WEiTI-znak-ENG-CMYK.png} \\
        \fi
        \hfill \break
        \ifnum \pdf@strcmp{\@lang}{polish} = 0
           {\large course \\ \@course} \\
        \fi
        \ifnum \pdf@strcmp{\@lang}{english} = 0
            {\large Course \\ \@course} \\
        \fi
        \hfill \break

        \includegraphics[width=0.5\textwidth]{config/images/logopw.png} \\
        \hfill \break
        \large
        \@title \\
        \ifnum \pdf@strcmp{\@lang}{polish} = 0
            {\normalsize \@reportDescription} \\
        \fi
        \ifnum \pdf@strcmp{\@lang}{english} = 0
            {\normalsize \@reportDescription} \\
        \fi
        \hfill \break
        \LARGE
        \@author \\
        \normalsize
        \ifnum \pdf@strcmp{\@lang}{polish} = 0
            Numer~albumu \@studentnumber \\
        \fi
        \ifnum \pdf@strcmp{\@lang}{english} = 0
            Student Record Book Number \@studentnumber \\
        \fi
        \hfill \break
        \hfill \break
        \ifnum \pdf@strcmp{\@lang}{polish} = 0
            prowadzący \\
        \fi
        \ifnum \pdf@strcmp{\@lang}{english} = 0
            Supervisor \\
        \fi
        \@professor \\
        \vfill
        \ifnum \pdf@strcmp{\@lang}{polish} = 0
            WARSZAWA \@date
        \fi
        \ifnum \pdf@strcmp{\@lang}{english} = 0
            Warsaw, Poland \@date
        \fi
    \end{center}

    \pagenumbering{arabic}
    \setcounter{page}{1}
}

%--------------------------------
% Blank Page - Macro
%--------------------------------
\newcommand{\blankpage}{
    \newpage
    \thispagestyle{empty}
    \
    \newpage
}

%--------------------------------
% Abbreviation (Acronym) - Macro
%--------------------------------
\newcommand{\acronymlist}{
    \ifnum \pdf@strcmp{\@lang}{polish} = 0
        \section*{Wykaz symboli i skrótów}
    \fi
    \ifnum \pdf@strcmp{\@lang}{english} = 0
        \section*{List of Symbols and Abbreviations}
    \fi
}
\newcommand{\acronym}[2]{
    \par\noindent\hspace{0.4em}
    {\textbf{#1} -- #2}
}

%--------------------------------
% Appendices - Macro
%--------------------------------
\newcommand{\nocontentsline}[3]{}
\newcommand{\tocless}[2]{%
    \bgroup\let\addcontentsline=\nocontentsline#1{#2}\egroup
}

\newcommand{\@appendixtitle}{
    \ifnum \pdf@strcmp{\@lang}{polish} = 0
        Załącznik
    \fi
    \ifnum \pdf@strcmp{\@lang}{english} = 0
        Appendix
    \fi
}

\let\standardappendix\appendix
\renewcommand\appendix[1]{%
    \tocless\section{\hspace*{1.5em} #1}
    \addcontentsline{app}{subsection}{\hspace*{-1.1em}\arabic{section}.\hspace*{0.5em} #1}
}

\newcommand\listofappendicestoc{
    \ifnum \pdf@strcmp{\@lang}{polish} = 0
        \section*{Spis załączników}\@starttoc{app}
    \fi
    \ifnum \pdf@strcmp{\@lang}{english} = 0
        \section*{List of Appendices}\@starttoc{app}
    \fi

    \standardappendix
    \renewcommand{\thesection}{\@appendixtitle~\arabic{section}}
}