#ifndef PARSECSV_HH_
# define PARSECSV_HH_

#include <string>
#include <vector>

#include "libcsv.h"


struct csv_struct
{
  unsigned int fields;
  unsigned int rows;
  std::vector<std::vector<std::string> > CSV;
};


/* Initialize the structure for CSV parsing */
void init_csv_struct(struct csv_struct *my_struct);

/* Clear the structure of everything */
void clear_csv_struct(struct csv_struct *csv_struct);

/* Dedicated function for CSV parsing: column function to be called */
void csv_column(void *s, size_t len, void *data);

/* Dedicated function for CSV parsing: line function to be called */
void csv_line(int c, void *data);

#endif /* !PARSECSV_HH_ */
