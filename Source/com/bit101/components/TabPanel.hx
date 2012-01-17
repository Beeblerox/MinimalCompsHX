/**
* TabPanel.as
* Jos Yule
* version 0.1
* 
* Essentially a bunch of Push Buttons with a bunch of Panels below. 
* 
* Copyright (c) 2011 Jos Yule
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

class TabPanel extends Component
{
	var _tabs:Array<Dynamic>;
	var _hbox:HBox;
  var TABS : Int;
	
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this Panel.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 */
	public function new(?parent:Dynamic = null, ?xpos:Float = 0, ?ypos:Float = 0, ?tabs = 2)
	{
    TABS = tabs;
		super(parent, xpos, ypos);
	}
	
	
	/**
	 * Initializes the component.
	 */
	override function init():Void
	{
		super.init();
		setSize(200, 150);
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override function addChildren():Void
	{
		var tab:PushButton;
		var panel:Panel;
		
		_hbox = new HBox(this);
		_hbox.spacing = 0;
		
		_tabs = new Array<Dynamic>();
		
		for (i in 0...TABS)
		{
			tab = new PushButton(_hbox, 0,0, "Tab " + i, tabSelected);
			tab.toggle = true;
			
			panel = new Panel(this, 0, tab.height - 1);
			panel.visible = false;
			
			_tabs.push({tab:tab, panel:panel});
		}
		
    if (_tabs.length > 0)
    {
      cast(_tabs[0].tab, PushButton).selected = true;
      cast(_tabs[0].panel, Panel).visible = true;
    }
	}
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/**
	 * Adds a new window to the bottom of the accordion.
	 * @param title The title of the new tab.
	 */
	public function addTab(title:String):Int
	{
		return addTabAt(title, _tabs.length);
	}
	
	public function addTabAt(title:String, index:Int):Int
	{
    var isNew : Bool = _tabs.length == 0;
		
		var pb:PushButton;
		var p:Panel;
		
		index = Std.int(Math.min(index, _tabs.length));
		index = Std.int(Math.max(index, 0));
		
		pb = new PushButton(null, 0, 0, title, tabSelected);
		pb.toggle = true;
		pb.selected = false;
		
		p = new Panel(this, 0, pb.height - 1);
		p.visible = false;
		
		_hbox.addChildAt(pb, index);
		
		_tabs.insert(index, {tab:pb, panel:p});

    if (isNew)
    {
      cast(_tabs[0].tab, PushButton).selected = true;
      cast(_tabs[0].panel, Panel).visible = true;
    }

    _resize ();
		invalidate();
    return index;
	}

  private function _resize () : Void
  {
		var tabW:Float = Math.round(width / _tabs.length);
		var tabH:Float = cast(_tabs[0].tab, PushButton).height;

		for (i in 0..._tabs.length)
		{
			cast (_tabs[i].tab, PushButton).width = tabW;
			cast (_tabs[i].panel, Panel).setSize(width, height - tabH);
		}
  }
	
	
	override public function draw():Void
	{
    _hbox.setY (height - _hbox.height);
    for (i in 0..._tabs.length)
    {
      _tabs[i].panel.setY (0);
    }

    _resize ();

		_hbox.draw();
	}
	
	/**
	 * Returns the Window at the specified index.
	 * @param index The index of the Window you want to get access to.
	 */
	public function getTabAt(index:Int):Panel
	{
		return _tabs[index].panel;
	}
	
  public function getTabButtonAt (index : Int) : PushButton
  {
    return _tabs[index].tab;
  }
	
	public function setTabNameAt(name:String, index:Int):Void
	{
		if (index >= _tabs.length) return;
		cast (_tabs[index].tab, PushButton).label = name;
		invalidate();
	}
		
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Called when any tab is pressed. Makes that tabs panel visible, and toggles the selected state for all the 
	 * other tabs to off. 
	 * */
	function tabSelected(e:Event):Void
	{
		var pb:PushButton;
		var p:Panel;
		
		var target = e.target;
		
		for (i in 0..._tabs.length)
		{
			pb = cast(_tabs[i].tab, PushButton);
			p = cast(_tabs[i].panel, Panel);
			
			if (pb.contains(target))
			{
				p.visible = true;
			}
			else
			{
				p.visible = false;
				pb.selected = false;
			}
		}

    dispatchEvent (new Event (Event.TAB_INDEX_CHANGE));
	}

  public function selected () : Int
  {
    for (i in 0..._tabs.length)
    {
      if (cast (_tabs[i].tab, PushButton).selected)
      {
        return i;
      }
    }

    return -1;
  }
	
  public function getHeaderHeight () : Float
  {
    return _hbox.height;
  }

  public function getPanelHeight () : Float
  {
    return getHeight () - getHeaderHeight ();
  }
	
}

