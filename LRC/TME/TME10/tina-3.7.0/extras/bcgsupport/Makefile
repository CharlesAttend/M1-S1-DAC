# makefile for libbcg

# CADP installation directory, please update:
CADP=/usr/local/cadp


BCGINCL=$(CADP)/incl

ifeq ($(HOSTTYPE),i386-linux)
# intel linux
DLLEXT=.so
BCGLIBS=$(CADP)/bin.iX86
else
# windows (mingw)
DLLEXT=.dll
BCGLIBS=$(CADP)/bin.win32
endif


build:
	$(MAKE) bcglib

bcglib: bcg_lib.c
	rm -f libbcg$(DLLEXT)
	gcc -O2 -o libbcg$(DLLEXT) bcg_lib.c -shared -s -Wall -I$(BCGINCL) -L$(BCGLIBS) -lBCG_IO -lBCG -lm


