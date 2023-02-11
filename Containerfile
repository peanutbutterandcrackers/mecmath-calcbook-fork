FROM fedora:latest
RUN dnf -y upgrade
RUN dnf -y install texlive-scheme-full
RUN dnf -y install ghostscript
RUN dnf -y install wget
CMD bash