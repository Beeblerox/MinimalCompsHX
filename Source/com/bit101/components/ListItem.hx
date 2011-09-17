/**
* ListItem.as
* Keith Peters
* version 0.9.10
* 
* A single item in a list. 
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

import flash.events.MouseEvent;

class ListItem extends Component
{
	
	public var data(getData, setData):Dynamic;
	public var selected(getSelected, setSelected):Bool;
	public var defaultColor(getDefaultColor, setDefaultColor):Int;
	public var selectedColor(getSelectedColor, setSelectedColor):Int;
	public var rolloverColor(getRolloverColor, setRolloverColor):Int;
	
	var _data:Dynamic;
	var _label:Label;
	var _defaultColor:Int;
	var _selectedColor:Int;
	var _rolloverColor:Int;
	var _selected:Bool;
	var _mouseOver:Bool;
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this ListItem.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param data The string to display as a label or object with a label property.
	 */
	public function new(?parent:Dynamic = null, ?xpos:Float = 0, ?ypos:Float = 0, ?data:Dynamic = null)
	{
		_defaultColor = 0xffffff;
		_selectedColor = 0xdddddd;
		_rolloverColor = 0xeeeeee;
		_mouseOver = false;
		
		_data = data;
		super(parent, xpos, ypos);
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
	 * Creates and adds the child display objects of this component.
	 */
	override function addChildren():Void
	{
		super.addChildren();
		_label = new Label(this, 5, 0);
		_label.draw();
	}
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
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

		if(_data == null) return;

		if(Std.is(_data, String))
		{
			_label.text = Std.string(_data);
		}
		else if(Reflect.hasField(_data, "label") && Std.is(Reflect.field(_data, "label"), String))
		{
			_label.text = Reflect.field(_data, "label");// _data.label;
		}
		else
		{
			_label.text = Std.string(_data);
		}
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