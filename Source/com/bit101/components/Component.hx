/**
* Component.as
* Keith Peters
* version 0.9.10
* 
* Base class for all components
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
* 
* 
* 
* Components with text make use of the font PF Ronda Seven by Yuusuke Kamiyamane
* This is a free font obtained from http://www.dafont.com/pf-ronda-seven.font
*/

package com.bit101.components;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.filters.DropShadowFilter;
import flash.events.IEventDispatcher;
import flash.display.Graphics;
import flash.geom.Point;
import flash.Lib;
import flash.text.Font;
import nme.filters.BitmapFilter;

class PFRondaSeven extends flash.text.Font {}

class Component implements IEventDispatcher
{
	
	//protected var Ronda:Class;
	
	public var height(getHeight, setHeight):Float;
	public var width(getWidth, setWidth):Float;
	public var x(default, setX):Float;
	public var y(default, setY):Float;
	public var mouseX(getMouseX, null):Float;
	public var mouseY(getMouseY, null):Float;
	public var mouseEnabled(getMouseEnabled, setMouseEnabled):Bool;
	public var mouseChildren(getMouseChildren, null):Bool;
	#if flash
	public var filters(getFilters, setFilters):Array<BitmapFilter>;
	#else
	public var filters(getFilters, setFilters):Array<Dynamic>;
	#end
	public var useHandCursor(getUseHandCursor, setUseHandCursor):Bool;
	public var buttonMode(getButtonMode, setButtonMode):Bool;	
	public var stage(getStage, null):Stage;
	public var numChildren(getNumChildren, null):Int;
	public var visible(getVisible, setVisible):Bool;
	public var graphics(getGraphics, null):Graphics;
	public var parent(default, null):Dynamic;
  public var component (getComponent, null) : Sprite;
	public var alpha(getAlpha, setAlpha):Float;
	
	public var tag(getTag, setTag):Int;
	public var enabled(getEnabled, setEnabled):Bool;
	
	// Composition instead of inheritence because of haxe getter/setter handicap
	var _comp:Sprite;
	var _width:Float;
	var _height:Float;
	var _tag:Int;
	var _enabled:Bool;
	var _parent:Dynamic;
	
	public static var DRAW:String = "draw";

	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this component.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 */
	public function new(?parent:Dynamic = null, ?xpos:Float = 0, ?ypos:Float =  0)
	{
		_comp = new Sprite();
		_width = 0;
		_height = 0;
		_tag = -1;
		_enabled = true;
		move(xpos, ypos);
		this.parent = parent;
		if(parent != null)
		{
			parent.addChild(_comp);
		}
		init();
	}
	
	/**
	 * Initilizes the component.
	 */
	function init():Void
	{
		addChildren();
		invalidate();
	}
	
	/**
	 * Overriden in subclasses to create child display objects.
	 */
	function addChildren():Void
	{
		
	}
	
	/********** Sprite composition ***************/
	public function localToGlobal(point:Point):Point
	{
		return _comp.localToGlobal(point);
	}
	
	public function addChild(child:Dynamic) 
	{
		if (Std.is(child, Component)) 
		{
			child.parent = this;
			child = untyped child._comp;			
		}
		return _comp.addChild(child);
	}
	
	public function addChildAt(child:Dynamic, index:Int)
	{
		if (Std.is(child, Component)) 
		{
			child.parent = this;
			child = untyped child._comp;			
		}
		return _comp.addChildAt(child, index);
	}
	
	public function removeChild(child:Dynamic) 
	{
		if (Std.is(child, Component)) 
		{
			child.parent = null;
			child = untyped child._comp;			
		}
		return _comp.removeChild(child);
	}
	
	public function removeChildAt(index:Int):DisplayObject
	{
		return _comp.removeChildAt(index);
	}
	
	public function contains(child:Dynamic):Bool 
	{
		if (Std.is(child, Component)) 
		{
			child = untyped child._comp;			
		}
		return _comp.contains(child);
	}
	
	public function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void
	{
		_comp.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}
	
	public function dispatchEvent(event:Event):Bool 
	{
		return _comp.dispatchEvent(event);
	}
	
	public function hasEventListener(type:String):Bool 
	{
		return _comp.hasEventListener(type);
	}
	
	public function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false):Void
	{
		_comp.removeEventListener(type, listener, useCapture);
	}
	
	public function willTrigger(type:String):Bool 
	{
		return _comp.willTrigger( type );
	}
	
	public function startDrag() 
	{
		_comp.startDrag();
	}
	
	public function stopDrag() 
	{
		return _comp.stopDrag();
	}
	
	/**
	 * DropShadowFilter factory method, used in many of the components.
	 * @param dist The distance of the shadow.
	 * @param knockout Whether or not to create a knocked out shadow.
	 */
	function getShadow(dist:Float, ?knockout:Bool = false):DropShadowFilter
	{
		return new DropShadowFilter(dist, 45, Style.DROPSHADOW, 1, dist, dist, .3, 1, knockout);
	}
	
	/**
	 * Marks the component to be redrawn on the next frame.
	 */
	function invalidate():Void
	{
		addEventListener(Event.ENTER_FRAME, onInvalidate);
	}
	
	
	
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/**
	 * Utility method to set up usual stage align and scaling.
	 */
	public static function initStage(stage:Stage):Void
	{
		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;
	}
	
	/**
	 * Moves the component to the specified position.
	 * @param xpos the x position to move the component
	 * @param ypos the y position to move the component
	 */
	public function move(xpos:Float, ypos:Float):Void
	{
		x = Math.round(xpos);
		y = Math.round(ypos);
	}
	
	/**
	 * Sets the size of the component.
	 * @param w The width of the component.
	 * @param h The height of the component.
	 */
	public function setSize(w:Float, h:Float):Void
	{
		_width = w;
		_height = h;
		dispatchEvent(new Event(Event.RESIZE));
		invalidate();
	}
	
	/**
	 * Abstract draw function.
	 */
	public function draw():Void
	{
		dispatchEvent(new Event(Component.DRAW));
	}
	
	public function addToDisplay(stage:DisplayObjectContainer)
	{
		if (stage != null)
		{
			this.parent = stage;
			return stage.addChild(this._comp);
		}
		return null;
	}
	
	public function removeFromDisplay(stage:DisplayObjectContainer)
	{
		this.parent = null;
		return stage.removeChild(this._comp);
	}
	
	public function isDisplayObjectContainsThisComponent(stage:DisplayObjectContainer):Bool
	{
		return stage.contains(this._comp);
	}
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Called one frame after invalidate is called.
	 */
	function onInvalidate(event:Event):Void
	{
		removeEventListener(Event.ENTER_FRAME, onInvalidate);
		draw();
	}
	
	
	
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	/**
	 * Sets/gets the width of the component.
	 */
	public function setWidth(w:Float):Float
	{
		_width = w;
		invalidate();
		dispatchEvent(new Event(Event.RESIZE));
		return w;
	}
	
	public function getWidth():Float
	{
		return _width;
	}
	
	/**
	 * Sets/gets the height of the component.
	 */
	public function setHeight(h:Float):Float
	{
		_height = h;
		invalidate();
		dispatchEvent(new Event(Event.RESIZE));
		return h;
	}
	
	public function getHeight():Float
	{
		return _height;
	}
	
	/**
	 * Sets/gets in integer that can identify the component.
	 */
	public function setTag(value:Int):Int
	{
		_tag = value;
		return value;
	}
	
	public function getTag():Int
	{
		return _tag;
	}
	
	/**
	 * Overrides the setter for x to always place the component on a whole pixel.
	 */
	public function setX(value:Float):Float
	{
		return x = _comp.x = Math.round(value);
	}
	
	/**
	 * Overrides the setter for y to always place the component on a whole pixel.
	 */
	public function setY(value:Float):Float
	{
		return y = _comp.y = Math.round(value);
	}

	/**
	 * Sets/gets whether this component is enabled or not.
	 */
	public function setEnabled(value:Bool):Bool
	{
		_enabled = value;
		mouseEnabled = mouseChildren = _enabled;
		#if flash
		_comp.tabEnabled = value;
		#end
		_comp.alpha = _enabled ? 1.0 : 0.5;
		return value;
	}
	
	public function getEnabled():Bool
	{
		return _enabled;
	}
	
	public function getMouseX():Float
	{
		return _comp.mouseX;
	}
	
	public function getMouseY():Float
	{
		return _comp.mouseY;
	}
	
	public function getMouseEnabled():Bool
	{
		return _comp.mouseEnabled;
	}
	
	public function setMouseEnabled(val:Bool):Bool
	{
		_comp.mouseEnabled = val;
		return val;
	}

	public function getMouseChildren():Bool
	{
		return _comp.mouseChildren;
	}
	
	public function setMouseChildren(val:Bool):Bool
	{
		_comp.mouseChildren = val;
		return val;
	}

	public function getButtonMode():Bool
	{
		return _comp.buttonMode;
	}
	
	public function setButtonMode(b:Bool):Bool
	{
		_comp.buttonMode = b;
		return b;
	}

	public function getUseHandCursor():Bool
	{
		return _comp.useHandCursor;
	}
	
	public function setUseHandCursor(b:Bool):Bool
	{
		_comp.useHandCursor = b;
		return b;
	}
	
	#if flash
	public function getFilters():Array<BitmapFilter>
	{
		return _comp.filters;
	}
	
	public function setFilters(filterArr:Array<BitmapFilter>):Array<BitmapFilter>
	{
		_comp.filters = filterArr;
		return filterArr;
	}
	#else
	public function getFilters():Array<Dynamic>
	{
		return _comp.filters;
	}
	
	public function setFilters(filterArr:Array<Dynamic>):Array<Dynamic>
	{
		_comp.filters = filterArr;
		return filterArr;
	}
	#end
	
	public function getStage():Stage
	{
		return _comp.stage;
	}
	
	public function getNumChildren():Int
	{
		return _comp.numChildren;
	}
	
	public function getChildAt(n:Int):DisplayObject 
	{
		return _comp.getChildAt(n);
	}
	
	public function getVisible():Bool 
	{
		return _comp.visible;
	}
	
	public function setVisible(visible:Bool):Bool 
	{
		_comp.visible = visible;
		dispatchEvent(new Event(Event.RESIZE));
		return visible;
	}
	
	public function getGraphics():Graphics 
	{
		return _comp.graphics;
	}
	
	public function getAlpha():Float
	{
		return _comp.alpha;
	}
	
	public function setAlpha(val:Float):Float
	{
		_comp.alpha = val;
		return val;
	}

  public function hide () : Void
  {
    _comp.visible = false;
  }

  public function show () : Void
  {
    _comp.visible = true;
  }

  public function getComponent () : Sprite
  {
    return _comp;
  }
}
