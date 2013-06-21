/**
* ComboBox.as
* Keith Peters
* version 0.9.10
* 
* A button that exposes a list of choices and displays the chosen item. 
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
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;

enum ComboBoxOpenPosition
{
	TOP;
	BOTTOM;
}

class ComboBox extends Component
{
	private var _defaultLabel:String = "";
	private var _dropDownButton:PushButton;
	private var _items:Array<Dynamic>;
	private var _labelButton:PushButton;
	private var _list:List;
	private var _numVisibleItems:Int = 6;
	private var _open:Bool = false;
	private var _openPosition:ComboBoxOpenPosition;
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this List.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param defaultLabel The label to show when no item is selected.
	 * @param items An array of items to display in the list. Either strings or objects with label property.
	 */
	public function new(parent:DisplayObjectContainer = null, xpos:Float = 0, ypos:Float = 0, defaultLabel:String = "", items:Array<Dynamic> = null)
	{
		_openPosition = ComboBoxOpenPosition.BOTTOM;
		_defaultLabel = defaultLabel;
		_items = items;
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		super(parent, xpos, ypos);
	}
	
	/**
	 * Initilizes the component.
	 */
	private override function init():Void
	{
		super.init();
		setSize(100, 20);
		setLabelButtonLabel();
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	private override function addChildren():Void
	{
		super.addChildren();
		_list = new List(null, 0, 0, _items);
		_list.autoHideScrollBar = true;
		_list.addEventListener(Event.SELECT, onSelect);
		
		_labelButton = new PushButton(this, 0, 0, "", onDropDown);
		_dropDownButton = new PushButton(this, 0, 0, "+", onDropDown);
	}
	
	/**
	 * Determines what to use for the main button label and sets it.
	 */
	private function setLabelButtonLabel():Void
	{
		if(selectedItem == null)
		{
			_labelButton.label = _defaultLabel;
		}
		else if(Std.is(selectedItem, String))
		{
			_labelButton.label = cast(selectedItem, String);
		}
		else if (Reflect.hasField(selectedItem, "label") && Std.is(Reflect.field(selectedItem, "label"), String))
		{
			_labelButton.label = selectedItem.label;
		}
		else
		{
			_labelButton.label = Std.string(selectedItem);
		}
	}
	
	/**
	 * Removes the list from the stage.
	 */
	private function removeList():Void
	{
		if (Lib.current.stage.contains(_list)) Lib.current.stage.removeChild(_list);
		Lib.current.stage.removeEventListener(MouseEvent.CLICK, onStageClick);
		_dropDownButton.label = "+";			
	}
	

	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	public override function draw():Void
	{
		super.draw();
		_labelButton.setSize(_width - _height + 1, _height);
		_labelButton.draw();
		
		_dropDownButton.setSize(_height, _height);
		_dropDownButton.draw();
		_dropDownButton.x = _width - height;
		
		_list.setSize(_width, _numVisibleItems * _list.listItemHeight);
	}
	
	
	/**
	 * Adds an item to the list.
	 * @param item The item to add. Can be a string or an object containing a string property named label.
	 */
	public function addItem(item:Dynamic):Void
	{
		_list.addItem(item);
	}
	
	/**
	 * Adds an item to the list at the specified index.
	 * @param item The item to add. Can be a string or an object containing a string property named label.
	 * @param index The index at which to add the item.
	 */
	public function addItemAt(item:Dynamic, index:Int):Void
	{
		_list.addItemAt(item, index);
	}
	
	/**
	 * Removes the referenced item from the list.
	 * @param item The item to remove. If a string, must match the item containing that string. If an object, must be a reference to the exact same object.
	 */
	public function removeItem(item:Dynamic):Void
	{
		_list.removeItem(item);
	}
	
	/**
	 * Removes the item from the list at the specified index
	 * @param index The index of the item to remove.
	 */
	public function removeItemAt(index:Int):Void
	{
		_list.removeItemAt(index);
	}
	
	/**
	 * Removes all items from the list.
	 */
	public function removeAll():Void
	{
		_list.removeAll();
	}

	
	
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Called when one of the top buttons is pressed. Either opens or closes the list.
	 */
	private function onDropDown(event:MouseEvent):Void
	{
		_open = !_open;
		if (_open)
		{
			var point:Point = new Point();
			if(_openPosition == ComboBoxOpenPosition.BOTTOM)
			{
				point.y = _height;
			}
			else
			{
				point.y = -_numVisibleItems * _list.listItemHeight;
			}
			point = this.localToGlobal(point);
			_list.move(point.x, point.y);
			#if !flash
			_list.parent = Lib.current.stage;
			#end
			Lib.current.stage.addChild(_list);
			_dropDownButton.label = "-";
		}
		else
		{
			removeList();
		}
	}
	
	/**
	 * Called when the mouse is clicked somewhere outside of the combo box when the list is open. Closes the list.
	 */
	private function onStageClick(event:MouseEvent):Void
	{
		// ignore clicks within buttons or list
		if(event.target == _dropDownButton || event.target == _labelButton) return;
		if(new Rectangle(_list.x, _list.y, _list.width, _list.height).contains(event.stageX, event.stageY)) return;
		
		_open = false;
		removeList();
	}
	
	/**
	 * Called when an item in the list is selected. Displays that item in the label button.
	 */
	private function onSelect(event:Event):Void
	{
		_open = false;
		_dropDownButton.label = "+";
		if(Lib.current.stage.contains(_list))
		{
			Lib.current.stage.removeChild(_list);
		}
		setLabelButtonLabel();
		dispatchEvent(event);
	}
	
	/**
	 * Called when the component is removed from the stage.
	 */
	private function onRemovedFromStage(event:Event):Void
	{
		removeList();
	}
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	/**
	 * Sets / gets the index of the selected list item.
	 */
	public var selectedIndex(get, set):Int;
	
	private function set_selectedIndex(value:Int):Int
	{
		_list.selectedIndex = value;
		setLabelButtonLabel();
		return value;
	}
	private function get_selectedIndex():Int
	{
		return _list.selectedIndex;
	}
	
	/**
	 * Sets / gets the item in the list, if it exists.
	 */
	public var selectedItem(get, set):Dynamic;
	
	private function set_selectedItem(item:Dynamic):Dynamic
	{
		_list.selectedItem = item;
		setLabelButtonLabel();
		return item;
	}
	private function get_selectedItem():Dynamic
	{
		return _list.selectedItem;
	}
	
	/**
	 * Sets/gets the default background color of list items.
	 */
	public var defaultColor(get, set):Int;
	
	private function set_defaultColor(value:Int):Int
	{
		_list.defaultColor = value;
		return value;
	}
	private function get_defaultColor():Int
	{
		return _list.defaultColor;
	}
	
	/**
	 * Sets/gets the selected background color of list items.
	 */
	public var selectedColor(get, set):Int;
	
	private function set_selectedColor(value:Int):Int
	{
		_list.selectedColor = value;
		return value;
	}
	private function get_selectedColor():Int
	{
		return _list.selectedColor;
	}
	
	/**
	 * Sets/gets the rollover background color of list items.
	 */
	public var rolloverColor(get, set):Int;
	
	private function set_rolloverColor(value:Int):Int
	{
		_list.rolloverColor = value;
		return value;
	}
	private function get_rolloverColor():Int
	{
		return _list.rolloverColor;
	}
	
	/**
	 * Sets the height of each list item.
	 */
	public var listItemHeight(get, set):Float;
	
	private function set_listItemHeight(value:Float):Float
	{
		_list.listItemHeight = value;
		invalidate();
		return value;
	}
	private function get_listItemHeight():Float
	{
		return _list.listItemHeight;
	}

	/**
	 * Sets / gets the position the list will open on: top or bottom.
	 */
	public var openPosition(get, set):ComboBoxOpenPosition;
	
	private function set_openPosition(value:ComboBoxOpenPosition):ComboBoxOpenPosition
	{
		_openPosition = value;
		return value;
	}
	private function get_openPosition():ComboBoxOpenPosition
	{
		return _openPosition;
	}

	/**
	 * Sets / gets the label that will be shown if no item is selected.
	 */
	public var defaultLabel(get, set):String;
	
	private function set_defaultLabel(value:String):String
	{
		_defaultLabel = value;
		setLabelButtonLabel();
		return value;
	}
	private function get_defaultLabel():String
	{
		return _defaultLabel;
	}

	/**
	 * Sets / gets the number of visible items in the drop down list. i.e. the height of the list.
	 */
	public var numVisibleItems(get, set):Int;
	
	private function set_numVisibleItems(value:Int):Int
	{
		_numVisibleItems = Std.int(Math.max(1, value));
		invalidate();
		return value;
	}
	private function get_numVisibleItems():Int
	{
		return _numVisibleItems;
	}

	/**
	 * Sets / gets the list of items to be shown.
	 */
	public var items(get, set):Array<Dynamic>;
	
	private function set_items(value:Array<Dynamic>):Array<Dynamic>
	{
		_list.items = value;
		return value;
	}
	private function get_items():Array<Dynamic>
	{
		return _list.items;
	}
	
	/**
	 * Sets / gets the class used to render list items. Must extend ListItem.
	 */
	public var listItemClass(get, set):Class<ListItem>;
	
	private function set_listItemClass(value:Class<ListItem>):Class<ListItem>
	{
		_list.listItemClass = value;
		return value;
	}
	private function get_listItemClass():Class<ListItem>
	{
		return _list.listItemClass;
	}
	
	
	/**
	 * Sets / gets the color for alternate rows if alternateRows is set to true.
	 */
	public var alternateColor(get, set):Int;
	private function set_alternateColor(value:Int):Int
	{
		_list.alternateColor = value;
		return value;
	}
	private function get_alternateColor():Int
	{
		return _list.alternateColor;
	}
	
	/**
	 * Sets / gets whether or not every other row will be colored with the alternate color.
	 */
	public var alternateRows(get, set):Bool;
	
	private function set_alternateRows(value:Bool):Bool
	{
		_list.alternateRows = value;
		return value;
	}
	private function get_alternateRows():Bool
	{
		return _list.alternateRows;
	}

	/**
	 * Sets / gets whether the scrollbar will auto hide when there is nothing to scroll.
	 */
	public var autoHideScrollBar(get, set):Bool;
	
	private function set_autoHideScrollBar(value:Bool):Bool
	{
		_list.autoHideScrollBar = value;
		invalidate();
		return value;
	}
	private function get_autoHideScrollBar():Bool
	{
		return _list.autoHideScrollBar;
	}
	
	/**
	 * Gets whether or not the combo box is currently open.
	 */
	public var isOpen(get, null):Bool;
	
	private function get_isOpen():Bool
	{
		return _open;
	}
}