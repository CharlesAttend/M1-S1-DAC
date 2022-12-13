
/* sites indexed in 1..N */

#include <math.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

typedef int bool;  /* 0, 1 */
typedef int comp;  /* -1, 0, 1 */


int ttsapiversion () {return 0;}


/* -- 1. type value and utilities --------------------------------------------------- */

/* -- bags holding integers in 1..N */

int empty (int *q) {
  int i=0;
  for (i=0; i<N; i++) {if (q[i]) return 0;}
  return 1;
}
#define mem(e,q) (q[e-1]>0)
#define add(q,e) {q[e-1]++;}
#define sub(q,e) {q[e-1]--;}


/* -- 2. local declarations */

/* state value type */
typedef struct {
  int Pere[N];
  int Req[N][N];  /* N bags of capacity N */
  int Ack;
} value;



/* -- 2. for storage API ------------------------------------------------------------ */

#include "avl.h"

/* lexicographically compares two values */
comp compare_value (value *a, value *b) {
  return memcmp(a,b,sizeof(value));
}

/* called by store when some value equal to v is already stored */
void free_value (value *v) {
  free(v);
}



/* -- 3. for tina API --------------------------------------------------------------- */

/* -- 3.1 initializes library and returns initial state */

key initial () {
  int i, j;
  value *initval = (value *)malloc(sizeof(value));
  for (i=0; i<N; i++) {initval->Pere[i]=1;}
  initval->Ack=0;
  set_database(".");
  init_storage(NULL,NULL,sizeof(value));
  return store (initval);
}


/* -- 3.2 predicates and actions */

/* by default, pre_t* returns true and act_t* is the identity function */

/* copie x dans y */
value *copyvalue (value *x) {
  value *y=(value *)malloc(sizeof(value));
  // bcopy (x,y,sizeof(value));
  memcpy (y,x,sizeof(value));
  return y;
}

/*
Pre_request_x  Pere[x] != x and empty(Req[x]) act
Act_request_x  add(Req[Pere[x]],x); Pere[x] :=x  act
*/
bool pre_request_x (int x, key s) {
  value *v = lookup(s);
  return v->Pere[x-1] != x && empty(v->Req[x-1]);
}
key act_request_x (int x, key s) {
  value *v = lookup(s);
  value *n = copyvalue(v);
  add(n->Req[n->Pere[x-1]-1],x);
  n->Pere[x-1]=x;
  return store (n);
}

/*
Pre_transit_x_y  pere[x] /= x and mem y Req[x] act
Act_transit_x_y  sub(Req[x],y); add(Req[pere[x]],y); pere[x]:=y  act
*/
bool pre_transit_x_y (int x, int y, key s) {
  value *v = lookup(s);
  return v->Pere[x-1] != x && mem(y,v->Req[x-1]);
}
key act_transit_x_y (int x, int y, key s) {
  value *v = lookup(s);
  value *n = copyvalue(v);
  add(n->Req[n->Pere[x-1]-1],y);
  sub(n->Req[x-1],y);
  n->Pere[x-1]=y;
  return store (n);
}

/*
Pre_ok_x_y  pere[x] = x  and mem(y,(v->Req)[x] act
Act_ok_x_y  sub(Req[x],y); Ack:=y; pere[x]:=y act
*/
bool pre_ok_x_y (int x, int y, key s) {
  value *v = lookup(s);
  return v->Pere[x-1] == x && mem(y,v->Req[x-1]);
}
key act_ok_x_y (int x, int y, key s) {
  value *v = lookup(s);
  value *n = copyvalue(v);
  n->Ack=y;
  n->Pere[x-1]=y;
  sub(n->Req[x-1],y);
  return store (n);
}

/*
Pre_ack_x Ack == x  act
Act_ack_x Ack := 0 act
*/
bool pre_ack_x (int x, key s) {
  value *v = lookup(s);
  return v->Ack == x;
}
key act_ack_x (int x, key s) {
  value *v = lookup(s);
  value *n = copyvalue(v);
  n->Ack=0;
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
   function should return -1 if buff is too short, so that the application can retry
   with a larger buff [*** warning: buff size check is not performed below ***]
*/

/* retourne dans buff une impression du tableau d'entiers a */
char *sprintarray (int n, char *buff, int *a) {
  char xbuff[16];
  int i=0;  
  sprintf(xbuff,"[%d",*a++);
  strcpy (buff,xbuff);
  for (i=1; i<N; i++) {
    sprintf(xbuff,",%d",*a++);
    strcat (buff,xbuff);
  }
  strcat(buff,"]");
  return buff;
}

/* retourne dans buff une impression du bag d'entiers a */
char *sprintbag (int n, char *buff, int *a) {
  char xbuff[16];
  int i=0;
  int fst=1;
  strcpy(buff,"{");
  for (i=0; i<N; i++) {
    if (*a) {
      if (!fst) strcat (buff,","); else fst=0;
      sprintf(xbuff,"%d",i+1);
      strcat (buff,xbuff);
      if (*a>1) {
	sprintf(xbuff,"*%d",*a);
	strcat (buff,xbuff);
      }
    }
    a++;
  }
  strcat(buff,"}");
  return buff;
}

int sprint_state (int sz, char *buff, key s) {
  char vbuff[256];
  int i;
  value *v = lookup(s);
  strcpy(buff,"Pere=");
  strcat(buff,sprintarray(N,vbuff,v->Pere));
  strcat(buff,", Req=[");
  for (i=0; i<N; i++) {
    // strcat(buff,sprintarray(N,vbuff,v->Req[i]));
    strcat(buff,sprintbag(N,vbuff,v->Req[i]));
    strcat(buff,",");
  }
  buff[strlen(buff)-1]=0;
  strcat(buff,"], Ack=");
  sprintf(vbuff,"%d",v->Ack);
  strcat(buff,vbuff);
  return strlen(buff);
}


/* -- 3.5 functions for kts output */

/* returns names of observables, and number of them in count */
/* P1 ... Pk B11 ... B1k ... Bk1 ... Bkk A */
char **obs_names (int *count) {
  int i, j, k;
  char **obsnames = (char **)malloc((N*(N+1)+1)*4);
  char tmpbuff[32];
  *count = N*(N+1)+1;
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
  obsnames[k] = (char *)malloc(2);
  strcpy(obsnames[k],"A");
  return obsnames;
}


/* returns values of observables for state s 
   (abstractions for noninteger fields) */
int ovalues[N*(N+1)];
int *obs_values (key s) {
  value *v = lookup(s);
  int i, j;
  int k = 0;
  /* save fathers */
  for (i=0; i<N; i++) {ovalues[k++] = (v->Pere)[i];}
  /* save bag */
  for (i=0; i<N; i++) {
    for (j=0; j<N; j++) {
      ovalues[k++] = (v->Req)[i][j];
    }
  }
  /* save A */
  ovalues[k] = (v->Ack);
  return ovalues;
}



