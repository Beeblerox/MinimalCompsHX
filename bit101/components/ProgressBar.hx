/**
* ProgressBar.as
* Keith Peters
* version 0.9.10
* 
* A progress bar component for showing a changing value in relation to a total.
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

class ProgressBar extends Component
{
	
	public var maximum(getMaximum, setMaximum):Float;
	public var value(getValue, setValue):Float;
	
	var _back:Sprite;
	var _bar:Sprite;
	var _value:Float;
	var _max:Float;

	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this ProgressBar.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 */
	public function new(?parent:Dynamic = null, ?xpos:Float = 0, ?ypos:Float =  0)
	{
		_value = 0;
		_max = 1;
		
		super(parent, xpos, ypos);
	}
	
	
	/**
	 * Initializes the component.
	 */
	override function init():Void
	{
		super.init();
		setSize(100, 10);
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override function addChildren():Void
	{
		_back = new Sprite();
		#if flash
		_back.filters = [getShadow(2, true)];
		#end
		addChild(_back);
		
		_bar = new Sprite();
		_bar.x = 1;
		_bar.y = 1;
		#if flash
		_bar.filters = [getShadow(1)];
		#end
		addChild(_bar);
	}
	
	/**
	 * Updates the size of the progress bar based on the current value.
	 */
	function update():Void
	{
		_bar.scaleX = _value / _max;
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
		_back.graphics.clear();
		_back.graphics.beginFill(Style.BACKGROUND);
		_back.graphics.drawRect(0, 0, _width, _height);
		_back.graphics.endFill();
		
		_bar.graphics.clear();
		_bar.graphics.beginFill(Style.PROGRESS_BAR);
		_bar.graphics.drawRect(0, 0, _width - 2, _height - 2);
		_bar.graphics.endFill();
		update();
	}
	
	
	
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	/**
	 * Gets / sets the maximum value of the ProgressBar.
	 */
	public function setMaximum(m:Float):Float
	{
		_max = m;
		_value = Math.min(_value, _max);
		update();
		return m;
	}
	
	public function getMaximum():Float
	{
		return _max;
	}
	
	/**
	 * Gets / sets the current value of the ProgressBar.
	 */
	public function setValue(v:Float):Float
	{
		_value = Math.min(v, _max);
		update();
		return v;
	}
	
	public function getValue():Float
	{
		return _value;
	}
	
}