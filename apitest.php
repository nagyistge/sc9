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

		// Particulars about an order

	$musicID  = "!@!#";

		/// Create New User

	$createnewuserURL = "http://music.legatomedia.com/v2/".$vend."/createNewUser/".$legatoPW."/?username=".$legatoID."&api_key=".$apikey;

		//$json = file_get_contents($$createnewuserURL); // call remote service

	$json = '{"success": true, "user": 1046518}'; // make believe response
	$obj = json_decode($json);
		//var_dump($obj); // dump what we got

	$s = $obj->success;
	$u = $obj->user;
	echo "\nCreate New User URL success: ".$s." user: ".$u;

		/// Check Location URL

	$checklocationURL = "http://music.legatomedia.com/v2/".$vend."/checkLocation/".$musicID."/".$ip."/?username=".$vendorUserName."&api_key=".$apikey;

		//$json = file_get_contents($checklocationURL); // call remote service

	$json = '{"user_changed": 1027924, "success": true}'; // make believe response
	$obj = json_decode($json);
	$s = $obj->success;
	$uc = $obj->user_changed;
	echo "\nCheck Location URL success: ".$s." changed: ".$uc;


		/// authorizeprint URL- no OrderID variant

	$authorizeprintURL = "http://music.legatomedia.com/v2/".$vend."/authorizePrint/".$legatoID."/".$musicID."/1/".$ip."/?username=".$vendorUserName."&api_key=".$apikey;

		//$json = file_get_contents($authorizeprint); // call remote service

	$json = '{"order_record": 1000000, "success": true, "printout_id": 1000000}'; // make believe response
	$obj = json_decode($json);
	$s = $obj->success;
	$or = $obj->order_record;
	$prid = $obj->printout_id;
	echo "\nAuthorize Print URL success: ".$s." order rec:".$or." printout id:".$prid ;
	
	?>