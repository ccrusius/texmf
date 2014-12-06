all: ccgrid.pdf ccgrid.lua ccgrid.tex

ccgrid.pdf: ccgrid.ccw ../../../submodules/ccweb/bin/ccweave.lua
	lua ../../../submodules/ccweb/bin/ccweave.lua -job-name=ccgrid_doc ccgrid.ccw
	pdftex -halt-on-error -interaction=nonstopmode -job-name=ccgrid ccgrid_doc

ccgrid.tex ccgrid.lua: ccgrid.ccw ../../../submodules/ccweb/bin/cctangle.lua
	lua ../../../submodules/ccweb/bin/cctangle.lua ccgrid.ccw

