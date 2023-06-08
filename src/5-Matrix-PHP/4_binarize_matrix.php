<?php

function binarize_matrix($matrix, $names_array)
{
  $array_len = sizeof($names_array);
  $out_matrix = array();
  for ($i = 0; $i < $array_len; $i++)
  {
    $in_name = $names_array[$i];
    $out_tab = array();
    foreach ($matrix[$in_name] as $key => $value)
    {
      if ($value == 0)
      {
        $out_tab[$key] = 0;
      }
      else
      {
        $out_tab[$key] = 1;
      }
    }
    $out_matrix[$in_name] = $out_tab;
  }
  return ($out_matrix);
}

?>
