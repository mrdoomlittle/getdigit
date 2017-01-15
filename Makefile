DESTDIR=/usr/local
ARC=

all: build

ARC64:
	make build ARC=-DARC64
ARC32:
	make build ARC=-DARC32
build: src/getdigit.o
	cp src/*.hpp inc
	ar rcs lib/libgetdigit.a src/getdigit.o
	g++ -Wall -std=c++11 $(ARC) -Iinc -Llib -o bin/getdigit getdigit.cpp -lgetdigit -lintlen

src/getdigit.o: src/getdigit.cpp
	g++ -c -Wall -std=c++11 $(ARC) -o src/getdigit.o src/getdigit.cpp

clean:
	rm -f bin/*
	rm -f lib/*.a
	rm -f inc/*.hpp
	rm -f src/*.o
install:
	mkdir -p $(DESTDIR)/bin
	mkdir -p $(DESTDIR)/lib
	mkdir -p $(DESTDIR)/include
	cp bin/getdigit $(DESTDIR)/bin/getdigit
	cp lib/libgetdigit.a $(DESTDIR)/lib/libgetdigit.a
	cp inc/getdigit.hpp $(DESTDIR)/include/getdigit.hpp
uninstall:
	rm -f $(DESTDIR)/bin/getdigit
	rm -f $(DESTDIR)/lib/getdigit.a
	rm -f $(DESTDIR)/include/getdigit.hpp
