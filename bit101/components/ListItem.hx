/**
* ListItem.as
* Keith Peters
* version 0.9.10
* 
* A single item in a list. 
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


class ListItem extends ViewItem
{
	var _label:Label;
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this ListItem.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param data The string to display as a label or object with a label property.
	 */
	public function new(?parent:Dynamic = null, ?xpos:Float = 0, ?ypos:Float = 0, ?data:Dynamic = null)
	{
		super(parent, xpos, ypos, data);
	}
	
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override function addChildren():Void
	{
		super.addChildren();
		_label = new Label(this, 5, 0);
		_label.draw();
	}
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/**
	 * Draws the data.
	 */
	public override function drawData () : Void
	{
    super.drawData ();

		if(Std.is(_data, String))
		{
			_label.text = Std.string(_data);
		}
		else if(Reflect.hasField(_data, "label") && Std.is(Reflect.field(_data, "label"), String))
		{
			_label.text = Reflect.field(_data, "label");// _data.label;
		}
		else
		{
			_label.text = Std.string(_data);
		}
	}
	
}
