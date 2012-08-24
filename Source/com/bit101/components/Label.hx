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

import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.display.Sprite;

class Label extends Component
{
	
	public var autoSize(getAutoSize, setAutoSize):Bool;
	public var text(getText, setText):String;
	public var align(getAlign, setAlign):String;
	public var textField(getTextField, null):TextField;
	
	var _autoSize:Bool;
	var _text:String;
	var _tf:TextField;
	var _align:String;
	
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
	public function new(?parent:Dynamic = null, ?xpos:Float = 0, ?ypos:Float =  0, ?text:String = "")
	{
		//this.text = text;
		_autoSize = true;
		_text = "";
		_align = "left";
		_text = text;
		
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
		#if flash
		_tf.embedFonts = Style.embedFonts;
		#end
		_tf.selectable = false;
		_tf.mouseEnabled = false;
		var format:TextFormat = new TextFormat(Style.fontName, Style.fontSize, Style.LABEL_TEXT);
		Reflect.setField(format, "align", _align);
		//_tf.defaultTextFormat = new TextFormat(Style.fontName, Style.fontSize, Style.LABEL_TEXT, null, null, null, null, null, _align);
		_tf.defaultTextFormat = format;
		//_tf.antiAliasType = Style.fontName == "PF Ronda Seven" ? 'normal' : 'advanced';
		var antiAliasType:String = (Style.fontName == "PF Ronda Seven") ? 'normal' : 'advanced';
		#if flash
		Reflect.setField(_tf, "antiAliasType", antiAliasType);
 		_tf.sharpness = 400;
		#end
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

  public function setFormat (format : Dynamic) : TextFormat
  {
    var name = _tf.defaultTextFormat.font;
    var size = _tf.defaultTextFormat.size;
    var color = _tf.defaultTextFormat.color;
    var align = _tf.defaultTextFormat.align;
    var bold = _tf.defaultTextFormat.bold;

    if (format.hasOwnProperty ("font"))
    {
      name = Reflect.field (format, "font");
    }
    if (format.hasOwnProperty ("size"))
    {
      size = Reflect.field (format, "size");
    }
    if (format.hasOwnProperty ("color"))
    {
      color = Reflect.field (format, "color");
    }
    if (format.hasOwnProperty ("align"))
    {
      align = Reflect.field (format, "align");
    }
    if (format.hasOwnProperty ("bold"))
    {
      bold = Reflect.field (format, "bold");
    }
      
		var f:TextFormat = new TextFormat (name, size, color, bold, null, null, null, null, align);
    _tf.defaultTextFormat = f;
    return f;
  }
	
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
			_width = Std.int(_tf.width);
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
	public function setText(t:String):String
	{
		_text = t;
		if(_text == null) _text = "";
		invalidate();
		return t;
	}
	
	public function getText():String
	{
		return _text;
	}
	
	/**
	 * Gets / sets whether or not this Label will autosize.
	 */
	public function setAutoSize(b:Bool):Bool
	{
		_autoSize = b;
		return b;
	}
	
	public function getAutoSize():Bool
	{
		return _autoSize;
	}
	
	/**
	 * Gets the internal TextField of the label if you need to do further customization of it.
	 */
	public function getTextField():TextField
	{
		return _tf;
	}
	
	override public function setWidth(value:Float):Float 
	{
		_autoSize = false;
		super.setWidth(value);
		return value;
	}
	
	public function getAlign():String 
	{
		return _align;
	}
	
	public function setAlign(value:String):String 
	{
		_align = value;
		var fmt:TextFormat = _tf.defaultTextFormat;
		//fmt.align = _align;
		Reflect.setField(fmt, "align", _align);
		_tf.setTextFormat(fmt);
		_tf.defaultTextFormat = fmt;
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
