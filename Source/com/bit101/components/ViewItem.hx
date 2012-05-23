package com.bit101.components;

import flash.events.MouseEvent;

class ViewItem extends ViewItemBase
{
  public function new (?parent : Dynamic = null, ?xpos : Float = 0, ?ypos : Float = 0, ?data : Dynamic = null)
  {
    super (parent, xpos, ypos, data);
  }

  /**
   * Draws the visual ui of the component.
   */
  public override function draw():Void
  {
    super.draw();
    graphics.clear();

    if(_selected)
    {
      graphics.beginFill(_selectedColor);
    }
    else if(_mouseOver)
    {
      graphics.beginFill(_rolloverColor);
    }
    else
    {
      graphics.beginFill(_defaultColor);
    }
    graphics.drawRect(0, 0, width, height);
    graphics.endFill();

    if (null != _data)
      drawData ();
  }
}
