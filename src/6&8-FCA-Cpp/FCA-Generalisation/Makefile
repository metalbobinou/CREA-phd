-include ../Makefile.rules

TARGET=FCA-4-Generalisation
TARGET_DIR=..

FILES=main.cc                     \
      MyAnsi.cc                   \
      Args.cc                     \
      Dirs.cc                     \
      Files.cc                    \
      LireEtInterpTreillis.cc     \
      ReadWriteTreillisMatrix.cc  \
      GeneralisationImpact.cc     \
      GeneralisationSimApp.cc     \
      GeneralisationSimContex.cc  \
      MyDebugs.cc



SRC=$(FILES)
#OBJS=${SRC:.c=.o}
#OBJS=${SRC:.cc=.o}
#OBJS=${SRC:.cpp=.o}
OBJS=$(patsubst %.cpp,%.o,$(patsubst %.cc,%.o,$(patsubst %.c,%.o,$(SRC))))
INCLUDE=
# Choose GCC as linker, or G++ if there is at least one C++ file
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
	mv $(TARGET) $(TARGET_DIR)

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDE) -c $< -o $@

${TARGET}: all

static: $(OBJS)
	ar cr $(TARGET).a $(OBJS)
	mv $(TARGET).a $(TARGET_DIR)

dynamic: $(OBJS)
#	$(CC) $(LDFLAGS) $(OBJS) -shared -o $(TARGET).so
	$(LD) $(OBJS) $(LDFLAGS) $(LIBS) -shared -o $(TARGET).so
	mv $(TARGET).so $(TARGET_DIR)

clean:
	rm -f $(OBJS)
	find . -name "*~" -exec rm -rf '{}' \;
	find . -name "*#*" -exec rm -rf '{}' \;

distclean: clean
	rm -f $(TARGET_DIR)/$(TARGET)
	rm -f $(TARGET_DIR)/$(TARGET).a
	rm -f $(TARGET_DIR)/$(TARGET).so
	rm -f $(TARGET_DIR)/$(TARGET).stackdump
	rm -rf $(TARGET_DIR)/$(TARGET).dSYM
