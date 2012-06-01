/**
* WheelMenu.as
* Keith Peters
* version 0.9.10
* 
* A radial menu that pops up around the mouse.
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
* 
* 
* 
* Components with text make use of the font PF Ronda Seven by Yuusuke Kamiyamane
* This is a free font obtained from http://www.dafont.com/pf-ronda-seven.font
*/

package com.bit101.components;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

class WheelMenu extends Component {
	
	public var borderColor(getBorderColor, setBorderColor):Int;
	public var color(getColor, setColor):Int;
	public var highlightColor(getHighlightColor, setHighlightColor):Int;
	public var selectedIndex(getSelectedIndex, null) : Int;
	public var selectedItem(getSelectedItem, null) : Dynamic;
	
	var _borderColor:Int;
	var _buttons:Array<Dynamic>;
	var _color:Int;
	var _highlightColor:Int;
	var _iconRadius:Float;
	var _innerRadius:Float;
	var _items:Array<Dynamic>;
	var _numButtons:Int;
	var _outerRadius:Float;
	var _selectedIndex:Int;
	var _startingAngle:Int;
	
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this component.
	 * @param numButtons The Float of segments in the menu
	 * @param outerRadius The radius of the menu as a whole.
	 * @parem innerRadius The radius of the inner circle at the center of the menu.
	 * @param defaultHandler The event handling function to handle the default event for this component (select in this case).
	 */
	public function new(parent:Dynamic, numButtons:Int, ?outerRadius:Int = 80, ?iconRadius:Int = 60, ?innerRadius:Int = 10, ?defaultHandler:Dynamic->Void = null) {	
		_borderColor = 0xcccccc;
		_color = 0xffffff;
		_highlightColor = 0xeeeeee;
		_selectedIndex = -1;
		_startingAngle = -90;
		_numButtons = numButtons;
		_outerRadius = outerRadius;
		_iconRadius = iconRadius;
		_innerRadius = innerRadius;
		super(parent);
		
		if (defaultHandler != null)
		{
			addEventListener(Event.SELECT, defaultHandler);
		}
	}
		
	///////////////////////////////////
	// protected methods
	///////////////////////////////////
	
	/**
	 * Initializes the component.
	 */
	override function init():Void
	{
		super.init();
		_items = new Array();
		makeButtons();

		filters = [];
		filters.push(new DropShadowFilter(4, 45, 0, 1, 4, 4, 0.2, 4));
		hide();
	}
	
	/**
	 * Creates the buttons that make up the wheel menu.
	 */
	function makeButtons():Void
	{
		_buttons = new Array();
		for (i in 0..._numButtons) 
		{
			var btn = new ArcButton(Math.PI * 2 / _numButtons, _outerRadius, _iconRadius, _innerRadius);
			btn.id = i;
			btn.arcRotation = _startingAngle + 360 / _numButtons * i;
			btn.addEventListener(Event.SELECT, onSelect);
			addChild(btn);
			_buttons.push(btn);
		}
	}
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/**
	 * Hides the menu.
	 */
	override public function hide():Void 
	{
		visible = false;
		if (stage != null)
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
	}
	
	/**
	 * Sets the icon / text and data for a specific menu item.
	 * @param index The index of the item to set icon/text and data for.
	 * @iconOrLabel Either a display object instance, a class that extends DisplayObject, or text to show in a label.
	 * @data Any data to associate with the item.
	 */
	public function setItem(index:Int, iconOrLabel:Dynamic, ?data:Dynamic = null):Void
	{
		_buttons[index].setIcon(iconOrLabel);
		_items[index] = data;
	}
	
	/**
	 * Shows the menu - placing it on top level of parent and centering around mouse.
	 */
	override public function show():Void
	{
		x = Math.round(parent.mouseX);
		y = Math.round(parent.mouseY);
		_selectedIndex = -1;
		visible = true;
		if(stage != null)
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
	}
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Called when one of the buttons is selected. Sets selected index and dispatches select event.
	 */
	function onSelect(event:Event) 
	{
		_selectedIndex = event.target.id;
		dispatchEvent(new Event(Event.SELECT));
	}
	
	/**
	 * Called when mouse is released. Hides menu.
	 */
	function onStageMouseUp(event:MouseEvent) 
	{
		hide();
	}
	
	///////////////////////////////////
	// getter / setters
	///////////////////////////////////
	
	/**
	 * Gets / sets the color of the border around buttons.
	 */
	public function setBorderColor(value:Int):Int 
	{
		if (value >= 0)
		{
			_borderColor = value;
			for (i in 0..._numButtons)
			{
				_buttons[i].borderColor = _borderColor;
			}
		}
		return value;
	}
	
	public function getBorderColor():Int 
	{
		return _borderColor;
	}
	
	/**
	 * Gets / sets the base color of buttons.
	 */
	public function setColor(value:Int):Int 
	{
		if (value >= 0)
		{
			_color = value;
			for(i in 0..._numButtons)
			{
				_buttons[i].color = _color;
			}
		}
		return value;
	}
	
	public function getColor():Int 
	{
		return _color;
	}
	
	/**
	 * Gets / sets the highlighted color of buttons.
	 */
	public function setHighlightColor(value:Int):Int 
	{
		if (value >= 0)
		{
			_highlightColor = value;
			for(i in 0..._numButtons)
			{
				_buttons[i].selectedColor = _highlightColor;
			}
		}
		return value;
	}
	
	public function getHighlightColor():Int 
	{
		return _highlightColor;
	}
	
	/**
	 * Gets the selected index.
	 */
	public function getSelectedIndex():Int 
	{
		return _selectedIndex;
	}
	
	/**
	 * Gets the selected item.
	 */
	public function getSelectedItem():Dynamic 
	{
		return _items[_selectedIndex];
	}	
}



/**
 * ArcButton class. Internal class only used by WheelMenu.
 */
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.display.Shape;

class ArcButton extends Sprite 
{
	public var id:Int;
	
	
	public var color(getColor, setColor):Int;
	public var arcRotation(getRotation, setRotation):Float;
	public var borderColor(getBorderColor, setBorderColor):Int;

	var _arc:Float;
	var _bg:Shape;
	var _borderColor:Int;
	var _color:Int;
	var _highlightColor:Int;
	var _icon:Dynamic;
	var _iconHolder:Sprite;
	var _iconRadius:Float;
	var _innerRadius:Float;
	var _outerRadius:Float;

	/**
	 * Constructor.
	 * @param arc The radians of the arc to draw.
	 * @param outerRadius The outer radius of the arc. 
	 * @param innerRadius The inner radius of the arc.
	 */
	public function new(arc:Float, outerRadius:Float, iconRadius:Float, innerRadius:Float) 
	{
		super();
		_arc = arc;
		_outerRadius = outerRadius;
		_iconRadius = iconRadius;
		_innerRadius = innerRadius;
		_borderColor = 0xCCCCCC;
		_color = 0xFFFFFF;
		_highlightColor = 0xEEEEEE;

		_bg = new Shape();
		addChild(_bg);

		_iconHolder = new Sprite();
		addChild(_iconHolder);

		drawArc(0xffffff);
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}

	///////////////////////////////////
	// private methods
	///////////////////////////////////

	/**
	 * Draws an arc of the specified color.
	 * @param color The color to draw the arc.
	 */
	function drawArc(color:Int):Void
	{
		_bg.graphics.clear();
		_bg.graphics.lineStyle(2, _borderColor);
		_bg.graphics.beginFill(color);
		_bg.graphics.moveTo(_innerRadius, 0);
		_bg.graphics.lineTo(_outerRadius, 0);
		var i = 0.;
		while (i < _arc) 
		{
			_bg.graphics.lineTo(Math.cos(i) * _outerRadius, Math.sin(i) * _outerRadius);
			i += .05;
		}
		_bg.graphics.lineTo(Math.cos(_arc) * _outerRadius, Math.sin(_arc) * _outerRadius);
		_bg.graphics.lineTo(Math.cos(_arc) * _innerRadius, Math.sin(_arc) * _innerRadius);
		var i = 0.;
		while (i < _arc) 
		{
			_bg.graphics.lineTo(Math.cos(i) * _innerRadius, Math.sin(i) * _innerRadius);
			i += .05;
		}
		_bg.graphics.lineTo(_innerRadius, 0);
		_bg.graphics.endFill();
	}

	///////////////////////////////////
	// public methods
	///////////////////////////////////

	/**
	 * Sets the icon or label of this button.
	 * @param iconOrLabel Either a display object instance, a class that extends DisplayObject, or text to show in a label.
	 */
	public function setIcon(iconOrLabel:Dynamic) 
	{
        if(iconOrLabel == null) return;
        while(_iconHolder.numChildren > 0) _iconHolder.removeChildAt(0);
		if (Std.is(iconOrLabel, Class))
		{
			_icon = cast(Type.createInstance(cast iconOrLabel, []), DisplayObject);
		}
		else if (Std.is(iconOrLabel, DisplayObject))
		{
			_icon = cast(iconOrLabel, DisplayObject);
		}
		else if (Std.is(iconOrLabel, String)) 
		{
			_icon = new Label(null, 0, 0, cast(iconOrLabel, String));
			cast(_icon, Label).draw();
		}
		if (_icon != null) 
		{
			var angle = _bg.rotation * Math.PI / 180;
			_icon.x = Math.round(-_icon.width / 2);
			_icon.y = Math.round( -_icon.height / 2);
			//_iconHolder.addChild(_icon);
			_icon.addToDisplay(_iconHolder);
			_iconHolder.x = Math.round(Math.cos(angle + _arc / 2) * _iconRadius);
			_iconHolder.y = Math.round(Math.sin(angle + _arc / 2) * _iconRadius);
		}
	}


	///////////////////////////////////
	// event handlers
	///////////////////////////////////

	/**
	 * Called when mouse moves over this button. Draws highlight.
	 */
	function onMouseOver(event:MouseEvent):Void
	{
		drawArc(_highlightColor);
	}

	/**
	 * Called when mouse moves out of this button. Draw base color.
	 */
	function onMouseOut(event:MouseEvent):Void
	{
		drawArc(_color);
	}

	/**
	 * Called when mouse is released over this button. Dispatches select event.
	 */
	function onMouseUp(event:MouseEvent):Void
	{
		dispatchEvent(new Event(Event.SELECT));
	}


	///////////////////////////////////
	// getter / setters
	///////////////////////////////////

	/**
	 * Sets / gets border color.
	 */
	function setBorderColor(value:Int):Int 
	{
		if (value >= 0)
		{
			_borderColor = value;
			drawArc(_color);
		}
		return _borderColor;
	}
	
	function getBorderColor():Int 
	{
        return _borderColor;
	}

	/**
	 * Sets / gets base color.
	 */
	function setColor(value:Int):Int 
	{
		if (value >= 0)
		{
			_color = value;
			drawArc(_color);
		}
		return _color;
	}
	
	function getColor():Int 
	{
		return _color;
	}

	/**
	 * Overrides rotation by rotating arc only, allowing label / icon to be unrotated.
	 */
	function setRotation(value:Float):Float 
	{
		return _bg.rotation = value;
	}
	
	function getRotation():Float 
	{
		return _bg.rotation;
	}
        
}