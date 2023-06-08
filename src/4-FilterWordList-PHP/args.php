<?php

function get_args($argv, $argc)
{
  $args = array();

  for ($i = 1; $i < $argc; $i++)
  {
    if (($argv[$i] == "-h") || ($argv[$i] == "--help"))
    {
      PrintUsage($argv);
      exit(0);
    }
    else
    {
      $args[] = $argv[$i];
    }
  }

  return ($args);
}

function min_args($args, $argv, $argc)
{
  test_help($args, $argv, $argc);
}

function test_help($args, $argv, $argc)
{
  if ((array_key_exists("help", $args)) ||
    (array_key_exists("h", $args)))
  {
    PrintUsage($argv);
    exit(0);
  }
}

function PrintUsage($argv)
{
  echo("Usage:\n");
  echo("php " . $argv[0] . " file1 file2 ...\n");
  echo("php " . $argv[0] . " [-h|--help]\n\n");
  echo("file1 file2 ... : read files and filter them\n");
  echo("-h OR --help : print this help\n");
}

?>
