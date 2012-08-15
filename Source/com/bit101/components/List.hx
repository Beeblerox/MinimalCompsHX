/**
* List.as
* Keith Peters
* version 0.9.10
* 
* A scrolling list of selectable items. 
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
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

class List extends Component
{
  public var selectedIndex(getSelectedIndex, setSelectedIndex):Int;
  public var selectedItem(getSelectedItem, setSelectedItem):Dynamic;
  public var defaultColor(getDefaultColor, setDefaultColor):Int;
  public var selectedColor(getSelectedColor, setSelectedColor):Int;
  public var rolloverColor(getRolloverColor, setRolloverColor):Int;
  public var listItemHeight(getListItemHeight, setListItemHeight):Float;
  public var items(getItems, setItems):Array<Dynamic>;
  public var listItemClass(getListItemClass, setListItemClass):Class<ListItem>;
  public var alternateColor(getAlternateColor, setAlternateColor):Int;
  public var alternateRows(getAlternateRows, setAlternateRows):Bool;
  public var autoHideScrollBar(getAutoHideScrollBar, setAutoHideScrollBar):Bool;
  
  public var numItemsToShow(getNumItemsToShow, setNumItemsToShow):Int;
  public var autoHeight(getAutoHeight, setAutoHeight):Bool;
  
  var _items:Array<Dynamic>;
  var _itemHolder:Sprite;
  var _panel:Panel;
  var _listItemHeight:Float;
  var _listItemClass:Class<ListItem>;
  var _scrollbar:VScrollBar;
  var _selectedIndex:Int;
  var _defaultColor:Int;
  var _alternateColor:Int;
  var _selectedColor:Int;
  var _rolloverColor:Int;
  var _alternateRows:Bool;
  
  var _numItemsToShow:Int;
  var _autoHeight:Bool;
  
  var _listItems:Array<ListItem>;
  
  /**
   * Constructor
   * @param parent The parent DisplayObjectContainer on which to add this List.
   * @param xpos The x position to place this component.
   * @param ypos The y position to place this component.
   * @param items An array of items to display in the list. Either strings or objects with label property.
   */
  public function new(?parent:Dynamic = null, ?xpos:Float = 0, ?ypos:Float = 0, ?items:Array<Dynamic> = null)
  {
    _listItemHeight = 20;
    _listItemClass = ListItem;
    _selectedIndex = -1;
    _defaultColor = Style.LIST_DEFAULT;
    _alternateColor = Style.LIST_ALTERNATE;
    _selectedColor = Style.LIST_SELECTED;
    _rolloverColor = Style.LIST_ROLLOVER;
    _alternateRows = false;
    
    _numItemsToShow = 5;
    _autoHeight = false;
    
    if(items != null)
    {
      _items = items;
    }
    else
    {
      _items = new Array();
    }
    
    _listItems = new Array<ListItem>();
    
    super(parent, xpos, ypos);
  }
  
  /**
   * Initilizes the component.
   */
  override function init():Void
  {
    super.init();
    setSize(100, 100);
    addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
    addEventListener(Event.RESIZE, onResize);
    makeListItems();
    fillItems();
  }
  
  /**
   * Creates and adds the child display objects of this component.
   */
  override function addChildren():Void
  {
    super.addChildren();
    _panel = new Panel(this, 0, 0);
    _panel.color = _defaultColor;
    _itemHolder = new Sprite();
    _panel.content.addChild(_itemHolder);
    _scrollbar = new VScrollBar(this, 0, 0, onScroll);
    _scrollbar.setSliderParams(0, 0, 0);
  }
  
  /**
   * Creates all the list items based on data.
   */
  function makeListItems():Void
  {
    _listItems = [];
    while (_itemHolder.numChildren > 0)
    {
      var displayItem : DisplayObject = _itemHolder.getChildAt(0);
      displayItem.removeEventListener(MouseEvent.CLICK, onSelect);
      _itemHolder.removeChildAt(0);
    }

    var numItems:Int = Math.ceil(_height / _listItemHeight);
    numItems = Std.int(Math.min(numItems, _items.length));
    numItems = Std.int(Math.max(numItems, 1));
    for (i in 0...numItems)
    {
      var item : ListItem = new ListItem (_itemHolder, 0, i * _listItemHeight);
      item.setSize(width, _listItemHeight);
      item.defaultColor = _defaultColor;

      item.selectedColor = _selectedColor;
      item.rolloverColor = _rolloverColor;
      item.addEventListener(MouseEvent.CLICK, onSelect);
      
      _listItems.push(item);
    }
  }

  function fillItems():Void
  {
    var offset:Int = Std.int(_scrollbar.value);
    var numItems:Int = Math.ceil(_height / _listItemHeight);
    numItems = Std.int(Math.min(numItems, _items.length));
    
    // TODO: Fix this
    if (_autoHeight)
    {
      _height = Std.int(Math.min(numItemsToShow * _listItemHeight, numItems * _listItemHeight));
    }
    // TODO: Fix this
    for (i in 0...numItems)
    {
      var item : ListItem = _listItems[i];
      if (offset + i < _items.length)
      {
        item.data = _items[offset + i];
      }
      else
      {
        item.data = "";
      }
      if(_alternateRows)
      {
        item.defaultColor = ((offset + i) % 2 == 0) ? _defaultColor : _alternateColor;
      }
      else
      {
        item.defaultColor = _defaultColor;
      }
      if(offset + i == _selectedIndex)
      {
        item.selected = true;
      }
      else
      {
        item.selected = false;
      }
    }
  }
  
  /**
   * If the selected item is not in view, scrolls the list to make the selected item appear in the view.
   */
  public function scrollToSelection():Void
  {
    var numItems:Int = Math.ceil(_height / _listItemHeight);
    if(_selectedIndex != -1)
    {
      if(_scrollbar.value > _selectedIndex)
      {
//                    _scrollbar.value = _selectedIndex;
      }
      else if(_scrollbar.value + numItems < _selectedIndex)
      {
        _scrollbar.value = _selectedIndex - numItems + 1;
      }
    }
    else
    {
      _scrollbar.value = 0;
    }
    fillItems();
  }
  
  
  
  ///////////////////////////////////
  // public methods
  ///////////////////////////////////
  
  /**
   * Sets the size of the list. This alters numItemsToShow.
   * @param w The width of the list.
   * @param h The height of the list.
   */
  public override function setSize(w:Float, h:Float):Void
  {
    _numItemsToShow = Math.ceil(h / _listItemHeight);
    super.setSize(w, h);
  }
  
  /**
   * Draws the visual ui of the component.
   */
  public override function draw():Void
  {
    super.draw();
    
    _selectedIndex = Std.int(Math.min(_selectedIndex, _items.length - 1));

    // panel
    _panel.setSize(_width, _height);
    _panel.color = _defaultColor;
    _panel.draw();
    
    // scrollbar
    _scrollbar.x = _width - 10;
    var contentHeight:Float = _items.length * _listItemHeight;
    _scrollbar.setThumbPercent(_height / contentHeight); 
    #if flash
    var pageSize:Float = Math.floor(_height / _listItemHeight);
    #else
    var pageSize:Float = Math.ceil(_height / _listItemHeight);
    #end
    _scrollbar.maximum = Math.max(0, _items.length - pageSize);
    _scrollbar.pageSize = Std.int(pageSize);
    _scrollbar.height = _height;
    _scrollbar.draw();
    scrollToSelection();
    
    #if !flash
    graphics.clear();
    graphics.lineStyle(1, 0, 0.1);
    graphics.drawRect(-1, -1, width + 1, height + 1);
    #end
  }
  
  /**
   * Adds an item to the list.
   * @param item The item to add. Can be a string or an object containing a string property named label.
   */
  public function addItem(item:Dynamic):Void
  {
    _items.push(item);
    invalidate();
    makeListItems();
    fillItems();
  }
  
  /**
   * Adds an item to the list at the specified index.
   * @param item The item to add. Can be a string or an object containing a string property named label.
   * @param index The index at which to add the item.
   */
  public function addItemAt(item:Dynamic, index:Int):Void
  {
    index = Std.int(Math.max(0, index));
    index = Std.int(Math.min(_items.length, index));
    //_items.splice(index, 0, item);
    _items.insert(index, item);
    invalidate();
    makeListItems();
    fillItems();
  }
  
  /**
   * Removes the referenced item from the list.
   * @param item The item to remove. If a string, must match the item containing that string. If an object, must be a reference to the exact same object.
   */
  public function removeItem(item:Dynamic):Void
  {
    //var index:Int = _items.indexOf(item);
    for (i in 0..._items.length)
    {
      if (item == _items[i])
      {
        removeItemAt(i);
        break;
      }
    }
    //removeItemAt(index);
  }
  
  /**
   * Removes the item from the list at the specified index
   * @param index The index of the item to remove.
   */
  public function removeItemAt(index:Int):Void
  {
    if (index < 0 || index >= _items.length) return;
    _items.splice(index, 1);
    invalidate();
    makeListItems();
    fillItems();
  }
  
  /**
   * Removes all items from the list.
   */
  public function removeAll():Void
  {
    _items = [];
    invalidate();
    makeListItems();
    fillItems();
  }
  
  
  
  
  
  ///////////////////////////////////
  // event handlers
  ///////////////////////////////////
  
  /**
   * Called when a user selects an item in the list.
   */
  function onSelect(event:Event):Void
  {
    // TODO: Fix this
    //if(!Std.is(event.target, ListItem)) return;
    
    var offset:Int = Std.int(_scrollbar.value);
    
    for (i in 0..._itemHolder.numChildren)
    {
      if (_itemHolder.getChildAt(i) == event.target) _selectedIndex = i + offset;
      //cast(_itemHolder.getChildAt(i), ListItem).selected = false;
      cast(_listItems[i], ListItem).selected = false;
    }
    //cast(event.target, ListItem).selected = true;
    //selectedIndex = _selectedIndex;
	
	if (_selectedIndex >= _items.length)
    {
		_selectedIndex = -1;
    }
	
	if (_selectedIndex - offset >= 0)
	{
		cast(_listItems[_selectedIndex - offset], ListItem).selected =  true;
	}
	
    dispatchEvent(new Event(Event.SELECT));
  }
  
  /**
   * Called when the user scrolls the scroll bar.
   */
  function onScroll(event:Event):Void
  {
    fillItems();
  }
  
  /**
   * Called when the mouse wheel is scrolled over the component.
   */
  function onMouseWheel(event:MouseEvent):Void
  {
    _scrollbar.value -= event.delta;
    fillItems();
  }

  function onResize(event:Event):Void
  {
    makeListItems();
    fillItems();
  }
  ///////////////////////////////////
  // getter/setters
  ///////////////////////////////////
  
  /**
   * Sets / gets the index of the selected list item.
   */
  public function setSelectedIndex(value:Int):Int
  {
    if (value >= 0 && value < _items.length)
    {
      _selectedIndex = value;
//        _scrollbar.value = _selectedIndex;
    }
    else
    {
      _selectedIndex = -1;
    }
    invalidate();
    dispatchEvent(new Event(Event.SELECT));
    return _selectedIndex;
  }
  
  public function getSelectedIndex():Int
  {
    return _selectedIndex;
  }
  
  /**
   * Sets / gets the item in the list, if it exists.
   */
  public function setSelectedItem(item:Dynamic):Dynamic
  {
    var index:Int = -1; //_items.indexOf(item);
    for (i in 0..._items.length)
    {
      if (item == _items[i])
      {
        index = i;
        break;
      }
    }
//      if(index != -1)
//      {
      selectedIndex = index;
      invalidate();
      dispatchEvent(new Event(Event.SELECT));
//      }
    return item;
  }
  
  public function getSelectedItem():Dynamic
  {
    if(_selectedIndex >= 0 && _selectedIndex < _items.length)
    {
      return _items[_selectedIndex];
    }
    return null;
  }

  /**
   * Sets/gets the default background color of list items.
   */
  public function setDefaultColor(value:Int):Int
  {
    if (value >= 0)
    {
      _defaultColor = value;
      invalidate();
    }
    return value;
  }
  
  public function getDefaultColor():Int
  {
    return _defaultColor;
  }

  /**
   * Sets/gets the selected background color of list items.
   */
  public function setSelectedColor(value:Int):Int
  {
    if (value >= 0)
    {
      _selectedColor = value;
      invalidate();
    }
    return value;
  }
  
  public function getSelectedColor():Int
  {
    return _selectedColor;
  }

  /**
   * Sets/gets the rollover background color of list items.
   */
  public function setRolloverColor(value:Int):Int
  {
    if (value >= 0)
    {
      _rolloverColor = value;
      invalidate();
    }
    return value;
  }
  
  public function getRolloverColor():Int
  {
    return _rolloverColor;
  }

  /**
   * Sets the height of each list item.
   */
  public function setListItemHeight(value:Float):Float
  {
    _listItemHeight = value;
    makeListItems();
    invalidate();
    return value;
  }
  
  public function getListItemHeight():Float
  {
    return _listItemHeight;
  }

  /**
   * Sets / gets the list of items to be shown.
   */
  public function setItems(value:Array<Dynamic>):Array<Dynamic>
  {
    _items = value;
    invalidate();
    return value;
  }
  
  public function getItems():Array<Dynamic>
  {
    return _items;
  }

  /**
   * Sets / gets the class used to render list items. Must extend ListItem.
   */
  public function setListItemClass(value:Class<ListItem>):Class<ListItem>
  {
    _listItemClass = value;
    makeListItems();
    invalidate();
    return value;
  }
  
  public function getListItemClass():Class<ListItem>
  {
    return _listItemClass;
  }

  /**
   * Sets / gets the color for alternate rows if alternateRows is set to true.
   */
  public function setAlternateColor(value:Int):Int
  {
    if (value >= 0)
    {
      _alternateColor = value;
      invalidate();
    }
    return value;
  }
  
  public function getAlternateColor():Int
  {
    return _alternateColor;
  }
  
  /**
   * Sets / gets whether or not every other row will be colored with the alternate color.
   */
  public function setAlternateRows(value:Bool):Bool
  {
    _alternateRows = value;
    invalidate();
    return value;
  }
  
  public function getAlternateRows():Bool
  {
    return _alternateRows;
  }

  /**
   * Sets / gets whether the scrollbar will auto hide when there is nothing to scroll.
   */
  public function setAutoHideScrollBar(value:Bool):Bool
  {
    _scrollbar.autoHide = value;
    return value;
  }
  
  public function getAutoHideScrollBar():Bool
  {
    return _scrollbar.autoHide;
  }
  
  public function setNumItemsToShow(value:Int):Int
  {
    if (value > 0)
    {
      _numItemsToShow = value;
      height = _numItemsToShow * _listItemHeight;
      //draw();
    }
    return value;
  }
  
  public function getNumItemsToShow():Int
  {
    return _numItemsToShow;
  }
  
  public function getAutoHeight():Bool
  {
    return _autoHeight;
  }
  
  public function setAutoHeight(value:Bool):Bool
  {
    _autoHeight = value;
    fillItems();
    return value;
  }
  
  override public function setHeight(h:Float):Float
  {
    _numItemsToShow = Math.ceil(h / _listItemHeight);
    return super.setHeight(h);
  }

}

