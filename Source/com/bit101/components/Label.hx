/**
* Label.as
* Keith Peters
* version 0.9.10
* 
* A Label component for displaying a single line of text.
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
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import openfl.Assets;

class Label extends Component
{
	private var _autoSize:Bool = true;
	private var _text:String = "";
	private var _tf:TextField;
	
	#if !flash
	var _clickableArea:Sprite;
	#end
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this Label.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param text The string to use as the initial text in this component.
	 */
	public function new(parent:DisplayObjectContainer = null, xpos:Float = 0, ypos:Float =  0, text:String = "")
	{
		this.text = text;
		
		#if !flash
		_clickableArea = new Sprite();
		#end
		
		super(parent, xpos, ypos);
	}
	
	/**
	 * Initializes the component.
	 */
	override function init():Void
	{
		super.init();
		mouseEnabled = false;
		mouseChildren = false;
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override function addChildren():Void
	{
		_height = 18;
		_tf = new TextField();
		_tf.height = _height;
		_tf.embedFonts = Style.embedFonts;
		_tf.selectable = false;
		_tf.mouseEnabled = false;
		_tf.defaultTextFormat = new TextFormat(Style.fontName, Style.fontSize, Style.LABEL_TEXT);
		_tf.text = _text;			
		addChild(_tf);
		draw();
		
		#if !flash
		addChild(_clickableArea);
		_clickableArea.alpha = 0.0;
		#end
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
		_tf.text = _text;
		if(_autoSize)
		{
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_width = _tf.width;
			dispatchEvent(new Event(Event.RESIZE));
		}
		else
		{
			_tf.autoSize = TextFieldAutoSize.NONE;
			_tf.width = _width;
		}
		_height = _tf.height = 18;
		
		#if !flash
		_clickableArea.graphics.clear();
		_clickableArea.graphics.beginFill(0);
		_clickableArea.graphics.drawRect(0, 0, _width, height);
		_clickableArea.graphics.endFill();
		#end
	}
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	/**
	 * Gets / sets the text of this Label.
	 */
	public var text(get_text, set_text):String;
	
	private function set_text(t:String):String
	{
		_text = t;
		if(_text == null) _text = "";
		invalidate();
		return t;
	}
	private function get_text():String
	{
		return _text;
	}
	
	/**
	 * Gets / sets whether or not this Label will autosize.
	 */
	public var autoSize(get_autoSize, set_autoSize):Bool;
	
	private function set_autoSize(b:Bool):Bool
	{
		_autoSize = b;
		return b;
	}
	private function get_autoSize():Bool
	{
		return _autoSize;
	}
	
	/**
	 * Gets the internal TextField of the label if you need to do further customization of it.
	 */
	public var textField(get_textField, null):TextField;
	
	private function get_textField():TextField
	{
		return _tf;
	}
}