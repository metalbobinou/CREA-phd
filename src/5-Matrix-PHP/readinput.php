<?php

function test_file($file)
{
  if (! file_exists($file))
  {
    echo("File " . $file . " does not exist\n");
    return (false);
  }
  return (true);
}

function readinput($filename)
{
  $inputtext = "";

  $handler = fopen($filename, "r");
  if ($handler)
  {
    while (($buffer = fgets($handler, 4096)) !== false)
    {
      //echo $buffer;
      $inputtext = $inputtext . $buffer;
    }
    if (!feof($handler))
    {
      echo "Error: fgets() failed\n";
    }
    fclose($handler);
  }

  return ($inputtext);
}


function ArrayToString($Array, $Sep = " ")
{
  $String = "";

  $numItems = count($Array);
  $i = 0;
  foreach($Array as $Cell)
  {
    if(++$i === $numItems)
    {
      $String = $String . $Cell;
    }
    else
    {
      $String = $String . $Cell . $Sep;
    }
  }
  return ($String);
}

?>
