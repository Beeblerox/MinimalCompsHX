/**
* LineChart.as
* Keith Peters
* version 0.9.10
* 
* A chart component for graphing an array of numeric data as a line graph.
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

class LineChart extends Chart
{
	
	public var lineWidth(getLineWidth, setLineWidth):Float;
	public var lineColor(getLineColor, setLineColor):Int;
	
	var _lineWidth:Float;
	var _lineColor:Int;
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this Label.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param data The array of numeric values to graph.
	 */
	public function new(?parent:Dynamic = null, ?xpos:Float = 0, ?ypos:Float = 0, ?data:Array<Float> = null)
	{
		_lineWidth = 1;
		_lineColor = 0x999999;
		
		super(parent, xpos, ypos, data);
	}
	
	/**
	 * Graphs the numeric data in the chart.
	 */
	override function drawChart():Void
	{
		var border:Float = 2;
		var lineWidth:Float = (_width - border) / (_data.length - 1);
		var chartHeight:Float = _height - border;
		_chartHolder.x = 0;
		_chartHolder.y = _height;
		var xpos:Float = border;
		var max:Float = getMaxValue();
		var min:Float = getMinValue();
		var scale:Float = chartHeight / (max - min);
		_chartHolder.graphics.lineStyle(_lineWidth, _lineColor);
		_chartHolder.graphics.moveTo(xpos, (_data[0] - min) * -scale);
		xpos += lineWidth;
		for (i in 1..._data.length)
		{
			if(!Math.isNaN(_data[i]))
			{
				_chartHolder.graphics.lineTo(xpos, (_data[i] - min) * -scale);
			}
			xpos += lineWidth;
		}
	}

	
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	/**
	 * Sets/gets the width of the line in the graph.
	 */
	public function setLineWidth(value:Float):Float
	{
		_lineWidth = value;
		invalidate();
		return value;
	}
	
	public function getLineWidth():Float
	{
		return _lineWidth;
	}

	/**
	 * Sets/gets the color of the line in the graph.
	 */
	public function setLineColor(value:Int):Int
	{
		if (value >= 0)
		{
			_lineColor = value;
			invalidate();
		}
		return value;
	}
	
	public function getLineColor():Int
	{
		return _lineColor;
	}


}