/**
* ScrollPane.as
* Keith Peters
* version 0.9.10
* 
* A panel with scroll bars for scrolling content that is larger.
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

import flash.display.Shape;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

class ScrollPane extends Panel
{
	
	public var dragContent(getDragContent, setDragContent):Bool;
	public var autoHideScrollBar(getAutoHideScrollBar, setAutoHideScrollBar):Bool;
	
	var _vScrollbar:VScrollBar;
	var _hScrollbar:HScrollBar;
	var _corner:Shape;
	var _dragContent:Bool;
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this ScrollPane.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 */
	public function new(?parent:Dynamic = null, ?xpos:Float = 0, ?ypos:Float = 0)
	{
		_dragContent = true;
		
		super(parent, xpos, ypos);
	}
	
	/**
	 * Initializes this component.
	 */
	override function init():Void
	{
		super.init();
		addEventListener(Event.RESIZE, onResize);
		_background.addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
		
		_background.useHandCursor = true;
		_background.buttonMode = true;
		
		setSize(100, 100);
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override function addChildren():Void
	{
		super.addChildren();
		_vScrollbar = new VScrollBar(null, width - 10, 0, onScroll);
		_hScrollbar = new HScrollBar(null, 0, height - 10, onScroll);
		addRawChild(_vScrollbar);
		addRawChild(_hScrollbar);
		_corner = new Shape();
		_corner.graphics.beginFill(Style.BUTTON_FACE);
		_corner.graphics.drawRect(0, 0, 10, 10);
		_corner.graphics.endFill();
		addRawChild(_corner);
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
		
		var vPercent:Float = (_height - 10) / content.height;
		var hPercent:Float = (_width - 10) / content.width; 
		
		_vScrollbar.x = width - 10;
		_hScrollbar.y = height - 10;
		
		if (hPercent >= 1)
		{
			_vScrollbar.height = height;
			_mask.height = height;
		}
		else
		{
			_vScrollbar.height = height - 10;
			_mask.height = height - 10;
		}
		if (vPercent >= 1)
		{
			_hScrollbar.width = width;
			_mask.width = width;
		}
		else
		{
			_hScrollbar.width = width - 10;
			_mask.width = width - 10;
		}
		
		_vScrollbar.setThumbPercent(vPercent);
		_vScrollbar.maximum = Math.max(0, content.height - _height + 10);
		_vScrollbar.pageSize = Std.int(_height - 10);
		
		_hScrollbar.setThumbPercent(hPercent);
		_hScrollbar.maximum = Math.max(0, content.width - _width + 10);
		_hScrollbar.pageSize = Std.int(_width - 10);
		
		_corner.x = width - 10;
		_corner.y = height - 10;
		_corner.visible = (hPercent < 1) && (vPercent < 1);
		content.x = -_hScrollbar.value;
		content.y = -_vScrollbar.value;
	}
	
	/**
	 * Updates the scrollbars when content is changed. Needs to be done manually.
	 */
	public function update():Void
	{
		invalidate();
	}
	
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Called when either scroll bar is scrolled.
	 */
	function onScroll(event:Event):Void
	{
		content.x = -_hScrollbar.value;
		content.y = -_vScrollbar.value;
	}
	
	function onResize(event:Event):Void
	{
		invalidate();
	}
	
	function onMouseGoDown(event:MouseEvent):Void
	{
		content.startDrag(false, new Rectangle(0, 0, Math.min(0, _width - content.width - 10), Math.min(0, _height - content.height - 10)));
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
	}
	
	function onMouseMove(event:MouseEvent):Void
	{
		_hScrollbar.value = -content.x;
		_vScrollbar.value = -content.y;
	}
	
	function onMouseGoUp(event:MouseEvent):Void
	{
		content.stopDrag();
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
	}

	public function setDragContent(value:Bool):Bool
	{
		_dragContent = value;
		if(_dragContent)
		{
			_background.addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
			
			_background.useHandCursor = true;
			_background.buttonMode = true;
		}
		else
		{
			_background.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
			
			_background.useHandCursor = false;
			_background.buttonMode = false;
		}
		return value;
	}
	
	public function getDragContent():Bool
	{
		return _dragContent;
	}

	/**
	 * Sets / gets whether the scrollbar will auto hide when there is nothing to scroll.
	 */
	public function setAutoHideScrollBar(value:Bool):Bool
	{
		_vScrollbar.autoHide = value;
		_hScrollbar.autoHide = value;
		return value;
	}
	
	public function getAutoHideScrollBar():Bool
	{
		return _vScrollbar.autoHide;
	}


}