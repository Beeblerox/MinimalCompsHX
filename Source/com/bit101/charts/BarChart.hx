/**
* BarChart.as
* Keith Peters
* version 0.9.10
* 
* A chart component for graphing an array of numeric data as a bar graph.
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

package com.bit101.charts;

import flash.display.DisplayObjectContainer;

class BarChart extends Chart
{
	private var _spacing:Float = 2;
	private var _barColor:Int = 0x999999;
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this Label.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param data The array of numeric values to graph.
	 */
	public function new(parent:DisplayObjectContainer = null, xpos:Float = 0, ypos:Float = 0, data:Array<Dynamic> = null)
	{
		super(parent, xpos, ypos, data);
	}
	
	/**
	 * Graphs the numeric data in the chart.
	 */
	private override function drawChart():Void
	{
		var border:Float = 2;
		var totalSpace:Float = _spacing * _data.length;
		var barWidth:Float = (_width - border - totalSpace) / _data.length;
		var chartHeight:Float = _height - border;
		_chartHolder.x = 0;
		_chartHolder.y = _height;
		var xpos:Float = border;
		var max:Float = getMaxValue();
		var min:Float = getMinValue();
		var scale:Float = chartHeight / (max - min);
		for(i in 0...(_data.length))
		{
			if(_data[i] != null)
			{
				_chartHolder.graphics.beginFill(_barColor);
				_chartHolder.graphics.drawRect(xpos, 0, barWidth, (_data[i] - min) * -scale);
				_chartHolder.graphics.endFill();
			}
			xpos += barWidth + _spacing;
		}
	}

	
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	/**
	 * Sets/gets the amount of space shown between each bar. If this is too wide, bars may become invisible.
	 */
	public var spacing(get, set):Float;
	
	private function set_spacing(value:Float):Float
	{
		_spacing = value;
		invalidate();
		return value;
	}
	private function get_spacing():Float
	{
		return _spacing;
	}

	/**
	 * Sets/gets the color of the bars.
	 */
	public var barColor(get, set):Int;
	
	private function set_barColor(value:Int):Int
	{
		_barColor = value;
		invalidate();
		return value;
	}
	private function get_barColor():Int
	{
		return _barColor;
	}


}