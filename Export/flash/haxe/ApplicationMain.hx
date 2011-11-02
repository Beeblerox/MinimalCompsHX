import Minimalcompshx;
import nme.Assets;


class ApplicationMain {
	
	static var mPreloader:NMEPreloader;

	public static function main () {
		
		var call_real = true;
		
		
		var loaded:Int = nme.Lib.current.loaderInfo.bytesLoaded;
		var total:Int = nme.Lib.current.loaderInfo.bytesTotal;
		
		if (loaded < total || true) /* Always wait for event */ {
			
			call_real = false;
			mPreloader = new NMEPreloader();
			nme.Lib.current.addChild(mPreloader);
			mPreloader.onInit();
			mPreloader.onUpdate(loaded,total);
			nme.Lib.current.addEventListener (nme.events.Event.ENTER_FRAME, onEnter);
			
		}
		
		
		if (call_real)
			Minimalcompshx.main();
	}

	static function onEnter (_) {
		
		var loaded:Int = nme.Lib.current.loaderInfo.bytesLoaded;
		var total:Int = nme.Lib.current.loaderInfo.bytesTotal;
		mPreloader.onUpdate(loaded,total);
		
		if (loaded >= total) {
			
			mPreloader.onLoaded();
			nme.Lib.current.removeEventListener(nme.events.Event.ENTER_FRAME, onEnter);
			nme.Lib.current.removeChild(mPreloader);
			mPreloader = null;
			
			Minimalcompshx.main ();
			
		}
		
	}

	public static function getAsset (inName:String):Dynamic {
		
		
		if (inName=="assets/pf_ronda_seven.ttf")
			 
			 return Assets.getFont ("assets/pf_ronda_seven.ttf");
         
		
		
		return null;
		
	}
	
}



	
		class NME_assets_pf_ronda_seven_ttf extends nme.text.Font { }
	
