package com.bit101.components;

import flash.events.MouseEvent;

class ViewItem extends Component
{
  public var data(getData, setData):Dynamic;
  public var selected(getSelected, setSelected):Bool;
  public var defaultColor(getDefaultColor, setDefaultColor):Int;
  public var selectedColor(getSelectedColor, setSelectedColor):Int;
  public var rolloverColor(getRolloverColor, setRolloverColor):Int;

  var _data:Dynamic;
  var _defaultColor:Int;
  var _selectedColor:Int;
  var _rolloverColor:Int;
  var _selected:Bool;
  var _mouseOver:Bool;

  public function new (?parent : Dynamic = null, ?xpos : Float = 0, ?ypos : Float = 0, ?data : Dynamic = null)
  {
    _defaultColor = 0xffffff;
    _selectedColor = 0xdddddd;
    _rolloverColor = 0xeeeeee;
    _mouseOver = false;

    _data = data;
    super (parent, xpos, ypos);
  }

  /**
   * Initilizes the component.
   */
  override function init():Void
  {
    super.init();
    addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
    setSize(100, 20);
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

  public function drawData () : Void
  {
  }

  ///////////////////////////////////
  // event handlers
  ///////////////////////////////////
  /**
   * Called when the user rolls the mouse over the item. Changes the background color.
   */
  function onMouseOver(event:MouseEvent):Void
  {
    addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
    _mouseOver = true;
    invalidate();
  }

  /**
   * Called when the user rolls the mouse off the item. Changes the background color.
   */
  function onMouseOut(event:MouseEvent):Void
  {
    removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
    _mouseOver = false;
    invalidate();
  }



  ///////////////////////////////////
  // getter/setters
  ///////////////////////////////////

  /**
   * Sets/gets the string that appears in this item.
   */
  public function setData(value:Dynamic):Dynamic
  {
    _data = value;
    invalidate();
    return value;
  }

  public function getData():Dynamic
  {
    return _data;
  }

  /**
   * Sets/gets whether or not this item is selected.
   */
  public function setSelected(value:Bool):Bool
  {
    _selected = value;
    invalidate();
    return value;
  }

  public function getSelected():Bool
  {
    return _selected;
  }

  /**
   * Sets/gets the default background color of list items.
   */
  public function setDefaultColor(value:Int):Int
  {
    if (value >= 0)
    {
      _defaultColor = value;
      invalidate();
    }
    return value;
  }

  public function getDefaultColor():Int
  {
    return _defaultColor;
  }

  /**
   * Sets/gets the selected background color of list items.
   */
  public function setSelectedColor(value:Int):Int
  {
    if (value >= 0)
    {
      _selectedColor = value;
      invalidate();
    }
    return value;
  }

  public function getSelectedColor():Int
  {
    return _selectedColor;
  }

  /**
   * Sets/gets the rollover background color of list items.
   */
  public function setRolloverColor(value:Int):Int
  {
    if (value >= 0)
    {
      _rolloverColor = value;
      invalidate();
    }
    return value;
  }

  public function getRolloverColor():Int
  {
    return _rolloverColor;
  }
}
