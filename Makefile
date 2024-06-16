Elementary_Calculus.pdf: calc12book.pdf
	cp -v $^ $@

cover.jpg: calc12book.pdf
	gs -q -dBATCH -dNOPAUSE -sDEVICE=jpeg -dFirstPage=1 -dLastPage=1 -sOutputFile=$@ -r300 $@
