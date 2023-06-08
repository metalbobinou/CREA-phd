<?php

require_once "args.php";
require_once "filenames.php";
require_once "readcsv.php";
require_once "writecsv.php";
require_once "filtermatrix.php";


// Prefix for files containing included or excluded words
$included_prefix = "included_";
$excluded_prefix = "excluded_";


// défini l'UTF-8 comme encodage par défaut
mb_internal_encoding('UTF-8');

// Get parameters and fundamentals args
$args = get_args($argv, $argc);

// Prepare filenames
echo("1 - Gathering files\n");
$input_array = $args;
$input_files_array = $input_array;

//Transform multiple CSVs of words into a full matrix
echo("2 - Filter CSV based on their criteria\n");
foreach($input_files_array as $file)
{
  $included_filename = add_prefix($file, $included_prefix);
  $excluded_filename = add_prefix($file, $excluded_prefix);

  $csv_array = read_matrix_from_csv($file);
  $out_double_matrix = filter_matrix($csv_array);
  $included_matrix = $out_double_matrix[0];
  $excluded_matrix = $out_double_matrix[1];

  write_matrix_in_csv($included_matrix, $included_filename);
  write_matrix_in_csv($excluded_matrix, $excluded_filename);
}

?>
