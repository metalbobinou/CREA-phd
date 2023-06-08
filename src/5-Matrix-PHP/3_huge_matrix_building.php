<?php

require_once "2_small_matrix_building.php";


function cmp($a, $b)
{
  return strcasecmp($a, $b);
}

function sort_array($my_array)
{
  uksort($my_array, "cmp");
}

function sort_matrix($my_matrix)
{
  foreach ($my_matrix as $my_array)
  {
    uksort($my_array, "cmp");
  }
}

// Transform input CSV and filenames, into matrix with all words
//   (with babelnet/bn sense instead => to keep the semantic)
function csv_to_matrix($names_array, $files_array)
{
  // Transform CSV into matrix && Get all possible words
  $array_len = sizeof($names_array);
  $csv_arrays = array();
  $BN_array = array();
  $bn_word_array = array();
  for ($i = 0; $i < $array_len; $i++)
  {
    $in_name = basename($names_array[$i]);
    $in_file = $files_array[$i];

    echo("(Pre-)Processing Arrays: " . $in_name .
         " (" . $in_file . ")" . "\n\n");

    // Get the words from a CSV file (col 0 = word, col 5 = bn)
    $local_array = build_small_matrix_col($in_file, 5);
    $csv_arrays[$in_name] = $local_array;

    // Put all the existing words in $words_array
    foreach ($local_array as $new_BNid => $new_nb)
    {
      if (! in_array($new_BNid, $BN_array))
      {
        $BN_array[] = $new_BNid;
      }
    }

    // Get the equivalence babelsense to words
    $tmp_bn_array = get_babelsenses_words_array($in_file);
    foreach ($tmp_bn_array as $bn => $word)
    {
      //if (! in_array($bn, $bn_word_array))
      if (! array_key_exists($bn, $bn_word_array))
      {
        $bn_word_array[$bn] = $word;
      }
    }
  }

  echo("\n------------\n");

  // Create a new matrix with every words from every files
  $full_matrix = array();
  for ($i = 0; $i < $array_len; $i++)
  {
    $in_name = basename($names_array[$i]);
    $in_file = $files_array[$i];

    echo("(Post-)Processing Matrix: " . $in_name .
         " (" . $in_file . ")" . "\n\n");

    $tmp_array = array();
    foreach ($BN_array as $BNid)
    {
      if (! array_key_exists($BNid, $csv_arrays[$in_name]))
      {
        $tmp_array[$BNid] = 0;
      }
      else
      {
        $tmp_array[$BNid] = $csv_arrays[$in_name][$BNid];
      }
    }
    $full_matrix[$in_name] = $tmp_array;
  }

  echo("\n\n############\n\n");

  // Transform back every babelnet sense into a word
  $final_matrix = bn_to_words_matrix($full_matrix, $bn_word_array);

  return ($final_matrix);
}


// Transform back bn matrix into word matrix
function bn_to_words_matrix($matrix, $bn_word_array)
{
  $full_matrix = array();
  $mat_files = array_keys($matrix);
  $mat_size = sizeof($mat_files);
  for ($i = 0; $i < $mat_size; $i++)
  {
    $cur_file = $mat_files[$i];
    $tab_keys = array_keys($matrix[$cur_file]);
    $tab_size = sizeof($tab_keys);
    for ($j = 0; $j < $tab_size; $j++)
    {
      $cur_key = $tab_keys[$j];
      $word = $bn_word_array[$cur_key];
      $word = $word . " " . $cur_key;
      $full_matrix[$cur_file][$word] = $matrix[$cur_file][$cur_key];
    }
  }

  //echo("\nDEBUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUG\n\n");
  //print_r($matrix);
  //echo("\nwooooooooooooooooooooooooooooooooooooooooot\n");
  //print_r($full_matrix);

  return ($full_matrix);
}

?>
