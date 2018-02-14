# Makefile for creating C program / Arduino code

#FLOW := C
#FLOW := CPP

ifeq ($(FLOW),CPP)
   $(warning FLOW is CPP)
   CC = g++
   SUFFIX = cpp
else
   $(warning FLOW is C)
   CC = gcc
   SUFFIX = c
endif

###################### ARDUINO ######################
ifeq ($(FLOW),ARD)
#ARDUINO_LIBS = Wire
#USER_LIB_PATH = /nas/iot/arduino/ard-lib
MONITOR_BAUDRATE = 115200

include /usr/share/arduino/Arduino.mk

else 

###################### DragonBoard ######################
#Libs
PROGRAM = exe_DB_for_arduino
#_OBJ = \
#	squareMraa.o
#	squareWave.o
#_DEPS = \
#	i2cBitBangingBus.h
_DEPS :=

OBJ  = $(patsubst %,$(ODIR)/%,$(_OBJ))
DEPS = $(patsubst %,$(DB_DIR)/%,$(_DEPS))

#Flags
LIBS = -lsoc -lmraa

ODIR=obj
DB_DIR = db_src
ifeq ($(FLOW),CPP)
#  CFLAGS = -I$(DB_DIR) -I/nas/scripts/cpp_lib/include -g -Wall -pedantic
   CFLAGS = -I$(DB_DIR) -I/nas/scripts/cpp_lib/include -g -pedantic
else
   CFLAGS = -I$(DB_DIR)
endif

RM = rm -rf

# making all progs
all: main run
complete: clean main run

#compiling each c file to obj
$(ODIR)/%.o: $(DB_DIR)/%.$(SUFFIX) $(ODIR) $(DEPS)
	$(CC) -c $< -o $@ $(CFLAGS) $(LIBS)

# making exe from objs
main: $(OBJ)
	$(CC) -o $(PROGRAM) $(OBJ) $(CFLAGS) $(LIBS)

run: main
	sudo ./$(PROGRAM)


# prepare dir
$(ODIR):
	mkdir -p $(ODIR)


#cleaning
clean:
	$(RM) $(ODIR) *.bak *~* "#"* core main flat *.cpp.* *.h.* $(PROGRAM)

###################### DEBUG ######################
debug:
	$(warning FLOW = $(FLOW))
	$(warning CC = $(CC))
	$(warning SUFFIX = $(SUFFIX))

endif
