/**
* Component.as
* Keith Peters
* version 0.9.10
* 
* Calendar component for showing and selecting a date.
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

import flash.display.DisplayObjectContainer;
import flash.display.Shape;
import flash.events.Event;
import flash.events.MouseEvent;

class Calendar extends Panel
{
	private var _dateLabel:Label;
	private var _day:Int;
	private var _dayButtons:Array<PushButton>;
	private var _month:Int;
	private var _monthNames:Array<String>;
	private var _selection:Shape;
	private var _year:Int;
	
	/**
	 * Constructor
	 * @param parent The parent DisplayObjectContainer on which to add this component.
	 * @param xpos The x position to place this component.
	 * @param ypos The y position to place this component.
	 */
	public function new(parent:DisplayObjectContainer = null, xpos:Float = 0, ypos:Float = 0)
	{
		_monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		_dayButtons = new Array<PushButton>();
		super(parent, xpos, ypos);
	}
	
	/**
	 * Initializes the component.
	 */
	private override function init():Void
	{
		super.init();
		setSize(140, 140);
		var today:Date = Date.now();
		setDate(today);
	}
	
	/**
	 * Creates and adds the child display objects of this component.
	 */
	private override function addChildren():Void
	{
		super.addChildren();
		for(i in 0...6)
		{
			for(j in 0...7)
			{
				var btn:PushButton = new PushButton(this.content, j * 20, 20 + i * 20);
				btn.setSize(19, 19);
				btn.addEventListener(MouseEvent.CLICK, onDayClick);
				_dayButtons.push(btn);
			}
		}
		
		_dateLabel = new Label(this.content, 25, 0);
		_dateLabel.autoSize = true;
		
		var prevYearBtn:PushButton = new PushButton(this.content, 2, 2, "«", onPrevYear);
		prevYearBtn.setSize(14, 14);
		
		var prevMonthBtn:PushButton = new PushButton(this.content, 17, 2, "<", onPrevMonth);
		prevMonthBtn.setSize(14, 14);
		
		var nextMonthBtn:PushButton = new PushButton(this.content, 108, 2, ">", onNextMonth);
		nextMonthBtn.setSize(14, 14);
		
		var nextYearBtn:PushButton = new PushButton(this.content, 124, 2, "»", onNextYear);
		nextYearBtn.setSize(14, 14);
		
		_selection = new Shape();
		_selection.graphics.beginFill(0, 0.15);
		_selection.graphics.drawRect(1, 1, 18, 18);
		this.content.addChild(_selection);
	}
	
	/**
	 * Gets the last day of the specfied month and year. Needed by layout.
	 * @param month The month to get the last day of.
	 * @param year The year in which the month is in (needed for leap years).
	 * @return The last day of the month.
	 */
	private function getEndDay(month:Int, year:Int):Int
	{
		switch(month)
		{
			case 0:		// jan
			case 2:		// mar
			case 4:		// may
			case 6:		// july
			case 7:		// aug
			case 9:		// oct
			case 11:	// dec
				return 31;			
			case 1:		// feb
				if((year % 400 == 0) ||  ((year % 100 != 0) && (year % 4 == 0))) return 29;
				return 28;
		}
		// april, june, sept, nov.
		return 30;
	}
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/**
	 * Displays specified date in calendar by drawing that month and year and highlighting the day.
	 * @param date The date to display.
	 */
	public function setDate(date:Date):Void
	{
		_year = date.getFullYear();
		_month = date.getMonth();
		_day = date.getDate();
		var startDay:Int = new Date(_year, _month, 1, 0, 0, 0).getDay();
		var endDay:Int = getEndDay(_month, _year);
		for(i in 0...42)
		{
			_dayButtons[i].visible = false;
		}
		for(i in 0...endDay)
		{
			var btn:PushButton = _dayButtons[i + startDay];
			btn.visible = true;
			btn.label = Std.string(i + 1);
			btn.tag = i + 1;
			if(i + 1 == _day)
			{
				_selection.x = btn.x;
				_selection.y = btn.y;
			}
		}
		
		_dateLabel.text = _monthNames[_month] + "  " + _year;
		_dateLabel.draw();
		_dateLabel.x = (width - _dateLabel.width) / 2;
	}
	
	/**
	 * Displays specified date in calendar by drawing that month and year and highlighting the day.
	 * @param year The year to display.
	 * @param month The month to display.
	 * @param day The day to display.
	 */
	public function setYearMonthDay(year:Int, month:Int, day:Int):Void
	{
		setDate(new Date(year, month, day, 0, 0, 0));
	}
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Advances the month forward by one.
	 */
	private function onNextMonth(event:MouseEvent):Void
	{
		_month++;
		if(_month > 11)
		{
			_month = 0;
			_year++;
		}
		_day = Std.int(Math.min(_day, getEndDay(_month, _year)));
		setYearMonthDay(_year, _month, _day);
	}
	
	/**
	 * Moves the month back by one.
	 */
	private function onPrevMonth(event:MouseEvent):Void
	{
		_month--;
		if(_month < 0)
		{
			_month = 11;
			_year--;
		}
		_day = Std.int(Math.min(_day,getEndDay(_month,_year)));
		setYearMonthDay(_year, _month, _day);
	}
	
	/**
	 * Advances the year forward by one.
	 */
	private function onNextYear(event:MouseEvent):Void
	{
		_year++;
		_day = Std.int(Math.min(_day,getEndDay(_month,_year)));
		setYearMonthDay(_year, _month, _day);
	}
	
	/**
	 * Moves the year back by one.
	 */
	private function onPrevYear(event:MouseEvent):Void
	{
		_year--;
		_day = Std.int(Math.min(_day,getEndDay(_month,_year)));
		setYearMonthDay(_year, _month, _day);
	}
	
	/**
	 * Called when a date button is clicked. Selects that date.
	 */
	private function onDayClick(event:MouseEvent):Void
	{
		if (Std.is(event.target, PushButton))
		{
			_day = cast (event.target, PushButton).tag;
			setYearMonthDay(_year, _month, _day);
			dispatchEvent(new Event(Event.SELECT));
		}
	}
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
	
	/**
	 * Gets the currently selected Date.
	 */
	public var selectedDate(get, null):Date;
	
	private function get_selectedDate():Date
	{
		return new Date(_year, _month, _day, 0, 0, 0);
	}

	/**
	 * Gets the current month.
	 */
	public var month(get, null):Int;
	
	private function get_month():Int
	{
		return _month;
	}

	/**
	 * Gets the current year.
	 */
	public var year(get, null):Int;
	
	private function get_year():Int
	{
		return _year;
	}

	/**
	 * Gets the current day.
	 */
	public var day(get, null):Int;
	
	private function get_day():Int
	{
		return _day;
	}
}