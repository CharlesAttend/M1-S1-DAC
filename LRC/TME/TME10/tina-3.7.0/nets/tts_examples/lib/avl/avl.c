/* avl's with state compression */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "avl.h"
#ifdef DATABASE
#include <db.h>
#endif



static int statesize = 0;       /* size of decompression buffer */


#ifdef COMPRESSION
/* compression/decompression ---------------------------------------------------------------- */

/* generic compressor/decompressor: */

/* compresses "sz" integers into byte array "to" using vle
   cz is size of to, assumed large enough
   fills to array from the end; returns index of first significant char in to
   ### TODO: use >> and << rather than / and % 
*/
int compressToBytes (int cz, unsigned char *to, int sz, int *from) {
  int i;           /* current index in from */
  int j = cz;      /* current index in to */
  int x, neg;
  for (i=sz-1; i>=0; i--) {
    x = from[i];
    if (x==0) {
      to[--j] = 128;
    } else {
      if (x < 0) {
	neg = 1;
	x = -x;
      } else {
	neg = 0;
      }
      /* vle neg x: */
      if (x < 128) {
	if (x < 64) {
	  to[--j] = (neg) ? (x+64+128) : (x+128);
	} else {
	  to[--j] = (x+128);
	  to[--j] = (neg) ? 64 : 0;
	}
      } else {
	to[--j] = (x % 128) + 128;
	/* vle2 neg x */
	x = x / 128;
	while (x >= 128) {
	  to[--j] = (x % 128);
	  x = x / 128;
	}
	if (x < 64) {
	  to[--j] = (neg) ? (x+64) : x;
	} else {
	  to[--j] = x;
	  to[--j] = (neg) ? 64 : 0;
	}
      }
    }
  }
  return j;
}

/* uncompresses "sz" chars into int array "to" using rvle; returns number of ints uncompressed
   to assumed large enough
*/
int uncompressFromBytes (int *to, int j, int cz, unsigned char *from) {
  int c, r, n;
  int k = 0;
  int neg;
  while (j < cz) {
    /* rvle j */
    c = from[j++];
    if (c >= 128) {
      r = c - 128;
      to[k++] = (r < 64) ? r : -(r - 64);
    } else {
      if (c < 64) {
	neg = 0;
	n = c;
      } else {
	neg = 1;
	n = c-64;
      }
      /* accu n : */
      while ((c = from[j++]) < 128) {
	n = 128*n + c;
      }
      n = 128*n + (c-128);
      to[k++] = (neg) ? -n : n;
    }
  }
  return k;
}


/* compression/decompression routines: */

static int compressf = 0;              /* does compress if 1, overwritten by set_compression if called */

int set_compression (int f) {
  compressf = f;
  // fprintf(stderr,"compressf=%d\n",compressf);
  return 0;
}

static unsigned char *bytes;    /* compression buffer           */ 
static int bytessize = 0;       /* size of compression buffer   */
static int stateintsize = 0;    /* size of states in int        */
static int *state;              /* decompression buffer         */
static key statekey = 0;        /* key of decompressed state    */


/* compressed states start with their size, encoded over CSIZE bytes.
   CSIZE is set to 1, please redefine if higher count is needed.
*/
#ifndef CSIZE
#define CSIZE 1     /* or 2, or 4 */
#endif
static int maxcsize;       /* set from CSIZE in init_storage */

#if (CSIZE==1)
#define getsize(x)   (*(x))
#define setsize(a,z) {*(a)=z;}
#else
#if (CSIZE==2)
#define getsize(x)   (*(unsigned short *)(x))
#define setsize(a,z) {*((unsigned short *)(a))=z;}
#else
/* SIZE==4 */
#define getsize(x)   (*(unsigned int *)(x))
#define setsize(a,z) {*((unsigned int *)(a))=z;}
#endif
#endif


/* compresses state into a string returned as result; frees the state */
unsigned char *compress (void *state) {
  unsigned int j = compressToBytes(bytessize,bytes,stateintsize,(int *)state);
  unsigned int z = bytessize-j;  /* size of result array */
  char *cstate = (unsigned char *)malloc(z+CSIZE);
  if (NULL == cstate || z > maxcsize) {
    fprintf (stderr,"error: cannot compress state\n");
    if (NULL != cstate) {
      if (CSIZE < 4) {
	fprintf (stderr,"error: cannot compress state: consider CSIZE=%d\n",(CSIZE==1)?2:4);
      } else {
	fprintf (stderr,"error: state too large, consider alternative storage\n");
      }
    } else {
      fprintf (stderr,"error: cannot compress state: out of memory\n");
    }
    exit(1); 
  }
  memcpy(cstate+CSIZE,bytes+j,z);
  setsize(cstate,z);
  // fprintf(stderr,"compressed %d bytes into %d bytes\n",statesize,z);
  free(state);
  return cstate;
}

/* uncompresses string into a state returned as result; does NOT free the string */
void *uncompress (unsigned char *cstate) {
  if (statekey == (key)cstate) {
    // fprintf (stderr,"cached\n");
    return state;                    /* cached; last state uncompressed is left in state */
  } else {
    // fprintf (stderr,"missed\n");
    statekey = (key)cstate;          /* do uncompress */
    uncompressFromBytes(state,0,getsize(cstate),cstate+CSIZE);
    return state;
  }
}
#endif


/* memcmp on mac does not return result in {-1,0,1}, will take sign of it ------------------- */
#if defined(__MACH__) && defined(__APPLE__)
int sign(int v) {return v > 0 ? 1 : (v < 0 ? -1 : 0);}
#else
#define sign(x) (x)
#endif



#ifdef DATABASE
/* database routines ------------------------------------------------------------------------ */

static int databasef = 0;              /* enables compression and database storage if 1 */
static char databasedir[256];          /* database directory                            */

int set_database (char *tinadbdir) {
  if (*tinadbdir) {
    compressf = 1;
    databasef = 1;
    strcpy(databasedir,tinadbdir);
  }
  // fprintf(stderr,"compressf=%d, databasef=%d, databasedir=%s\n",compressf,databasef,databasedir);
  return 0;
}

DB* dbd;
char dbname[256];

int init_dbase () {
  int ret;
  /* set dbname: */
  if (strlen(databasedir)) {
    strcpy(dbname,databasedir);
  } else {
    char *edir=getenv("TINADBDIR");
    if (NULL==edir) {
      strcpy(dbname,"/tmp");
    } else {
      strcpy(dbname,edir);
    }
  }
  strcat(dbname,"/cdata.db");
  /* create database: */
  ret = db_create(&dbd, NULL, 0);
  if (ret != 0) {
    fprintf(stderr,"Cannot create cstate database\n");
    return -1;
  }
  dbd->set_cachesize(dbd,0,536870912,1);
  ret = dbd->open( dbd,        /* DB structure pointer */
		   NULL,       /* Transaction pointer */
		   dbname,     /* On-disk file that holds the database. */
		   NULL,       /* Optional logical database name */
		   DB_BTREE,   /* Database access method */
		   DB_CREATE | DB_TRUNCATE,      /* Open flags */
		   0);         /* File mode (using defaults) */
  if (ret) {
    fprintf(stderr,"Cannot open cstate database\n");
    return -1;
  }
  return 1;
}

// insert: value -> key
// if some m=cstate is stored then returns associated key,
// else stores record (new_key,cstate) and returns new_key
int NEXT = 1;  /* ### beware: cached statekey initialized to 0, should be != from any key ... ###### */
key store_dbase (char *cstate)
{
  int no = NEXT;
  DBT key;
  DBT data;
  int msize = getsize(cstate) + CSIZE;
  // fprintf(stderr,"storing ... ");
  /* factorizing cstate: */
  memset(&key, 0, sizeof(DBT));
  key.data = cstate;
  key.size = msize;
  memset(&data, 0, sizeof(DBT));
  if (dbd->get(dbd, NULL, &key, &data, 0) == DB_NOTFOUND) {
    data.data = &no;
    data.size = sizeof(int);
    dbd->put(dbd, NULL, &key, &data, 0);
    dbd->put(dbd, NULL, &data, &key, 0);
    NEXT++;
    // fprintf(stderr,"new %d\n",no);
  } else {
    no = *(int *)data.data;
    // fprintf(stderr,"old %d\n",no);
  }
  free(cstate);
  return no;
}

// lookup: key -> value
// returns cstate associated with key (assumed stored)
void *lookup_dbase (key k)
{
  // fprintf(stderr,"looking up %d ... ",k);
  if (statekey == k) {
    // fprintf (stderr,"cached\n");
    return state;  /* last state uncompressed is left in state */
  } else {
    DBT key;
    DBT data;
    memset(&key, 0, sizeof(DBT));
    key.data = &k;
    key.size = sizeof(int);
    memset(&data, 0, sizeof(DBT));
    dbd->get(dbd, NULL, &key, &data, 0);
    /* uncompress: */
    statekey = k;
    char *dt = data.data;
    uncompressFromBytes(state,0,getsize(dt),dt+CSIZE);
    // fprintf(stderr,"found\n");
    return state;
  }
}

void finalize_dbase ()
{
  dbd->close( dbd, 0);
}
#endif




/* API routines: */

/* by default, values are assumed to be blocks of statesize bytes which are sizeof(int) aligned,
      that can be compared with memcmp and freed with free;
   If not the case, then application may pass specific compare_value and free_value functions;
*/

int compare (char *x, char *y) {return sign(memcmp(x,y,statesize));}
#ifdef COMPRESSION
int compare_compressed (unsigned char *x, unsigned char *y) {return sign(memcmp(x,y,getsize(x)+CSIZE));}
#endif
int (*COMPAREF)();  /* state comparison function */
#define compare_state(x,y) ((*COMPAREF)(x,y))

void (*FREEF)();     /* state free function */
#define free_state(x) ((*FREEF)(x))

/* initilization of storage, assuming init_cavl has already been called */
int init_storage (void *comparef, void *freef, int size) {
  /* set sstatesize and compare/free functions: */
  // fprintf(stderr,"init_storage %d %d %d \n",NULL!=comparef,NULL!=freef,size);
  statesize = size;
  // printf ("statesize=%d\n",size);
#ifdef COMPRESSION
  if (compressf) {
    COMPAREF = compare_compressed;
    FREEF =  free;
    /* set/check compression parameters: */
    maxcsize = pow(256,CSIZE) - 1;
    stateintsize = size / sizeof(int);
    if (!(CSIZE==1 || CSIZE==2 || CSIZE==4)) {
      fprintf (stderr,"error: illegal CSIZE value (%d), must be in {1,2,4}\n",CSIZE);
      exit(1);  
    } else {
      bytessize = 5*stateintsize+CSIZE;
    }
    bytes = (char *)malloc(bytessize);
    state = (int *)malloc(statesize);
    if ((NULL == bytes) | (NULL == state)) {
      fprintf (stderr,"error: cannot initialize compressor\n");
      exit(1);  
    }
#ifdef DATABASE
    /* init database, if enabled: */
    if (databasef)
      init_dbase (databasedir);
#endif
  } else
#endif
         {
    /* no compression, use compare/free or comparef/freef according to args */
    if (NULL == comparef)
      COMPAREF = compare;
    else
      COMPAREF = comparef;
    if (NULL == freef)
      FREEF = free;
    else
      FREEF = freef;
    }
  return 0;
}

extern key SearchInsert();

key store_state (void *state) {
#ifdef COMPRESSION
  if (compressf) {
#ifdef DATABASE
    if (databasef) {
      return store_dbase (compress (state));
    } else
#endif
           {
      return SearchInsert (compress (state));
    }
  } else
#endif
         {
    return SearchInsert (state);
  }
}

void *lookup_state (key k) {
#ifdef COMPRESSION
  if (compressf) {
#ifdef DATABASE
    if (databasef) {
      return lookup_dbase(k);  /* uncompresses */
    } else 
#endif
           {
      return uncompress ((void *)k);
    }
  } else 
#endif
         {
    return (void *)k;
  }
}



/* storage */

typedef struct avl {
  short path;
  short balance;
  key key;
  struct avl *left;
  struct avl *right;
} avl;

avl *storage = NULL;


/* SearchInsert (combines lookup and add) */

#define AllocNode(e)            {node = (avl *)malloc(sizeof(avl)); \
                                 /* if (node==NULL) {fprintf (stderr,"cannot malloc (avl)\n"); fflush(stderr);} */ \
                                 node->path=0; node->key=(key)(e); \
                                 node->balance=0; \
                                 node->left=NULL; node->right=NULL;}
/* Rotate*: use P, PP, TMP as temporaries. */
#define RotateRight(Q)          {P=Q->left; PP=P->right; \
			         P->right=Q; Q->left=PP; Q=P;}
#define RotateLeftRight(Q)      {TMP=Q->left; RotateLeft(TMP); \
				 Q->left=TMP; RotateRight(Q);}
#define RotateLeft(Q)           {P=Q->right; PP=P->left; \
			         P->left=Q; Q->right=PP; Q=P;}
#define RotateRightLeft(Q)      {TMP=Q->right; RotateRight(TMP); \
				 Q->right=TMP; RotateLeft(Q);}

key SearchInsert (void *e)
{
  avl *P=storage;     /* moves down the tree                */
  avl *PP=NULL;       /* father of P                        */
  avl *A=P;           /* deepest on path with non-0 balance */
  avl *AA=NULL;       /* father of A                        */
  avl *TMP;
  avl *node;

  /* search: */ 
  if (P==NULL) {
    /* avl is empty */
    AllocNode(e);
    storage = node;
    return ((key)e);
  }
  
  do {
    if (P->balance!=0) {A=P; AA=PP;}
    switch (compare_state((void *)(P->key),e)) {
    case  1 : P->path=1; PP=P; P=P->left; break;
    case  0 : free_state(e); return(P->key);
    case -1 : P->path=0; PP=P; P=P->right; break;
    }
  } while (P!=NULL);

  /* insertion at PP: */
  
  AllocNode(e);
  if (PP->path) {PP->left=node;} else {PP->right=node;}

  /* update balance between A and node: */
  P=A;
  while (P!=node) {
    if (P->path) {
      P->balance=P->balance+1; P=P->left;
    } else {
      P->balance=P->balance-1; P=P->right;
    }
  }

  /* re-balance: */
  switch (A->balance) {
  case 2 : 
    switch ((A->left)->balance) {
    case 1 : 
      RotateRight(A); 
      A->balance=0;
      (A->right)->balance=0;
      break;
    case -1 :
      RotateLeftRight(A);
      switch (A->balance) {
      case  1 : (A->left)->balance=0; (A->right)->balance= -1; break;
      case  0 : (A->left)->balance=0; (A->right)->balance=0;  break;
      case -1 : (A->left)->balance= -1; (A->right)->balance=0; break;
      }
      A->balance=0;
      break;
    }
    break;
  case -2 :
    switch ((A->right)->balance) {
    case -1 :
      RotateLeft(A); 
      A->balance=0;
      (A->left)->balance=0;
      break;
    case  1 :
      RotateRightLeft(A);
      switch (A->balance) {
      case  1 : (A->left)->balance=0; (A->right)->balance=1; break;
      case  0 : (A->left)->balance=0; (A->right)->balance=0;  break;
      case -1 : (A->left)->balance=1; (A->right)->balance=0; break;
      }
      A->balance=0;
      break;
    }
    break;
  default: return((key)e);
  }

  /* update link to A: */
  if (AA==NULL) {
    storage = A;
  } else {
    if (AA->path) {
      AA->left=A;
    } else {
      AA->right=A;
    }
  }

  return((key)e);
}

