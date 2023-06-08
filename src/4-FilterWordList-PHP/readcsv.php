<?php

function read_matrix_from_csv($file, $Sep = ";")
{
    $output = array();
    $fd = fopen($file, "r");

    if ($fd)
    {
        $row = 0;
        while (($data = fgetcsv($fd, 1000, $Sep)) !== FALSE)
        {
            $line = array();
            $max_cols = count($data);
            for ($col = 0; $col < $max_cols; $col++)
            {
                $line[] = $data[$col];
            }
            $output[] = $line;
            $row++;
        }
        if (!feof($fd))
        {
            echo "Error: fgetcsv() failed\n";
        }
        fclose($fd);
    }
    return ($output);
}

?>
