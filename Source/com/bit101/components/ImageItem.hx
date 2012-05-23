package com.bit101.components;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Matrix;
import flash.events.MouseEvent;

class ImageItem extends ViewItem
{
  private var _image : Sprite;
  private var _matrix : Matrix;

  public function new (?parent : Dynamic = null, ?xpos : Float = 0, ?ypos : Float = 0, ?data : Dynamic = null)
  {
    super (parent, xpos, ypos, data);
    _image.name = "ImageItem._image";
    component.name = "ImageItem";
  }

  override function addChildren () : Void
  {
    super.addChildren ();
    _matrix = new Matrix ();
    _image = new Sprite ();
    this.component.addChild (_image);
  }

  override function drawData () : Void
  {
    _image.graphics.clear ();
    _image.graphics.beginBitmapFill (_data.bitmapData,
        _matrix, false, false);
    _image.graphics.drawRect (0, 0, width, height);
    _image.graphics.endFill ();
  }


  override function setSize (width : Float, height : Float) : Void
  {
    super.setSize (width, height);
    _matrix.identity ();
    _matrix.scale (width / _data.width, height / _data.height);
    invalidate ();
  }
}
