package nme.installer;


import nme.display.BitmapData;
import nme.media.Sound;
import nme.net.URLRequest;
import nme.text.Font;
import nme.utils.ByteArray;
import ApplicationMain;


/**
 * ...
 * @author Joshua Granick
 */

class Assets {

	
	public static function getBitmapData (id:String):BitmapData {
		
		switch (id) {
			
			
		}
		
		return null;
		
	}
	
	
	public static function getBytes (id:String):ByteArray {
		
		switch (id) {
			
			case "assets/pf_ronda_seven.ttf": return cast (new NME_assets_pf_ronda_seven_ttf (), ByteArray);
			
		}
		
		return null;
		
	}
	
	
	public static function getFont (id:String):Font {
		
		switch (id) {
			
			case "assets/pf_ronda_seven.ttf": return cast (new NME_assets_pf_ronda_seven_ttf (), Font); 
			
		}
		
		return null;
		
	}
	
	
	public static function getSound (id:String):Sound {
		
		switch (id) {
			
			
		}
		
		return null;
		
	}
	
	
	public static function getText (id:String):String {
		
		var bytes:ByteArray = getBytes (id);
		
		if (bytes == null) {
			
			return null;
			
		} else {
			
			return bytes.readUTFBytes (bytes.length);
			
		}
		
	}
	
	
}