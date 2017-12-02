SHELL :=/bin/bash
def_install_dir=/usr/local
ifndef install_dir
 install_dir=$(def_install_dir)
endif

no_binary=false
ifndef intlen_inc_dir
 intlen_inc_dir=$(def_install_dir)/include
endif

ifndef intlen_lib_dir
 intlen_lib_dir=$(def_install_dir)/lib
endif

ifndef mdlint_inc_dir
 mdlint_inc_dir=$(def_install_dir)/include
endif

inc_flags=-Iinc -I$(intlen_inc_dir) -I$(mdlint_inc_dir)
lib_flags=-Llib -L$(intlen_lib_dir)
ld_flags=-lmdl-getdigit -lmdl-intlen

ifndef arc
 arc=ARC32
endif

build_rust_lib=false
all: build
arc64:
	make build arc=ARC64 build_rust_lib=$(build_rust_lib)\
	intlen_inc_dir=$(inclen_inc_dir) intlen_lib_dir=$(intlen_lib_dir) mdlint_inc_dir=$(mdlint_inc_dir)
arc32:
	make build arc=ARC32 build_rust_lib=$(build_rust_lib)\
	intlen_inc_dir=$(inclen_inc_dir) intlen_lib_dir=$(intlen_lib_dir) mdlint_inc_dir=$(mdlint_inc_dir)

build: src/getdigit.o libmdl-getdigit.a
	cp src/getdigit.hpp inc/mdl
	if [ $(build_rust_lib) = true ]; then\
		make rust-libs arc=$(arc);\
		rustc -Llib -Lrlib -o bin/getdigit.rust getdigit.rs -lmdl-getdigit;\
	fi;

	if [ $(no_binary) = false ]; then\
		g++ -Wall -std=c++11 $(inc_flags) $(lib_flags) -D__$(arc) -o bin/getdigit getdigit.cpp $(ld_flags);\
	fi;
rust-libs: src/libgetdigit.rlib

libmdl-getdigit.a: src/getdigit.o
	ar rcs lib/libmdl-getdigit.a src/getdigit.o

src/getdigit.o: src/getdigit.cpp
	g++ -c -Wall -fPIC -std=c++11 $(inc_flags) -D__$(arc) -o src/getdigit.o src/getdigit.cpp

src/libgetdigit.rlib: src/getdigit.rs
	rustc -L/usr/local/lib --cfg $(arc) --crate-type=lib -o rlib/libmdl-getdigit.rlib src/getdigit.rs -lmdl-intlen -lstdc++

clean:
	rm -f bin/*
	rm -f lib/*.a
	rm -f rlib/*.rlib
	rm -f inc/mdl/*.hpp
	rm -f src/*.o
install:
	mkdir -p $(install_dir)/bin
	mkdir -p $(install_dir)/lib
	mkdir -p $(install_dir)/rlib
	mkdir -p $(install_dir)/include

	if [ -f bin/getdigit ]; then \
		cp bin/getdigit $(install_dir)/bin; \
	fi;

	cp lib/libmdl-getdigit.a $(install_dir)/lib

	if [ -f rlib/libgetdigit.rlib ]; then \
		cp rlib/libgetdigit.rlib $(install_dir)/rlib/libgetdigit.rlib;\
	fi;

	mkdir -p $(install_dir)/include/mdl
	cp inc/mdl/getdigit.hpp $(install_dir)/include/mdl/getdigit.hpp
uninstall:
	rm -f $(install_dir)/bin/getdigit
	rm -f $(install_dir)/lib/libmdl-getdigit.a
	rm -f $(install_dir)/rlib/libmdl-getdigit.rlib
	rm -rf $(install_dir)/include/mdl
