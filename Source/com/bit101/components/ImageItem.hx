package com.bit101.components;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;

class ImageItem extends ViewItem
{
  private var _image : Bitmap;
  private var _matrix : Matrix;

  public function new (?parent : Dynamic = null, ?xpos : Float = 0, ?ypos : Float = 0, ?data : Dynamic = null)
  {
    super (parent, xpos, ypos, data);
  }

  override function addChildren () : Void
  {
    super.addChildren ();
    _matrix = new Matrix ();
    _image = new Bitmap (null);
    this.component.addChild (_image);
  }

  override function setSize (width : Float, height : Float) : Void
  {
    super.setSize (width, height);
    _matrix.identity ();
    _matrix.scale (width / _data.width, height / _data.height);
    _image.bitmapData = new BitmapData (Std.int (width), Std.int (height));
    _image.bitmapData.draw (_data, _matrix, null, null, null, true);
  }
}
