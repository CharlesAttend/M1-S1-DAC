
/* sites are indexed in 1..N */

#include <math.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

typedef int bool;  /* 0, 1 */
typedef int comp;  /* -1, 0, 1 */

int ttsapiversion () {return 0;}



/* -- 1. type value and utilities --------------------------------------------------- */

/* -- bags holding integers in 1..N */

typedef struct {
  int C;    /* reference count */
  int B[N]; /* bag of integers in 1..N,; encoded as a vector */
} bag;


/* creates new, empty, bag, with initial ref count 1 */
bag *new_bag () {
  bag *b = (bag *)malloc(sizeof(bag));
  b->C=1;
  return b;
}

/* dec ref count, then frees bag if no more referenced */
void free_bag (bag *b) {
  if (! --(b->C)) {
    free(b);
  }
}

/* identity function, increments ref count */
bag *share_bag (bag *b) {
  b->C++;
  return b;
}

/* creates new bag, copy of b, then frees b */
bag *copy_bag (bag *b) {
  bag *n = new_bag ();
  int i;
  for (i=0; i<N; i++)
    n->B[i] = b->B[i];
  free_bag(b);
  return n;
}

/* emptyness check */
int is_bag_empty (bag *b) {
  int i=0;
  for (i=0; i<N; i++) {if (b->B[i]) return 0;}
  return 1;
}

/* membership test */
int in_bag (int e, bag *b) {
  return b->B[e-1]>0;
}

/* copy bag, frees it, then adds element to copy */
bag *add_bag (bag *b, int e) {
  bag *n = copy_bag (b);
  n->B[e-1]++;
  return n;
}

/* copy bag, frees it, then removes element to copy */
bag *sub_bag (bag *b, int e) {
  bag *n = copy_bag (b);
  n->B[e-1]--;
  return n;
}


/* -- sites -------- */

/* site is the type of local values at each site */
typedef struct {
  int C;  /* reference count */
  int Father;
  bag *Req;
  int Ack;
} site;

/* dec ref count, then frees site if no more referenced */
void free_site (site *s) {
  if (! --(s->C)) {
    free_bag(s->Req);
    free(s);
  }
}

/* creates site from args, with initial ref count 1 */
site *new_site (int father, bag *bag, int ack) {
  site *s=(site *)malloc(sizeof(site));
  s->C=1;
  s->Father=father;
  s->Req=bag;
  s->Ack=ack;
  return s;
}

/* identity function, increments ref count */
site *share_site (site *s) {
  s->C++;
  return s;
}

/* returns a copy of site s, then frees s */
site *copy_site (site *s) {
  site *w=new_site(s->Father,share_bag(s->Req),s->Ack);
  free_site(s);
  return w;
}


/* -- values -------- */

/* a value is an array of sites pointers (== a pointer to the first site in array) */
typedef site *value;

/* allocates a value (uninitialized) */
value *new_value () {
  value *v = (value *)malloc(N*sizeof(site *));
  return v;
}

/* copy of a value, sharing sites */
value *copy_value (value *v) {
  value *w = new_value ();
  int i;
  for (i=0; i<N; i++)
    w[i]=share_site(v[i]);
  return w;
}



/* -- 2. for storage API ------------------------------------------------------------ */

#include "avl.h"

/* lexicographically compares two bags */
comp compare_bag (bag *a, bag *b) {
  int i = 0;
  if (a != b) {
    for (i=0; i<N; i++) {
      if (a->B[i]>b->B[i]) return 1;
      if (a->B[i]<b->B[i]) return -1;
    }
  }
  return 0;
}

/* lexicographically compares two sites */
comp compare_site (site *a, site *b) {
  int res;
    if (a != b) {
      if (a->Father>b->Father) return 1;
      if (a->Father<b->Father) return -1;
      if (res=compare_bag (a->Req,b->Req)) return res;
      if (a->Ack>b->Ack) return 1;
      if (a->Ack<b->Ack) return -1;
    }
    return 0;
}

/* lexicographically compares two values */
comp compare_value (value *a, value *b) {
  int res, i;
  for (i=0; i<N; i++)
    if (res=compare_site (a[i],b[i])) return res;
  return 0;
}

/* called by store when some value equal to v is already stored */
void free_value (value *v) {
  int i;
  for (i=0; i<N; i++)
    free_site(v[i]);
  free(v);
}



/* -- 3. for tina API --------------------------------------------------------------- */

/* -- 3.1 initializes storage and returns initial state */

key initial () {
  int i;
  value *w = new_value();
  for (i=0; i<N; i++) {
    w[i]=new_site(1,new_bag(),0);
  }
  init_storage(compare_value,free_value);
  return store (w);
}


/* -- 3.2 predicates and actions */

/* by default, pre_* returns true and act_* is the identity function */
/* BEWARE: sites are indexed in 1..N, but C arrays are indexed from 0 ... */

/*
Pre_request_x  Father[x] != x and is_bag_empty(Req[x]) act
Act_request_x  add_bag(Req[Father[x]],x); Father[x] :=x  act
*/
bool pre_request_x (int x, key s) {
  value *v = lookup(s);
  return v[x-1]->Father != x && is_bag_empty(v[x-1]->Req);
}
key act_request_x (int x, key s) {
  value *v = lookup(s);
  value *n = copy_value(v);
  int father = n[x-1]->Father;
  n[x-1]=copy_site(v[x-1]);
  if (father != x) n[father-1]=copy_site(v[father-1]);
  n[father-1]->Req=add_bag(n[father-1]->Req,x);
  n[x-1]->Father=x;
  return store (n);
}

/*
Pre_transit_x_y  pere[x] /= x and in_bag y Req[x] act
Act_transit_x_y  sub_bag(Req[x],y); add_bag(Req[pere[x]],y); pere[x]:=y  act
*/
bool pre_transit_x_y (int x, int y, key s) {
  value *v = lookup(s);
  return v[x-1]->Father != x && in_bag(y,v[x-1]->Req);
}
key act_transit_x_y (int x, int y, key s) {
  value *v = lookup(s);
  value *n = copy_value(v);
  int father = n[x-1]->Father;
  n[x-1]=copy_site(v[x-1]);
  if (father != x) n[father-1]=copy_site(v[father-1]);
  n[father-1]->Req=add_bag(n[father-1]->Req,y);
  n[x-1]->Req=sub_bag(n[x-1]->Req,y);
  n[x-1]->Father=y;
  return store (n);
}

/*
Pre_ok_x_y  pere[x] = x  and in_bag(y,(v->Req)[x] act
Act_ok_x_y  sub_bag(Req[x],y); Ack[y]:=1; pere[x]:=y act
*/
bool pre_ok_x_y (int x, int y, key s) {
  value *v = lookup(s);
  return v[x-1]->Father == x && in_bag(y,v[x-1]->Req);
}
key act_ok_x_y (int x, int y, key s) {
  value *v = lookup(s);
  value *n = copy_value(v);
  n[y-1]=copy_site(v[y-1]);
  if (y != x) n[x-1]=copy_site(v[x-1]);
  n[y-1]->Ack=1;
  n[x-1]->Father=y;
  n[x-1]->Req=sub_bag(n[x-1]->Req,y);
  return store (n);
}

/*
Pre_ack_x Ack > 0  act
Act_ack_x Ack := 0 act
*/
bool pre_ack_x (int x, key s) {
  value *v = lookup(s);
  return v[x-1]->Ack;
}
key act_ack_x (int x, key s) {
  value *v = lookup(s);
  value *n = copy_value(v);
  n[x-1]=copy_site(v[x-1]);
  n[x-1]->Ack=0;
  return store (n);
}

/*
Pre_lib_x true  act
Act_lib_x id  act
*/



/* -- 3.3 independance information for actions, for partial order and timed modes */

bool independant (int t1, int t2) {return 1;}



/* -- 3.4 state representation function for verbose output
   writes in buff (of size sz) a textual description of state s, returns its size.
   function returns -1 if buff is too short, so that tina can retry with a larger buff
*/

/* amount printed so far */
static int tot;

#define APPEND(sz,buffer,tmp) {if (tot += strlen(tmp) < sz) strcat(buffer,tmp); else return -1;}

/* appends to buff a string representing bag b */
int sprint_bag (int sz, char *buff, bag *b) {
  char xbuff[256];
  int i;
  int fst=1;
  APPEND(sz,buff,"{");
  for (i=0; i<N; i++) {
    if (b->B[i]) {
      if (!fst) {APPEND(sz,buff,",");} else fst=0;
      sprintf(xbuff,"%d",i+1);
      APPEND(sz,buff,xbuff);
      if (b->B[i]>1) {
	sprintf(xbuff,"*%d",b->B[i]);
	APPEND(sz,buff,xbuff);
      }
    }
  }
  APPEND(sz,buff,"}");
  return 0;
}

/* appends to buff a string representing site s */
int sprint_site (int sz, char *buff, site *s) {
  char vbuff[256];
  int i;
  sprintf(vbuff,"(%d,",s->Father);
  APPEND(sz,buff,vbuff);
  if (sprint_bag(sz,buff,s->Req)<0) return -1;
  sprintf(vbuff,",%d)",s->Ack);
  APPEND(sz,buff,vbuff);
  return 0;
}

/* appends to buff a string representing the value referred to by s */
int sprint_state (int sz, char *buff, key s) {
  char vbuff[256];
  int i;
  value *v = lookup(s);
  *buff=0;
  tot=0;
  for (i=0; i<N; i++) {
    sprintf(vbuff,"S%d=",i+1);
    APPEND(sz,buff,vbuff);
    if (sprint_site(sz,buff,v[i])<0) return -1;
    APPEND(sz,buff,",");
  }
  buff[strlen(buff)-1]=0;
  return strlen(buff);
}


/* -- 3.4 functions for kts output */

/* returns names of observables, and number of them in count */
/* P1 ... Pk B11 ... B1k ... Bk1 ... Bkk A1 ... A4 */
char **obs_names (int *count) {
  int i, j, k;
  char **obsnames = (char **)malloc(N*(N+2)*4);
  char tmpbuff[64];
  *count = N*(N+2);
  k=0;
  for (i=0; i<N; i++) {
    sprintf(tmpbuff,"P%d",i+1);
    obsnames[k] = (char *)malloc(strlen(tmpbuff)+1);
    strcpy(obsnames[k],tmpbuff);
    k++;
  }
  for (i=0; i<N; i++) {
    for (j=0; j<N; j++) {
      sprintf(tmpbuff,"B%d%d",i+1,j+1);
      obsnames[k] = (char *)malloc(strlen(tmpbuff)+1);
      strcpy(obsnames[k],tmpbuff);
      k++;
    }
  }
  for (i=0; i<N; i++) {
    sprintf(tmpbuff,"A%d",i+1);
    obsnames[k] = (char *)malloc(strlen(tmpbuff)+1);
    strcpy(obsnames[k],tmpbuff);
    k++;
  }
  return obsnames;
}

/* returns values of observables for state s 
   (abstractions for noninteger fields) */
int ovalues[N*(N+2)];
int *obs_values (key s) {
  value *v = lookup(s);
  int i, j;
  int k = 0;
  /* save fathers */
  for (i=0; i<N; i++) {ovalues[k++] = v[i]->Father;}
  /* save bags */
  for (i=0; i<N; i++) {
    for (j=0; j<N; j++) {
      ovalues[k++] = v[i]->Req->B[j];
    }
  }
  /* save A */
  for (i=0; i<N; i++) {ovalues[k++] = v[i]->Ack;}
  return ovalues;
}

