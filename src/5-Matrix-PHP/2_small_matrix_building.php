<?php

require_once "readinput.php";


// (internal) Extract the CSV and make it an array of array
function get_array_from_csv($input_file)
{
   $csv_array = array();
   $row = 0;
   $fd = fopen($input_file, "r");
   while (($data = fgetcsv($fd, 1000, ";")) !== FALSE)
   {
     /*
     if ($row == 0) // Skip the header/1st line
     {
       $row++;
       continue ;
     }
     */
     $nb_cols = count($data);
     //echo "<p> $nb_cols champs à la ligne $row: <br /></p>\n";
     $local_array = array();
     for ($col = 0; $col < $nb_cols; $col++)
     {
       //echo $data[$col] . "<br />\n";
       $local_array[] = $data[$col];
     }
     $csv_array[] = $local_array;
     $row++;
   }

   fclose($fd);
   return ($csv_array);
}


// Build the binary matrix from a CSV
function build_small_matrix($words_csv)
{
   if (! test_file($words_csv))
    return (null);

    /*
    ** $csv_array[] = array("$tokens", "$score", "$coherenceScore",
    **                      "$globalScore", "$position", "$synsetId");
    */

   $csv_array = get_array_from_csv($words_csv);
   $bin_matrix = array();
   foreach ($csv_array as $line)
   {
     $index = $line[0]; // Get first column : word
     //$index = $line[4]; // Get 4th column : babelnet ID
     if (array_key_exists($index, $bin_matrix))
     {
       $bin_matrix[$index]++;
     }
     else
     {
       $bin_matrix[$index] = 1;
     }
   }
   return ($bin_matrix);
}


// Build the binary matrix from a CSV using column $col_nb
function build_small_matrix_col($words_csv, $col_nb)
{
   if (! test_file($words_csv))
    return (null);

    /*
    ** $csv_array[] = array("$tokens", "$score", "$coherenceScore",
    **                      "$globalScore", "$position", "$synsetId");
    */

   $csv_array = get_array_from_csv($words_csv);
   $bin_matrix = array();
   foreach ($csv_array as $line)
   {
     $index = $line[$col_nb]; // Get column $col_nb
     if (array_key_exists($index, $bin_matrix))
     {
       $bin_matrix[$index]++;
     }
     else
     {
       $bin_matrix[$index] = 1;
     }
   }
   return ($bin_matrix);
}


// Get an array with every words within babelsenses
function get_babelsenses_words_array($words_csv)
{
   if (! test_file($words_csv))
    return (null);

    /*
    ** $csv_array[] = array("$tokens", "$score", "$coherenceScore",
    **                      "$globalScore", "$position", "$synsetId");
    */

   $csv_array = get_array_from_csv($words_csv);
   $bn_array = array();
   foreach ($csv_array as $line)
   {
     $index = $line[5]; // Get synsetId
     if (! array_key_exists($index, $bn_array))
     {
       $bn_array[$index] = $line[0];
     }
   }
   return ($bn_array);
}

?>
