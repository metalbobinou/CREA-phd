-include ../Makefile.rules

TARGET=FCA-treillis

FILES=main.cc                     \
      libcsv.c                    \
      MyAnsi.cc                   \
      Args.cc                     \
      Dirs.cc                     \
      Files.cc                    \
      ParseCSV.cc                 \
      AppliqueLesMesures.cc       \
      LireEtInterpTreillis.cc     \
      ContextFormelStrategies.cc  \
      GeneralisationImpact.cc     \
      GeneralisationSimApp.cc     \
      GeneralisationSimContex.cc  \
      DSPLs.cc

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
CFLAGS:=$(CFLAGS) -DMULTIPLE_ARGS=true -DWITH_CSV_PARSER=true
CXXFLAGS:=$(CXXFLAGS) -DMULTIPLE_ARGS=true -DWITH_CSV_PARSER=true


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
