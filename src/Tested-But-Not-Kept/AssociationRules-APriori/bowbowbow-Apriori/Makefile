-include Makefile.rules

PROJET=bowbowbow-APriori
CLASSICS=AUTHORS README.md LICENSE
SUPPLEMENTS=

#DIR=treillis
DIRS=src


# Compile and Link
all:
#	cd $(DIR) && $(MAKE)
	$(MAKE) $(DIRS)

$(PROJET): all

$(DIRS):
	(cd $@ && $(MAKE))

# Clean directories
clean:
	rm -f *~
	rm -f *#*
	rm -rf *.core
	rm -rf *.stackdump
	rm -rf *.dSYM
	rm -f $(PROJET).tar.bz2
	rm -rf $(PROJET)
	find . -name "*~" -exec rm -rf '{}' \;
	find . -name "*#*" -exec rm -rf '{}' \;
	find . -name "*.class" -exec rm -rf '{}' \;
#	cd $(DIR) && $(MAKE) clean distclean
	for dir in $(DIRS); do \
	  (cd $$dir && $(MAKE) clean); \
	done

# Clean previous dist (in case of abort)
distclean: clean
	sh configure
	for dir in $(DIRS); do \
	  (cd $$dir && $(MAKE) distclean); \
	done
	rm -rf $(PROJET)
	rm -f $(PROJET).tar.bz2
	rm -f Makefile.rules

# Create the tarball by copying files and deleting .svn directories
dist: distclean
	sh configure
	mkdir $(PROJET)
	cp -r $(CLASSICS) $(SUPPLEMENTS) configure Makefile $(DIRS) check   $(PROJET)
	find $(PROJET) -depth -name .svn -type d -exec rm -rf '{}' \;
	find $(PROJET) -depth -name .git -type d -exec rm -rf '{}' \;
	tar cvjf $(PROJET).tar.bz2 $(PROJET)
	rm -rf $(PROJET)
	$(MD5) $(PROJET).tar.bz2

# Create the archive & test it
distcheck: dist
	tar xvjf $(PROJET).tar.bz2
	cd $(PROJET) && $(MAKE) check
	rm -rf $(PROJET)

.PHONY: check $(DIRS)

# Launch the test suite if it exists
check: all
	cd check && $(MAKE) check

# Glouglou...
cafe:
	@echo "                       "
	@echo "    \ | ( | ) / /      "
	@echo "  _________________    "
	@echo "  |               |    "
	@echo "  |               |    "
	@echo "  |               /--\ "
	@echo "  |               |  | "
	@echo "   \             /\--/ "
	@echo "    \___________/      "
	@echo "                       "

coffee: cafe
