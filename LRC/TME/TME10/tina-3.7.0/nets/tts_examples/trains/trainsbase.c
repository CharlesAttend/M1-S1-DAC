
#include <stdio.h>
#include <string.h>


/* -- 1. local declarations */

typedef int bool;

typedef int value;

int ttsapiversion () {return 0;}


/* -- 2. storage API */
/* value is a single integer, no storage required */


/* -- 3. functions for tina API */

/* -- initializes storage and returns initial state */
value initial () {return 0;}


/* -- independance predicate for actions, for partial order and timed modes */
bool independant (int t1, int t2) {return 1;}


/* -- state representation function for verbose output
   no size check needed here (sz is at least 256)
*/
int sprint_state (int sz, char *buff, value s) {
  sprintf(buff,"count=%d",s);
  return strlen(buff);
}

/* -- state representation function for kts output */
/* names of observables, and number of them in count */
char *obsnames[1] = {"count"};
char **obs_names (int *count) {*count = 1; return obsnames;}

/* values of observables for state s */
int ovalues[1];
int *obs_values (value s) {ovalues[0] = s; return ovalues;}



/* -- predicates and actions */

bool pre_0 /* D1 */ (value s) {return s > 0;}
bool pre_1 /* D2 */ (value s) {return s > 0;}

bool pre_2 /* U */ (value s) {return s <= 0;}

