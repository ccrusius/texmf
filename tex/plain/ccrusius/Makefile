packages := ccbase ccgrid ccsections

all:: $(addsuffix .pdf,$(packages))
all:: $(addsuffix .tex,$(packages))

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

%.pdf: %.ccw
	lua ../../../submodules/ccweb/bin/ccweave.lua -job-name=$(@:.pdf=)_doc $<
	pdftex -halt-on-error -interaction=nonstopmode -include-directory=$(PWD) $(@:.pdf=)_doc
	$(CP) $(@:.pdf=)_doc.pdf $@
	$(RM) $(@:.pdf=)_doc.pdf

%.tex: %.ccw
	lua ../../../submodules/ccweb/bin/cctangle.lua $<


