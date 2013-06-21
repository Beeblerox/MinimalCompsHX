/**
* RotarySelector.as
* Keith Peters
* version 0.9.10
* 
* A rotary selector component for choosing among different values.
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
import flash.events.MouseEvent;

enum RotarySelectorLabelMode
{
	ALPHABETIC;
	NUMERIC;
	ROMAN;
}

class RotarySelector extends Component
{	
	private var _label:Label;
	private var _labelText:String = "";
	private var _knob:Sprite;
	private var _numChoices:Int = 2;
	private var _choice:Int = 0;
	private var _labels:Sprite;
	private var _labelMode:RotarySelectorLabelMode;
	
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this CheckBox.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param label String containing the label for this component.
	 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
	 */
	public function new(parent:DisplayObjectContainer = null, xpos:Float = 0, ypos:Float =  0, label:String = "", defaultHandler:Event->Void = null)
	{
		_labelText = label;
		_labelMode = RotarySelectorLabelMode.ALPHABETIC;
		super(parent, xpos, ypos);
		if(defaultHandler != null)
		{
			addEventListener(Event.CHANGE, defaultHandler);
		}
	}
	
	/**
	 * Initializes the component.
	 */
	override private function init():Void
	{
		super.init();
		setSize(60, 60);
	}
	
	/**
	 * Creates the children for this component
	 */
	override private function addChildren():Void
	{
		_knob = new Sprite();
		_knob.buttonMode = true;
		_knob.useHandCursor = true;
		addChild(_knob);
		
		_label = new Label();
		_label.autoSize = true;
		addChild(_label);
		
		_labels = new Sprite();
		addChild(_labels);
		
		_knob.addEventListener(MouseEvent.CLICK, onClick);
	}
	
	/**
	 * Decrements the index of the current choice.
	 */
	private function decrement():Void
	{
		if(_choice > 0)
		{
			_choice--;
			draw();
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
	
	/**
	 * Increments the index of the current choice.
	 */
	private function increment():Void
	{
		if(_choice < _numChoices - 1)
		{
			_choice++;
			draw();
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
	
	/**
	 * Removes old labels.
	 */
	private function resetLabels():Void
	{
		while(_labels.numChildren > 0)
		{
			_labels.removeChildAt(0);
		}
		_labels.x = _width / 2 - 5;
		_labels.y = _height / 2 - 10;
	}
	
	/**
	 * Draw the knob at the specified radius.
	 * @param radius The radius with which said knob will be drawn.
	 */
	private function drawKnob(radius:Float):Void
	{
		_knob.graphics.clear();
		_knob.graphics.beginFill(Style.BACKGROUND);
		_knob.graphics.drawCircle(0, 0, radius);
		_knob.graphics.endFill();
		
		_knob.graphics.beginFill(Style.BUTTON_FACE);
		_knob.graphics.drawCircle(0, 0, radius - 2);
		
		_knob.x = _width / 2;
		_knob.y = _height / 2;
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
		
		var radius:Float = Math.min(_width, _height) / 2;
		drawKnob(radius);
		resetLabels();
		
		var arc:Float = Math.PI * 1.5 / _numChoices; // the angle between each choice
		var start:Float = - Math.PI / 2 - arc * (_numChoices - 1) / 2; // the starting angle for choice 0
		
		graphics.clear();
		graphics.lineStyle(4, Style.BACKGROUND, .5);
		var angle:Float;
		for(i in 0...(_numChoices))
		{
			angle = start + arc * i;
			var sin:Float = Math.sin(angle);
			var cos:Float = Math.cos(angle);
			
			graphics.moveTo(_knob.x, _knob.y);
			graphics.lineTo(_knob.x + cos * (radius + 2), _knob.y + sin * (radius + 2));
			
			var lab:Label = new Label(_labels, cos * (radius + 10), sin * (radius + 10));
			lab.mouseEnabled = true;
			lab.buttonMode = true;
			lab.useHandCursor = true;
			lab.addEventListener(MouseEvent.CLICK, onLabelClick);
			if(_labelMode == RotarySelectorLabelMode.ALPHABETIC)
			{
				lab.text = String.fromCharCode(65 + i);
			}
			else if(_labelMode == RotarySelectorLabelMode.NUMERIC)
			{
				lab.text = Std.string(i + 1);
			}
			else if(_labelMode == RotarySelectorLabelMode.ROMAN)
			{
				var chars:Array<String> = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"];
				lab.text = chars[i];
			}
			if(i != _choice)
			{
				lab.alpha = 0.5;
			}
		}
		
		angle = start + arc * _choice;
		graphics.lineStyle(4, Style.LABEL_TEXT);
		graphics.moveTo(_knob.x, _knob.y);
		graphics.lineTo(_knob.x + Math.cos(angle) * (radius + 2), _knob.y + Math.sin(angle) * (radius + 2));
		
		
		_label.text = _labelText;
		_label.draw();
		_label.x = _width / 2 - _label.width / 2;
		_label.y = _height + 2;
	}
	
	
	
	///////////////////////////////////
	// event handler
	///////////////////////////////////
	
	/**
	 * Internal click handler.
	 * @param event The MouseEvent passed by the system.
	 */
	private function onClick(event:MouseEvent):Void
	{
		if(mouseX < _width / 2)
		{
			decrement();
		}
		else 
		{
			increment();
		}
	}
	
	private function onLabelClick(event:Event):Void
	{
		var lab:Label = cast(event.target, Label);
		choice = _labels.getChildIndex(lab);
	}
	
	
	
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	/**
	 * Gets / sets the number of available choices (maximum of 10).
	 */
	public var numChoices(get_numChoices, set_numChoices):Int;
	
	private function set_numChoices(value:Int):Int
	{
		_numChoices = Std.int(Math.min(value, 10));
		draw();
		return value;
	}
	private function get_numChoices():Int
	{
		return _numChoices;
	}
	
	/**
	 * Gets / sets the current choice, keeping it in range of 0 to numChoices - 1.
	 */
	public var choice(get_choice, set_choice):Int;
	
	private function set_choice(value:Int):Int
	{
		_choice = Std.int(Math.max(0, Math.min(_numChoices - 1, value)));
		draw();
		dispatchEvent(new Event(Event.CHANGE));
		return value;
	}
	private function get_choice():Int
	{
		return _choice;
	}
	
	/**
	 * Specifies what will be used as labels for each choice. Valid values are "alphabetic", "numeric", and "none".
	 */
	public var labelMode(get_labelMode, set_labelMode):RotarySelectorLabelMode;
	
	private function set_labelMode(value:RotarySelectorLabelMode):RotarySelectorLabelMode
	{
		_labelMode = value;
		draw();
		return value;
	}
	private function get_labelMode():RotarySelectorLabelMode
	{
		return _labelMode;
	}
}