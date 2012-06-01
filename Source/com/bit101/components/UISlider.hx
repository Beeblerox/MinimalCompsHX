/**
* UISlider.as
* Keith Peters
* version 0.9.10
* 
* A Slider with a label and value label. Abstract base class for VUISlider and HUISlider
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

import flash.events.Event;

class UISlider extends Component
{
	
	public var value(getValue, setValue):Float;
	public var maximum(getMaximum, setMaximum):Float;
	public var minimum(getMinimum, setMinimum):Float;
	public var labelPrecision(getLabelPrecision, setLabelPrecision):Int;
	public var label(getLabel, setLabel):String;
	public var tick(getTick, setTick):Float;
	
	var _label:Label;
	var _valueLabel:Label;
	var _slider:Slider;
	var _precision:Int;
	var _sliderClass:Class<Dynamic>;
	var _labelText:String;
	var _tick:Float;
	
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this UISlider.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param label The initial string to display as this component's label.
	 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
	 */
	public function new(?parent:Dynamic = null, ?xpos:Float = 0, ?ypos:Float = 0, ?label:String = "", ?defaultHandler:Dynamic->Void = null)
	{
		_precision = 1;
		_tick = 1;
		
		_labelText = label;
		super(parent, xpos, ypos);
		if(defaultHandler != null)
		{
			addEventListener(Event.CHANGE, defaultHandler);
		}
		formatValueLabel();
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override function addChildren():Void
	{
		_label = new Label(this, 0, 0);
		//_slider = new _sliderClass(this, 0, 0, onSliderChange);
		_slider = Type.createInstance(_sliderClass, [this, 0, 0, onSliderChange]);
		_valueLabel = new Label(this);
	}
	
	/**
	 * Formats the value of the slider to a string based on the current level of precision.
	 */
	function formatValueLabel():Void
	{
		if(Math.isNaN(_slider.value))
		{
			_valueLabel.text = "NaN";
			return;
		}
		var mult:Float = Math.pow(10, _precision);
		var val:String = Std.string(Math.round(_slider.value * mult) / mult);
		var parts:Array<String> = val.split(".");
		if(parts[1] == null)
		{ 
			if(_precision > 0)
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
		positionLabel();
	}
	
	/**
	 * Positions the label when it has changed. Implemented in child classes.
	 */
	function positionLabel():Void
	{
		
	}
	
	
	
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/**
	 * Draws the visual ui of this component.
	 */
	override public function draw():Void
	{
		super.draw();
		_label.text = _labelText;
		_label.draw();
		formatValueLabel();
	}
	
	/**
	 * Convenience method to set the three main parameters in one shot.
	 * @param min The minimum value of the slider.
	 * @param max The maximum value of the slider.
	 * @param value The value of the slider.
	 */
	public function setSliderParams(min:Float, max:Float, value:Float):Void
	{
		_slider.setSliderParams(min, max, value);
	}
	
	
	
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Handler called when the slider's value changes.
	 * @param event The Event passed by the slider.
	 */
	function onSliderChange(event:Event):Void
	{
		formatValueLabel();
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	
	
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	/**
	 * Sets / gets the current value of this slider.
	 */
	public function setValue(v:Float):Float
	{
		_slider.value = v;
		formatValueLabel();
		return v;
	}
	
	public function getValue():Float
	{
		return _slider.value;
	}
	
	/**
	 * Gets / sets the maximum value of this slider.
	 */
	public function setMaximum(m:Float):Float
	{
		_slider.maximum = m;
		return m;
	}
	
	public function getMaximum():Float
	{
		return _slider.maximum;
	}
	
	/**
	 * Gets / sets the minimum value of this slider.
	 */
	public function setMinimum(m:Float):Float
	{
		_slider.minimum = m;
		return m;
	}
	
	public function getMinimum():Float
	{
		return _slider.minimum;
	}
	
	/**
	 * Gets / sets the number of decimals to format the value label. Does not affect the actual value of the slider, just the number shown.
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
	 * Gets / sets the text shown in this component's label.
	 */
	public function setLabel(str:String):String
	{
		_labelText = str;
//			invalidate();
		draw();
		return str;
	}
	
	public function getLabel():String
	{
		return _labelText;
	}
	
	/**
	 * Gets / sets the tick value of this slider. This round the value to the nearest multiple of this number. 
	 */
	public function setTick(t:Float):Float
	{
		_tick = t;
		_slider.tick = _tick;
		return t;
	}
	
	public function getTick():Float
	{
		return _tick;
	}	

}