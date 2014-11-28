all: ccgrid.pdf ccgrid.lua ccgrid.tex

ccgrid.pdf: ccgrid.ccw
	lua ../../../submodules/ccweb/bin/ccweave.lua ccgrid.ccw > ccgrid_doc.tex
	luatex --halt-on-error --job-name=ccgrid ccgrid_doc

ccgrid.tex ccgrid.lua: ccgrid.ccw
	lua ../../../submodules/ccweb/bin/cctangle.lua ccgrid.ccw

