/* this file should be compiled as a shared library, statically linked
   with the libbcg.a of CADP */


#include "bcg_user.h"

/* reading bcg */

BCG_TYPE_OBJECT_TRANSITION bcg_graph;

int TINA_READ_BCG_OPEN (char* file)
{
  BCG_INIT ();
  BCG_OT_READ_BCG_SURVIVE (BCG_TRUE);
  BCG_OT_READ_BCG_BEGIN (file, &bcg_graph, 1);
  
  if (NULL==bcg_graph) {return 1;} else {return 0;}
}

BCG_TYPE_NATURAL TINA_READ_NB_STATES ()
{
  return BCG_OT_NB_STATES (bcg_graph);
}

BCG_TYPE_NATURAL TINA_READ_NB_EDGES ()
{
  return BCG_OT_NB_EDGES (bcg_graph);
}

BCG_TYPE_NATURAL TINA_READ_NB_LABELS ()
{
  return BCG_OT_NB_LABELS (bcg_graph);
}

char *TINA_READ_TR_NAME (bcg_label_number)
     BCG_TYPE_LABEL_NUMBER bcg_label_number;
{
  return BCG_OT_LABEL_STRING (bcg_graph, bcg_label_number);
}

BCG_TYPE_NATURAL TINA_READ_STATE_NB_SUCCS (bcg_s1)
     bcg_type_state_number bcg_s1;
{
  BCG_TYPE_LABEL_NUMBER bcg_label_number;
  bcg_type_state_number bcg_s2;
  int count=0;

  BCG_OT_ITERATE_P_LN (bcg_graph, bcg_s1, bcg_label_number, bcg_s2) {
    count++;
  }
  BCG_OT_END_ITERATE;
  return count;
}

int TINA_READ_STATE_SUCCS (count,bcg_s1,sbuffer,tbuffer)
     int count;
     bcg_type_state_number sbuffer[];
     BCG_TYPE_LABEL_NUMBER tbuffer[];
     bcg_type_state_number bcg_s1;
{
  BCG_TYPE_LABEL_NUMBER bcg_label_number;
  bcg_type_state_number bcg_s2;
  int i=0;

  BCG_OT_ITERATE_P_LN (bcg_graph, bcg_s1, bcg_label_number, bcg_s2) {
    sbuffer[i]=bcg_s2;
    tbuffer[i]=bcg_label_number;
    i++;
  }
  BCG_OT_END_ITERATE;
  return 0;
}
    
int TINA_READ_BCG_CLOSE ()
{
  BCG_OT_READ_BCG_END (&bcg_graph);
  return 0;
}



/* writing bcg */

int TINA_WRITE_BCG_OPEN (char* file, int initial, int format, char* creator, int monitor)
{
  int res;
  BCG_INIT ();
  BCG_IO_WRITE_BCG_SURVIVE (BCG_TRUE);  /* don't exit if file can't be opened */
  BCG_IO_WRITE_BCG_PARSING (0);         /* don't parse labels */
  res = BCG_IO_WRITE_BCG_BEGIN (file, initial, format, creator, monitor);
  return res;
}

int TINA_WRITE_BCG_EDGE (int from, char* label, int to)
{
  BCG_IO_WRITE_BCG_EDGE (from, label, to);
  return 0;
}

int TINA_WRITE_BCG_CLOSE (int dummy)
{
  BCG_IO_WRITE_BCG_END ();
  return 0;
}

