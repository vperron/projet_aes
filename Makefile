CC = gcc
LD = gcc


PROGRAM = projaes

OBJS = main.o test.o 


all: $(PROGRAM)

$(PROGRAM): $(OBJS)
	$(LD) $^ -o $@

clean:
	rm -f *.o

%.o: %.asm
	fasm $<
