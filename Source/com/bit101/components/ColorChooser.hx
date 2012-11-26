/**
* ColorChooser.as
* Keith Peters
* version 0.9.10
* 
* A Color Chooser component, allowing textual input, a default gradient, or custom image.
* 
* Copyright (c) 2011 Keith Peters
* 
* popup color choosing code by Rashid Ghassempouri
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

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.InterpolationMethod;
import flash.display.SpreadMethod;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;

class ColorChooser extends Component
{
	
	public var value(getValue, setValue):Int;
	public var model(getModel, setModel):DisplayObject;
	public var popupAlign(getPopupAlign, setPopupAlign):String;
	public var usePopup(getUsePopup, setUsePopup):Bool;
	
	public static inline var TOP:String = "top";
	public static inline var BOTTOM:String = "bottom";
	
	var _colors:BitmapData;
	var _colorsContainer:Sprite;
	var _defaultModelColors:Array<Int>;
	var _input:InputText;
	var _model:DisplayObject;
	var _oldColorChoice:Int;
	var _popupAlign:String;
	var _stage:Stage;
	var _swatch:Sprite;
	var _tmpColorChoice:Int;
	var _usePopup:Bool;
	var _value:Int;
	
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this ColorChooser.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param value The initial color value of this component.
	 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
	 */
	
	public function new(?parent:Dynamic = null, ?xpos:Float = 0, ?ypos:Float =  0, ?value:Int = 0xff0000, ?defaultHandler:Dynamic->Void = null)
	{
		_defaultModelColors = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF, 0xFF00FF, 0xFF0000,0xFFFFFF,0x000000];
		_oldColorChoice = _value;
		_popupAlign = BOTTOM;
		_tmpColorChoice = _value;
		_usePopup = false;
		if (value >= 0)
		{
			_value = value;
		}
		else 
		{
			_value = 0xff0000;
		}
		
		_oldColorChoice = _tmpColorChoice = _value;
		
		super(parent, xpos, ypos);
		
		if(defaultHandler != null)
		{
			addEventListener(Event.CHANGE, defaultHandler);
		}
			
	}		
	
	/**
	 * Initializes the component.
	 */
	override function init():Void
	{
		
		super.init();

		_width = 65;
		_height = 15;
		value = _value;
	}
	
	override function addChildren():Void
	{
		_input = new InputText();
		_input.width = 45;
		_input.restrict = "0123456789ABCDEFabcdef";
		_input.maxChars = 6;
		_input.addEventListener(Event.CHANGE, onChange);
		addChild(_input);
		
		_swatch = new Sprite();
		_swatch.x = 50;
		#if flash
		_swatch.filters = [getShadow(2, true)];
		#end
		addChild(_swatch);
		
		_colorsContainer = new Sprite();
		_colorsContainer.addEventListener(Event.ADDED_TO_STAGE, onColorsAddedToStage);
		_colorsContainer.addEventListener(Event.REMOVED_FROM_STAGE, onColorsRemovedFromStage);
		_model = getDefaultModel();
		drawColors(_model);
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
		_swatch.graphics.clear();
		_swatch.graphics.beginFill(_value);
		_swatch.graphics.drawRect(0, 0, 16, 16);
		_swatch.graphics.endFill();
	}
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Internal change handler.
	 * @param event The Event passed by the system.
	 */
	function onChange(event:Event):Void
	{
		event.stopImmediatePropagation();
		_value = Std.parseInt("0x" + _input.text/*, 16*/);
		_input.text = _input.text.toUpperCase();
		_oldColorChoice = value;
		invalidate();
		dispatchEvent(new Event(Event.CHANGE));
		
	}	
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	/**
	 * Gets / sets the color value of this ColorChooser.
	 */
	public function setValue(n:Int):Int
	{
		if (value >= 0)
		{
			var str = StringTools.hex(n).toUpperCase();
			while(str.length < 6)
			{
				str = "0" + str;
			}
			_input.text = str;
			_value = Std.parseInt("0x" + _input.text/*, 16*/);
			invalidate();
		}
		return n;
	}
	
	public function getValue():Int
	{
		return _value;
	}
	
	///////////////////////////////////
	// COLOR PICKER MODE SUPPORT
	///////////////////////////////////}
	
	
	public function getModel():DisplayObject 
	{ 
		return _model; 
	}
	
	public function setModel(value:DisplayObject):DisplayObject 
	{
		_model = value;
		if (_model != null) 
		{
			drawColors(_model);
			if (!usePopup) usePopup = true;
		} 
		else 
		{
			_model = getDefaultModel();
			drawColors(_model);
			usePopup = false;
		}
		return value;
	}
	
	function drawColors(d:DisplayObject):Void
	{
		_colors = new BitmapData(Std.int(d.width), Std.int(d.height));
		_colors.draw(d);
		while (_colorsContainer.numChildren > 0) _colorsContainer.removeChildAt(0);
		_colorsContainer.addChild(new Bitmap(_colors));
		placeColors();
	}
	
	public function getPopupAlign():String { return _popupAlign; }
	public function setPopupAlign(value:String):String 
	{
		_popupAlign = value;
		placeColors();
		return value;
	}
	
	public function getUsePopup():Bool { return _usePopup; }
	public function setUsePopup(value:Bool):Bool 
	{
		_usePopup = value;
		
		if (_usePopup) 
		{
			_swatch.buttonMode = true;
			_colorsContainer.buttonMode = true;
			
			_colorsContainer.addEventListener(MouseEvent.MOUSE_MOVE, browseColorChoice);
			_colorsContainer.addEventListener(MouseEvent.MOUSE_OUT, backToColorChoice);
			_colorsContainer.addEventListener(MouseEvent.CLICK, setColorChoice);
			_swatch.addEventListener(MouseEvent.CLICK, onSwatchClick);
			_input.addEventListener(MouseEvent.CLICK, onSwatchClick);
		} 
		else 
		{
			_swatch.buttonMode = false;
			_colorsContainer.buttonMode = false;
			
			_colorsContainer.removeEventListener(MouseEvent.MOUSE_MOVE, browseColorChoice);
			_colorsContainer.removeEventListener(MouseEvent.MOUSE_OUT, backToColorChoice);
			_colorsContainer.removeEventListener(MouseEvent.CLICK, setColorChoice);
			_swatch.removeEventListener(MouseEvent.CLICK, onSwatchClick);
			_input.removeEventListener(MouseEvent.CLICK, onSwatchClick);
		}
		
		/*
		_swatch.buttonMode = true;
		_colorsContainer.buttonMode = true;
		_colorsContainer.addEventListener(MouseEvent.MOUSE_MOVE, browseColorChoice);
		_colorsContainer.addEventListener(MouseEvent.MOUSE_OUT, backToColorChoice);
		_colorsContainer.addEventListener(MouseEvent.CLICK, setColorChoice);
		_swatch.addEventListener(MouseEvent.CLICK, onSwatchClick);
		
		if (!_usePopup) {
			_swatch.buttonMode = false;
			_colorsContainer.buttonMode = false;
			_colorsContainer.removeEventListener(MouseEvent.MOUSE_MOVE, browseColorChoice);
			_colorsContainer.removeEventListener(MouseEvent.MOUSE_OUT, backToColorChoice);
			_colorsContainer.removeEventListener(MouseEvent.CLICK, setColorChoice);
			_swatch.removeEventListener(MouseEvent.CLICK, onSwatchClick);
		}*/
		
		return value;
	}
	
	/**
	 * The color picker mode Handlers 
	 */
	
	function onColorsRemovedFromStage(e:Event):Void 
	{
		_stage.removeEventListener(MouseEvent.CLICK, onStageClick);
	}
	
	function onColorsAddedToStage(e:Event):Void 
	{
		_stage = stage;
		_stage.addEventListener(MouseEvent.CLICK, onStageClick);
	}
	
	function onStageClick(e:MouseEvent):Void 
	{
		displayColors();
	}
	 
	
	function onSwatchClick(event:MouseEvent):Void 
	{
		event.stopImmediatePropagation();
		displayColors();
	}
	
	function backToColorChoice(e:MouseEvent):Void 
	{
		value = _oldColorChoice;
	}
	
	function setColorChoice(e:MouseEvent):Void 
	{
		value = _colors.getPixel(Std.int(_colorsContainer.mouseX), Std.int(_colorsContainer.mouseY));
		_oldColorChoice = value;
		dispatchEvent(new Event(Event.CHANGE));
		displayColors();
	}
	
	function browseColorChoice(e:MouseEvent):Void 
	{
		_tmpColorChoice = _colors.getPixel(Std.int(_colorsContainer.mouseX), Std.int(_colorsContainer.mouseY));
		value = _tmpColorChoice;
	}

	/**
	 * The color picker mode Display functions
	 */
	
	function displayColors():Void 
	{
		placeColors();
		if (_colorsContainer.parent != null) _colorsContainer.parent.removeChild(_colorsContainer);
		else stage.addChild(_colorsContainer);
	}		
	
	function placeColors():Void
	{
		var point:Point = new Point(x, y);
		// TODO: LocalToLocal the x and y to place it properly.
		if(parent != null) point = parent.localToGlobal(point);
		switch (_popupAlign)
		{
			case TOP : 
				_colorsContainer.x = point.x;
				_colorsContainer.y = point.y - _colorsContainer.height - 4;
			case BOTTOM : 
				_colorsContainer.x = point.x;
				_colorsContainer.y = point.y + 22;
			default: 
				_colorsContainer.x = point.x;
				_colorsContainer.y = point.y + 22;
		}
	}
	
	/**
	 * Create the default gradient Model
	 */

	function getDefaultModel():Sprite 
	{	
		var w:Int = 100;
		var h:Int = 100;
		var bmd:BitmapData = new BitmapData(w, h);
		
		var g1:Sprite = getGradientSprite(w, h, _defaultModelColors);
		bmd.draw(g1);
		
		#if (flash || js)
		var blendmodes = [BlendMode.MULTIPLY, BlendMode.ADD];
		#else
		var blendmodes = ["multiply", "add"];
		#end
		var nb:Int = blendmodes.length;
		var g2:Sprite = getGradientSprite(h/nb, w, [0xFFFFFF, 0x000000]);		
		
		for (i in 0...nb) 
		{
			var blendmode = blendmodes[i];
			var m:Matrix = new Matrix();
			m.rotate(-Math.PI / 2);
			m.translate(0, h / nb * i + h/nb);
			
			bmd.draw(g2, m, null, blendmode);
		}
		
		var s:Sprite = new Sprite();
		var bm:Bitmap = new Bitmap(bmd);
		s.addChild(bm);
		return s;
	}
	
	function getGradientSprite(w:Float, h:Float, gc:Array<Int>):Sprite 
	{
		var gs:Sprite = new Sprite();
		var g:Graphics = gs.graphics;
		var gn:Int = gc.length;
		var ga = [];
		var gr = [];
		var gm:Matrix = new Matrix(); 
		gm.createGradientBox(w, h, 0, 0, 0);
		for (i in 0...gn) 
		{ 
			ga.push(1); 
			gr.push(0x00 + 0xFF / (gn - 1) * i); 
		}
		g.beginGradientFill(GradientType.LINEAR, gc, ga, gr, gm, SpreadMethod.PAD, InterpolationMethod.RGB);
		g.drawRect(0, 0, w, h);
		g.endFill();	
		return gs;
	}
}