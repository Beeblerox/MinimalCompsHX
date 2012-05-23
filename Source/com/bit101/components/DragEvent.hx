package com.bit101.components;

import flash.events.Event;
import flash.display.DisplayObject;
import flash.geom.Point;

class DragEvent extends Event
{
  public static var DRAG : String = "DRAG";
  public static var DROP : String = "DROP";

  public var dragged : Component;
  public var point : Point;

  public function new (type : String,
      c : Component,
      p : Point,
      ?bubbles : Bool = false)
  {
    super (type, bubbles, false);
    dragged = c;
    point = p;
  }
}
