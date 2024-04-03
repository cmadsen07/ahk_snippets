; REMOVED: #NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.

SetTitleMatchMode 2
GroupAdd "editors", "WordPad"
GroupAdd "editors", "Overleaf"


#HotIf WinActive("ahk_group editors")

#a::Suspend(-1) ; pause script
#HotString EndChars `t ; [Tab] triggers Hotstrings

; Reset Hotstring for CTRL+Backspace and CTRL+A (otherwise hostrings won't trigger)
Ctrl & Backspace::
{ ; V1toV2: Added bracket
    SendInput("^`b")
    Hotstring("Reset")
    Return
} ; V1toV2: Added Bracket before hotkey or Hotstring

Ctrl & a::
{ ; V1toV2: Added bracket
    SendInput("^a")
    Hotstring("Reset")
    Return
}

; :o:   omit ending character
; :?:   triggers hotstring even between characters
; :c:   case sensitive
; :*:   no trigger
; ^     ctrl
; +     shift
; <!    left alt

; /// 1. BRACKETS //////////////////////////////////////////////////////////////////////////////////

:o:abs::\left|  \right| {Left 9} ; Absolut Value: \left| \right|

; \left* \right*
; (instruction: place the cursor between the opening and the closing symbol, then hit ctrl+7)
^7::
{ ; V1toV2: Added bracket
    SendInput("{Left}\left{Right}  \right{Left 7}")
    Return

; put brackets around selection
; (warning: this might not work in some applications!)
} ; V1toV2: Added Bracket before hotkey or Hotstring

; /// 2. OTHER /////////////////////////////////////////////////////////////////////////////////////

; Jump to first occurance of • in the current line. (Continues search in the next line.)
 ; V1toV2: Added Bracket before hotkey or Hotstring
^Space::
{ ; V1toV2: Added bracket
    ClipBackup := ClipboardAll()
    A_Clipboard := ""
    SendInput("{Home}+{End}")
    SendInput("^c")
    Sleep(50) ; increase this number, if it doesn't work
    SearchedText := A_Clipboard
    ; MsgBox, %SearchedText%    
    pos := InStr(SearchedText, "•") - 1
    if (pos >= 0)
        ; MsgBox "%Target% was found at %pos%."
        SendInput("{Home}{Right " pos "}+{Right}")
    else
		;MsgBox "Here"
        SendInput("{Down}")
        SendInput("{Home}+{End}")
        SendInput("^c")
        Sleep(50) ; increase this number, if it doesn't work
        SearchedText := A_Clipboard
        ; MsgBox, %SearchedText%    
        pos := InStr(SearchedText, "•") - 1
        if (pos >= 0)
            ; MsgBox, %Target% was found at %pos%.
            SendInput("{Home}{Right " pos "}+{Right}")
        else
            SendInput("{End}")
    A_Clipboard := ClipBackup
    Return
}

; Whitespaces

:o:qd::\quad
:o:qq::\qquad

; Environments
:o:beg::
{ ; V1toV2: Added bracket
    IB := InputBox("", "Environment", "w200 h120", "align"), OutputVar := IB.Value
    SendInput("\begin{{}" OutputVar "{}}`r`r\end{{}" OutputVar "{}}{Up}`t")
    Return
}

:o:fig::\begin{{}figure{}}[•]`r\centering `r\includegraphics[width=0.8\columnwidth, height=0.2\textheight, keepaspectratio]{{}figs/•{}}`r\caption{{}•{}}`r\label{{}fig:•{}}`r\end{{}figure{}} {Left 13}{Up}`t!{Left}{Up}`t!{Left}{Up}`t!{Left}{Up}`t!{Left}{Up}{Right 16}+{Left} ; figure

:o:subfigh::\begin{{}figure{}}[•]`r\centering `r\begin{{}subfigure{}}[t]{{}0.5\textwidth{}}`r\centering `r\includegraphics[width=\linewidth]{{}•{}}`r\caption{{}(a){}}`r\end{{}subfigure{}}%`r~ `r\begin{{}subfigure{}}[t]{{}0.5\textwidth{}}`r\centering `r\includegraphics[width=\linewidth]{{}•{}}`r\caption{{}(b){}}`r\end{{}subfigure{}}`r\caption{{}caption{}}`r\label{{}fig:{}}`r\end{{}figure{}}{Left 12}{Up}`t{Left}{Up}`t{Left}{Up}`t{Left}{Up}`t`t{Left 2}{Up}`t`t{Left 2}{Up}`t`t{Left 2}{Up}`t{Left}{Up}`t{Left}{Up}`t{Left}{Up}`t`t{Left 2}{Up}`t`t{Left 2}{Up}`t`t{Left 2}{Up}`t{Left}{Up}`t{Left}{Up}{Right 16}+{Left}

:o:subfigv::\begin{{}figure{}}[•]`r\centering `r\begin{{}subfigure{}}[t]{{}0.8\textwidth{}}`r\centering `r\includegraphics[width=\linewidth]{{}•{}}`r\caption{{}(a){}}`r\end{{}subfigure{}}%`r~ `r\begin{{}subfigure{}}[t]{{}0.8\textwidth{}}`r\centering `r\includegraphics[width=\linewidth]{{}•{}}`r\caption{{}(b){}}`r\end{{}subfigure{}}`r\caption{{}caption{}}`r\label{{}fig:{}}`r\end{{}figure{}}{Left 12}{Up}`t{Left}{Up}`t{Left}{Up}`t{Left}{Up}`t`t{Left 2}{Up}`t`t{Left 2}{Up}`t`t{Left 2}{Up}`t{Left}{Up}`t{Left}{Up}`t{Left}{Up}`t`t{Left 2}{Up}`t`t{Left 2}{Up}`t`t{Left 2}{Up}`t{Left}{Up}`t{Left}{Up}{Right 16}+{Left}

:o:bal::\begin{{}align{}}`r`r\end{{}align{}}{Up}`t ; align
:o:bsal::\begin{{}align*{}}`r`r\end{{}align*{}}{Up}`t ; align*
:o:beq::\begin{{}equation{}}`r`r\end{{}equation{}}{Up}`t ; equation
:o:bseq::\begin{{}equation*{}}`r`r\end{{}equation*{}}{Up}`t ; equation*

; /// 3. TEXT FORMATTING ///////////////////////////////////////////////////////////////////////////

; Sections
:o:sec::\section{{}•{}}{Left}+{Left} ; \section
:o:subsec::\subsection{{}•{}}{Left}+{Left} ; \subsection

; Text
:o:tx::\text{{}•{}}{Left}+{Left} ; \text
:o:bf::\textbf{{}•{}}{Left}+{Left} ; \textbf
:o:it::\textit{{}•{}}{Left}+{Left} ; \textit
:o:em::\emph{{}•{}}{Left}+{Left} ; \emph
:o:tt::\texttt{{}•{}}{Left}+{Left} ; \texttt
:o:tbd::\textit{{}\textbf{{}TBD: •{}}{}}{Left 2}+{Left} ; \textit{\textbf{TBD: }}
:o:tbr::\textit{{}\textbf{{}TBR: •{}}{}}{Left 2}+{Left} ; \textit{\textbf{TBR: }}

; Cross references
:o:ref::(\ref{{}•{}}){Left 2}+{Left} ; \ref
:o:cite::(\cite{{}•{}}){Left 2}+{Left} ; \cite

:o:mbf::\mathbf{{}•{}}{Left}+{Left} ; \mathbf
:o:mcal::\mathcal{{}•{}}{Left}+{Left} ; \mathcal
:o:mscr::\mathscr{{}•{}}{Left}+{Left} ; \mathscr

; /// 4. MATH STUFF ////////////////////////////////////////////////////////////////////////////////

; Common Operations
:o:frac::\frac{{}•{}}{{}•{}}{Left 4}+{Left} ; \frac{•}{•}
:o:tfr::\tfrac{Space} ; \tfrac
:o:int::\int_{{}•{}}{^}{{}•{}}{Left 5}+{Left} ; \int_{•}^{•}
:o:sq::\sqrt{{}•{}}{Left}+{Left} ; \sqrt{ } 
:o:sin::\sin\left({}•{}\right){Left 7}+{Left} ; \sin( )
:o:cos::\cos\left({}•{}\right){Left 7}+{Left} ; \cos( )

; alt+^ instantly yields ^{•}
<!^::
{ ; V1toV2: Added bracket
    SendInput("{^}{{}•{}}{Left}+{Left}")
    Return
}
; alt+_ instantly yields _{•}
<!_::
{ ; V1toV2: Added bracket
    SendInput("{_}{{}•{}}{Left}+{Left}")
    Return
}

; Relations
 ; V1toV2: Added Bracket before hotkey or Hotstring
:o:<=>::\Leftrightarrow ; <=>
:o:=>::\Rightarrow ; =>
:o:<=::\Leftarrow ; <=
:o:->::\rightarrow ; ->

; Other / Symbols
:o:dell::\frac{{}\partial{}}{{}\partial •{}}{Left}+{Left}
:o:ovs::\overset{{}•{}}{{}•{}}{Left 4}+{Left}
:o:uns::\underset{{}•{}}{{}•{}}{Left 4}+{Left}
:o:inf::\infty
:o:deg::{^}\circ 
:o:cd::\cdot{Space}

; /// 5. MATRICES //////////////////////////////////////////////////////////////////////////////////

; Matrices
:o:pm2::\begin{{}pmatrix{}}`r• & • \\`r• & • \\`r\end{{}pmatrix{}}{Left 13}{Up}`t{Left}{Up}`t+{Right}
:o:bm2::\begin{{}bmatrix{}}`r• & • \\`r• & • \\`r\end{{}bmatrix{}}{Left 13}{Up}`t{Left}{Up}`t+{Right}
:o:pm3::\begin{{}pmatrix{}}`r• & • & • \\`r• & • & • \\`r• & • & • \\`r\end{{}pmatrix{}}{Left 13}{Up}`t{Left}{Up}`t{Left}{Up}`t+{Right}
:o:bm3::\begin{{}bmatrix{}}`r• & • & • \\`r• & • & • \\`r• & • & • \\`r\end{{}bmatrix{}}{Left 13}{Up}`t{Left}{Up}`t{Left}{Up}`t+{Right}
:o:pm4::\begin{{}pmatrix{}}`r• & • & • & • \\`r• & • & • & • \\`r• & • & • & • \\`r• & • & • & • \\`r\end{{}pmatrix{}}{Left 13}{Up}`t{Left}{Up}`t{Left}{Up}`t{Left}{Up}`t+{Right}
:o:bm4::\begin{{}bmatrix{}}`r0 & 0 & 0 & 0 \\`r0 & 0 & 0 & 0 \\`r0 & 0 & 0 & 0 \\`r0 & 0 & 0 & 0 \\`r\end{{}bmatrix{}}{Left 13}{Up}`t{Left}{Up}`t{Left}{Up}`t{Left}{Up}`t+{Right}

; Vectors
:o:v2::\begin{{}pmatrix{}}`r• \\`r• \\`r\end{{}pmatrix{}}{Left 13}{Up}`t{Left}{Up}`t+{Right}
:o:v3::\begin{{}pmatrix{}}`r• \\`r• \\`r• \\`r\end{{}pmatrix{}}{Left 13}{Up}`t{Left}{Up}`t{Left}{Up}`t+{Right}
:o:v4::\begin{{}pmatrix{}}`r• \\`r• \\`r• \\`r• \\`r\end{{}pmatrix{}}{Left 13}{Up}`t{Left}{Up}`t{Left}{Up}`t{Left}{Up}`t+{Right}

; /// 6. GREEK /////////////////////////////////////////////////////////////////////////////////////

:o:a::\alpha  
:o:b::\beta
:o:c::\chi
:oc:d::\delta
:oc:D::\Delta
:o:e::\epsilon
:o:ve::\varepsilon
:oc:f::\phi
:oc:F::\Phi
:o:vf::\varphi
:oc:g::\gamma
:oc:G::\Gamma
:o:h::\eta
:o:i::\iota
:o:k::\kappa
:oc:l::\lambda
:oc:L::\Lambda
:o:m::\mu
:o:n::\nu
:oc:p::\pi
:oc:P::\Pi
:oc:q::\theta
:oc:Q::\Theta
:o:vq::\vartheta
:o:r::\rho
:oc:s::\sigma
:oc:S::\Sigma
:o:t::\tau
:oc:u::\upsilon
:oc:U::\Upsilon
:o:v::\digamma
:oc:w::\omega
:oc:W::\Omega
:oc:x::\xi
:oc:X::\Xi
:oc:y::\psi
:oc:Y::\Psi
:o:z::\zeta

; /// 3. EDIT SNIPPET ///////////////////////////////////////////////////////////////////////////
^<!+o::•
^<!+k::{
	Send "{Raw}{{}"
	Return
}
^<!+l::{
	Send "{Raw}{}}"
	Return
}