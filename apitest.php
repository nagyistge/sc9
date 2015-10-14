<?php
		// Guitar Connection and its servers
	$vend = "Strat1979";
	$apikey = "c55359fb57c006f";
	$ip = "199.48.238.168";


		// Guitar Connection Always has a User for Legato
	$guitarConnectionUserName = "HeavyShredder";
	$guitarConnectionUserPassword = "scott123456";

		// Make the Vendor User Name be the Same as GC

	$vendorUserName = $guitarConnectionUserName;
	$vendorUserPassword = "CommunicationsBreakdown43";

	$legatoID = $guitarConnectionUserName;
	$legatoPW = $vendorUserPassword;

	function ssha($password){
		mt_srand((double)microtime()*1000000);
		$salt = pack("CCCC", mt_rand(), mt_rand(), mt_rand(), mt_rand());
		$hash = base64_encode(pack("H*", sha1($password . $salt)) . $salt);
		$hash = str_replace('+', '@', $hash);
		$hash = str_replace('/', '.', $hash);
		return $hash;
	}

	$getPrintReadyListResponse = '{
	"printouts": [{
		"order_id": 12345,
		"music_id": 10000,
		"arrangement": "Arrangement Type",
		"artist": "Artist Name",
		"prints_remaining": 2,
		"title": "A Music Title"
	}, {
		"order_id": 12345,
		"music_id": 10002,
		"arrangement": "Another Arrangement",
		"artist": "Another Artist",
		"prints_remaining": 1,
		"title": "Another Music Title"
	}],
	"success": true
	}';

	$obj = json_decode($getPrintReadyListResponse);

	$s = $obj->success;

	foreach ( $obj->printouts as $o) {
		$hashed_vendorUserName = ssha($vendorUserName);
		$hashed_vendorUserPassword = ssha($vendorUserPassword);
		$viewer_url = "https://dmc.musicrain.com/v2/music/music_view/". $hashed_vendorUserName."/".$o->music_id."/".$legatoID."/".$hashed_vendorUserPassword;

		echo "\n".$o->order_id." ".$o->artist." - ".$o->music_id." ".$o->title;
		echo"\n         <a href='".$viewer_url."'>".$viewer_url."</a>"."\n";
	};

	?>