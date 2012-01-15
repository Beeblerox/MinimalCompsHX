package com.bit101.components;

import com.bit101.components.ListItem;
import com.bit101.components.IItemsModel;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.errors.Error;

class ListItemsModel implements IItemsModel
{
  public var rowCount (getRowCount, null) : Int;
  public var columnCount (getColumnCount, null) : Int;

  private var _data : Array <Dynamic>;
  private var _items : Array <ViewItem>;

  public function new (data : Array <Dynamic>)
  {
    _data = data;
    _items = new Array ();
    for (_ in 0...rowCount * columnCount)
    {
      _items.push (null);
    }
  }

  public function getRowCount () : Int
  {
    return _data.length;
  }

  public function getColumnCount () : Int
  {
    return 1;
  }

  public function getItemWidth (column : Int, ?width : Float = 0) : Float
  {
    return width / columnCount;
  }

  public function getItemHeight () : Float
  {
    return 20;
  }

  public function data (row : Int, column : Int) : ViewItem
  {
    var index : Int = row * columnCount + column;
    if (null == _items[index])
    {
      _items[index] = new ListItem (null);
      _items[index].data = _data[row];
    }

    return _items[index];
  }
}
