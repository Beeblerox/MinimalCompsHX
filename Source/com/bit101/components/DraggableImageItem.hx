package com.bit101.components;

import flash.events.MouseEvent;
import flash.geom.Point;

class DraggableImageItem extends ImageItem
{
  public function new (?parent : Dynamic = null, ?xpos : Float = 0, ?ypos : Float = 0, ?data : Dynamic = null)
  {
    super (parent, xpos, ypos, data);
  }

  override function init () : Void
  {
    super.init ();
    addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
    addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
  }

  function onMouseDown (e : MouseEvent) : Void
  {
    var p = localToGlobal (new Point (0, 0));
    stage.addChild (component);
    x = p.x;
    y = p.y;
    startDrag ();
  }
  function onMouseUp (e : MouseEvent) : Void
  {
    stopDrag ();
    _comp.dropTarget.dispatchEvent (new DragEvent (DragEvent.DROP,
          this, new Point (e.stageX, e.stageY), true));
  }
}
