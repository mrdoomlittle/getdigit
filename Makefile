SHELL :=/bin/bash
DEF_INSTALL=/usr/local
INSTALL_DIR=$(DEF_INSTALL)

NO_BINARY=false
INC_DIR_NAME=include

INTLEN_INC=$(DEF_INSTALL)/$(INC_DIR_NAME)
INTLEN_LIB=$(DEF_INSTALL)/lib
MDLINT_INC=$(DEF_INSTALL)/$(INC_DIR_NAME)

INC=-Iinc -I$(INTLEN_INC) -I$(MDLINT_INC)
LIB=-Llib -L$(INTLEN_LIB)
LL=-lmdl-getdigit -lmdl-intlen

ARC=ARC32
R_ARC=
CFG=
RUST_LIBS=false

all: build

ARC64:
	make build ARC=ARC64 R_ARC=ARC64 CFG=--cfg RUST_LIBS=$(RUST_LIBS)\
	INTLEN_INC=$(INTLEN_INC) INTLEN_LIB=$(INTLEN_LIB) MDLINT_INC=$(MDLINT_INC)
ARC32:
	make build ARC=ARC32 R_ARC=ARC32 CFG=--cfg RUST_LIBS=$(RUST_LIBS)\
	INTLEN_INC=$(INTLEN_INC) INTLEN_LIB=$(INTLEN_LIB) MDLINT_INC=$(MDLINT_INC)

build: src/getdigit.o libmdl-getdigit.a
	cp src/getdigit.hpp inc/mdl
	cp libmdl-getdigit.a lib

	if [ $(RUST_LIBS) = true ]; then\
		make rust-libs R_ARC=$(R_ARC) CFG=$(CFG);\
		cp libmdl-getdigit.rlib rlib;\
		rustc -Llib -Lrlib -o bin/getdigit.rust getdigit.rs -lmdl-getdigit;\
	fi;

	if [ $(NO_BINARY) = false ]; then\
		g++ -Wall -std=c++11 $(INC) $(LIB) -D__$(ARC) -o bin/getdigit getdigit.cpp $(LL);\
	fi;
rust-libs: src/libgetdigit.rlib

libmdl-getdigit.a: src/getdigit.o
	ar rcs libmdl-getdigit.a src/getdigit.o

src/getdigit.o: src/getdigit.cpp
	g++ -c -Wall -fPIC -std=c++11 $(INC) -D__$(ARC) -o src/getdigit.o src/getdigit.cpp

src/libgetdigit.rlib: src/getdigit.rs
	rustc -L/usr/local/lib $(CFG) $(R_ARC) --crate-type=lib -o libmdl-getdigit.rlib src/getdigit.rs -lmdl-intlen -lstdc++

clean:
	rm -f bin/*
	rm -f lib/*.a
	rm -f rlib/*.rlib
	rm -f inc/mdl/*.hpp
	rm -f src/*.o
	rm -f src/*.a
	rm -f src/*.rlib
install:
	mkdir -p $(INSTALL_DIR)/bin
	mkdir -p $(INSTALL_DIR)/lib
	mkdir -p $(INSTALL_DIR)/rlib
	mkdir -p $(INSTALL_DIR)/$(INC_NAME)

	cp bin/getdigit $(INSTALL_DIR)/bin
	cp lib/libmdl-getdigit.a $(INSTALL_DIR)/lib

	if [ -f rlib/libgetdigit.rlib ]; then \
		cp rlib/libgetdigit.rlib $(INSTALL_DIR)/rlib/libgetdigit.rlib;\
	fi;

	mkdir -p $(INSTALL_DIR)/$(INC_NAME)/mdl
	cp inc/mdl/getdigit.hpp $(INSTALL_DIR)/$(INC_NAME)/mdl/getdigit.hpp
uninstall:
	rm -f $(INSTALL_DIR)/bin/getdigit
	rm -f $(INSTALL_DIR)/lib/libmdl-getdigit.a
	rm -f $(INSTALL_DIR)/rlib/libmdl-getdigit.rlib
	rm -rf $(INSTALL_DIR)/$(INC_NAME)/mdl
