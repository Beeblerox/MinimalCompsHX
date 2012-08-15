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

import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;

class ComboBox extends Component
{
	
	public var selectedIndex(getSelectedIndex, setSelectedIndex):Int;
	public var selectedItem(getSelectedItem, setSelectedItem):Dynamic;
	public var defaultColor(getDefaultColor, setDefaultColor):Int;
	public var selectedColor(getSelectedColor, setSelectedColor):Int;
	public var rolloverColor(getRolloverColor, setRolloverColor):Int;
	public var listItemHeight(getListItemHeight, setListItemHeight):Float;
	public var openPosition(getOpenPosition, setOpenPosition):String;
	public var defaultLabel(getDefaultLabel, setDefaultLabel):String;
	public var numVisibleItems(getNumVisibleItems, setNumVisibleItems):Int;
	public var items(getItems, setItems):Array<Dynamic>;
	public var listItemClass(getListItemClass, setListItemClass):Class<ListItem>;
	public var alternateRows(getAlternateRows, setAlternateRows):Bool;
	public var autoHideScrollBar(getAutoHideScrollBar, setAutoHideScrollBar):Bool;
	public var isOpen(getIsOpen, null):Bool;
	public var alternateColor(getAlternateColor, setAlternateColor):Int;
	
	public static inline var TOP:String = "top";
	public static inline var BOTTOM:String = "bottom";
	
	var _defaultLabel:String;
	var _dropDownButton:PushButton;
	var _items:Array<Dynamic>;
	var _labelButton:PushButton;
	var _list:List;
	var _numVisibleItems:Int;
	var _open:Bool;
	var _openPosition:String;
	var _stage:Stage;
	
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this List.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 * @param defaultLabel The label to show when no item is selected.
	 * @param items An array of items to display in the list. Either strings or objects with label property.
	 */
	public function new(?parent:Dynamic = null, ?xpos:Float = 0, ?ypos:Float = 0, ?defaultLabel:String = "", ?items:Array<Dynamic> = null)
	{
		_defaultLabel = "";
		_numVisibleItems = 6;
		_open = false;
		_openPosition = BOTTOM;
		
		_defaultLabel = defaultLabel;
		_items = items;
		super(parent, xpos, ypos);
		if (parent != null) _stage = _comp.stage;
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
	}
	
	/**
	 * Initilizes the component.
	 */
	override function init():Void
	{
		super.init();
		setSize(100, 20);
		setLabelButtonLabel();
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	override function addChildren():Void
	{
		super.addChildren();
		_list = new List(null, 0, 0, _items);
		_list.autoHeight = true;
		_list.autoHideScrollBar = true;
		_list.addEventListener(Event.SELECT, onSelect);
		
		_labelButton = new PushButton(this, 0, 0, "", onDropDown);
		_dropDownButton = new PushButton(this, 0, 0, "+", onDropDown);
	}
	
	/**
	 * Determines what to use for the main button label and sets it.
	 */
	function setLabelButtonLabel():Void
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
			_labelButton.label = selectedItem.toString();
		}
	}
	
	/**
	 * Removes the list from the stage.
	 */
	function removeList():Void
	{
		// TODO: Fix this
		/*if (_stage.contains(_list)) 
		{
			_stage.removeChild(_list);
		}*/
		if (_list.isDisplayObjectContainsThisComponent(_stage))
		{
			_list.removeFromDisplay(_stage);
		}
		_stage.removeEventListener(MouseEvent.CLICK, onStageClick);
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
		invalidate();
	}
	
	/**
	 * Adds an item to the list at the specified index.
	 * @param item The item to add. Can be a string or an object containing a string property named label.
	 * @param index The index at which to add the item.
	 */
	public function addItemAt(item:Dynamic, index:Int):Void
	{
		_list.addItemAt(item, index);
		invalidate();
	}
	
	/**
	 * Removes the referenced item from the list.
	 * @param item The item to remove. If a string, must match the item containing that string. If an object, must be a reference to the exact same object.
	 */
	public function removeItem(item:Dynamic):Void
	{
		_list.removeItem(item);
		invalidate();
	}
	
	/**
	 * Removes the item from the list at the specified index
	 * @param index The index of the item to remove.
	 */
	public function removeItemAt(index:Int):Void
	{
		_list.removeItemAt(index);
		invalidate();
	}
	
	/**
	 * Removes all items from the list.
	 */
	public function removeAll():Void
	{
		_list.removeAll();
		invalidate();
	}

	
	
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Called when one of the top buttons is pressed. Either opens or closes the list.
	 */
	function onDropDown(event:MouseEvent):Void
	{
		_open = !_open;
		if(_open)
		{
			var point:Point = new Point();
			if(_openPosition == BOTTOM)
			{
				point.y = _height;
			}
			else
			{
				point.y = -_list.height;
			}
			point = this.localToGlobal(point);
			_list.move(point.x, point.y);
			// TODO: Fix this
			/*_stage.addChild(_list);*/
			_stage.addEventListener(MouseEvent.CLICK, onStageClick);
			_list.addToDisplay(_stage);
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
	function onStageClick(event:MouseEvent):Void
	{
		// ignore clicks within buttons or list
		if (_dropDownButton.contains(event.target) || _labelButton.contains(event.target)) 
		{
			return;
		}
		if (new Rectangle(_list.x, _list.y, _list.width, _list.height).contains(event.stageX, event.stageY)) 
		{
			return;
		}
		_open = false;
		removeList();
	}
	
	/**
	 * Called when an item in the list is selected. Displays that item in the label button.
	 */
	function onSelect(event:Event):Void
	{
		_open = false;
		_dropDownButton.label = "+";
		// TODO: Fix this
		/*if(stage != null && stage.contains(_list))
		{
			stage.removeChild(_list);
		}*/
		if (_stage != null && _list.isDisplayObjectContainsThisComponent(_stage))
		{
			_list.removeFromDisplay(_stage);
		}
		setLabelButtonLabel();
		dispatchEvent(event);
	}
	
	/**
	 * Called when the component is added to the stage.
	 */
	function onAddedToStage(event:Event):Void
	{
		_stage = _comp.stage;
	}
	
	/**
	 * Called when the component is removed from the stage.
	 */
	function onRemovedFromStage(event:Event):Void
	{
		removeList();
	}
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	/**
	 * Sets / gets the index of the selected list item.
	 */
	public function setSelectedIndex(value:Int):Int
	{
		_list.selectedIndex = value;
		setLabelButtonLabel();
		return value;
	}
	
	public function getSelectedIndex():Int
	{
		return _list.selectedIndex;
	}
	
	/**
	 * Sets / gets the item in the list, if it exists.
	 */
	public function setSelectedItem(item:Dynamic):Dynamic
	{
		_list.selectedItem = item;
		setLabelButtonLabel();
		return item;
	}
	
	public function getSelectedItem():Dynamic
	{
		return _list.selectedItem;
	}
	
	/**
	 * Sets/gets the default background color of list items.
	 */
	public function setDefaultColor(value:Int):Int
	{
		if (value >= 0)
		{
			_list.defaultColor = value;
		}
		return value;
	}
	
	public function getDefaultColor():Int
	{
		return _list.defaultColor;
	}
	
	/**
	 * Sets/gets the selected background color of list items.
	 */
	public function setSelectedColor(value:Int):Int
	{
		if (value >= 0)
		{
			_list.selectedColor = value;
		}
		return value;
	}
	
	public function getSelectedColor():Int
	{
		return _list.selectedColor;
	}
	
	/**
	 * Sets/gets the rollover background color of list items.
	 */
	public function setRolloverColor(value:Int):Int
	{
		if (value >= 0)
		{
			_list.rolloverColor = value;
		}
		return value;
	}
	
	public function getRolloverColor():Int
	{
		return _list.rolloverColor;
	}
	
	/**
	 * Sets the height of each list item.
	 */
	public function setListItemHeight(value:Float):Float
	{
		_list.listItemHeight = value;
		invalidate();
		return value;
	}
	
	public function getListItemHeight():Float
	{
		return _list.listItemHeight;
	}

	/**
	 * Sets / gets the position the list will open on: top or bottom.
	 */
	public function setOpenPosition(value:String):String
	{
		_openPosition = value;
		return value;
	}
	
	public function getOpenPosition():String
	{
		return _openPosition;
	}

	/**
	 * Sets / gets the label that will be shown if no item is selected.
	 */
	public function setDefaultLabel(value:String):String
	{
		_defaultLabel = value;
		setLabelButtonLabel();
		return value;
	}
	
	public function getDefaultLabel():String
	{
		return _defaultLabel;
	}

	/**
	 * Sets / gets the number of visible items in the drop down list. i.e. the height of the list.
	 */
	public function setNumVisibleItems(value:Int):Int
	{
		_numVisibleItems = value;
		invalidate();
		return value;
	}
	
	public function getNumVisibleItems():Int
	{
		return _numVisibleItems;
	}

	/**
	 * Sets / gets the list of items to be shown.
	 */
	public function setItems(value:Array<Dynamic>):Array<Dynamic>
	{
		removeAll();
		for (o in value) 
		{
			addItem(o);
		}
		return value;
	}
	
	public function getItems():Array<Dynamic>
	{
		return _list.items;
	}
	
	/**
	 * Sets / gets the class used to render list items. Must extend ListItem.
	 */
	public function setListItemClass(value:Class<ListItem>):Class<ListItem>
	{
		_list.listItemClass = value;
		return value;
	}
	
	public function getListItemClass():Class<ListItem>
	{
		return _list.listItemClass;
	}
	
	
	/**
	 * Sets / gets the color for alternate rows if alternateRows is set to true.
	 */
	public function setAlternateColor(value:Int):Int
	{
		if (value >= 0)
		{
			_list.alternateColor = value;
		}
		return value;
	}
	
	public function getAlternateColor():Int
	{
		return _list.alternateColor;
	}
	
	/**
	 * Sets / gets whether or not every other row will be colored with the alternate color.
	 */
	public function setAlternateRows(value:Bool):Bool
	{
		_list.alternateRows = value;
		return value;
	}
	
	public function getAlternateRows():Bool
	{
		return _list.alternateRows;
	}

	/**
	 * Sets / gets whether the scrollbar will auto hide when there is nothing to scroll.
	 */
	public function setAutoHideScrollBar(value:Bool):Bool
	{
		_list.autoHideScrollBar = value;
		invalidate();
		return value;
	}
	
	public function getAutoHideScrollBar():Bool
	{
		return _list.autoHideScrollBar;
	}
	
	/**
	 * Gets whether or not the combo box is currently open.
	 */
	public function getIsOpen():Bool
	{
		return _open;
	}
}