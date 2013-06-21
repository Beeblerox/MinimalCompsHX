/**
* PushButton.as
* Keith Peters
* version 0.9.10
* 
* A basic button component with a label.
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

class PushButton extends Component
{
	private var _back:Sprite;
	private var _face:Sprite;
	private var _label:Label;
	private var _labelText:String = "";
	private var _over:Bool = false;
	private var _down:Bool = false;
	private var _selected:Bool = false;
	private var _toggle:Bool = false;
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this PushButton.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param label The string to use for the initial label of this component.
	 * @param defaultHandler The event handling function to handle the default event for this component (click in this case).
	 */
	public function new(parent:DisplayObjectContainer = null, xpos:Float = 0, ypos:Float =  0, label:String = "", defaultHandler:MouseEvent->Void = null)
	{
		super(parent, xpos, ypos);
		if(defaultHandler != null)
		{
			addEventListener(MouseEvent.CLICK, defaultHandler);
		}
		this.label = label;
	}
	
	/**
	 * Initializes the component.
	 */
	override private function init():Void
	{
		super.init();
		buttonMode = true;
		useHandCursor = true;
		setSize(100, 20);
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override private function addChildren():Void
	{
		_back = new Sprite();
		#if flash
		_back.filters = [getShadow(2, true)];
		_back.mouseEnabled = false;
		#end
		addChild(_back);
		
		_face = new Sprite();
		_face.mouseEnabled = false;
		#if flash
		_face.filters = [getShadow(1)];
		#end
		_face.x = 1;
		_face.y = 1;
		addChild(_face);
		
		_label = new Label();
		addChild(_label);
		
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
		addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
	}
	
	/**
	 * Draws the face of the button, color based on state.
	 */
	private function drawFace():Void
	{
		_face.graphics.clear();
		if(_down)
		{
			_face.graphics.beginFill(Style.BUTTON_DOWN);
		}
		else
		{
			_face.graphics.beginFill(Style.BUTTON_FACE);
		}
		_face.graphics.drawRect(0, 0, _width - 2, _height - 2);
		_face.graphics.endFill();
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
		_back.graphics.drawRect(0, 0, _width, _height);
		_back.graphics.endFill();
		
		drawFace();
		
		_label.text = _labelText;
		_label.autoSize = true;
		_label.draw();
		if(_label.width > _width - 4)
		{
			_label.autoSize = false;
			_label.width = _width - 4;
		}
		else
		{
			_label.autoSize = true;
		}
		_label.draw();
		_label.move(_width / 2 - _label.width / 2, _height / 2 - _label.height / 2);
		
	}
	
	
	
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Internal mouseOver handler.
	 * @param event The MouseEvent passed by the system.
	 */
	private function onMouseOver(event:MouseEvent):Void
	{
		_over = true;
		addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
	}
	
	/**
	 * Internal mouseOut handler.
	 * @param event The MouseEvent passed by the system.
	 */
	private function onMouseOut(event:MouseEvent):Void
	{
		_over = false;
		if(!_down)
		{
			#if flash
			_face.filters = [getShadow(1)];
			#end
		}
		removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
	}
	
	/**
	 * Internal mouseOut handler.
	 * @param event The MouseEvent passed by the system.
	 */
	private function onMouseGoDown(event:MouseEvent):Void
	{
		_down = true;
		drawFace();
		#if flash
		_face.filters = [getShadow(1, true)];
		#end
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
	}
	
	/**
	 * Internal mouseUp handler.
	 * @param event The MouseEvent passed by the system.
	 */
	private function onMouseGoUp(event:MouseEvent):Void
	{
		if(_toggle  && _over)
		{
			_selected = !_selected;
		}
		_down = _selected;
		drawFace();
		#if flash
		_face.filters = [getShadow(1, _selected)];
		#end
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
	}
	
	
	
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	/**
	 * Sets / gets the label text shown on this Pushbutton.
	 */
	public var label(get_label, set_label):String;
	
	private function set_label(str:String):String
	{
		_labelText = str;
		draw();
		return str;
	}
	private function get_label():String
	{
		return _labelText;
	}
	
	public var selected(get_selected, set_selected):Bool;
	
	private function set_selected(value:Bool):Bool
	{
		if(!_toggle)
		{
			value = false;
		}
		
		_selected = value;
		_down = _selected;
		#if flash
		_face.filters = [getShadow(1, _selected)];
		#end
		drawFace();
		return value;
	}
	private function get_selected():Bool
	{
		return _selected;
	}
	
	public var toggle(get_toggle, set_toggle):Bool;
	
	private function set_toggle(value:Bool):Bool
	{
		_toggle = value;
		return value;
	}
	private function get_toggle():Bool
	{
		return _toggle;
	}
	
	
}