ElementaryCalculus.pdf: ad-hoc-patches manual_dependencies *.tex
	./calc12book.sh

pdf: ElementaryCalculus.pdf

### Ad-hoc patches
ad-hoc-patches:
	sed -i '/\usetkzobj{all}/d' calc12book.tex

### Manual Dependencies
manual_dependencies: gnuplot-lua-tikz.sty picins.sty

gnuplot-lua-tikz.sty:
	wget https://raw.githubusercontent.com/kpu/mtplz/master/paper/gnuplot-lua-tikz.sty
	wget https://raw.githubusercontent.com/kpu/mtplz/master/paper/gnuplot-lua-tikz-common.tex

picins.sty:
	wget http://mirrors.ctan.org/macros/latex209/contrib/picins/picins.sty

### Environment (Uses Containers)
env: container_env

### Containers
CONTAINER_RUNTIME_ENGINE=$(shell which docker || echo "podman")
CRE=${CONTAINER_RUNTIME_ENGINE}
IMAGE_TAG=mc-ec-image

container_env: container_image
	${CRE} run --rm --interactive --tty --volume `pwd`:/sources --workdir="/sources" ${IMAGE_TAG}

container_image: .container_image_id
.container_image_id: Containerfile
	${CRE} build --file $< --tag ${IMAGE_TAG}
	${CRE} inspect --format {{.Id}} ${IMAGE_TAG} > .container_image_id
