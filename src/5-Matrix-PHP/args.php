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
//  echo("php " . $argv[0] . " [--bn]\n");
  echo("php " . $argv[0] . " file1 file2 ...\n");
  echo("php " . $argv[0] . " [-h|--help]\n\n");
//  echo("*nothing* : just read the intermediate files to generate matrix\n");
//  echo("--bn : activate the research online with babelfy " .
//         "[REQUIRED AT FIRST USAGE] <-\n");
  echo("file1 file2 ... : reunite N files within a global matrix\n");
  echo("-h OR --help : print this help\n");
}

?>
