all: ccgrid.pdf ccgrid.lua ccgrid.tex

#
# I don't know why I need -include-directory specified in the call to pdftex, but in my
# setup it seems I do. Perhaps it is because my repository is my TEXMF, and that
# confuses MiKTeX somehow? This is not necessary anywhere else in my filesystem.
#
ifeq ($(OS),Windows_NT)
  PWD := $(shell echo %cd%)
  PWD := $(subst C:,,$(PWD))
  CP := copy
  RM := del
else
  PWD := $(shell pwd)
  CP := cp
  RM := rm -f
endif

ccgrid.pdf: ccgrid.ccw ../../../submodules/ccweb/bin/ccweave.lua
	lua ../../../submodules/ccweb/bin/ccweave.lua -job-name=ccgrid_doc ccgrid.ccw
	pdftex -halt-on-error -interaction=nonstopmode -include-directory=$(PWD) ccgrid_doc
	$(CP) ccgrid_doc.pdf $@
	$(RM) ccgrid_doc.pdf

ccgrid.tex ccgrid.lua: ccgrid.ccw ../../../submodules/ccweb/bin/cctangle.lua
	lua ../../../submodules/ccweb/bin/cctangle.lua ccgrid.ccw

