
/* macros for tts .c files */


/* for sprint_state */

#define CATI(z,s) {avail -= z; if (avail<1) {return -1;} else {strcat(buff,s);}}
#define CATV(f,v) {sprintf(tmpbuff,f,v); avail -= strlen(tmpbuff); if (avail<1) {return -1;} else {strcat(buff,tmpbuff);}}

/* for interval arithmetics */

#define XINTERVAL {fprintf(stderr,"interval value out of range\n"); fflush(stderr); exit(1);}

#define IMINUS(x,l,h)  ({int r= -x; if (r<l || r>h) {XINTERVAL;} r;})
#define ICOERCE(x,l,h) ({int r=x; if (r<l || r>h) {XINTERVAL;} r;})
#define IADD(x,y,l,h)  ({int r=x + y; if (r<l || r>h) {XINTERVAL;} r;})
#define ISUB(x,y,l,h)  ({int r=x - y; if (r<l || r>h) {XINTERVAL;} r;})
#define IMUL(x,y,l,h)  ({int r=x * y; if (r<l || r>h) {XINTERVAL;} r;})
#define IDIV(x,y,l,h)  ({int r=x / y; if (r<l || r>h) {XINTERVAL;} r;})
#define IMOD(x,y,l,h)  ({int r=x % y; if (r<l || r>h) {XINTERVAL;} r;})

/* for natural integer arithmetics */

#define XNATURAL {fprintf(stderr,"nat integer out of range\n"); fflush(stderr); exit(1);}

#define NMINUS(x)  ({int r= -x; if (r<0) {XNATURAL;} r;})
#define NCOERCE(x) ({int r=x; if (r<0) {XNATURAL;} r;})
#define NADD(x,y)  ({int r=x + y; if (r<0) {XNATURAL;} r;})
#define NSUB(x,y)  ({int r=x - y; if (r<0) {XNATURAL;} r;})
#define NMUL(x,y)  ({int r=x * y; if (r<0) {XNATURAL;} r;})
#define NDIV(x,y)  ({int r=x / y; if (r<0) {XNATURAL;} r;})
#define NMOD(x,y)  ({int r=x % y; if (r<0) {XNATURAL;} r;})

/* for queues */

#define XQUEUE {fprintf(stderr,"queue exception\n"); fflush(stderr); exit(1);}

#define EMPTY(q)         ((q).len==0)
#define FULL(q,n)        ((q).len==(n))

#define FailIfEmpty(q,n)   {if (EMPTY(q)) {XQUEUE;}}
#define FailIfFull(q,n)   {if (FULL(q,n)) {XQUEUE;}}



