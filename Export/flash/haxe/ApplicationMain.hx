
  
     class NME_assets_pf_ronda_seven_ttf extends flash.utils.ByteArray { }
  





class ApplicationMain
{
   static var mPreloader:NMEPreloader;

   public static function main()
   {
      var call_real = true;
      
         var loaded:Int = flash.Lib.current.loaderInfo.bytesLoaded;
         var total:Int = flash.Lib.current.loaderInfo.bytesTotal;
         if (loaded<total || true) /* Always wait for event */
         {
            call_real = false;
            mPreloader = new NMEPreloader();
            flash.Lib.current.addChild(mPreloader);
            mPreloader.onInit();
            mPreloader.onUpdate(loaded,total);
            flash.Lib.current.addEventListener(flash.events.Event.ENTER_FRAME, onEnter);
         }
      

      if (call_real)
         Minimalcompshx.main();
   }

   static function onEnter(_)
   {
      var loaded:Int = flash.Lib.current.loaderInfo.bytesLoaded;
      var total:Int = flash.Lib.current.loaderInfo.bytesTotal;
      mPreloader.onUpdate(loaded,total);
      if (loaded>=total)
      {
         mPreloader.onLoaded();
         flash.Lib.current.removeEventListener(flash.events.Event.ENTER_FRAME, onEnter);
         flash.Lib.current.removeChild(mPreloader);
         mPreloader = null;

         Minimalcompshx.main();
      }
   }

   public static function getAsset(inName:String) : Dynamic
   {
      
      if (inName=="assets/pf_ronda_seven.ttf")
         return new NME_assets_pf_ronda_seven_ttf();
      

      return null;
   }
}
