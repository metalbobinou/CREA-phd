-include ../Makefile.rules

all:
	$(MAKE) check

check:
	sh check.sh

clean:
	rm -f *~
	rm -f *#*

distclean: clean
	rm -rf *.core
	rm -rf *.stackdump
	rm -rf *.dSYM
	rm -f FCA-1-StrategyPreProcessing
	rm -f FCA-3-FragmentsExtraction
	rm -f FCA-4-Measures
	rm -f FCA-5-Generalisation
	rm -rf FichiersStrategies
