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
	import flash.geom.Point;

	class Window extends Component
	{
		
		public var color(getColor, setColor):Int;
		public var content(getContent, null):DisplayObjectContainer;
		public var draggable(getDraggable, setDraggable):Bool;
		public var hasMinimizeButton(getHasMinimizeButton, setHasMinimizeButton):Bool;
		public var minimized(getMinimized, setMinimized):Bool;
		public var shadow(getBoolShadow, setBoolShadow):Bool;
		public var title(getTitle, setTitle):String;
		//override public var height(getHeight, setHeight):Float;
		public var hasCloseButton(getHasCloseButton, setHasCloseButton):Bool;
		public var titleBar(getTitleBar, setTitleBar):Panel;
		public var grips(getGrips, null):Shape;
		
		var _title:String;
		var _titleBar:Panel;
		var _titleLabel:Label;
		var _panel:Panel;
		var _color:Int;
		var _shadow:Bool;
		var _draggable:Bool;
		var _minimizeButton:Sprite;
		var _hasMinimizeButton:Bool;
		var _minimized:Bool;
		var _hasCloseButton:Bool;
		var _closeButton:PushButton;
		var _grips:Shape;
		
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this Panel.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param title The string to display in the title bar.
		 */
		public function new(?parent:Dynamic = null, ?xpos:Float = 0, ?ypos:Float = 0, ?title:String = "Window")
		{
			_color = -1;
			_shadow = true;
			_draggable = true;
			_hasMinimizeButton = false;
			_minimized = false;
			
			_title = title;
			super(parent, xpos, ypos);
		}
		
		/**
		 * Initializes the component.
		 */
		override function init():Void
		{
			super.init();
			setSize(100, 100);
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override function addChildren():Void
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
			
			filters = [];
			filters.push(getShadow(4, false));
		}
		
		
		
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Overridden to add new child to content.
		 */
		override public function localToGlobal(point:Point):Point
		{
			return content.localToGlobal(point);
		}
		 
		 override public function addChild(child:Dynamic)
		{
			if (Std.is(child, Component)) 
			{
				child.parent = this;
				child = untyped child._comp;			
			}
			return content.addChild(child);
		
			//content.addChild(child);
			//return child;
		}
		
		override public function addChildAt(child:Dynamic, index:Int)
		{
			if (Std.is(child, Component)) 
			{
				child.parent = this;
				child = untyped child._comp;			
			}
			return content.addChildAt(child, index);
		}
		
		override public function removeChild(child:Dynamic) 
		{
			if (Std.is(child, Component)) 
			{
				child.parent = null;
				child = untyped child._comp;			
			}
			return content.removeChild(child);
		}
		
		override public function removeChildAt(index:Int):DisplayObject
		{
			return content.removeChildAt(index);
		}
		
		override public function contains(child:Dynamic):Bool 
		{
			if (Std.is(child, Component)) 
			{
				child = untyped child._comp;			
			}
			return content.contains(child) || super.contains(child);
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
			_panel.setSize(_width, _height/* - 20*/);
			_panel.draw();
		}


		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Internal mouseDown handler. Starts a drag.
		 * @param event The MouseEvent passed by the system.
		 */
		function onMouseGoDown(event:MouseEvent):Void
		{
			if(_draggable)
			{
				this.startDrag();
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
				parent.addChild(this._comp); // move to top
			}
			dispatchEvent(new Event(Event.SELECT));
		}
		
		/**
		 * Internal mouseUp handler. Stops the drag.
		 * @param event The MouseEvent passed by the system.
		 */
		function onMouseGoUp(event:MouseEvent):Void
		{
			this.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		function onMinimize(event:MouseEvent):Void
		{
			minimized = !minimized;
		}
		
		function onClose(event:MouseEvent):Void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Gets / sets whether or not this Window will have a drop shadow.
		 */
		public function setBoolShadow(b:Bool):Bool
		{
			_shadow = b;
			if(_shadow)
			{
				filters = [];
				filters.push(getShadow(4, false));
			}
			else
			{
				filters = [];
			}
			return b;
		}
		
		public function getBoolShadow():Bool
		{
			return _shadow;
		}
		
		/**
		 * Gets / sets the background color of this panel.
		 */
		public function setColor(c:Int):Int
		{
			_color = c;
			invalidate();
			return c;
		}
		
		public function getColor():Int
		{
			return _color;
		}
		
		/**
		 * Gets / sets the title shown in the title bar.
		 */
		public function setTitle(t:String):String
		{
			_title = t;
			_titleLabel.text = _title;
			return t;
		}
		
		public function getTitle():String
		{
			return _title;
		}
		
		/**
		 * Container for content added to this panel. This is just a reference to the content of the internal Panel, which is masked, so best to add children to content, rather than directly to the window.
		 */
		public function getContent():DisplayObjectContainer
		{
			return _panel.content;
		}
		
		/**
		 * Sets / gets whether or not the window will be draggable by the title bar.
		 */
		public function setDraggable(b:Bool):Bool
		{
			_draggable = b;
			_titleBar.buttonMode = _draggable;
			_titleBar.useHandCursor = _draggable;
			return b;
		}
		
		public function getDraggable():Bool
		{
			return _draggable;
		}
		
		/**
		 * Gets / sets whether or not the window will show a minimize button that will toggle the window open and closed. A closed window will only show the title bar.
		 */
		public function setHasMinimizeButton(b:Bool):Bool
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
		
		public function getHasMinimizeButton():Bool
		{
			return _hasMinimizeButton;
		}
		
		/**
		 * Gets / sets whether the window is closed. A closed window will only show its title bar.
		 */
		public function setMinimized(value:Bool):Bool
		{
			_minimized = value;
//			_panel.visible = !_minimized;
			if(_minimized)
			{
				if (super.contains(_panel)) 
				{
					super.removeChild(_panel);
				}
				_minimizeButton.rotation = -90;
			}
			else
			{
				if(!super.contains(_panel)) super.addChild(_panel);
				_minimizeButton.rotation = 0;
			}
			dispatchEvent(new Event(Event.RESIZE));
			return value;
		}
		
		public function getMinimized():Bool
		{
			return _minimized;
		}
		
		/**
		 * Gets the height of the component. A minimized window's height will only be that of its title bar.
		 */
		override public function getHeight():Float
		{
			if(contains(_panel))
			{
				//return super.height;
				return _comp.height;
			}
			return 20;
		}
		
		/**
		 * Sets / gets whether or not the window will display a close button.
		 * Close button merely dispatches a CLOSE event when clicked. It is up to the developer to handle this event.
		 */
		public function setHasCloseButton(value:Bool):Bool
		{
			_hasCloseButton = value;
			if(_hasCloseButton)
			{
				//_titleBar.content.addChild(_closeButton);
				_titleBar.addChild(_closeButton);
			}
			//else if(_titleBar.content.contains(_closeButton))
			else if(_titleBar.contains(_closeButton))
			{
				//_titleBar.content.removeChild(_closeButton);
				_titleBar.removeChild(_closeButton);
			}
			invalidate();
			return value;
		}
		
		public function getHasCloseButton():Bool
		{
			return _hasCloseButton;
		}

		/**
		 * Returns a reference to the title bar for customization.
		 */
		public function getTitleBar():Panel
		{
			return _titleBar;
		}
		
		public function setTitleBar(value:Panel):Panel
		{
			_titleBar = value;
			return value;
		}

		/**
		 * Returns a reference to the shape showing the grips on the title bar. Can be used to do custom drawing or turn them invisible.
		 */		
		public function getGrips():Shape
		{
			return _grips;
		}
		
	}