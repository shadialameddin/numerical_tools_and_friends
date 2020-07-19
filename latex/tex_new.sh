# ############################# software

Gummi; the simple LaTeX editor

pdflatex -shell-escape p_emma_template.tex

# ############################# new libraries of templates
% load package with ``framed'' and ``numbered'' option.
%\usepackage[framed,numbered,autolinebreaks,useliterate]{mcode}
%sudo cp /home/alameddin/src/tex/templates/mcode.sty /usr/share/texlive/texmf-local/tex/latex/mcode.sty
%sudo texhash
%https://www.math.ias.edu/computing/faq/local-latex-style-files
%/home/alameddin/.config/texstudio/templates/user


# ############################# latex_uarial_package
wget -q http://tug.org/fonts/getnonfreefonts/install-getnonfreefonts
texlua ./install-getnonfreefonts
getnonfreefonts -a

could copy the template to:
	/usr/share/texstudio


# bib: use biber
