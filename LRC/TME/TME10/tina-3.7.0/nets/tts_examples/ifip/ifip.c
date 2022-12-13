
#include <stdlib.h>
#include <string.h>
#include <stdio.h>



/* -- 1. private declarations ----------------------------------------------- */

/* this section is application specific.
   typically, one would define a type of values and possibly some
   routines for manipulating values
*/

#include <math.h>
#include <string.h>

typedef int bool;  /* 0 or 1     */

typedef int comp;  /* -1, 0 or 1 */


/* a type of strings.
   It is assumed that string components can be shared between values.
   Field C is maintained as a reference count for the string structure.
*/

typedef struct {
  int C;
  char *S;
} string;

/* creates an string, uninitialized */
string *new_string () {
  string *new = (string *)malloc(sizeof(string));
  new->C = 1;
  return new;
}

/* decrements the reference count. Then, if count reaches 0,
   frees the structure and the char pointer encapsulated */
void free_string (string *s) {
  if (! --(s->C)) {
    free (s->S);
    free (s);
  }
}

/* identity function, incrementing ref count */
string *share_string (string *s) {
  s->C++;
  return s;
}

/* creates string as s concat x */
string *concat_string (string *s, char *x) {
  string *new = new_string ();
  char *tmp=malloc(strlen(s->S)+strlen(x)+1);
  strcpy(tmp,s->S);
  strcat(tmp,x);
  new->S=tmp;
  return new;
}

/* builds a string capturing x */
string *make_string (char *x) {
  string *new = new_string ();
  char *tmp=malloc(strlen(x)+1);
  strcpy(tmp,x);
  new->S=tmp;
  return new;
}


/* the type of data values */

typedef struct {
  int X;
  float Y;
  string *Z;
} value;

/* makes a new value, unitialized */
value *new_value () {
  return (value *)malloc(sizeof(value));
}

/* makes a value out of components x, y, z */
value *make_value (int x, double y, string *z) {
  value *w = new_value ();
  w->X=x;
  w->Y=y;
  w->Z=z;
  return w;
}




/* -- 2. functions for the storage API -------------------------------------- */

/* This section depends on the storage library choosen for values
   All such libraries should provide
       type key  (an alias for int)
     and functions
       store : value -> key
       lookup : key -> value
   Some libraries may require auxiliary functions from the user.

   The avl library used here requires:

       compare_value : value * value -> comp  (a total order on values)
           The avl storage library store values into ... avl's; compare_value is
	   any total order comparison function for values;

       free_value : value -> void
           free_value is called by the storage library when attempting to store
	   a value equal to some other already stored. Allocation and collection
	   of storage for values is entirely the user's responsability.

   The avl library also requires to call function init_storage before any other
   avl libray call, by:

       init_storage(compare_value,free_value);
*/

/* the avl interface: */
#include "avl.h"

/* comparison function for values */
comp compare_value (value *v1, value *v2) {
  if (v1->X > v2->X) return 1;
  if (v1->X < v2->X) return -1;
  if (v1->Y > v2->Y) return 1;
  if (v1->Y < v2->Y) return -1;
  return strcmp(v1->Z->S,v2->Z->S);
}

/* frees the string encapsulated (see above), and then the value frame */
void free_value (value *v) {
  free_string (v->Z);
  free(v);
}



/* -- 3. functions for the tina API ----------------------------------------- */

/* required by the tina tts API:

   initial : void -> key
             returns the access key of the initial value
   transitions  : int ref -> string array
             returns an array of the names referred to in the file,
	     and its size in the argument pointer.
	     Throughout the file, transitions will be referred to by their
	     index in the array returned.
   independant : int * int -> bool
             The independance predicate for transitions.
	     Independant should be typically taken here as "non-interfering",
	     the actual interpretation is up to the user;
   sprint_state : int ref * string ref * key -> int
             That function prints in its second argument a representation of
	     the value referred to by "key". The first argument holds the
	     size of the second argument.
	     It returns -1 (see below), or the amount of characters written.
   obs_names : int ref -> string array
             similar to transitions above, except it returns an array of
	     "observables" names, and its size.
   obs_values : key -> int array
             given a key, return the values of observables in the value
	     referred to by "key"

   optional:

   ttsapiversion : void -> int
   pre_i : key -> bool (optional)
	     the pre-condition associated with the i^th transition
	     in the array returned by transitions.
	     returns 1 if that transition is firable when the value
	     is that referred to by key.
	     May be omitted if the pre-condition is always true.
   act_i : key -> key, optional
             the action on value associated with the i^th transition
	     in the array returned by transitions.
	     that action should NOT have side effects on the argument
	     value, but return a new value instead.
	     May be omitted if tye action is always the identity function.

   NOTES
   As can be seen, two representations can be given to states:
   - one as the string returned by sprint_state, 
   - the other as the record of integers the labels of which are passed by
   obs_names, and the values of which are passed by obs_values.

   The first form is used for printing states in the "verbose" output mode
   of tina. The second form is used for transition system output or verbose
   output with option -ls. The observable names are then the state properties
   saved in e.g. .ktz or .mec files.

   All three functions: sprint_state, obs_names and obs_values, are required by
   the tina API, but the first could return the empty string if no state 
   representation is desired, and the second and third the empty array, if
   not needed.
*/


int ttsapiversion () {return 0;}


/* -- 3.1 initializes library and returns initial value (1, 10.0, "a") */

key initial () {
  /* initialize avl storage (required by avl API) */
  init_storage(compare_value,free_value,sizeof(value));
  /* create and store initial value */
  return store (make_value (0, 10.0, make_string ("a")));
}


/* -- 3.2 transitions table: */

/* transitions returns array of names of the transitions referred to in the file */
char *transtable[4] = {"t1","t4","t2","t5"};
char **transitions (int *sz) {*sz = 4; return transtable;}


/* -- 3.3 predicates and actions: */

/* by default, pre_* is always true and act_* is the identity function */

/* X,Y,Z -> X,10.0,Z */
key act_0 (key s) {
  value *old = lookup(s);
  return store (make_value (old->X, 10.0, share_string(old->Z)));
}

/* X <= 3 */
bool pre_1 (key s) {
  value *v = lookup(s);
  return (v->X>3)?0:1;
}

/* X,Y,Z -> X+1,Y,Z^".a" */
key act_1 (key s) {
  value *old = lookup(s);
  return store (make_value (old->X+1, old->Y, concat_string (old->Z,".a")));
}

/* X,Y,Z -> Z,Y/2,Z */
key act_2 (key s) {
  value *old = lookup(s);
  return store (make_value (old->X, old->Y/2, share_string(old->Z)));
}

/* X,Y,Z -> 0,Y,"a" */
key act_3 (key s) {
  value *old = lookup(s);
  return store (make_value (0, old->Y, make_string ("a")));
}


/* -- 3.4 independance relation for actions, for partial order and resets in timed modes */
/* indices refer to transtable; specifies independance for ALL transitions */

bool independant (int t1, int t2) {
  /* all pairs independant except t1 and t4 (for instance, no particular reason here) */
  if (t1 == 0) return t2 != 1;
  if (t2 == 1) return t1 != 0;
  return 1;
}


/* -- 3.5 state representation function for verbose output
   writes in buff (of size sz) a textual description of state s, returns its size.
   should return -1 if buff is too short, so that caller can retry with a larger buff
*/
int sprint_state (int sz, char *buff, key s) {
  char tmp[128];
  value *v = lookup(s);
  /* tmp is large enough to hold an integer and a float, so: */
  sprintf(tmp,"X=%d,Y=%f",v->X,v->Y);
  /* now fill buff, checking that buff is large enough to hold tmp and string: */
  if (sz >= strlen(tmp) + strlen(v->Z->S) + 2) {
    sprintf(buff,"%s,Z=\"%s\"",tmp,v->Z->S);
    return strlen(buff);
  } else {
    return -1;
  }
}


/* -- 3.6 state representation functions for transition system output */

/* obs_names returns an array of names of observables, and their number in count */
char *obsnames[3] = {"X","Y","Z"};
char **obs_names (int *count) {*count = 3; return obsnames;}

/* obs_values returns the array of values of observables for state s,
   these must be integers, noninteger value components must be abstracted
*/
int ovalues[3];
int *obs_values (key s) {
  value *v = lookup(s);
  ovalues[0] = v->X;
  ovalues[1] = rint(v->Y);
  ovalues[2] = strlen(v->Z->S);
  return ovalues;
}
