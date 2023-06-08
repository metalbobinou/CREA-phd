<?php

require_once "const_define.php";


function get_input_filenames($min_data, $max_data)
{
  //$min_data = 1;
  //$max_data = 11;

  $input_data = array();
  if ($min_data <= $max_data)
  {
    $input_data = array();
    for ($i = $min_data; $i <= $max_data; $i++)
    {
      $input_data[] = "cours" . $i;
    }
  }
  return ($input_data);
}

function add_prefix($input_files_array, $prefix)
{
  $out = array();
  $len = sizeof($input_files_array);
  for ($i = 0; $i < $len; $i++)
  {
    $out[] = $prefix . $input_files_array[$i];
  }
  return ($out);
}

function add_suffix($input_files_array, $suffix)
{
  $out = array();
  $len = sizeof($input_files_array);
  for ($i = 0; $i < $len; $i++)
  {
    $out[] = $input_files_array[$i] . $suffix;
  }
  return ($out);
}

?>