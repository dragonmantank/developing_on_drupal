<?php
if(extension_loaded('xhprof')) {
	$profiler_namespace = 'myapp';
	$xhprof_data = xhprof_disable();
	$xhprof_runs = new XHProfRuns_Default();
	$run_id = $xhprof_runs->save_run($xhprof_data, $profiler_namespace);
}