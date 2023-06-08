<?php

require_once "writecsv.php";


function write_matrix($matrix, $file)
{
  echo("\nWrite matrix into: " . $file . "\n");
  write_matrix_in_csv($matrix, $file);
  echo("\n---------\n");
}

function write_matrix_names($matrix, $file)
{
  echo("\nGet matrix words and names\n");

  $full_matrix = array();
  $mat_keys = array_keys($matrix);
  $word_list = array_keys($matrix[$mat_keys[0]]);
  $mat_size = sizeof($mat_keys);
  $word_size = sizeof($word_list);
  $full_matrix[0][0] = "X";
  for ($i = 0; $i < $mat_size; $i++)
  {
     $full_matrix[$i + 1][0] = $mat_keys[$i];
  }
  for ($i = 0; $i < $word_size; $i++)
  {
     $full_matrix[0][$i + 1] = $word_list[$i];
  }

  for ($i = 0; $i < $mat_size; $i++)
  {
    for ($j = 0; $j < $word_size; $j++)
    {
      $full_matrix[$i + 1][$j + 1] = $matrix[$mat_keys[$i]][$word_list[$j]];
    }
  }

  //print_r($full_matrix);

  write_matrix($full_matrix, $file);
}

?>
