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

?>
