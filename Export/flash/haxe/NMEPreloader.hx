import nme.display.Sprite;

class NMEPreloader extends Sprite
{
   public function new()
   {
      super();
   }

   public function onInit() {}

   public function getWidth():Float { return 400; }
   public function getHeight():Float { return 300; }

   public function onUpdate(inBytes:Int,inTotal:Int)
   {
      var frac = inBytes/inTotal;
      var w = getWidth();
      var h = getHeight();

      var gfx = graphics;
      gfx.clear();
      var x0 = 20;
      w-=40;
      var y0 = h/2-20;
      var h = 40;

      gfx.lineStyle(1,0x00ff00);
      gfx.drawRect(x0,y0,w,h);
      gfx.beginFill(0x00ff00);
      gfx.drawRect(x0,y0, frac*w, h);
 
   }

   public function onLoaded()
   {
   }
}



