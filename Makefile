CFLAGS = -Wall -Wextra -fPIC -Og -ggdb3 -MMD
CC = gcc
LIBS=-L./ -lcgic

all: libcgic.so.2.0.8 cgictest.cgi capture

install: libcgic.so.2.0.8
	cp libcgic.so.2.0.8 /usr/local/lib
	ln -sfv /usr/local/lib/libcgic.so.2.0.8 /usr/local/lib/libcgic.so.2
	ln -sfv /usr/local/lib/libcgic.so.2 /usr/local/lib/libcgic.so
	cp cgic.h /usr/local/include
	@echo libcgic.so.2.0.8 in /usr/local/lib. cgic.h is in /usr/local/include.

libcgic.so.2.0.8: cgic.o cgic.h
	rm -f libcgic.so.2.0.8
	gcc $(CFLAGS) -shared -Wl,-soname,libcgic.so.2 -o libcgic.so.2.0.8 cgic.o

#mingw32 and cygwin users: replace .cgi with .exe

cgictest.cgi: cgictest.o libcgic.so.2.0.8
	gcc -fPIC cgictest.o -o cgictest.cgi ${LIBS}

capture: capture.o libcgic.so.2.0.8
	gcc -fPIC capture.o -o capture ${LIBS}

clean:
	rm -f *.o libcgic.so.2.0.8 cgictest.cgi capture cgicunittest
	
test:
	gcc -fPIC -D UNIT_TEST=1 cgic.c -o cgicunittest
	./cgicunittest
