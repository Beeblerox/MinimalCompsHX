/**
* Meter.as
* Keith Peters
* version 0.9.10
* 
* A meter component similar to a voltage meter, with a dial and a needle that indicates a value.
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

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.DropShadowFilter;

class Meter extends Component
{
	private var _damp:Float = .8;
	private var _dial:Sprite;
	private var _label:Label;
	private var _labelText:String;
	private var _maximum:Float = 1.0;
	private var _maxLabel:Label;
	private var _minimum:Float = 0.0;
	private var _minLabel:Label;
	private var _needle:Sprite;
	private var _needleMask:Sprite;
	private var _showValues:Bool = true;
	private var _targetRotation:Float = 0;
	private var _value:Float = 0.0;
	private var _velocity:Float = 0;
	
	
	
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this Meter.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param text The string to use as the initial text in this component.
	 */
	public function new(parent:DisplayObjectContainer = null, xpos:Float = 0, ypos:Float =  0, text:String = "")
	{
		_labelText = text;
		super(parent, xpos, ypos);
	}
	
	/**
	 * Initializes the component.
	 */
	override private function init():Void
	{
		super.init();
		_width = 200;
		_height = 100;
	}
	
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override private function addChildren():Void
	{ 
		_dial = new Sprite();
		addChild(_dial);

		_needle = new Sprite();
		_needle.rotation = -50;
		_dial.addChild(_needle);
		
		_needleMask = new Sprite();
		addChild(_needleMask);
		_dial.mask = _needleMask;
		
		_minLabel = new Label(this);
		_minLabel.text = Std.string(_minimum);
		
		_maxLabel = new Label(this);
		_maxLabel.autoSize = true;
		_maxLabel.text = Std.string(_maximum);
		
		_label = new Label(this);
		_label.text = _labelText;
	}
	
	 
	 
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/**
	 * Draws the visual ui of the component.
	 */
	override public function draw():Void
	{
		var startAngle:Float = -140 * Math.PI / 180;
		var endAngle:Float = -40 * Math.PI / 180;
		
		drawBackground();
		drawDial(startAngle, endAngle);
		drawTicks(startAngle, endAngle);
		drawNeedle();
		
		_minLabel.move(10, _height - _minLabel.height - 4);
		_maxLabel.move(_width - _maxLabel.width - 10, _height - _maxLabel.height - 4);
		_label.move((_width - _label.width) / 2, _height * .5);
		update();
	}
	
	/**
	 * Sets the size of the component. Adjusts height to be 1/2 width.
	 * @param w The width of the component.
	 * @param h The height of the component.
	 */
	override public function setSize(w:Float, h:Float):Void
	{
		h = w / 2;
		super.setSize(w, h);
	}
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/**
	 * Draws the background of the component.
	 */
	private function drawBackground():Void
	{
		graphics.clear();
		graphics.beginFill(Style.BACKGROUND);
		graphics.drawRect(0, 0, _width, _height);
		graphics.endFill();
		
		graphics.beginFill(Style.PANEL);
		graphics.drawRect(1, 1, _width - 2, _height - 2);
		graphics.endFill();
	}
	
	/**
	 * Draws the dial.
	 */
	private function drawDial(startAngle:Float, endAngle:Float):Void
	{
		_dial.x = _width / 2;
		_dial.y = _height * 1.25;
		_dial.graphics.clear();
		_dial.graphics.lineStyle(0, Style.BACKGROUND);
		_dial.graphics.beginFill(Style.BUTTON_FACE);
		var r1:Float = _height * 1.05;
		var r2:Float = _height * 0.96;
		
		_dial.graphics.moveTo(Math.cos(startAngle) * r1, Math.sin(startAngle) * r1);
		var i:Float = startAngle;
		while (i < endAngle)
		{
			_dial.graphics.lineTo(Math.cos(i) * r1, Math.sin(i) * r1);
			i += .1;
		}
		_dial.graphics.lineTo(Math.cos(endAngle) * r1, Math.sin(endAngle) * r1);
		
		_dial.graphics.lineTo(Math.cos(endAngle) * r2, Math.sin(endAngle) * r2);
		i = endAngle;
		while (i > startAngle)
		{
			_dial.graphics.lineTo(Math.cos(i) * r2, Math.sin(i) * r2);
			i -= .1;
		}
		_dial.graphics.lineTo(Math.cos(startAngle) * r2, Math.sin(startAngle) * r2);
		_dial.graphics.lineTo(Math.cos(startAngle) * r1, Math.sin(startAngle) * r1);
		
	}
	
	/**
	 * Draws the tick marks on the dial.
	 */
	private function drawTicks(startAngle:Float, endAngle:Float):Void
	{
		var r1:Float = _height * 1.05;
		var r2:Float = _height * 0.96;
		var r3:Float = _height * 1.13;
		var tick:Float = 0;
		for(i in 0...9)
		{
			var angle:Float = startAngle + i * (endAngle - startAngle) / 8;
			_dial.graphics.moveTo(Math.cos(angle) * r2, Math.sin(angle) * r2);
			if(tick++ % 2 == 0)
			{
				_dial.graphics.lineTo(Math.cos(angle) * r3, Math.sin(angle) * r3);
			}
			else
			{
				_dial.graphics.lineTo(Math.cos(angle) * r1, Math.sin(angle) * r1);
			}
		}
	}
	
	/**
	 * Draws the needle.
	 */
	private function drawNeedle():Void
	{
		_needle.graphics.clear();
		_needle.graphics.beginFill(0xff0000);
		_needle.graphics.drawRect(-0.5, -_height * 1.10, 1, _height * 1.10);
		_needle.filters = [new DropShadowFilter(4, 0, 0, 1, 3, 3, .2)];
		
		_needleMask.graphics.clear();
		_needleMask.graphics.beginFill(0);
		_needleMask.graphics.drawRect(0, 0, _width, _height);
		_needleMask.graphics.endFill();
	}
	
	/**
	 * Updates the target rotation of the needle and starts an enterframe handler to spring it to that point.
	 */
	private function update():Void
	{
		_value = Math.max(_value, _minimum);
		_value = Math.min(_value, _maximum);
		_targetRotation = -50 + (_value - _minimum) / (_maximum - _minimum) * 100;
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Handles the enterFrame event to spring the needle to the target rotation.
	 */
	private function onEnterFrame(event:Event):Void
	{
		var dist:Float = _targetRotation - _needle.rotation;
		_velocity += dist * .05;
		_velocity *= _damp;
		if(Math.abs(_velocity) < .1 && Math.abs(dist) < .1)
		{
			_needle.rotation = _targetRotation;
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		else
		{
			_needle.rotation += _velocity;
		}
	}
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	/**
	 * Gets / sets the maximum value for the meter.
	 */
	public var maximum(get_maximum, set_maximum):Float;
	
	private function set_maximum(value:Float):Float
	{
		_maximum = value;
		_maxLabel.text = Std.string(_maximum);
		update();
		return value;
	}
	private function get_maximum():Float
	{
		return _maximum;
	}
	
	/**
	 * Gets / sets the minimum value for the meter.
	 */
	public var minimum(get_minimum, set_minimum):Float;
	
	private function set_minimum(value:Float):Float
	{
		_minimum = value;
		_minLabel.text = Std.string(_minimum);
		update();
		return value;
	}
	private function get_minimum():Float
	{
		return _minimum;
	}
	
	/**
	 * Gets / sets the current value for the meter.
	 */
	public var value(get_value, set_value):Float;
	
	private function set_value(val:Float):Float
	{
		_value = val;
		update();
		return val;
	}
	private function get_value():Float
	{
		return _value;
	}
	
	/**
	 * Gets / sets the label shown on the meter.
	 */
	public var label(get_label, set_label):String;
	
	private function set_label(value:String):String
	{
		_labelText = value;
		_label.text = _labelText;
		return value;
	}
	private function get_label():String
	{
		return _labelText;
	}
	
	/**
	 * Gets / sets whether or not value labels will be shown for max and min values.
	 */
	public var showValues(get_showValues, set_showValues):Bool;
	
	private function set_showValues(value:Bool):Bool
	{
		_showValues = value;
		_minLabel.visible = _showValues;
		_maxLabel.visible = _showValues;
		return value;
	}
	private function get_showValues():Bool
	{
		return _showValues;
	}

	/**
	 * Gets / sets the damping value for the meter.
	 */
	public var damp(get_damp, set_damp):Float;
	
	private function set_damp(value:Float):Float
	{
		_damp = value;
		return value;
	}
	private function get_damp():Float
	{
		return _damp;
	}
}