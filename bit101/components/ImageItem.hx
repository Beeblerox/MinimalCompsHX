package com.bit101.components;

import flash.display.Bitmap;

class ImageItem extends ViewItem
{
  private var _image : Bitmap;

  public function new (?parent : Dynamic = null, ?xpos : Float = 0, ?ypos : Float = 0, ?data : Dynamic = null)
  {
    super (parent, xpos, ypos, data);
  }

  override function addChildren () : Void
  {
    super.addChildren ();
    _image = new Bitmap (_data.bitmapData.clone ());
    this.component.addChild (_image);
  }
}
