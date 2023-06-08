<?php

require_once "args.php";

require_once "1_files_gathering.php";
require_once "2_small_matrix_building.php";
require_once "3_huge_matrix_building.php";
require_once "4_binarize_matrix.php";
require_once "5_write_matrix.php";


// défini l'UTF-8 comme encodage par défaut
mb_internal_encoding('UTF-8');

// Get parameters and fundamentals args
$args = get_args($argv, $argc);

// Prepare values
$prefix_output = "out_";
$suffix_output = ".csv";

// Prepare filenames
echo("1 - Gathering files\n");
$input_array = $args;
$input_files_array = $input_array;

$intermediate_files_array = $input_files_array;

$output_file = $prefix_output . "matrix" . $suffix_output;

//Transform multiple CSVs of words into a full matrix
echo("2 & 3 - Transform word files into a matrix\n");
$final_matrix = csv_to_matrix($input_array, $intermediate_files_array);


//Binarize matrix "if" required
/*
** echo("4 - [OPTIONAL] Binarize matrix\n");
** $binarized_matrix = binarize_matrix($final_matrix, $input_array);
*/

// Write the final matrix in a CSV
echo("5 - Write matrix into a CSV\n");
//write_matrix($final_matrix, $output_file);
write_matrix_names($final_matrix, $output_file);

?>
