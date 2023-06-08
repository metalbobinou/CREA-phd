<?php

function write_matrix_in_csv($array, $file)
{
  $fd = fopen($file, "w");

  //add BOM to fix UTF-8 in Excel
  //fputs($fd, $bom =( chr(0xEF) . chr(0xBB) . chr(0xBF) ));
  //OR
  //UTF-8 BOM (echo this on top of file if not generating csv file
  //only downloading it directly in the browser. )
  //echo "\xEF\xBB\xBF";

  //Make sure that you convert your UTF-8 text to UTF-16LE
  //mb_convert_encoding($csv, 'UTF-16LE', 'UTF-8');
  // Make sure that you add the UTF-16LE byte order mark
  //fputs($fd, $bom =(chr(255) . chr(254)));

  foreach ($array as $line)
  {
    fputcsv($fd, $line, ";", '"', "\n");
  }
  fclose($fd);
}

?>
