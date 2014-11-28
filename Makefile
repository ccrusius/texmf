all:
	$(MAKE) -C submodules
	$(MAKE) -C tex/plain/ccrusius
	$(MAKE) -C regression
