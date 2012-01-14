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
  private var _items : Array <ListItem>;

  public function new (data : Array <Dynamic>)
  {
    _data = data;
    _items = new Array ();
    for (_ in data)
    {
      _items.push (null);
    }
  }

  public function getRowCount () : Int
  {
    return _items.length;
  }

  public function getColumnCount () : Int
  {
    return 1;
  }

  public function data (row : Int, column : Int) : ListItem
  {
    if (null == _items[row])
    {
      _items[row] = new ListItem (null);
      _items[row].data = _data[row];
    }

    return _items[row];
  }
}
