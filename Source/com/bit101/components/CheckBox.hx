/**
* CheckBox.as
* Keith Peters
* version 0.9.10
* 
* A basic CheckBox component.
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
import flash.events.Event;
import flash.events.MouseEvent;

class CheckBox extends Component
{
	
	public var label(getLabel, setLabel):String;
	public var selected(getSelected, setSelected):Bool;
	
	var _back:Sprite;
	var _button:Sprite;
	var _label:Label;
	var _labelText:String;
	var _selected:Bool;
	
	#if !flash
	var _clickableArea:Sprite;
	#end
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this CheckBox.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param label String containing the label for this component.
	 * @param defaultHandler The event handling function to handle the default event for this component (click in this case).
	 */
	public function new(?parent:Dynamic = null, ?xpos:Float = 0, ?ypos:Float =  0, ?label:String = "", ?defaultHandler:Dynamic->Void = null)
	{
		_labelText = "";
		_selected = false;
		
		#if !flash
		_clickableArea = new Sprite();
		#end
		
		_labelText = label;
		super(parent, xpos, ypos);
		
		if(defaultHandler != null)
		{
			addEventListener(MouseEvent.CLICK, defaultHandler);
		}
	}
	
	/**
	 * Initializes the component.
	 */
	override function init():Void
	{
		super.init();
		buttonMode = true;
		useHandCursor = true;
		mouseChildren = false;
	}
	
	/**
	 * Creates the children for this component
	 */
	override function addChildren():Void
	{
		_back = new Sprite();
		addChild(_back);
		
		_button = new Sprite();
		_button.visible = false;
		addChild(_button);
		
		#if flash
		_back.filters = [getShadow(2, true)];
		_button.filters = [getShadow(1)];
		#end
		
		_label = new Label(this, 0, 0, _labelText);
		draw();
		
		#if !flash
		addChild(_clickableArea);
		_clickableArea.alpha = 0.0;
		#end
		
		addEventListener(MouseEvent.CLICK, onClick);
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
		_back.graphics.drawRect(0, 0, 10, 10);
		_back.graphics.endFill();
		
		_button.graphics.clear();
		_button.graphics.beginFill(Style.LABEL_TEXT);
		_button.graphics.drawRect(2, 2, 6, 6);
		
		_label.text = _labelText;
		_label.draw();
		_label.x = 12;
		_label.y = (10 - _label.height) / 2;
		_width = _label.width + 12;
		_height = 10;
		
		#if !flash
		_clickableArea.graphics.clear();
		_clickableArea.graphics.beginFill(0);
		_clickableArea.graphics.drawRect(0, 0, _width, height);
		_clickableArea.graphics.endFill();
		#end
	}
	
	
	
	
	///////////////////////////////////
	// event handler
	///////////////////////////////////
	
	/**
	 * Internal click handler.
	 * @param event The MouseEvent passed by the system.
	 */
	function onClick(event:MouseEvent):Void
	{
		_selected = !_selected;
		_button.visible = _selected;
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	
	
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	/**
	 * Sets / gets the label text shown on this CheckBox.
	 */
	public function setLabel(str:String):String
	{
		_labelText = str;
		invalidate();
		return str;
	}
	
	public function getLabel():String
	{
		return _labelText;
	}
	
	/**
	 * Sets / gets the selected state of this CheckBox.
	 */
	public function setSelected(s:Bool):Bool
	{
		_selected = s;
		_button.visible = _selected;
		dispatchEvent(new Event(Event.CHANGE));
		return s;
	}
	
	public function getSelected():Bool
	{
		return _selected;
	}

	/**
	 * Sets/gets whether this component will be enabled or not.
	 */
	public override function setEnabled(value:Bool):Bool
	{
		super.setEnabled(value);
		mouseChildren = false;
		return value;
	}
	
	override public function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void
	{
		#if flash
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		#else
		_clickableArea.addEventListener(type, listener, useCapture, priority, useWeakReference);
		#end
	}
	
	override public function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false):Void
	{
		#if flash
		super.removeEventListener(type, listener, useCapture);
		#else
		_clickableArea.removeEventListener(type, listener, useCapture);
		#end
	}

}