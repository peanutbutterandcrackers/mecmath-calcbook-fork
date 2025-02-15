FROM fedora:41
RUN dnf -y upgrade
RUN dnf -y install texlive-scheme-basic texlive-koma-script
RUN dnf -y install texlive-nomencl texlive-fancybox texlive-braket \
    texlive-phaistos texlive-dingbat texlive-cancel texlive-relsize texlive-bigints \
    texlive-mathtools texlive-appendix texlive-imakeidx texlive-idxlayout texlive-fouriernc \
    texlive-mdwtools texlive-tkz-euclide texlive-framed texlive-nextpage texlive-clrscode texlive-everysel
RUN dnf -y install texlive-ncntrsbk texlive-fourier
RUN dnf -y install gnuplot-latex
RUN export DEST=`kpsewhich -var-value=TEXMFHOME`/tex/latex/misc; \
    mkdir -p ${DEST} && curl -L http://mirrors.ctan.org/macros/latex209/contrib/picins/picins.sty -o ${DEST}/picins.sty \
    && echo "For Reference: https://tex.stackexchange.com/a/1138"
RUN mktexlsr
RUN dnf -y install ghostscript make
RUN dnf -y install entr
RUN dnf -y install texlive-multirow
RUN dnf -y install git texlive-latexdiff texlive-ulem # for `make diff-pdf`
CMD bash
