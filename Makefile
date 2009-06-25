CC = gcc
LD = gcc

CFLAGS = -g -Wall
PROGRAM = projaes

OBJS = main.o aes.o aes_sse.o 


all: $(PROGRAM)

$(PROGRAM): $(OBJS)
	$(LD) $^ -o $@

clean:
	rm -f *.o
	rm -f projaes

%.o: %.asm
	fasm $<
