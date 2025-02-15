calc12book.pdf: *.tex
	./calc12book.sh

pdf: calc12book.pdf

loop:
	ls *.tex | entr -sr 'make pdf'

scratch-calc12book.tex:
	# The escapes---confusing as they are---were figured out through a lot of trial-and-error.
	( sed 's/^\(.*\\include{.*\)/%\1/' calc12book.tex | sed '/%Put the main chapters here/a \\\addchap{Scratch}\\include{scratch.tex}' ) > $@

scratch.tex:
	touch scratch.tex

scratch: scratch-calc12book
scratch-calc12book: scratch.tex scratch-calc12book.tex
	latex $@.tex
	dvips -Pps -t letter -G0 -z $@.dvi -o
	ps2pdf -dALLOWPSTRANSPARENCY -dMaxSubsetPct=100 -dSubsetFonts=true -dPDFSETTINGS=/printer -dCompatibilityLevel=1.4 $@.ps

scratch-loop: scratch*.tex
	ls $^ | entr -sr 'make scratch'

###Diff PDF: Generate a diff-pdf between current state and COMMITISH.
diff-pdf: COMMITISH := "upstream"
diff-pdf: TMPDIR := $(shell mktemp -d)
diff-pdf: calc12book.tex
	git worktree add --detach ${TMPDIR} ${COMMITISH}
	latexdiff --flatten ${TMPDIR}/$^ $^ > diff.tex
	git worktree remove ${TMPDIR}
	# Ignore exit status because there are errors yet to be debugged.
	# See diff.log for details. Undefined control sequence. Probably
	# due to expanding \input{} files or something, AFAIUI.
	-latex -interaction=batchmode diff.tex
	-makeindex -s myindex.ist -o diff.ind diff.idx
	-latex -interaction=batchmode diff.tex
	-makeindex diff.nlo -s nomencl.ist -o diff.nls
	-latex -interaction=batchmode diff.tex
	-latex -interaction=batchmode diff.tex
	dvips -Pps -t letter -G0 -z diff.dvi -o
	ps2pdf -dALLOWPSTRANSPARENCY -dMaxSubsetPct=100 -dSubsetFonts=true -dEmbedAllFonts=true -dPDFSETTINGS=/printer -dCompatibilityLevel=1.4 diff.ps

### Environment (Uses Containers)
env: container_env

### Containers
CONTAINER_RUNTIME_ENGINE=$(shell which docker || echo "podman")
CRE=${CONTAINER_RUNTIME_ENGINE}
IMAGE_TAG=mc-ec-image

container_env: container_image
	${CRE} run --rm --interactive --tty --volume `pwd`:/sources:z --workdir="/sources" ${IMAGE_TAG}

container_image: .container_image_id
.container_image_id: Containerfile
	${CRE} build --file $< --tag ${IMAGE_TAG}
	${CRE} inspect --format {{.Id}} ${IMAGE_TAG} > .container_image_id
