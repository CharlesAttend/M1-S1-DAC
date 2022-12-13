
#ifndef NULL
#define NULL 0
#endif


/* storage API */

/* values as seen by applications : */
typedef void * key;


/* provided by the storage library: */

/* called by applications before any lookup or store */
/* passes here size of value and paddingsafe flag */
extern int init_storage();

/*
 lookup : key -> value
   given a key, retreives the data value stored under that key.
   key is assumed defined.
   For avl's, assuming values are structures, lookup just returns
   the key cast to a value pointer:
*/
extern void *lookup_state();
#define lookup(x) (lookup_state(x))

/*
 store : value -> key
   stores a value in the database, returning an access key.
   if data is new, returns a new key, otherwise frees the
   data and returns the key of the equal data stored in the database.
*/
extern key store_state();
#define store(x) (store_state(x))


/* provided by application: */

extern int compare_value();
extern void free_value();


#ifdef DATABASE
#define COMPRESSION
#endif
