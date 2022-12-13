# usage:
#	make K=<int>    // makes nt<int>.tts and cleans up


K=0
GCC=gcc -O2 -s
TARGET=self
AVL=../lib/avl


# setting target dependant flags
ifeq ($(HOSTTYPE),i86pc-64)
# x86 solaris
EXT=.so
SHFLG=-shared -fPIC -fpic -static-libgcc
CFLAGS=-m64
else
ifeq ($(HOSTTYPE),i86pc)
# x86 solaris
EXT=.so
SHFLG=-shared -fPIC -fpic -static-libgcc
else
ifeq ($(HOSTTYPE),sparc)
# sparc solaris
EXT=.so
SHFLG=-G -fPIC -fpic
else
ifeq ($(HOSTTYPE),i386-linux)
# intel linux
EXT=.so
SHFLG=-shared -fPIC -fpic
else
ifeq ($(HOSTTYPE),x86_64-linux)
# intel linux 64 bit
EXT=.so
SHFLG=-shared -fPIC -fpic
CFLAGS=-m64
else
ifeq ($(HOSTTYPE),powermac)
# powerpc-darwin
EXT=.dylib
SHFLG=-dynamiclib -flat_namespace -undefined suppress -fPIC -fno-common
else
ifeq ($(HOSTTYPE),intel-pc)
# intelpc-darwin
EXT=.dylib
SHFLG=-m32 -dynamiclib -flat_namespace -undefined suppress -fPIC -fno-common
else
# assuming intel mingw
EXT=.dll
SHFLG=-shared
HOSTTYPE=i386-mswin
endif
endif
endif
endif
endif
endif
endif



all:	
	@if test $(K) = 0; then echo "usage: make K=<int>"; else $(MAKE) static K=$(K); fi

static:	
	@mknt.sh $(K)
	@mkdir -p nt$(K).tts
	@mv nt$(K).net nt$(K).tts
	@$(GCC) -o nt$(K)$(EXT) $(SHFLG) -DCOMPRESSION -I$(AVL) nt$(K).c $(AVL)/avl.c
	@mv nt$(K)$(EXT) nt$(K).ltl nt$(K).c nt$(K).tts
	@echo "made static nt$(K).tts"

clean:
	rm -rf nt*.tts

