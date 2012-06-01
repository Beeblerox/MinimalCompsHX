/**
* Knob.as
* Keith Peters
* version 0.9.10
* 
* A knob component for choosing a numerical value.
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

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

class Knob extends Component
{
	
	public var maximum(getMaximum, setMaximum):Float;
	public var minimum(getMinimum, setMinimum):Float;
	public var value(getValue, setValue):Float;
	public var mouseRange(getMouseRange, setMouseRange):Float;
	public var labelPrecision(getLabelPrecision, setLabelPrecision):Int;
	public var showValue(getShowValue, setShowValue):Bool;
	public var label(getLabel, setLabel):String;
	public var mode(getMode, setMode):String;
	public var radius(getRadius, setRadius):Float;
	
	public static inline var VERTICAL:String = "vertical";
	public static inline var HORIZONTAL:String = "horizontal";
	public static inline var ROTATE:String = "rotate";
	
	var _knob:Sprite;
	var _label:Label;
	var _labelText:String;
	var _max:Float;
	var _min:Float;
	var _mode:String;
	var _mouseRange:Float;
	var _precision:Int;
	var _radius:Float;
	var _startX:Float;
	var _startY:Float;
	var _value:Float;
	var _valueLabel:Label;
	
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this Knob.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param label String containing the label for this component.
	 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
	 */
	public function new(?parent:Dynamic = null, ?xpos:Float = 0, ?ypos:Float =  0, ?label:String = "", ?defaultHandler:Dynamic->Void = null)
	{
		_labelText = "";
		_max = 100;
		_min = 0;
		_mode = VERTICAL;
		_mouseRange = 100;
		_precision = 1;
		_radius = 20;
		_value = 0;
		
		_labelText = label;
		super(parent, xpos, ypos);
		if(defaultHandler != null)
		{
			addEventListener(Event.CHANGE, defaultHandler);
		}
	}

	/**
	 * Initializes the component.
	 */
	override function init():Void
	{
		super.init();
	}
	
	/**
	 * Creates the children for this component
	 */
	override function addChildren():Void
	{
		_knob = new Sprite();
		
		_knob.buttonMode = true;
		_knob.useHandCursor = true;
		
		_knob.addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
		addChild(_knob);
		
		_label = new Label();
		_label.autoSize = true;
		addChild(_label);
		
		_valueLabel = new Label();
		_valueLabel.autoSize = true;
		addChild(_valueLabel);
		
		_width = _radius * 2;
		_height = _radius * 2 + 40;		}
	
	/**
	 * Draw the knob at the specified radius.
	 */
	function drawKnob():Void
	{
		_knob.graphics.clear();
		_knob.graphics.beginFill(Style.BACKGROUND);
		_knob.graphics.drawCircle(0, 0, _radius);
		_knob.graphics.endFill();
		
		_knob.graphics.beginFill(Style.BUTTON_FACE);
		_knob.graphics.drawCircle(0, 0, _radius - 2);
		_knob.graphics.endFill();
		
		_knob.graphics.beginFill(Style.BACKGROUND);
		var s:Float = _radius * .1;
		_knob.graphics.drawRect(_radius, -s, s*1.5, s * 2);
		_knob.graphics.endFill();
		
		_knob.x = _radius;
		_knob.y = _radius + 20;
		updateKnob();
	}
	
	/**
	 * Updates the rotation of the knob based on the value, then formats the value label.
	 */
	function updateKnob():Void
	{
		_knob.rotation = -225 + (_value - _min) / (_max - _min) * 270;
		formatValueLabel();
	}
	
	/**
	 * Adjusts value to be within minimum and maximum.
	 */
	function correctValue():Void
	{
		if(_max > _min)
		{
			_value = Math.min(_value, _max);
			_value = Math.max(_value, _min);
		}
		else
		{
			_value = Math.max(_value, _max);
			_value = Math.min(_value, _min);
		}
	}
	
	/**
	 * Formats the value of the knob to a string based on the current level of precision.
	 */
	function formatValueLabel():Void
	{
		var mult:Float = Math.pow(10, _precision);
		var val:String = Std.string(Math.round(_value * mult) / mult);
		var parts:Array<String> = val.split(".");
		if(parts[1] == null)
		{ 
			if (_precision > 0)
			{
				val += ".";
			}
			for (i in 0..._precision)
			{
				val += "0";
			}
		}
		else if(parts[1].length < _precision)
		{
			for (i in 0...(_precision - parts[1].length))
			{
				val += "0";
			}
		}
		_valueLabel.text = val;
		_valueLabel.draw();
		_valueLabel.x = width / 2 - _valueLabel.width / 2;
	}
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/**
	 * Draws the visual ui of the component.
	 */
	override public function draw():Void
	{
		super.draw();
		
		drawKnob();
		
		_label.text = _labelText;
		_label.draw();
		_label.x = _radius - _label.width / 2;
		_label.y = 0;
		
		formatValueLabel();
		_valueLabel.x = _radius - _valueLabel.width / 2;
		_valueLabel.y = _radius * 2 + 20;
		
		_width = _radius * 2;
		_height = _radius * 2 + 40;
	}
	
	///////////////////////////////////
	// event handler
	///////////////////////////////////
	
	/**
	 * Internal handler for when user clicks on the knob. Starts tracking up/down motion of the mouse.
	 */
	function onMouseGoDown(event:MouseEvent):Void
	{
		_startX = mouseX;
		_startY = mouseY;
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoved);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
	}
	
	/**
	 * Internal handler for mouse move event. Updates value based on how far mouse has moved up or down.
	 */
	function onMouseMoved(event:MouseEvent):Void
	{
		var oldValue:Float = _value;
		var diff:Float;
		var range:Float;
		var percent:Float;
		if(_mode == ROTATE)
		{
			var angle:Float = Math.atan2(mouseY - _knob.y, mouseX - _knob.x);
			var rot:Float = angle * 180 / Math.PI - 135;
			while(rot > 360) rot -= 360;
			while(rot < 0) rot += 360;
			if(rot > 270 && rot < 315) rot = 270;
			if(rot >= 315 && rot <= 360) rot = 0;
			_value = rot / 270 * (_max - _min) + _min;
			if(_value != oldValue)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}				
			_knob.rotation = rot + 135;
			formatValueLabel();
		}
		else if(_mode == VERTICAL)
		{
			diff = _startY - mouseY;
			range = _max - _min;
			percent = range / _mouseRange;
			_value += percent * diff;
			correctValue();
			if(_value != oldValue)
			{
				updateKnob();
				dispatchEvent(new Event(Event.CHANGE));
			}
			_startY = mouseY;
		}
		else if(_mode == HORIZONTAL)
		{
			diff = _startX - mouseX;
			range = _max - _min;
			percent = range / _mouseRange;
			_value -= percent * diff;
			correctValue();
			if(_value != oldValue)
			{
				updateKnob();
				dispatchEvent(new Event(Event.CHANGE));
			}
			_startX = mouseX;
		}
	}
	
	/**
	 * Internal handler for mouse up event. Stops mouse tracking.
	 */
	function onMouseGoUp(event:MouseEvent):Void
	{
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoved);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
	}
	
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	/**
	 * Gets / sets the maximum value of this knob.
	 */
	public function setMaximum(m:Float):Float
	{
		_max = m;
		correctValue();
		updateKnob();
		return m;
	}
	
	public function getMaximum():Float
	{
		return _max;
	}
	
	/**
	 * Gets / sets the minimum value of this knob.
	 */
	public function setMinimum(m:Float):Float
	{
		_min = m;
		correctValue();
		updateKnob();
		return m;
	}
	
	public function getMinimum():Float
	{
		return _min;
	}
	
	/**
	 * Sets / gets the current value of this knob.
	 */
	public function setValue(v:Float):Float
	{
		_value = v;
		correctValue();
		updateKnob();
		return v;
	}
	
	public function getValue():Float
	{
		return _value;
	}
	
	/**
	 * Sets / gets the number of pixels the mouse needs to move to make the value of the knob go from min to max.
	 */
	public function setMouseRange(value:Float):Float
	{
		_mouseRange = value;
		return value;
	}
	
	public function getMouseRange():Float
	{
		return _mouseRange;
	}
	
	/**
	 * Gets / sets the number of decimals to format the value label.
	 */
	public function setLabelPrecision(decimals:Int):Int
	{
		_precision = decimals;
		return decimals;
	}
	
	public function getLabelPrecision():Int
	{
		return _precision;
	}
	
	/**
	 * Gets / sets whether or not to show the value label.
	 */
	public function setShowValue(value:Bool):Bool
	{
		_valueLabel.visible = value;
		return value;
	}
	
	public function getShowValue():Bool
	{
		return _valueLabel.visible;
	}
	
	/**
	 * Gets / sets the text shown in this component's label.
	 */
	public function setLabel(str:String):String
	{
		_labelText = str;
		draw();
		return str;
	}
	
	public function getLabel():String
	{
		return _labelText;
	}

	public function setMode(value:String):String
	{
		_mode = value;
		return value;
	}
	
	public function getMode():String
	{
		return _mode;
	}

	public function getRadius():Float
	{
		return _radius;
	}

	public function setRadius(value:Float):Float
	{
		_radius = value;
		_width = _radius * 2;
		_height = _radius * 2 + 40;
		invalidate();
		return value;
	}
}