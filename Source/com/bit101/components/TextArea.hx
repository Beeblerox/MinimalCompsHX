/**
* TextArea.as
* Keith Peters
* version 0.9.10
* 
* A Text component for displaying multiple lines of text with a scrollbar.
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
import flash.events.MouseEvent;

class TextArea extends Text
{
	private var _scrollbar:VScrollBar;
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this Label.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param text The initial text to display in this component.
	 */
	public function new(parent:DisplayObjectContainer = null, xpos:Float = 0, ypos:Float = 0, text:String = "")
	{
		super(parent, xpos, ypos, text);
	}
	
	/**
	 * Initilizes the component.
	 */
	override private function init():Void
	{
		super.init();
		addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
	}
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override private function addChildren():Void
	{
		super.addChildren();
		_scrollbar = new VScrollBar(this, 0, 0, onScrollbarScroll);
		_tf.addEventListener(Event.SCROLL, onTextScroll);
	}
	
	/**
	 * Changes the thumb percent of the scrollbar based on how much text is shown in the text area.
	 */
	private function updateScrollbar():Void
	{
		var visibleLines:Int = _tf.numLines - _tf.maxScrollV + 1;
		var percent:Float = visibleLines / _tf.numLines;
		_scrollbar.setSliderParams(1, _tf.maxScrollV, _tf.scrollV);
		_scrollbar.setThumbPercent(percent);
		_scrollbar.pageSize = visibleLines;
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
		
		_tf.width = _width - _scrollbar.width - 4;
		_scrollbar.x = _width - _scrollbar.width;
		_scrollbar.height = _height;
		_scrollbar.draw();
		addEventListener(Event.ENTER_FRAME, onTextScrollDelay);
	}
	
	
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Waits one more frame before updating scroll bar.
	 * It seems that numLines and maxScrollV are not valid immediately after changing a TextField's size.
	 */
	private function onTextScrollDelay(event:Event):Void
	{
		removeEventListener(Event.ENTER_FRAME, onTextScrollDelay);
		updateScrollbar();
	}
	
	/**
	 * Called when the text in the text field is manually changed.
	 */
	override private function onChange(event:Event):Void
	{
		super.onChange(event);
		updateScrollbar();
	}
	
	/**
	 * Called when the scroll bar is moved. Scrolls text accordingly.
	 */
	private function onScrollbarScroll(event:Event):Void
	{
		_tf.scrollV = Math.round(_scrollbar.value);
	}
	
	/**
	 * Called when the text is scrolled manually. Updates the position of the scroll bar.
	 */
	private function onTextScroll(event:Event):Void
	{
		_scrollbar.value = _tf.scrollV;
		updateScrollbar();
	}
	
	/**
	 * Called when the mouse wheel is scrolled over the component.
	 */
	private function onMouseWheel(event:MouseEvent):Void
	{
		_scrollbar.value -= event.delta;
		_tf.scrollV = Math.round(_scrollbar.value);
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

	/**
	 * Sets / gets whether the scrollbar will auto hide when there is nothing to scroll.
	 */
	public var autoHideScrollBar(get_autoHideScrollBar, set_autoHideScrollBar):Bool;
	
	private function set_autoHideScrollBar(value:Bool):Bool
	{
		_scrollbar.autoHide = value;
		return value;
	}
	private function get_autoHideScrollBar():Bool
	{
		return _scrollbar.autoHide;
	}
}