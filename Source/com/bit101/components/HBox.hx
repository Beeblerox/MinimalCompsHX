/**
* VBox.as
* Keith Peters
* version 0.9.10
* 
* A layout container for vertically aligning other components.
* 
* Copyright (c) 2011 Keith Peters
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/


package com.bit101.components;

import flash.display.DisplayObject;
import flash.events.Event;

class HBox extends Component
{
	
	public var spacing(getSpacing, setSpacing):Float;
	public var alignment(getAlignment, setAlignment):String;
	
	var _spacing:Float;
	private var _alignment:String;
  private var _hAlignment : String;
	
	public static inline var TOP:String = "top";
	public static inline var BOTTOM:String = "bottom";
	public static inline var MIDDLE:String = "middle";

  public static inline var LEFT : String = "left";
  public static inline var RIGHT : String = "right";
	
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this PushButton.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 */
	public function new(?parent:Dynamic = null, ?xpos:Float = 0, ?ypos:Float =  0)
	{
		_spacing = 5;
		_alignment = TOP;
    _hAlignment = LEFT;
		
		super(parent, xpos, ypos);
	}
	
	/**
	 * Override of addChild to force layout;
	 */
	override public function addChild(child:Dynamic)
	{
		child = super.addChild(child);
		child.addEventListener(Event.RESIZE, onResize);
		draw();
		return child;
	}

	/**
	 * Override of addChildAt to force layout;
	 */
	override public function addChildAt(child:Dynamic, index:Int)
	{
		child = super.addChildAt(child, index);
		child.addEventListener(Event.RESIZE, onResize);
		draw();
		return child;
	}

	/**
	 * Override of removeChild to force layout;
	 */
	override public function removeChild(child:Dynamic)
	{
		child = super.removeChild(child);
		child.removeEventListener(Event.RESIZE, onResize);
		draw();
		return child;
	}

	/**
	 * Override of removeChild to force layout;
	 */
	override public function removeChildAt(index:Int)
	{
		var child = super.removeChildAt(index);
		child.removeEventListener(Event.RESIZE, onResize);
		draw();
		return child;
	}

	function onResize(event:Event):Void
	{
		invalidate();
	}
	
  function doAlignment():Void
  {
    var xpos : Float = 0;
    for(i in 0...numChildren)
    {
      var child:DisplayObject = getChildAt(i);
      if(_alignment == TOP)
      {
        child.y = 0;
      }
      else if(_alignment == BOTTOM)
      {
        child.y = _height - child.height;
      }
      else if(_alignment == MIDDLE)
      {
        child.y = (_height - child.height) / 2;
      }
    }

    if (_hAlignment == LEFT)
    {
      var xpos : Float = 0;
      for (i in 0...numChildren)
      {
        var child:DisplayObject = getChildAt(i);
        if (child.visible)
        {
          child.x = xpos;
          xpos += child.width + _spacing;
        }
      }
    }
    else if (_hAlignment == RIGHT)
    {
      var xpos : Float = 0;
      for (i in 0...numChildren)
      {
        var child:DisplayObject = getChildAt(numChildren - i - 1);
        if (child.visible)
        {
          child.x = _width - xpos - child.width;
          xpos += child.width + _spacing;
        }
      }
    }
  }

	/**
	 * Draws the visual ui of the component, in this case, laying out the sub components.
	 */
	override public function draw():Void
	{
    if (_height == 0)
    {
      _height = _calculateHeight ();
    }
    if (_width == 0)
    {
      _width = _calculateWidth ();
    }

    doAlignment ();
    dispatchEvent(new Event(Event.RESIZE));
  }

  function _calculateHeight () : Float
  {
    var h : Float = 0;
    for (i in 0...numChildren)
    {
      var child : DisplayObject = getChildAt (i);
      h = Math.max (h, child.height);
    }

    return h;
  }

  function _calculateWidth () : Float
  {
    var w : Float = 0;
    for (i in 0...numChildren)
    {
      var child : DisplayObject = getChildAt (i);
      w += child.width + _spacing;
    }

    return w;
  }

	/**
	 * Gets / sets the spacing between each sub component.
	 */
	public function setSpacing(s:Float):Float
	{
		_spacing = s;
		invalidate();
		return s;
	}
	
	public function getSpacing():Float
	{
		return _spacing;
	}

	/**
	 * Gets / sets the vertical alignment of components in the box.
	 */
	public function setAlignment(value:String):String
	{
		_alignment = value;
		invalidate();
		return value;
	}
	
	public function getAlignment():String
	{
		return _alignment;
	}

  public function setHorizontalAlignment (value : String) : String
  {
    _hAlignment = value;
    invalidate ();
    return value;
  }
	
	override public function setVisible(value:Bool):Bool 
	{
		super.setVisible(value);
		dispatchEvent(new Event(Event.RESIZE, true));
		return value;
	}
}
