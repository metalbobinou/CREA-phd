#include "ParseCSV.hh"

/* Initialize the structure for CSV parsing */
void init_csv_struct(struct csv_struct *csv_struct)
{
  csv_struct->fields = 0;
  csv_struct->rows = 0;
  //csv_struct->CSV = new std::vector<std::vector<std::string> >;
  csv_struct->CSV.resize(0);
  csv_struct->CSV.clear();
}

/* Clear the structure of everything */
void clear_csv_struct(struct csv_struct *csv_struct)
{
  csv_struct->CSV.erase(csv_struct->CSV.begin(), csv_struct->CSV.end());
  csv_struct->CSV.resize(0);
  //delete csv_struct->CSV;
  csv_struct->fields = 0;
  csv_struct->rows = 0;
}

/* Dedicated function for CSV parsing: column function to be called */
/*
** The function that will be called from csv_parse() after an entire field has been read.
** It will be called with a pointer to the parsed data (which is NOT nul-terminated
** unless the CSV_APPEND_NULL option is set), the number of bytes in the data, and the
** pointer that was passed to csv_parse().
*/
void csv_column(void *s, size_t len, void *data)
{
  struct csv_struct *csv_struct = (struct csv_struct *) data;
  std::string str = std::string((char *) s, len);
  unsigned int cur_field;
  unsigned int cur_row;

  cur_field = csv_struct->fields++;
  cur_row = csv_struct->rows;

  if (csv_struct->CSV.empty())
    csv_struct->CSV.resize(1);

  if (csv_struct->CSV.size() < (cur_row + 1u))
    csv_struct->CSV.resize(cur_row + 1);

  if (csv_struct->CSV[cur_row].size() < (cur_field + 1u))
    csv_struct->CSV[cur_row].resize(cur_field + 1);

  csv_struct->CSV[cur_row][cur_field] = str;
}

/* Dedicated function for CSV parsing: line function to be called */
/*
** The function that will be called when the end of a record is encountered, it will be
** called with the character that caused the record to end, cast to an unsigned char, or
** -1 if called from csv_fini, and the pointer that was passed to csv_init().
**
** !! By default this function is not called when rows that do not contain any fields are
** encountered. This behavior is meant to accomodate files using only either a linefeed
** or a carriage return as a record seperator to be parsed properly while at the same time
** being able to parse files with rows terminated by multiple characters from resulting
** in blank rows after each actual row of data (for example, processing a text CSV file
** created that was created on a Windows machine on a Unix machine).
** The CSV_REPALL_NL option will cause this function to be called once for every carriage
** return or linefeed encountered outside of a field. !!
*/

void csv_line(int c, void *data)
{
  struct csv_struct *csv_struct = (struct csv_struct *) data;
  unsigned int cur_row;

  cur_row = csv_struct->rows++;
  csv_struct->fields = 0; // New line, let's go back to column 0

  if (csv_struct->CSV[cur_row].empty())
    csv_struct->CSV.resize(1);

  if (csv_struct->CSV.size() < (cur_row + 1))
    csv_struct->CSV.resize(cur_row + 1);

  return ; // Reduce warnings
  c++;
}
