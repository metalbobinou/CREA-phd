-include ../Makefile.rules

TARGET=FCA-3-LatticeAnalysis

FILES=main.cc                   \
      MyAnsi.cc                 \
      Args.cc                   \
      Dirs.cc                   \
      Files.cc                  \
      Printers.cc               \
      ProcessingFiles.cc        \
      ParseXML.cc               \
      TreeParseXML.cc           \
      FlatFileParseXML.c        \
      XMLLatticeLATReading.cc   \
      XMLLatticeOBJSReading.cc  \
      XMLLatticeATTSReading.cc  \
      XMLLatticeNODSReading.cc  \
      XMLLatticeReading.cc      \
      FCALatticeComponent.cc    \
      FCAObject.cc              \
      FCAAttribute.cc           \
      FCAConcept.cc             \
      FCALattice.cc             \
      FCALatticeStatistics.cc   \
      MyDebug.cc


SRC=$(FILES)
#OBJS=${SRC:.c=.o}
#OBJS=${SRC:.cpp=.o}
#OBJS=${SRC:.ccc=.o}
OBJS=$(patsubst %.cpp,%.o,$(patsubst %.cc,%.o,$(patsubst %.c,%.o,$(SRC))))
INCLUDE=
ifneq (,$(findstring .cpp,$(SRC)))
  LD=$(CXX)
else
  ifneq (,$(findstring .cc,$(SRC)))
    LD=$(CXX)
  else
    LD=$(CC)
  endif
endif


all: $(OBJS)
#	$(CC) $(OBJS) -o $(TARGET) $(LDFLAGS) $(LIBS)
	$(LD) $(OBJS) -o $(TARGET) $(LDFLAGS) $(LIBS)
	mv $(TARGET) ..

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDE) -c $< -o $@

${TARGET}: all

static: $(OBJS)
	ar cr $(TARGET).a $(OBJS)
	mv $(TARGET).a ..

dynamic: $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJS) -shared -o $(TARGET).so
	mv $(TARGET).so ..

clean:
	rm -f $(OBJS)
	find . -name "*~" -exec rm -rf '{}' \;
	find . -name "*#*" -exec rm -rf '{}' \;

distclean: clean
	rm -f ../$(TARGET)
	rm -f ../$(TARGET).a
	rm -f ../$(TARGET).so
	rm -rf ../$(TARGET).dSYM
