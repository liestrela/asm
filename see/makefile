AS=as
LD=ld

all: see

see.o: see.S linux.S error.S
	$(AS) -o $@ $<

see: see.o
	$(LD) -o $@ $<

clean:
	rm -f *.o see
