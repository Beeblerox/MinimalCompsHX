/**
* Chart.as
* Keith Peters
* version 0.9.10
* 
* A base chart component for graphing an array of numeric data.
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

import com.bit101.components.Component;
import com.bit101.components.Label;
import com.bit101.components.Panel;

import flash.display.Shape;

class Chart extends Component
{
	
	public var data(getData, setData):Array<Dynamic>;
	public var maximum(getMaximum, setMaximum):Float;
	public var minimum(getMinimum, setMinimum):Float;
	public var autoScale(getAutoScale, setAutoScale):Bool;
	public var showScaleLabels(getShowScaleLabels, setShowScaleLabels):Bool;
	public var labelPrecision(getLabelPrecision, setLabelPrecision):Int;
	public var gridSize(getGridSize, setGridSize):Int;
	public var showGrid(getShowGrid, setShowGrid):Bool;
	public var gridColor(getGridColor, setGridColor):Int;
	
	var _data:Array<Dynamic>;
	var _chartHolder:Shape;
	var _maximum:Float;
	var _minimum:Float;
	var _autoScale:Bool;
	var _maxLabel:Label;
	var _minLabel:Label;
	var _showScaleLabels:Bool;
	var _labelPrecision:Int;
	var _panel:Panel;
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this Label.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param data The array of numeric values to graph.
	 */
	public function new(?parent:Dynamic = null, ?xpos:Float = 0, ?ypos:Float = 0, ?data:Array<Dynamic> = null)
	{
		_maximum = 100;
		_minimum = 0;
		_autoScale = true;
		_showScaleLabels = false;
		_labelPrecision = 0;
		
		_data = data;
		super(parent, xpos, ypos);
	}
	
	/**
	 * Initializes the component.
	 */
	override function init():Void
	{
		super.init();
		setSize(200, 100);
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override function addChildren():Void
	{
		super.addChildren();
		_panel = new Panel(this);
		
		_chartHolder = new Shape();
		_panel.content.addChild(_chartHolder);
		
		_maxLabel = new Label();
		_minLabel = new Label();
	}
	
	/**
	 * Graphs the numeric data in the chart. Override in subclasses.
	 */
	function drawChart():Void
	{
	}
	
	/**
	 * Gets the highest value of the numbers in the data array.
	 */
	function getMaxValue():Float
	{
		if (!_autoScale) return _maximum;
		var maxValue:Float = Math.NEGATIVE_INFINITY;
		for (i in 0..._data.length)
		{
			if(!Math.isNaN(_data[i]))
			{
				maxValue = Math.max(_data[i], maxValue);
			}
		}
		return maxValue;
	}
	
	/**
	 * Gets the lowest value of the numbers in the data array.
	 */
	function getMinValue():Float
	{
		if (!_autoScale) return _minimum;
		var minValue:Float = Math.POSITIVE_INFINITY;
		for (i in 0..._data.length)
		{
			if(!Math.isNaN(_data[i]))
			{
				minValue = Math.min(_data[i], minValue);
			}
		}
		return minValue;
	}
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/**
	 * Draws the visual ui of the component.
	 */
	public override function draw():Void
	{
		super.draw();
		_panel.setSize(width, height);
		_panel.draw();
		_chartHolder.graphics.clear();
		if(_data != null)
		{
			drawChart();
		
			var mult:Float = Math.pow(10, _labelPrecision);
			var maxVal:Float = Math.round(maximum * mult) / mult;
			_maxLabel.text = Std.string(maxVal);
			_maxLabel.draw();
			_maxLabel.x = -_maxLabel.width - 5;
			_maxLabel.y = -_maxLabel.height * 0.5; 
			
			var minVal:Float = Math.round(minimum * mult) / mult;
			_minLabel.text = Std.string(minVal);
			_minLabel.draw();
			_minLabel.x = -_minLabel.width - 5;
			_minLabel.y = height - _minLabel.height * 0.5;
		}
	}
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
			
	/**
	 * Sets/gets the data array.
	 */
	public function setData(value:Array<Dynamic>):Array<Dynamic>
	{
		_data = value;
		invalidate();
		return value;
	}
	
	public function getData():Array<Dynamic>
	{
		return _data;
	}

	/**
	 * Sets/gets the maximum value of the graph. Only used if autoScale is false.
	 */
	public function setMaximum(value:Float):Float
	{
		_maximum = value;
		invalidate();
		return value;
	}
	
	public function getMaximum():Float
	{
		if(_autoScale) return getMaxValue();
		return _maximum;
	}

	/**
	 * Sets/gets the minimum value of the graph. Only used if autoScale is false.
	 */
	public function setMinimum(value:Float):Float
	{
		_minimum = value;
		invalidate();
		return value;
	}
	
	public function getMinimum():Float
	{
		if(_autoScale) return getMinValue();
		return _minimum;
	}

	/**
	 * Sets/gets whether the graph will automatically set its own max and min values based on the data values.
	 */
	public function setAutoScale(value:Bool):Bool
	{
		_autoScale = value;
		invalidate();
		return value;
	}
	
	public function getAutoScale():Bool
	{
		return _autoScale;
	}

	/**
	 * Sets/gets whether or not labels for max and min graph values will be shown.
	 * Note: these labels will be to the left of the x position of the chart. Chart position may need adjusting.
	 */
	public function setShowScaleLabels(value:Bool):Bool
	{
		_showScaleLabels = value;
		if(_showScaleLabels )
		{
			addChild(_maxLabel);
			addChild(_minLabel);
		}
		else
		{
			if(contains(_maxLabel)) removeChild(_maxLabel);
			if(contains(_minLabel)) removeChild(_minLabel);
		}
		return value;
	}
	
	public function getShowScaleLabels():Bool
	{
		return _showScaleLabels;
	}

	/**
	 * Sets/gets the amount of decimal places shown in the scale labels.
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
	 * Sets / gets the size of the grid.
	 */
	public function setGridSize(value:Int):Int
	{
		_panel.gridSize = value;
		invalidate();
		return value;
	}
	
	public function getGridSize():Int
	{
		return _panel.gridSize;
	}
	
	/**
	 * Sets / gets whether or not the grid will be shown.
	 */
	public function setShowGrid(value:Bool):Bool
	{
		_panel.showGrid = value;
		invalidate();
		return value;
	}
	
	public function getShowGrid():Bool
	{
		return _panel.showGrid;
	}
	
	/**
	 * Sets / gets the color of the grid lines.
	 */
	public function setGridColor(value:Int):Int
	{
		if (value >= 0)
		{
			_panel.gridColor = value;
			invalidate();
		}
		return value;
	}
	
	public function getGridColor():Int
	{
		return _panel.gridColor;
	}

}