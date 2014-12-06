all: ccgrid.pdf ccgrid.lua ccgrid.tex

#
# I don't know why I need -include-directory specified in the call to pdftex, but in my
# setup it seems I do. Perhaps it is because my repository is my TEXMF, and that
# confuses MiKTeX somehow? This is not necessary anywhere else in my filesystem.
#
ifeq ($(OS),Windows_NT)
  PWD := $(shell echo %cd%)
  PWD := $(subst C:,,$(PWD))
else
  PWD := $(shell pwd)
endif

ccgrid.pdf: ccgrid.ccw ../../../submodules/ccweb/bin/ccweave.lua
	lua ../../../submodules/ccweb/bin/ccweave.lua -job-name=ccgrid_doc ccgrid.ccw
	pdftex -halt-on-error -interaction=nonstopmode -include-directory=$(PWD) -job-name=ccgrid ccgrid_doc

ccgrid.tex ccgrid.lua: ccgrid.ccw ../../../submodules/ccweb/bin/cctangle.lua
	lua ../../../submodules/ccweb/bin/cctangle.lua ccgrid.ccw

