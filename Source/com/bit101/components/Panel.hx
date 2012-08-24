/**
* Panel.as
* Keith Peters
* version 0.9.10
* 
* A rectangular panel. Can be used as a container for other components.
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
import flash.display.Sprite;
import flash.events.Event;

class Panel extends Component
{
	
	public var color(getColor, setColor):Int;
	public var shadow(getShadowBool, setShadowBool):Bool;
	public var gridSize(getGridSize, setGridSize):Int;
	public var showGrid(getShowGrid, setShowGrid):Bool;
	public var gridColor(getGridColor, setGridColor):Int;
	
	var _mask:Sprite;
	var _background:Sprite;
	var _color:Int;
	var _shadow:Bool;
	var _gridSize:Int;
	var _showGrid:Bool;
	var _gridColor:Int;
	
	
	/**
	 * Container for content added to this panel. This is masked, so best to add children to content, rather than directly to the panel.
	 */
	public var content:Sprite;
	
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this Panel.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 */
	public function new(?parent:Dynamic = null, ?xpos:Float = 0, ?ypos:Float =  0)
	{
		_color = -1;
		_shadow = true;
		_gridSize = 10;
		_showGrid = false;
		_gridColor = 0xd0d0d0;
		
		super(parent, xpos, ypos);
	}
	
	
	/**
	 * Initializes the component.
	 */
	override function init():Void
	{
		super.init();
		setSize(100, 100);
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override function addChildren():Void
	{
		_background = new Sprite();
		super.addChild(_background);
		
		_mask = new Sprite();
		_mask.mouseEnabled = false;
		super.addChild(_mask);
		
		content = new Sprite();
		super.addChild(content);
		content.mask = _mask;
		#if flash
		filters = [];
		filters.push(getShadow(2, true));
		#end
	}
	
	
	
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/**
	 * Overridden to add new child to content.
	 */
	override public function addChild(child:Dynamic)
	{
		if (Std.is(child, Component)) 
		{
			child.parent = this;
			child = untyped child._comp;			
		}
		return content.addChild(child);
	}
	
	override public function addChildAt(child:Dynamic, index:Int)
	{
		if (Std.is(child, Component)) 
		{
			child.parent = this;
			child = untyped child._comp;			
		}
		return content.addChildAt(child, index);
	}
	
	override public function removeChild(child:Dynamic) 
	{
		if (Std.is(child, Component)) 
		{
			child.parent = null;
			child = untyped child._comp;			
		}
		return content.removeChild(child);
	}
	
	override public function removeChildAt(index:Int):DisplayObject
	{
		return content.removeChildAt(index);
	}
	
	override public function contains(child:Dynamic):Bool 
	{
		if (Std.is(child, Component)) 
		{
			child = untyped child._comp;			
		}
		return content.contains(child);
	}
	
	
	/**
	 * Access to super.addChild
	 */
	public function addRawChild(child:Dynamic):DisplayObject
	{
		return super.addChild(child);
	}
	
	/**
	 * Draws the visual ui of the component.
	 */
	override public function draw():Void
	{
		super.draw();
		_background.graphics.clear();
		_background.graphics.lineStyle(1, 0, 0.1);
		if(_color == -1)
		{
			_background.graphics.beginFill(Style.PANEL);
		}
		else
		{
			_background.graphics.beginFill(_color);
		}
		_background.graphics.drawRect(0, 0, _width, _height);
		_background.graphics.endFill();
		
		drawGrid();
		
		_mask.graphics.clear();
		_mask.graphics.beginFill(0xffffff);
		_mask.graphics.drawRect(0, 0, _width, _height);
		_mask.graphics.endFill();
	}
	
	function drawGrid():Void
	{
		if(!_showGrid) return;
		
		_background.graphics.lineStyle(0, _gridColor);
		var i:Int = 0;
		while (i < _width)
		{
			_background.graphics.moveTo(i, 0);
			_background.graphics.lineTo(i, _height);
			i += _gridSize;
		}
		i = 0;
		while (i < _height)
		{
			_background.graphics.moveTo(0, i);
			_background.graphics.lineTo(_width, i);
			i += _gridSize;
		}
	}
	
	
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	/**
	 * Gets / sets whether or not this Panel will have an inner shadow.
	 */
	public function setShadowBool(b:Bool):Bool
	{
		_shadow = b;
		#if flash
		if(_shadow)
		{
			filters = [];
			filters.push(getShadow(2, true));
		}
		else
		{
			filters = [];
		}
		#end
		return b;
	}
	
	public function getShadowBool():Bool
	{
		return _shadow;
	}
	
	/**
	 * Gets / sets the backgrond color of this panel.
	 */
	public function setColor(c:Int):Int
	{
		_color = c;
		invalidate();
		return c;
	}
	
	public function getColor():Int
	{
		return _color;
	}

	/**
	 * Sets / gets the size of the grid.
	 */
	public function setGridSize(value:Int):Int
	{
		_gridSize = value;
		invalidate();
		return value;
	}
	
	public function getGridSize():Int
	{
		return _gridSize;
	}

	/**
	 * Sets / gets whether or not the grid will be shown.
	 */
	public function setShowGrid(value:Bool):Bool
	{
		_showGrid = value;
		invalidate();
		return value;
	}
	
	public function getShowGrid():Bool
	{
		return _showGrid;
	}

	/**
	 * Sets / gets the color of the grid lines.
	 */
	public function setGridColor(value:Int):Int
	{
		if (value >= 0)
		{
			_gridColor = value;
			invalidate();
		}
		return value;
	}
	
	public function getGridColor():Int
	{
		return _gridColor;
	}
	
	override public function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void
	{
		#if !flash
		_comp.addEventListener(type, listener, useCapture, priority, useWeakReference);
		#else
		content.addEventListener(type, listener, useCapture, priority, useWeakReference);
		#end
	}
	
	override public function dispatchEvent(event:Event):Bool 
	{
		#if !flash
		return _comp.dispatchEvent(event);
		#else
		return content.dispatchEvent(event);
		#end
	}
	
}