/**
* ScrollBar.as
* Keith Peters
* version 0.9.10
* 
* Base class for HScrollBar and VScrollBar
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
import flash.display.Shape;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.geom.Rectangle;
import com.bit101.components.Slider;
import com.bit101.components.Style;

enum ScrollBarDirection
{
	UP;
	DOWN;
}

class ScrollBar extends Component
{
	private static inline var DELAY_TIME:Int = 500;
	private static inline var REPEAT_TIME:Int = 100; 

	private var _autoHide:Bool = false;
	private var _upButton:PushButton;
	private var _downButton:PushButton;
	private var _scrollSlider:ScrollSlider;
	private var _orientation:SliderOrientation;
	private var _lineSize:Int = 1;
	private var _delayTimer:Timer;
	private var _repeatTimer:Timer;
	private var _direction:ScrollBarDirection;
	private var _shouldRepeat:Bool = false;
	
	/**
	 * Constructor
	 * @param orientation Whether this is a vertical or horizontal slider.
	 * @param parent The parent DisplayObjectContainer on which to add this Slider.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
	 */
	public function new(orientation:SliderOrientation, parent:DisplayObjectContainer = null, xpos:Float = 0, ypos:Float = 0, defaultHandler:Event->Void = null)
	{
		_orientation = orientation;
		super(parent, xpos, ypos);
		if(defaultHandler != null)
		{
			addEventListener(Event.CHANGE, defaultHandler);
		}
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override private function addChildren():Void
	{
		_scrollSlider = new ScrollSlider(_orientation, this, 0, 10, onChange);
		_upButton = new PushButton(this, 0, 0, "");
		_upButton.addEventListener(MouseEvent.MOUSE_DOWN, onUpClick);
		_upButton.setSize(10, 10);
		var upArrow:Shape = new Shape();
		_upButton.addChild(upArrow);
		
		_downButton = new PushButton(this, 0, 0, "");
		_downButton.addEventListener(MouseEvent.MOUSE_DOWN, onDownClick);
		_downButton.setSize(10, 10);
		var downArrow:Shape = new Shape();
		_downButton.addChild(downArrow);
		
		if(_orientation == SliderOrientation.VERTICAL)
		{
			upArrow.graphics.beginFill(Style.DROPSHADOW, 0.5);
			upArrow.graphics.moveTo(5, 3);
			upArrow.graphics.lineTo(7, 6);
			upArrow.graphics.lineTo(3, 6);
			upArrow.graphics.endFill();
			
			downArrow.graphics.beginFill(Style.DROPSHADOW, 0.5);
			downArrow.graphics.moveTo(5, 7);
			downArrow.graphics.lineTo(7, 4);
			downArrow.graphics.lineTo(3, 4);
			downArrow.graphics.endFill();
		}
		else
		{
			upArrow.graphics.beginFill(Style.DROPSHADOW, 0.5);
			upArrow.graphics.moveTo(3, 5);
			upArrow.graphics.lineTo(6, 7);
			upArrow.graphics.lineTo(6, 3);
			upArrow.graphics.endFill();
			
			downArrow.graphics.beginFill(Style.DROPSHADOW, 0.5);
			downArrow.graphics.moveTo(7, 5);
			downArrow.graphics.lineTo(4, 7);
			downArrow.graphics.lineTo(4, 3);
			downArrow.graphics.endFill();
		}

		
	}
	
	/**
	 * Initializes the component.
	 */
	override private function init():Void
	{
		super.init();
		if(_orientation == SliderOrientation.HORIZONTAL)
		{
			setSize(100, 10);
		}
		else
		{
			setSize(10, 100);
		}
		_delayTimer = new Timer(DELAY_TIME, 1);
		_delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
		_repeatTimer = new Timer(REPEAT_TIME);
		_repeatTimer.addEventListener(TimerEvent.TIMER, onRepeat);
	}
	
	
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/**
	 * Convenience method to set the three main parameters in one shot.
	 * @param min The minimum value of the slider.
	 * @param max The maximum value of the slider.
	 * @param value The value of the slider.
	 */
	public function setSliderParams(min:Float, max:Float, value:Float):Void
	{
		_scrollSlider.setSliderParams(min, max, value);
	}
	
	/**
	 * Sets the percentage of the size of the thumb button.
	 */
	public function setThumbPercent(value:Float):Void
	{
		_scrollSlider.setThumbPercent(value);
	}
	
	/**
	 * Draws the visual ui of the component.
	 */
	override public function draw():Void
	{
		super.draw();
		if(_orientation == SliderOrientation.VERTICAL)
		{
			_scrollSlider.x = 0;
			_scrollSlider.y = 10;
			_scrollSlider.width = 10;
			_scrollSlider.height = _height - 20;
			_downButton.x = 0;
			_downButton.y = _height - 10;
		}
		else
		{
			_scrollSlider.x = 10;
			_scrollSlider.y = 0;
			_scrollSlider.width = _width - 20;
			_scrollSlider.height = 10;
			_downButton.x = _width - 10;
			_downButton.y = 0;
		}
		_scrollSlider.draw();
		if(_autoHide)
		{
			visible = _scrollSlider.thumbPercent < 1.0;
		}
		else
		{
			visible = true;
		}
	}

	
	
	
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////

	/**
	 * Sets / gets whether the scrollbar will auto hide when there is nothing to scroll.
	 */
	public var autoHide(get_autoHide, set_autoHide):Bool;
	
	private function set_autoHide(value:Bool):Bool
	{
		_autoHide = value;
		invalidate();
		return value;
	}
	private function get_autoHide():Bool
	{
		return _autoHide;
	}

	/**
	 * Sets / gets the current value of this scroll bar.
	 */
	public var value(get_value, set_value):Float;
	
	private function set_value(v:Float):Float
	{
		_scrollSlider.value = v;
		return v;
	}
	private function get_value():Float
	{
		return _scrollSlider.value;
	}
	
	/**
	 * Sets / gets the minimum value of this scroll bar.
	 */
	public var minimum(get_minimum, set_minimum):Float;
	
	private function set_minimum(v:Float):Float
	{
		_scrollSlider.minimum = v;
		return v;
	}
	private function get_minimum():Float
	{
		return _scrollSlider.minimum;
	}
	
	/**
	 * Sets / gets the maximum value of this scroll bar.
	 */
	public var maximum(get_maximum, set_maximum):Float;
	
	private function set_maximum(v:Float):Float
	{
		_scrollSlider.maximum = v;
		return v;
	}
	private function get_maximum():Float
	{
		return _scrollSlider.maximum;
	}
	
	/**
	 * Sets / gets the amount the value will change when up or down buttons are pressed.
	 */
	public var lineSize(get_lineSize, set_lineSize):Int;
	
	private function set_lineSize(value:Int):Int
	{
		_lineSize = value;
		return value;
	}
	private function get_lineSize():Int
	{
		return _lineSize;
	}
	
	/**
	 * Sets / gets the amount the value will change when the back is clicked.
	 */
	public var pageSize(get_pageSize, set_pageSize):Int;
	
	private function set_pageSize(value:Int):Int
	{
		_scrollSlider.pageSize = value;
		invalidate();
		return value;
	}
	private function get_pageSize():Int
	{
		return _scrollSlider.pageSize;
	}
	

	
	
	
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	private function onUpClick(event:MouseEvent):Void
	{
		goUp();
		_shouldRepeat = true;
		_direction = ScrollBarDirection.UP;
		_delayTimer.start();
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
	}
	
	private function goUp():Void
	{
		_scrollSlider.value -= _lineSize;
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	private function onDownClick(event:MouseEvent):Void
	{
		goDown();
		_shouldRepeat = true;
		_direction = ScrollBarDirection.DOWN;
		_delayTimer.start();
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
	}
	
	private function goDown():Void
	{
		_scrollSlider.value += _lineSize;
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	private function onMouseGoUp(event:MouseEvent):Void
	{
		_delayTimer.stop();
		_repeatTimer.stop();
		_shouldRepeat = false;
	}
	
	private function onChange(event:Event):Void
	{
		dispatchEvent(event);
	}
	
	private function onDelayComplete(event:TimerEvent):Void
	{
		if(_shouldRepeat)
		{
			_repeatTimer.start();
		}
	}
	
	private function onRepeat(event:TimerEvent):Void
	{
		if(_direction == UP)
		{
			goUp();
		}
		else
		{
			goDown();
		}
	}
}



/**
* Helper class for the slider portion of the scroll bar.
*/
class ScrollSlider extends Slider
{
	private var _thumbPercent:Float = 1.0;
	private var _pageSize:Int = 1;

	/**
	 * Constructor
	 * @param orientation Whether this is a vertical or horizontal slider.
	 * @param parent The parent DisplayObjectContainer on which to add this Slider.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
	 */
	public function new(orientation:SliderOrientation, parent:DisplayObjectContainer = null, xpos:Float = 0, ypos:Float = 0, defaultHandler:Event->Void = null)
	{
		super(orientation, parent, xpos, ypos);
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
		setSliderParams(1, 1, 0);
		backClick = true;
	}

	/**
	 * Draws the handle of the slider.
	 */
	override private function drawHandle():Void
	{
		var size:Float;
		_handle.graphics.clear();
		if (_orientation == SliderOrientation.HORIZONTAL)
		{
			size = Math.round(_width * _thumbPercent);
			size = Math.max(_height, size);
			_handle.graphics.beginFill(0, 0);
			_handle.graphics.drawRect(0, 0, size, _height);
			_handle.graphics.endFill();
			_handle.graphics.beginFill(Style.BUTTON_FACE);
			_handle.graphics.drawRect(1, 1, size - 2, _height - 2);
		}
		else
		{
			size = Math.round(_height * _thumbPercent);
			size = Math.max(_width, size);
			_handle.graphics.beginFill(0, 0);
			_handle.graphics.drawRect(0, 0, _width  - 2, size);
			_handle.graphics.endFill();
			_handle.graphics.beginFill(Style.BUTTON_FACE);
			_handle.graphics.drawRect(1, 1, _width - 2, size - 2);
		}
		_handle.graphics.endFill();
		positionHandle();
	}

	/**
	 * Adjusts position of handle when value, maximum or minimum have changed.
	 * TODO: Should also be called when slider is resized.
	 */
	private override function positionHandle():Void
	{
		var range:Float;
		if(_orientation == SliderOrientation.HORIZONTAL)
		{
			range = width - _handle.width;
			_handle.x = (_value - _min) / (_max - _min) * range;
		}
		else
		{
			range = height - _handle.height;
			_handle.y = (_value - _min) / (_max - _min) * range;
		}
		
		if (_handle.x < 0 || Math.isNaN(_handle.x))
		{
			_handle.x = 0;
		}
		
		if (_handle.y < 0 || Math.isNaN(_handle.y))
		{
			_handle.y = 0;
		}
	}



	///////////////////////////////////
	// public methods
	///////////////////////////////////

	/**
	 * Sets the percentage of the size of the thumb button.
	 */
	public function setThumbPercent(value:Float):Float
	{
		_thumbPercent = Math.min(value, 1.0);
		invalidate();
		return value;
	}





	///////////////////////////////////
	// event handlers
	///////////////////////////////////

	/**
	 * Handler called when user clicks the background of the slider, causing the handle to move to that point. Only active if backClick is true.
	 * @param event The MouseEvent passed by the system.
	 */
	private override function onBackClick(event:MouseEvent):Void
	{
		if(_orientation == SliderOrientation.HORIZONTAL)
		{
			if(mouseX < _handle.x)
			{
				if(_max > _min)
				{
					_value -= _pageSize;
				}
				else
				{
					_value += _pageSize;
				}
				correctValue();
			}
			else
			{
				if(_max > _min)
				{
					_value += _pageSize;
				}
				else
				{
					_value -= _pageSize;
				}
				correctValue();
			}
			positionHandle();
		}
		else
		{
			if(mouseY < _handle.y)
			{
				if(_max > _min)
				{
					_value -= _pageSize;
				}
				else
				{
					_value += _pageSize;
				}
				correctValue();
			}
			else
			{
				if(_max > _min)
				{
					_value += _pageSize;
				}
				else
				{
					_value -= _pageSize;
				}
				correctValue();
			}
			positionHandle();
		}
		dispatchEvent(new Event(Event.CHANGE));
		
	}

	/**
	 * Internal mouseDown handler. Starts dragging the handle.
	 * @param event The MouseEvent passed by the system.
	 */
	private override function onDrag(event:MouseEvent):Void
	{
		stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlide);
		if(_orientation == HORIZONTAL)
		{
			_handle.startDrag(false, new Rectangle(0, 0, _width - _handle.width, 0));
		}
		else
		{
			_handle.startDrag(false, new Rectangle(0, 0, 0, _height - _handle.height));
		}
	}

	/**
	 * Internal mouseMove handler for when the handle is being moved.
	 * @param event The MouseEvent passed by the system.
	 */
	private override function onSlide(event:MouseEvent):Void
	{
		var oldValue:Float = _value;
		if(_orientation == HORIZONTAL)
		{
			if(_width == _handle.width)
			{
				_value = _min;
			}
			else
			{
				_value = _handle.x / (_width - _handle.width) * (_max - _min) + _min;
			}
		}
		else
		{
			if(_height == _handle.height)
			{
				_value = _min;
			}
			else
			{
				_value = _handle.y / (_height - _handle.height) * (_max - _min) + _min;
			}
		}
		if(_value != oldValue)
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
	}





	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
		
	/**
	 * Sets / gets the amount the value will change when the back is clicked.
	 */
	public var pageSize(get_pageSize, set_pageSize):Int;
	
	private function set_pageSize(value:Int):Int
	{
		_pageSize = value;
		invalidate();
		return value;
	}
	private function get_pageSize():Int
	{
		return _pageSize;
	}
	
	public var thumbPercent(get_thumbPercent, null):Float;
	
	private function get_thumbPercent():Float
	{
		return _thumbPercent;
	}
}