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
import flash.display.DisplayObjectContainer;
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

enum ColorChooserAlign
{
	TOP;
	BOTTOM;
}

class ColorChooser extends Component
{
	private var _colors:BitmapData;
	private var _colorsContainer:Sprite;
	private var _defaultModelColors:Array<Int>;
	private var _input:InputText;
	private var _model:DisplayObject;
	private var _oldColorChoice:Int;
	private var _popupAlign:ColorChooserAlign;
	private var _stage:Stage;
	private var _swatch:Sprite;
	private var _tmpColorChoice:Int;
	private var _usePopup:Bool = false;
	private var _value:Int;
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this ColorChooser.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param value The initial color value of this component.
	 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
	 */
	public function new(parent:DisplayObjectContainer = null, xpos:Float = 0, ypos:Float =  0, value:Int = 0xff0000, defaultHandler:Event->Void = null)
	{
		_oldColorChoice = _tmpColorChoice = _value = value;
		_popupAlign = ColorChooserAlign.BOTTOM;
		_defaultModelColors = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF, 0xFF00FF, 0xFF0000,0xFFFFFF,0x000000];
		
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

		_width = 65;
		_height = 15;
		value = _value;
	}
	
	override private function addChildren():Void
	{
		_input = new InputText();
		_input.width = 45;
		_input.restrict = "0123456789ABCDEFabcdef";
		_input.maxChars = 6;
		addChild(_input);
		_input.addEventListener(Event.CHANGE, onChange);
		
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
	private function onChange(event:Event):Void
	{
		event.stopImmediatePropagation();
		Std.parseInt("0x" + _input.text/*, 16*/);
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
	public var value(get, set):Int;
	
	private function set_value(n:Int):Int
	{
		var str = StringTools.hex(n).toUpperCase();
		while(str.length < 6)
		{
			str = "0" + str;
		}
		_input.text = str;
		_value = Std.parseInt("0x" + _input.text/*, 16*/);
		invalidate();
		return n;
	}
	private function get_value():Int
	{
		return _value;
	}
	
	///////////////////////////////////
	// COLOR PICKER MODE SUPPORT
	///////////////////////////////////}
	public var model(get, set):DisplayObject;
	
	private function get_model():DisplayObject 
	{ 
		return _model; 
	}
	private function set_model(value:DisplayObject):DisplayObject 
	{
		_model = value;
		if (_model!=null) {
			drawColors(_model);
			if (!usePopup) usePopup = true;
		} else {
			_model = getDefaultModel();
			drawColors(_model);
			usePopup = false;
		}
		return value;
	}
	
	private function drawColors(d:DisplayObject):DisplayObject
	{
		_colors = new BitmapData(Std.int(d.width), Std.int(d.height));
		_colors.draw(d);
		while (_colorsContainer.numChildren > 0) _colorsContainer.removeChildAt(0);
		_colorsContainer.addChild(new Bitmap(_colors));
		placeColors();
		return d;
	}
	
	public var popupAlign(get, set):ColorChooserAlign;
	
	private function get_popupAlign():ColorChooserAlign { return _popupAlign; }
	private function set_popupAlign(value:ColorChooserAlign):ColorChooserAlign 
	{
		_popupAlign = value;
		placeColors();
		return value;
	}
	
	public var usePopup(get, set):Bool;
	
	private function get_usePopup():Bool { return _usePopup; }
	private function set_usePopup(value:Bool):Bool 
	{
		_usePopup = value;
		
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
		}
		
		return value;
	}
	
	/**
	 * The color picker mode Handlers 
	 */
	
	private function onColorsRemovedFromStage(e:Event):Void {
		_stage.removeEventListener(MouseEvent.CLICK, onStageClick);
	}
	
	private function onColorsAddedToStage(e:Event):Void {
		_stage = stage;
		_stage.addEventListener(MouseEvent.CLICK, onStageClick);
	}
	
	private function onStageClick(e:MouseEvent):Void {
		displayColors();
	}
	 
	
	private function onSwatchClick(event:MouseEvent):Void 
	{
		event.stopImmediatePropagation();
		displayColors();
	}
	
	private function backToColorChoice(e:MouseEvent):Void 
	{
		value = _oldColorChoice;
	}
	
	private function setColorChoice(e:MouseEvent):Void {
		value = _colors.getPixel(Std.int(_colorsContainer.mouseX), Std.int(_colorsContainer.mouseY));
		_oldColorChoice = value;
		dispatchEvent(new Event(Event.CHANGE));
		displayColors();
	}
	
	private function browseColorChoice(e:MouseEvent):Void 
	{
		_tmpColorChoice = _colors.getPixel(Std.int(_colorsContainer.mouseX), Std.int(_colorsContainer.mouseY));
		value = _tmpColorChoice;
	}

	/**
	 * The color picker mode Display functions
	 */
	
	private function displayColors():Void 
	{
		placeColors();
		if (_colorsContainer.parent != null) _colorsContainer.parent.removeChild(_colorsContainer);
		else stage.addChild(_colorsContainer);
	}		
	
	private function placeColors():Void
	{
		var point:Point = new Point(x, y);
		if(parent != null) point = parent.localToGlobal(point);
		switch (_popupAlign)
		{
			case ColorChooserAlign.TOP:
				_colorsContainer.x = point.x;
				_colorsContainer.y = point.y - _colorsContainer.height - 4;
			default: 
				_colorsContainer.x = point.x;
				_colorsContainer.y = point.y + 22;
		}
	}
	
	/**
	 * Create the default gradient Model
	 */
	private function getDefaultModel():Sprite 
	{	
		var w:Int = 100;
		var h:Int = 100;
		var bmd:BitmapData = new BitmapData(w, h);
		
		var g1:Sprite = getGradientSprite(w, h, _defaultModelColors);
		bmd.draw(g1);
		
		var blendmodes:Array<BlendMode> = [BlendMode.MULTIPLY,BlendMode.ADD];
		var nb:Int = blendmodes.length;
		var g2:Sprite = getGradientSprite(h/nb, w, [0xFFFFFF, 0x000000]);		
		
		for (i in 0...nb) {
			var blendmode:BlendMode = blendmodes[i];
			var m:Matrix = new Matrix();
			m.rotate(-Math.PI / 2);
			m.translate(0, h / nb * i + h / nb);
			#if flash
			bmd.draw(g2, m, null, blendmode);
			#end
		}
		
		var s:Sprite = new Sprite();
		var bm:Bitmap = new Bitmap(bmd);
		s.addChild(bm);
		return(s);
	}
	
	private function getGradientSprite(w:Float, h:Float, gc:Array<Int>):Sprite 
	{
		var gs:Sprite = new Sprite();
		var g:Graphics = gs.graphics;
		var gn:Int = gc.length;
		var ga:Array<Float> = [];
		var gr:Array<Float> = [];
		var gm:Matrix = new Matrix(); 
		gm.createGradientBox(w, h, 0, 0, 0);
		for (i in 0...gn) 
		{ 
			ga.push(1); 
			gr.push(0x00 + (0xFF / (gn - 1) * i)); 
		}
		g.beginGradientFill(GradientType.LINEAR, gc, ga, gr, gm, SpreadMethod.PAD, InterpolationMethod.RGB);
		g.drawRect(0, 0, w, h);
		g.endFill();	
		return(gs);
	}
}