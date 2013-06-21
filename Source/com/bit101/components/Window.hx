/**
* Window.as
* Keith Peters
* version 0.9.10
* 
* A draggable window. Can be used as a container for other components.
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

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

class Window extends Component
{
	private var _title:String;
	private var _titleBar:Panel;
	private var _titleLabel:Label;
	private var _panel:Panel;
	private var _color:Int = -1;
	private var _shadow:Bool = true;
	private var _draggable:Bool = true;
	private var _minimizeButton:Sprite;
	private var _hasMinimizeButton:Bool = false;
	private var _minimized:Bool = false;
	private var _hasCloseButton:Bool;
	private var _closeButton:PushButton;
	private var _grips:Shape;
	
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this Panel.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param title The string to display in the title bar.
	 */
	public function new(parent:DisplayObjectContainer = null, xpos:Float = 0, ypos:Float = 0, title:String = "Window")
	{
		_title = title;
		super(parent, xpos, ypos);
	}
	
	/**
	 * Initializes the component.
	 */
	override private function init():Void
	{
		super.init();
		setSize(100, 100);
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override private function addChildren():Void
	{
		_titleBar = new Panel();
		_titleBar.filters = [];
		_titleBar.buttonMode = true;
		_titleBar.useHandCursor = true;
		_titleBar.addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
		_titleBar.height = 20;
		super.addChild(_titleBar);
		_titleLabel = new Label(_titleBar.content, 5, 1, _title);
		
		_grips = new Shape();
		
		for (i in 0...4)
		{
			_grips.graphics.lineStyle(1, 0xffffff, .55);
			_grips.graphics.moveTo(0, 3 + i * 4);
			_grips.graphics.lineTo(100, 3 + i * 4);
			_grips.graphics.lineStyle(1, 0, .125);
			_grips.graphics.moveTo(0, 4 + i * 4);
			_grips.graphics.lineTo(100, 4 + i * 4);
		}
		_titleBar.content.addChild(_grips);
		_grips.visible = false;
		
		_panel = new Panel(null, 0, 20);
		_panel.visible = !_minimized;
		super.addChild(_panel);
		
		_minimizeButton = new Sprite();
		_minimizeButton.graphics.beginFill(0, 0);
		_minimizeButton.graphics.drawRect(-10, -10, 20, 20);
		_minimizeButton.graphics.endFill();
		_minimizeButton.graphics.beginFill(0, .35);
		_minimizeButton.graphics.moveTo(-5, -3);
		_minimizeButton.graphics.lineTo(5, -3);
		_minimizeButton.graphics.lineTo(0, 4);
		_minimizeButton.graphics.lineTo(-5, -3);
		_minimizeButton.graphics.endFill();
		_minimizeButton.x = 10;
		_minimizeButton.y = 10;
		_minimizeButton.useHandCursor = true;
		_minimizeButton.buttonMode = true;
		_minimizeButton.addEventListener(MouseEvent.CLICK, onMinimize);
		
		_closeButton = new PushButton(null, 86, 6, "", onClose);
		_closeButton.setSize(8, 8);
		#if flash
		filters = [getShadow(4, false)];
		#end
	}
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/**
	 * Overridden to add new child to content.
	 */
	public override function addChild(child:DisplayObject):DisplayObject
	{
		content.addChild(child);
		return child;
	}
	
	/**
	 * Access to super.addChild
	 */
	public function addRawChild(child:DisplayObject):DisplayObject
	{
		super.addChild(child);
		return child;
	}
	
	/**
	 * Draws the visual ui of the component.
	 */
	override public function draw():Void
	{
		super.draw();
		_titleBar.color = _color;
		_panel.color = _color;
		_titleBar.width = width;
		_titleBar.draw();
		_titleLabel.x = _hasMinimizeButton ? 20 : 5;
		_closeButton.x = _width - 14;
		_grips.x = _titleLabel.x + _titleLabel.width;
		if(_hasCloseButton)
		{
			_grips.width = _closeButton.x - _grips.x - 2;
		}
		else
		{
			_grips.width = _width - _grips.x - 2;
		}
		_panel.setSize(_width, _height - 20);
		_panel.draw();
	}


	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Internal mouseDown handler. Starts a drag.
	 * @param event The MouseEvent passed by the system.
	 */
	private function onMouseGoDown(event:MouseEvent):Void
	{
		if(_draggable)
		{
			this.startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
			parent.addChild(this); // move to top
		}
		dispatchEvent(new Event(Event.SELECT));
	}
	
	/**
	 * Internal mouseUp handler. Stops the drag.
	 * @param event The MouseEvent passed by the system.
	 */
	private function onMouseGoUp(event:MouseEvent):Void
	{
		this.stopDrag();
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
	}
	
	private function onMinimize(event:MouseEvent):Void
	{
		minimized = !minimized;
	}
	
	private function onClose(event:MouseEvent):Void
	{
		dispatchEvent(new Event(Event.CLOSE));
	}
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	/**
	 * Gets / sets whether or not this Window will have a drop shadow.
	 */
	public var shadow(get_shadow, set_shadow):Bool;
	
	private function set_shadow(b:Bool):Bool
	{
		_shadow = b;
		#if flash
		if(_shadow)
		{
			filters = [getShadow(4, false)];
		}
		else
		{
			filters = [];
		}
		#end
		return b;
	}
	private function get_shadow():Bool
	{
		return _shadow;
	}
	
	/**
	 * Gets / sets the background color of this panel.
	 */
	public var color(get_color, set_color):Int;
	
	private function set_color(c:Int):Int
	{
		_color = c;
		invalidate();
		return c;
	}
	private function get_color():Int
	{
		return _color;
	}
	
	/**
	 * Gets / sets the title shown in the title bar.
	 */
	public var title(get_title, set_title):String;
	
	private function set_title(t:String):String
	{
		_title = t;
		_titleLabel.text = _title;
		return t;
	}
	private function get_title():String
	{
		return _title;
	}
	
	/**
	 * Container for content added to this panel. This is just a reference to the content of the internal Panel, which is masked, so best to add children to content, rather than directly to the window.
	 */
	public var content(get_content, null):DisplayObjectContainer;
	
	private function get_content():DisplayObjectContainer
	{
		return _panel.content;
	}
	
	/**
	 * Sets / gets whether or not the window will be draggable by the title bar.
	 */
	public var draggable(get_draggable, set_draggable):Bool;
	
	private function set_draggable(b:Bool):Bool
	{
		_draggable = b;
		_titleBar.buttonMode = _draggable;
		_titleBar.useHandCursor = _draggable;
		return b;
	}
	private function get_draggable():Bool
	{
		return _draggable;
	}
	
	/**
	 * Gets / sets whether or not the window will show a minimize button that will toggle the window open and closed. A closed window will only show the title bar.
	 */
	public var hasMinimizeButton(get_hasMinimizeButton, set_hasMinimizeButton):Bool;
	
	private function set_hasMinimizeButton(b:Bool):Bool
	{
		_hasMinimizeButton = b;
		if(_hasMinimizeButton)
		{
			super.addChild(_minimizeButton);
		}
		else if(contains(_minimizeButton))
		{
			removeChild(_minimizeButton);
		}
		invalidate();
		return b;
	}
	private function get_hasMinimizeButton():Bool
	{
		return _hasMinimizeButton;
	}
	
	/**
	 * Gets / sets whether the window is closed. A closed window will only show its title bar.
	 */
	public var minimized(get_minimized, set_minimized):Bool;
	
	private function set_minimized(value:Bool):Bool
	{
		_minimized = value;
//			_panel.visible = !_minimized;
		if(_minimized)
		{
			if(contains(_panel)) removeChild(_panel);
			_minimizeButton.rotation = -90;
		}
		else
		{
			if(!contains(_panel)) super.addChild(_panel);
			_minimizeButton.rotation = 0;
		}
		dispatchEvent(new Event(Event.RESIZE));
		return value;
	}
	private function get_minimized():Bool
	{
		return _minimized;
	}

	/**
	 * Sets / gets whether or not the window will display a close button.
	 * Close button merely dispatches a CLOSE event when clicked. It is up to the developer to handle this event.
	 */
	public var hasCloseButton(get_hasCloseButton, set_hasCloseButton):Bool;
	
	private function set_hasCloseButton(value:Bool):Bool
	{
		_hasCloseButton = value;
		if(_hasCloseButton)
		{
			_titleBar.content.addChild(_closeButton);
		}
		else if(_titleBar.content.contains(_closeButton))
		{
			_titleBar.content.removeChild(_closeButton);
		}
		invalidate();
		return value;
	}
	private function get_hasCloseButton():Bool
	{
		return _hasCloseButton;
	}

	/**
	 * Returns a reference to the title bar for customization.
	 */
	public var titleBar(get_titleBar, set_titleBar):Panel;
	
	private function get_titleBar():Panel
	{
		return _titleBar;
	}
	private function set_titleBar(value:Panel):Panel
	{
		_titleBar = value;
		return value;
	}

	/**
	 * Returns a reference to the shape showing the grips on the title bar. Can be used to do custom drawing or turn them invisible.
	 */	
	public var grips(get_grips, null):Shape;
	
	private function get_grips():Shape
	{
		return _grips;
	}
	
	/**
	 * Gets the height of the component. A minimized window's height will only be that of its title bar.
	 */
	#if !flash
	override function get_height():Float
	#else
	@:getter(height) override function get_height():Float
	#end
	{
		if (contains(_panel))
		{
			#if !flash
			return super.get_height();
			#else
			return super.height;
			#end
		}
		else
		{
			return 20;
		}
	}

}