<?php

require_once "const_define.php";

function test_rules($line)
{
    /*
    ** "$tokens", "$score", "$coherenceScore", "$globalScore", "$position", "$synsetId"
    */

    // Coherence Score > lower limit
    if ($line[2] > __LOWEST_ACCEPTABLE_SCORE__)
    {
        return (true);
    }
    return (false);
}

function filter_matrix($matrix)
{
    $out_matrix = array();
    $included_matrix = array();
    $excluded_matrix = array();

    foreach ($matrix as $line)
    {
        if (test_rules($line))
        {
            $included_matrix[] = $line;
        }
        else
        {
            $excluded_matrix[] = $line;
        }
    }

    $out_matrix[0] = $included_matrix;
    $out_matrix[1] = $excluded_matrix;
    return ($out_matrix);
}

?>
