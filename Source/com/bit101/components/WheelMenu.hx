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

import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.Shape;
import com.bit101.components.Label;

class WheelMenu extends Component
{
	private var _borderColor:Int = 0xcccccc;
	private var _buttons:Array<ArcButton>;
	private var _color:Int = 0xffffff;
	private var _highlightColor:Int = 0xeeeeee;
	private var _iconRadius:Float;
	private var _innerRadius:Float;
	private var _items:Array<Dynamic>;
	private var _numButtons:Int;
	private var _outerRadius:Float;
	private var _selectedIndex:Int = -1;
	private var _startingAngle:Float = -90;
	
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this component.
	 * @param numButtons The number of segments in the menu
	 * @param outerRadius The radius of the menu as a whole.
	 * @parem innerRadius The radius of the inner circle at the center of the menu.
	 * @param defaultHandler The event handling function to handle the default event for this component (select in this case).
	 */
	public function new(parent:DisplayObjectContainer, numButtons:Int, outerRadius:Float = 80, iconRadius:Float = 60, innerRadius:Float = 10, defaultHandler:Event->Void = null)
	{
		_numButtons = numButtons;
		_outerRadius = outerRadius;
		_iconRadius = iconRadius;
		_innerRadius = innerRadius;
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		super(parent);
		
		if(defaultHandler != null)
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
	override private function init():Void
	{
		super.init();
		_items = new Array<Dynamic>();
		makeButtons();
		
		filters = [new DropShadowFilter(4, 45, 0, 1, 4, 4, .2, 4)];
	}
	
	/**
	 * Creates the buttons that make up the wheel menu.
	 */
	private function makeButtons():Void
	{
		_buttons = new Array<ArcButton>();
		for(i in 0...(_numButtons))
		{
			var btn:ArcButton = new ArcButton(Math.PI * 2 / _numButtons, _outerRadius, _iconRadius, _innerRadius);
			btn.id = i;
			btn.rotation = _startingAngle + 360 / _numButtons * i;
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
	public function hide():Void
	{
		visible = false;
		if(stage != null)
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
	public function setItem(index:Int, iconOrLabel:Dynamic, data:Dynamic = null):Void
	{
		_buttons[index].setIcon(iconOrLabel);
		_items[index] = data;
	}
	
	/**
	 * Shows the menu - placing it on top level of parent and centering around mouse.
	 */
	public function show():Void
	{
		parent.addChild(this);
		x = Math.round(parent.mouseX);
		y = Math.round(parent.mouseY);
		_selectedIndex = -1;
		visible = true;
		stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp, true);
	}
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Called when the component is added to the stage. Adds mouse listeners to the stage.
	 */
	private function onAddedToStage(event:Event):Void
	{
		hide();
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
	}
	
	/**
	 * Called when the component is removed from the stage. Removes mouse listeners from stage.
	 */
	private function onRemovedFromStage(event:Event):Void
	{
		stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
	}
	
	/**
	 * Called when one of the buttons is selected. Sets selected index and dispatches select event.
	 */
	private function onSelect(event:Event):Void
	{
		_selectedIndex = event.target.id;
		dispatchEvent(new Event(Event.SELECT));
	}
	
	/**
	 * Called when mouse is released. Hides menu.
	 */
	private function onStageMouseUp(event:MouseEvent):Void
	{
		hide();
	}
	
	///////////////////////////////////
	// getter / setters
	///////////////////////////////////
	
	/**
	 * Gets / sets the color of the border around buttons.
	 */
	public var borderColor(get, set):Int;
	
	private function set_borderColor(value:Int):Int
	{
		_borderColor = value;
		for(i in 0...(_numButtons))
		{
			_buttons[i].borderColor = _borderColor;
		}
		return value;
	}
	private function get_borderColor():Int
	{
		return _borderColor;
	}
	
	/**
	 * Gets / sets the base color of buttons.
	 */
	public var color(get, set):Int;
	
	private function set_color(value:Int):Int
	{
		_color = value;
		for(i in 0...(_numButtons))
		{
			_buttons[i].color = _color;
		}
		return value;
	}
	private function get_color():Int
	{
		return _color;
	}
	
	/**
	 * Gets / sets the highlighted color of buttons.
	 */
	public var highlightColor(get, set):Int;
	
	private function set_highlightColor(value:Int):Int
	{
		_highlightColor = value;
		for(i in 0...(_numButtons))
		{
			_buttons[i].highlightColor = _highlightColor;
		}
		return value;
	}
	private function get_highlightColor():Int
	{
		return _highlightColor;
	}
	
	/**
	 * Gets the selected index.
	 */
	public var selectedIndex(get, null):Int;
	
	private function get_selectedIndex():Int
	{
		return _selectedIndex;
	}
	
	/**
	 * Gets the selected item.
	 */
	public var selectedItem(get, null):Dynamic;
	
	private function get_selectedItem():Dynamic
	{
		return _items[_selectedIndex];
	}
}


/**
* ArcButton class. Internal class only used by WheelMenu.
*/
class ArcButton extends Sprite
{
	public var id:Int;

	private var _arc:Float;
	private var _bg:Shape;
	private var _borderColor:Int = 0xcccccc;
	private var _color:Int = 0xffffff;
	private var _highlightColor:Int = 0xeeeeee;
	private var _icon:DisplayObject;
	private var _iconHolder:Sprite;
	private var _iconRadius:Float;
	private var _innerRadius:Float;
	private var _outerRadius:Float;

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
		
		_bg = new Shape();
		addChild(_bg);
		
		_iconHolder = new Sprite();
		addChild(_iconHolder);
		
		drawArc(0xffffff);
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
	}

	///////////////////////////////////
	// protected methods
	///////////////////////////////////

	/**
	 * Draws an arc of the specified color.
	 * @param color The color to draw the arc.
	 */
	private function drawArc(color:Int):Void
	{
		_bg.graphics.clear();
		_bg.graphics.lineStyle(2, _borderColor);
		_bg.graphics.beginFill(color);
		_bg.graphics.moveTo(_innerRadius, 0);
		_bg.graphics.lineTo(_outerRadius, 0);
		var i:Float = 0;
		while (i < _arc)
		{
			_bg.graphics.lineTo(Math.cos(i) * _outerRadius, Math.sin(i) * _outerRadius);
			i += 0.05;
		}
		_bg.graphics.lineTo(Math.cos(_arc) * _outerRadius, Math.sin(_arc) * _outerRadius);
		_bg.graphics.lineTo(Math.cos(_arc) * _innerRadius, Math.sin(_arc) * _innerRadius);
		i = _arc;
		while (i > 0)
		{
			_bg.graphics.lineTo(Math.cos(i) * _innerRadius, Math.sin(i) * _innerRadius);
			i -= 0.05;
		}
		_bg.graphics.lineTo(_innerRadius, 0);
		
		graphics.endFill();
	}

	///////////////////////////////////
	// public methods
	///////////////////////////////////

	/**
	 * Sets the icon or label of this button.
	 * @param iconOrLabel Either a display object instance, a class that extends DisplayObject, or text to show in a label.
	 */
	public function setIcon(iconOrLabel:Dynamic):Void
	{
		if(iconOrLabel == null) return;
		while(_iconHolder.numChildren > 0) _iconHolder.removeChildAt(0);
		if(Std.is(iconOrLabel, Class))
		{
			_icon = cast(Type.createInstance(cast iconOrLabel, []), DisplayObject);
		}
		else if(Std.is(iconOrLabel, DisplayObject))
		{
			_icon = cast(iconOrLabel, DisplayObject);
		}
		else if(Std.is(iconOrLabel, String))
		{
			_icon = new Label(null, 0, 0, cast(iconOrLabel, String));
			cast(_icon, Label).draw();
		}
		if(_icon != null)
		{
			var angle:Float = _bg.rotation * Math.PI / 180;
			_icon.x = Math.round(-_icon.width / 2);
			_icon.y = Math.round(-_icon.height / 2);
			_iconHolder.addChild(_icon);
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
	private function onMouseOver(event:MouseEvent):Void
	{
		drawArc(_highlightColor);
	}

	/**
	 * Called when mouse moves out of this button. Draw base color.
	 */
	private function onMouseOut(event:MouseEvent):Void
	{
		drawArc(_color);
	}

	/**
	 * Called when mouse is released over this button. Dispatches select event.
	 */
	private function onMouseGoUp(event:MouseEvent):Void
	{
		dispatchEvent(new Event(Event.SELECT));
	}


	///////////////////////////////////
	// getter / setters
	///////////////////////////////////

	/**
	 * Sets / gets border color.
	 */
	public var borderColor(get, set):Int;

	private function set_borderColor(value:Int):Int
	{
		_borderColor = value;
		drawArc(_color);
		return value;
	}
	private function get_borderColor():Int
	{
		return _borderColor;
	}

	/**
	 * Sets / gets base color.
	 */
	public var color(get, set):Int;

	private function set_color(value:Int):Int
	{
		_color = value;
		drawArc(_color);
		return value;
	}
	private function get_color():Int
	{
		return _color;
	}

	/**
	 * Sets / gets highlight color.
	 */
	public var highlightColor(get, set):Int;

	private function set_highlightColor(value:Int):Int
	{
		_highlightColor = value;
		return value;
	}
	private function get_highlightColor():Int
	{
		return _highlightColor;
	}

	/**
	 * Overrides rotation by rotating arc only, allowing label / icon to be unrotated.
	 */
	#if !flash
	override function get_rotation():Float
	#else
	@:getter(rotation) function get_rotation():Float
	#end
	{
		return _bg.rotation;
	}
	
	#if flash
	@:setter(rotation) function set_rotation(value:Float):Void
	{
		_bg.rotation = value;
	}
	#else
	override function set_rotation(value:Float):Float
	{
		_bg.rotation = value;
		return value;
	}
	#end
}