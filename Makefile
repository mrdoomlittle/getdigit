SHELL :=/bin/bash
DESTDIR=/usr/local
ARC=
R_ARC=
CFG=
RUST_LIBS=false

all: build

ARC64:
	make build ARC=-DARC64 R_ARC=ARC64 CFG=--cfg RUST_LIBS=$(RUST_LIBS)
ARC32:
	make build ARC=-DARC32 R_ARC=ARC32 CFG=--cfg RUST_LIBS=$(RUST_LIBS)
build: src/getdigit.o src/libgetdigit.a
	cp src/getdigit.hpp inc
	cp src/libgetdigit.a lib
	
	if [ $(RUST_LIBS) = true ]; then\
		make rust-libs R_ARC=$(R_ARC) CFG=$(CFG);\
		cp src/libgetdigit.rlib rlib;\
		rustc -Llib -Lrlib -o bin/getdigit.rust getdigit.rs -lgetdigit;\
	fi;
	
	g++ -Wall -std=c++11 $(ARC) -Iinc -Llib -o bin/getdigit getdigit.cpp -lgetdigit -lintlen

rust-libs: src/libgetdigit.rlib
	
src/libgetdigit.a: src/getdigit.o
	ar rcs src/libgetdigit.a src/getdigit.o

src/getdigit.o: src/getdigit.cpp
	g++ -c -Wall -fPIC -std=c++11 $(ARC) -o src/getdigit.o src/getdigit.cpp

src/libgetdigit.rlib: src/getdigit.rs
	rustc -L/usr/local/lib $(CFG) $(R_ARC) --crate-type=lib -o src/libgetdigit.rlib src/getdigit.rs -lintlen -lstdc++

clean:
	rm -f bin/*
	rm -f lib/*.a
	rm -f rlib/*.rlib
	rm -f inc/*.hpp
	rm -f src/*.o
	rm -f src/*.a
	rm -f src/*.rlib
install:
	mkdir -p $(DESTDIR)/bin
	mkdir -p $(DESTDIR)/lib
	mkdir -p $(DESTDIR)/rlib
	mkdir -p $(DESTDIR)/include
	cp bin/getdigit $(DESTDIR)/bin/getdigit
	cp lib/libgetdigit.a $(DESTDIR)/lib/libgetdigit.a
	if [ -f rlib/libgetdigit.rlib ]; then \
		cp rlib/libgetdigit.rlib $(DESTDIR)/rlib/libgetdigit.rlib;\
	fi;
	cp inc/getdigit.hpp $(DESTDIR)/include/getdigit.hpp
uninstall:
	rm -f $(DESTDIR)/bin/getdigit
	rm -f $(DESTDIR)/lib/libgetdigit.a
	rm -f $(DESTDIR)/rlib/libgetdigit.rlib
	rm -f $(DESTDIR)/include/getdigit.hpp
