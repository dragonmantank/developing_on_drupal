<?php
// This file is called with theme('db_sample_page', array('data' => $result'); from db_sample_main(). The second
// parameter sets up the variables that are available in the template, so 'data' gets transformed into $data, which
// is set to whatever $result is. We will use $data instead of $result thanks to this scope.

// You can copy this file to your theme that you are using and customize it, which will allow you to modify this page
// without having to overwrite the distributed code of the module. This is useful if you distribute a module but want
// to let people modify the output.
?>
<h1><?php echo variable_get('db_sample_title', 'Sample Form'); ?></h1>
<ol>
    <?php foreach($data as $row): ?>
        <li><?php echo $row->firstName; ?></li>
    <?php endforeach; ?>
</ol>





