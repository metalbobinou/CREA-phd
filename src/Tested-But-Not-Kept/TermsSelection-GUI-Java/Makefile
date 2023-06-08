-include Makefile.rules

TARGET=TermsSelectionGUI
DIST_FOLDER=$(LOGIN_L)-$(TARGET)
MANIFEST=Manifest.mf

SRC_DIRS=     \
         CSVManipulation  \
         FormalContextGUI \
         Main

JARFILE=$(TARGET).jar

all: $(JARFILE)

# Call Make for each folder containing sources
compile:
	$(MAKE) $(SRC_DIRS)

$(TARGET): compile

# Compile sources & Create a JAR file
jar: compile
	(cd bin && $(JAR) -cvmf ../$(MANIFEST) $(JARFILE) $(SRC_DIRS))
	mv -f ./bin/$(JARFILE) ./

$(JARFILE): jar

# Go in each folder to compile & move each file to "bin" folder
$(SRC_DIRS):
	(cd src/$@ && $(MAKE))
	mkdir -p ./bin/$@
	mv ./src/$@/*.class ./bin/$@

# Clean building files
clean:
	rm -f *~
	rm -rf *#*
	find . -name "*~" -exec rm -rf '{}' \;
	find . -name "*#*" -exec rm -rf '{}' \;
	find . -name "*.class" -exec rm -rf '{}' \;
	rm -f bin/$(TARGET).jar
	rm -rf bin/

# Clean binaries & configure
distclean: clean
	rm -f $(TARGET).jar
	rm -rf $(DIST_FOLDER)
	rm -f $(DIST_FOLDER).tar.bz2
	rm -f Makefile.rules
	rm -rf Output/

# Create the tarball by copying files and deleting .svn directories
dist: distclean
	mkdir -p $(DIST_FOLDER)
	cp -r src $(MANIFEST) configure Makefile $(DIST_FOLDER)
	find $(DIST_FOLDER) -depth -name ".svn" -type d -exec rm -rf '{}' \;
	tar cvjf $(DIST_FOLDER).tar.bz2 $(DIST_FOLDER)
	rm -rf $(DIST_FOLDER)
	$(MD5) $(DIST_FOLDER).tar.bz2
