/**
* FPSMeter.as
* Keith Peters
* version 0.9.10
* 
* An simple component showing the frames per second the current movie is running at.
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
import flash.Lib;


class FPSMeter extends Component
{
	
	public var prefix(getPrefix, setPrefix):String;
	public var fps(getFps, null):Int;
	
	var _label:Label;
	var _startTime:Int;
	var _frames:Int;
	var _prefix:String;
	var _fps:Int;
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this ColorChooser.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param prefix A string to put in front of the number value shown. Default is "FPS:".
	 */
	
	public function new(?parent:Dynamic = null, ?xpos:Float = 0, ?ypos:Float = 0, ?prefix:String = "FPS:")
	{
		_prefix = "";
		_fps = 0;
		
		super(parent, xpos, ypos);
		_prefix = prefix;
		_frames = 0;
		_startTime = Lib.getTimer();
		setSize(50, 20);
		if(stage != null)
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
	}
	
	override function addChildren():Void
	{
		super.addChildren();
		_label = new Label(this, 0, 0);
	}
	
	
	public override function draw():Void
	{
		_label.text = _prefix + Std.string(_fps);
	}
	
	/**
	 * Internal enterFrame handler to measure fps and update label.
	 */
	function onEnterFrame(event:Event):Void
	{
		// Increment frame count each frame. When more than a second has passed, 
		// display number of accumulated frames and reset.
		// Thus FPS will only be calculated and displayed once per second.
		// There are more responsive methods that calculate FPS on every frame. 
		// This method is uses less CPU and avoids the "jitter" of those other methods.
		_frames++;
		var time:Int = Lib.getTimer();
		var elapsed:Int = time - _startTime;
		if(elapsed >= 1000)
		{
			_fps = Math.round(_frames * 1000 / elapsed);
			_frames = 0;
			_startTime = time;
			draw();
		}
	}
	
	/**
	 * Stops the meter if it is removed from stage.
	 */
	function onRemovedFromStage(event:Event):Void
	{
		stop();
	}
	
	/**
	 * Stops the meter by removing the enterFrame listener.
	 */
	public function stop():Void
	{
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	/**
	 * Starts the meter again if it has been stopped.
	 */
	public function start():Void
	{
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	/**
	 * Sets or gets the prefix shown before the number. Defaults to "FPS:".
	 */
	public function setPrefix(value:String):String
	{
		_prefix = value;
		return value;
	}
	
	public function getPrefix():String
	{
		return _prefix;
	}
	
	/**
	 * Returns the current calculated FPS.
	 */
	public function getFps():Int
	{
		return _fps;
	}
}