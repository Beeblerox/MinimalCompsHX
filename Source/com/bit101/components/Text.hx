/**
* Text.as
* Keith Peters
* version 0.9.10
* 
* A Text component for displaying multiple lines of text.
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
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;

class Text extends Component
{
	private var _tf:TextField;
	private var _text:String = "";
	private var _editable:Bool = true;
	private var _panel:Panel;
	private var _selectable:Bool = true;
	private var _html:Bool = false;
	private var _format:TextFormat;
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this Label.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param text The initial text to display in this component.
	 */
	public function new(parent:DisplayObjectContainer = null, xpos:Float = 0, ypos:Float = 0, text:String = "")
	{
		this.text = text;
		super(parent, xpos, ypos);
		setSize(200, 100);
	}
	
	/**
	 * Initializes the component.
	 */
	override private function init():Void
	{
		super.init();
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override private function addChildren():Void
	{
		_panel = new Panel(this);
		_panel.color = Style.TEXT_BACKGROUND;
		
		_format = new TextFormat(Style.fontName, Style.fontSize, Style.LABEL_TEXT);
		
		_tf = new TextField();
		_tf.x = 2;
		_tf.y = 2;
		_tf.height = _height;
		_tf.embedFonts = Style.embedFonts;
		_tf.multiline = true;
		_tf.wordWrap = true;
		_tf.selectable = true;
		_tf.type = TextFieldType.INPUT;
		_tf.defaultTextFormat = _format;
		_tf.addEventListener(Event.CHANGE, onChange);			
		addChild(_tf);
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
		
		_panel.setSize(_width, _height);
		_panel.draw();
		
		_tf.width = _width - 4;
		_tf.height = _height - 4;
		if(_html)
		{
			_tf.htmlText = _text;
		}
		else
		{
			_tf.text = _text;
		}
		if(_editable)
		{
			_tf.mouseEnabled = true;
			_tf.selectable = true;
			_tf.type = TextFieldType.INPUT;
		}
		else
		{
			_tf.mouseEnabled = _selectable;
			_tf.selectable = _selectable;
			_tf.type = TextFieldType.DYNAMIC;
		}
		_tf.setTextFormat(_format);
	}
	
	
	
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Called when the text in the text field is manually changed.
	 */
	private function onChange(event:Event):Void
	{
		_text = _tf.text;
		dispatchEvent(event);
	}
	
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
	 * Returns a reference to the internal text field in the component.
	 */
	public var textField(get_textField, null):TextField;
	
	private function get_textField():TextField
	{
		return _tf;
	}
	
	/**
	 * Gets / sets whether or not this text component will be editable.
	 */
	public var editable(get_editable, set_editable):Bool;
	
	private function set_editable(b:Bool):Bool
	{
		_editable = b;
		invalidate();
		return b;
	}
	private function get_editable():Bool
	{
		return _editable;
	}
	
	/**
	 * Gets / sets whether or not this text component will be selectable. Only meaningful if editable is false.
	 */
	public var selectable(get_selectable, set_selectable):Bool;
	
	private function set_selectable(b:Bool):Bool
	{
		_selectable = b;
		invalidate();
		return b;
	}
	public function get_selectable():Bool
	{
		return _selectable;
	}
	
	/**
	 * Gets / sets whether or not text will be rendered as HTML or plain text.
	 */
	public var html(get_html, set_html):Bool;
	
	private function set_html(b:Bool):Bool
	{
		_html = b;
		invalidate();
		return b;
	}
	private function get_html():Bool
	{
		return _html;
	}

	/**
	 * Sets/gets whether this component is enabled or not.
	 */
	override private function set_enabled(value:Bool):Bool
	{
		super.enabled = value;
		#if flash
		_tf.tabEnabled = value;
		#end
		return value;
	}

}