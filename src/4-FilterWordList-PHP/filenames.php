<?php

function add_prefix($filename, $prefix)
{
  $basename = basename($filename);
  $outname = $prefix . $basename;

  return($outname);
}

?>
