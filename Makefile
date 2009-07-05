CC = gcc
LD = gcc

CFLAGS = -g -Wall -m32
#-O2 
PROGRAM = projaes

OBJS = main.o aes.o aes_sse.o cpucycles/cpucycles.o

all: $(PROGRAM)

cpucycles/cpucycles.o:
	env ARCHITECTURE=32 sh cpucycles/do

$(PROGRAM): $(OBJS)
	$(LD) $^ -o $@

clean:
	rm -f *.o
	rm -f projaes

%.o: %.asm
	fasm $<
