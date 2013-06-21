/**
* NumericStepper.as
* Keith Peters
* version 0.9.10
* 
* A component allowing for entering a numeric value with the keyboard, or by pressing up/down buttons.
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
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;

enum NumericStepperDirection
{
	UP;
	DOWN;
}

class NumericStepper extends Component
{
	private static inline var DELAY_TIME:Int = 500;
	private var _minusBtn:PushButton;

	private var _repeatTime:Int = 100;
	private var _plusBtn:PushButton;
	private var _valueText:InputText;
	private var _value:Float = 0;
	private var _step:Float = 1;
	private var _labelPrecision:Int = 1;
	private var _maximum:Float;
	private var _minimum:Float;
	private var _delayTimer:Timer;
	private var _repeatTimer:Timer;
	private var _direction:NumericStepperDirection;
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this Slider.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
	 */
	public function new(parent:DisplayObjectContainer = null, xpos:Float = 0, ypos:Float = 0, defaultHandler:Event->Void = null)
	{
		_maximum = Math.POSITIVE_INFINITY;
		_minimum = Math.NEGATIVE_INFINITY;
		super(parent, xpos, ypos);
		if(defaultHandler != null)
		{
			addEventListener(Event.CHANGE, defaultHandler);
		}
	}
	
	/**
	 * Initializes the component.
	 */
	private override function init():Void
	{
		super.init();
		setSize(80, 16);
		_delayTimer = new Timer(DELAY_TIME, 1);
		_delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
		_repeatTimer = new Timer(_repeatTime);
		_repeatTimer.addEventListener(TimerEvent.TIMER, onRepeat);
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	private override function addChildren():Void
	{
		_valueText = new InputText(this, 0, 0, "0", onValueTextChange);
		_valueText.restrict = "-0123456789.";
		_minusBtn = new PushButton(this, 0, 0, "-");
		_minusBtn.addEventListener(MouseEvent.MOUSE_DOWN, onMinus);
		_minusBtn.setSize(16, 16);
		_plusBtn = new PushButton(this, 0, 0, "+");
		_plusBtn.addEventListener(MouseEvent.MOUSE_DOWN, onPlus);
		_plusBtn.setSize(16, 16);
	}
	
	private function increment():Void
	{
		if(_value + _step <= _maximum)
		{
			_value += _step;
			invalidate();
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
	
	private function decrement():Void
	{
		if(_value - _step >= _minimum)
		{
			_value -= _step;
			invalidate();
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
	
	
	
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/**
	 * Draws the visual ui of the component.
	 */
	public override function draw():Void
	{
		_plusBtn.x = _width - 16;
		_minusBtn.x = _width - 32;
		_valueText.text = Std.string(Math.round(_value * Math.pow(10, _labelPrecision)) / Math.pow(10, _labelPrecision));
		_valueText.width = _width - 32;
		_valueText.draw();
	}
	
	
	
	
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Called when the minus button is pressed. Decrements the value by the step amount.
	 */
	private function onMinus(event:MouseEvent):Void
	{
		decrement();
		_direction = NumericStepperDirection.DOWN;
		_delayTimer.start();
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
	}
	
	/**
	 * Called when the plus button is pressed. Increments the value by the step amount.
	 */
	private function onPlus(event:MouseEvent):Void
	{
		increment();
		_direction = NumericStepperDirection.UP;
		_delayTimer.start();
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
	}
	
	private function onMouseGoUp(event:MouseEvent):Void
	{
		_delayTimer.stop();
		_repeatTimer.stop();
	}
	
	/**
	 * Called when the value is changed manually.
	 */
	private function onValueTextChange(event:Event):Void
	{
		event.stopImmediatePropagation();
		var newVal:Float = Std.parseFloat(_valueText.text);
		if(newVal <= _maximum && newVal >= _minimum)
		{
			_value = newVal;
			invalidate();
			dispatchEvent(new Event(Event.CHANGE));
		}
	}

	private function onDelayComplete(event:TimerEvent):Void
	{
		_repeatTimer.start();
	}

	private function onRepeat(event:TimerEvent):Void
	{
		if(_direction == NumericStepperDirection.UP)
		{
			increment();
		}
		else
		{
			decrement();
		}
	}
	
	
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	/**
	 * Sets / gets the current value of this component.
	 */
	public var value(get, set):Float;
	
	private function set_value(val:Float):Float
	{
		if(val <= _maximum && val >= _minimum)
		{
			_value = val;
			invalidate();
		}
		return val;
	}
	private function get_value():Float
	{
		return _value;
	}

	/**
	 * Sets / gets the amount the value will change when the up or down button is pressed. Must be zero or positive.
	 */
	public var step(get, set):Float;
	
	private function set_step(value:Float):Float
	{
		if(value < 0) 
		{
			throw "NumericStepper step must be positive.";
		}
		_step = value;
		return value;
	}
	private function get_step():Float
	{
		return _step;
	}

	/**
	 * Sets / gets how many decimal points of precision will be shown.
	 */
	public var labelPrecision(get, set):Int;
	
	private function set_labelPrecision(value:Int):Int
	{
		_labelPrecision = value;
		invalidate();
		return value;
	}
	private function get_labelPrecision():Int
	{
		return _labelPrecision;
	}

	/**
	 * Sets / gets the maximum value for this component.
	 */
	public var maximum(get, set):Float;
	
	private function set_maximum(value:Float):Float
	{
		_maximum = value;
		if(_value > _maximum)
		{
			_value = _maximum;
			invalidate();
		}
		return value;
	}
	private function get_maximum():Float
	{
		return _maximum;
	}

	/**
	 * Sets / gets the maximum value for this component.
	 */
	public var minimum(get, set):Float;
	
	private function set_minimum(value:Float):Float
	{
		_minimum = value;
		if(_value < _minimum)
		{
			_value = _minimum;
			invalidate();
		}
		return value;
	}
	private function get_minimum():Float
	{
		return _minimum;
	}

	/**
	 * Gets/sets the update rate that the stepper will change its value if a button is held down.
	 */
	public var repeatTime(get, set):Int;
	
	private function get_repeatTime():Int
	{
		return _repeatTime;
	}

	private function set_repeatTime(value:Int):Int
	{
		// shouldn't be any need to set it faster than 10 ms. guard against negative.
		_repeatTime = Std.int(Math.max(value, 10));
		_repeatTimer.delay = _repeatTime;
		return value;
	}
}