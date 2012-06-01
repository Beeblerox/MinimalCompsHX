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

#if flash
import flash.errors.Error;
#end

import flash.events.Event;
import flash.events.MouseEvent;
//import flash.events.TimerEvent;
//import flash.utils.Timer;
import haxe.Timer;

class NumericStepper extends Component
{
	
	public var value(getValue, setValue):Float;
	public var step(getStep, setStep):Int;
	public var labelPrecision(getLabelPrecision, setLabelPrecision):Int;
	public var maximum(getMaximum, setMaximum):Float;
	public var minimum(getMinimum, setMinimum):Float;
	public var repeatTime(getRepeatTime, setRepeatTime):Int;
	
	private var DELAY_TIME:Int;
	private var UP:String;
	private var DOWN:String;
	var _minusBtn:PushButton;

	var _repeatTime:Int;
	var _plusBtn:PushButton;
	var _valueText:InputText;
	var _value:Float;
	var _step:Int;
	var _labelPrecision:Int;
	var _maximum:Float;
	var _minimum:Float;
	var _delayTimer:Timer;
	var _repeatTimer:Timer;
	var _direction:String;
	var _numRepeats:Int;
	var _isRepeatTimerRunning:Bool;
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this Slider.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
	 */
	public function new(?parent:Dynamic = null, ?xpos:Float = 0, ?ypos:Float = 0, ?defaultHandler:Dynamic->Void = null)
	{
		DELAY_TIME = 500;
		UP = "up";
		DOWN = "down";
		
		_repeatTime = 100;
		_value = 0;
		_step = 1;
		_labelPrecision = 1;
		_maximum = Math.POSITIVE_INFINITY;
		_minimum = Math.NEGATIVE_INFINITY;
		
		_isRepeatTimerRunning = false;
		
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
		setSize(80, 16);
		//_delayTimer = new Timer(DELAY_TIME, 1);
		//_delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
		//_repeatTimer = new Timer(_repeatTime);
		//_repeatTimer.addEventListener(TimerEvent.TIMER, onRepeat);
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override function addChildren():Void
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
	
	function increment():Void
	{
		if(_value + _step <= _maximum)
		{
			_value += _step;
			invalidate();
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
	
	function decrement():Void
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
	function onMinus(event:MouseEvent):Void
	{
		decrement();
		_direction = DOWN;
		_delayTimer = Timer.delay(onDelayComplete, DELAY_TIME);
		//_delayTimer.start();
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
	}
	
	/**
	 * Called when the plus button is pressed. Increments the value by the step amount.
	 */
	function onPlus(event:MouseEvent):Void
	{
		increment();
		_direction = UP;
		_delayTimer = Timer.delay(onDelayComplete, DELAY_TIME);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
	}
	
	function onMouseGoUp(event:MouseEvent):Void
	{
		if (_delayTimer != null) _delayTimer.stop();
		if (_repeatTimer != null) _repeatTimer.stop();
		_isRepeatTimerRunning = false;
	}
	
	/**
	 * Called when the value is changed manually.
	 */
	function onValueTextChange(event:Event):Void
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

	function onDelayComplete(/*event:TimerEvent*/):Void
	{
		if (_repeatTimer != null)
		{
			_repeatTimer.stop();
		}
		_repeatTimer = new Timer(_repeatTime);
		_repeatTimer.run = onRepeat;
		_isRepeatTimerRunning = true;
		//_repeatTimer.start();
	}

	function onRepeat(/*event:TimerEvent*/):Void
	{
		if(_direction == UP)
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
	public function setValue(val:Float):Float
	{
		if(val <= _maximum && val >= _minimum)
		{
			_value = val;
			invalidate();
		}
		return val;
	}
	
	public function getValue():Float
	{
		return _value;
	}

	/**
	 * Sets / gets the amount the value will change when the up or down button is pressed. Must be zero or positive.
	 */
	public function setStep(value:Int):Int
	{
		if(value < 0) 
		{
			#if flash
			throw new Error("NumericStepper step must be positive.");
			#else
			throw "NumericStepper step must be positive.";
			#end
		}
		_step = value;
		return value;
	}
	
	public function getStep():Int
	{
		return _step;
	}

	/**
	 * Sets / gets how many decimal points of precision will be shown.
	 */
	public function setLabelPrecision(value:Int):Int
	{
		_labelPrecision = value;
		invalidate();
		return value;
	}
	
	public function getLabelPrecision():Int
	{
		return _labelPrecision;
	}

	/**
	 * Sets / gets the maximum value for this component.
	 */
	public function setMaximum(value:Float):Float
	{
		_maximum = value;
		if(_value > _maximum)
		{
			_value = _maximum;
			invalidate();
		}
		return value;
	}
	
	public function getMaximum():Float
	{
		return _maximum;
	}

	/**
	 * Sets / gets the maximum value for this component.
	 */
	public function setMinimum(value:Float):Float
	{
		_minimum = value;
		if(_value < _minimum)
		{
			_value = _minimum;
			invalidate();
		}
		return value;
	}
	
	public function getMinimum():Float
	{
		return _minimum;
	}

	/**
	 * Gets/sets the update rate that the stepper will change its value if a button is held down.
	 */
	public function getRepeatTime():Int
	{
		return _repeatTime;
	}

	public function setRepeatTime(value:Int):Int
	{
		// shouldn't be any need to set it faster than 10 ms. guard against negative.
		_repeatTime = Std.int(Math.max(value, 10));
		if (_isRepeatTimerRunning)
		{
			_repeatTimer.stop();
			_repeatTimer = new Timer(_repeatTime);
			_repeatTimer.run = onRepeat;
		}
		//_repeatTimer.delay = _repeatTime;
		return value;
	}
}