package;

/*
import com.bit101.components.Accordion;
import com.bit101.components.HUISlider;
import com.bit101.components.Knob;
import com.bit101.components.ListItem;
import com.bit101.components.WheelMenu;
import com.bit101.components.RotarySelector;
import com.bit101.components.ScrollBar;
import com.bit101.components.ScrollPane;
import com.bit101.components.VUISlider;
import com.bit101.components.Window;
*/

import com.bit101.charts.BarChart;
import com.bit101.charts.Chart;
import com.bit101.charts.LineChart;
import com.bit101.charts.PieChart;

import com.bit101.components.Calendar;
import com.bit101.components.CheckBox;
import com.bit101.components.ColorChooser;
import com.bit101.components.ComboBox;
import com.bit101.components.Component;
import com.bit101.components.FPSMeter;
import com.bit101.components.HBox;
import com.bit101.components.HRangeSlider;
import com.bit101.components.HSlider;
import com.bit101.components.IndicatorLight;
import com.bit101.components.InputText;
import com.bit101.components.Label;
import com.bit101.components.List;
import com.bit101.components.Meter;
import com.bit101.components.NumericStepper;
import com.bit101.components.Panel;
import com.bit101.components.ProgressBar;
import com.bit101.components.PushButton;
import com.bit101.components.RadioButton;
import com.bit101.components.RangeSlider;
import com.bit101.components.Slider;
import com.bit101.components.Style;
import com.bit101.components.Text;
import com.bit101.components.TextArea;
import com.bit101.components.VBox;
import com.bit101.components.VRangeSlider;
import com.bit101.components.VSlider;


import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.Lib;
import haxe.Timer;

import flash.display.StageAlign;
import flash.display.StageScaleMode;

/**
 * @author Zaphod
 */
class Minimalcompshx extends Sprite {
	private var vSlider:VSlider;
	private var vBox:VBox;
	private var hBox:HBox;
	private var hSlider:HSlider;
	
	public function new () {
		
		super ();
		
		initialize ();
		
		Style.setStyle(Style.LIGHT);
		
		var container:Sprite = new Sprite();
		addChild(container);
		container.scaleX = container.scaleY = 1.0;
		
		var btn:PushButton = new PushButton(container, 200, 0, "Button", onClick);
		btn.enabled = false;
		
		var fps:FPSMeter = new FPSMeter(Lib.current, 0, 0);
		
		var label:Label = new Label(container, 0, 20);
		label.text = "Label";
		
		var panel:Panel = new Panel(container, 0, 40);
		panel.setSize(410, 120);
		
		var input:InputText = new InputText(panel, 0, 0);
		input.enabled = true;
		input.password = true;
		
		var text:Text = new Text(panel, 0, 20);
		text.editable = true;
		
		var check:CheckBox = new CheckBox(container, 10, 180, "CheckBox");
		check.selected = true;
		
		var indicator = new IndicatorLight(container, 20 + check.width, 180, 0xff0000, "indicator");
		indicator.flash();
		
		var meter:Meter = new Meter(panel, 10 + text.width, 20);
		meter.value = 0.65;
		
		var pieChart:PieChart = new PieChart(container, 0, 200, [1, 2, 3]);
		var barChart:BarChart = new BarChart(container, pieChart.width + 20, 200, [1.0, 2.0, 3.0]);
		barChart.height = pieChart.height;
		
		var lineChart:LineChart = new LineChart(container, 0, pieChart.y + pieChart.height + 20, [1.0, 4.0, 3.0, 2.0]);
		
		var radio1:RadioButton = new RadioButton(container, 20 + lineChart.width, lineChart.y, "RadioButtons");
		var radio2:RadioButton = new RadioButton(container, 20 + lineChart.width, lineChart.y + 20, "RadioButtons");
		
		var progress:ProgressBar = new ProgressBar(container, radio1.x, radio2.y + 20);
		progress.value = 0.33;
		
		var stepper:NumericStepper = new NumericStepper(container, progress.x, progress.y + 20);
		stepper.minimum = 0;
		stepper.maximum = 100;
		
		var range:RangeSlider = new RangeSlider(Slider.HORIZONTAL, container, progress.x, stepper.y + 40);
		var slider:Slider = new Slider(Slider.HORIZONTAL, container, range.x, range.y + 20);
		
		var calendar:Calendar = new Calendar(container, slider.x, slider.y + 20);
		
		var list:List = new List(container, calendar.x + calendar.width + 20, calendar.y, ["1", "2", "3"]);
		
		for (i in 3...50)
		{
			list.addItem(Std.string(i));
		}
		list.numItemsToShow = 6;
		list.scrollToSelection();
		
		vBox = new VBox(container, panel.x + panel.width + 10, panel.y);
		vBox.setSize(vBox.width, 80);
		vBox.alignment = VBox.LEFT;
		vBox.spacing = 30;
		
		hSlider = new HSlider(vBox, 0, 0, onHSlider);
		hSlider.minimum = 30;
		hSlider.maximum = 60;
		var hRange:HRangeSlider = new HRangeSlider(vBox/*, 0, 30*/);
		
		hBox = new HBox(container, vBox.x, vBox.y + 90);
		hBox.setSize(80, hBox.height);
		hBox.spacing = 30;
		
		vSlider = new VSlider(hBox, 0, 0, onVSlider);
		vSlider.minimum = 30;
		vSlider.maximum = 60;
		
		var vRange:VRangeSlider = new VRangeSlider(hBox);
		
		var comboBox:ComboBox = new ComboBox(container, lineChart.x, lineChart.y + lineChart.height + 20, "label", ["1", "2", "3", "4"]);
		for (i in 5...30)
		{
			comboBox.addItem(Std.string(i));
		}
		
		var textArea:TextArea = new TextArea(container, comboBox.x, comboBox.y + comboBox.height + 20);
		
		var colorChooser:ColorChooser = new ColorChooser(container, 10, textArea.y + textArea.height + 20);
		colorChooser.usePopup = true;
		
		/*
		var window:Window = new Window(Lib.current);
		window.hasMinimizeButton = true;
		window.hasCloseButton = true;
		
		var selector:RotarySelector = new RotarySelector(Lib.current, 500, 50);
		selector.numChoices = 4;
		
		var knob:Knob = new Knob(window, 20);
		knob.mode = Knob.HORIZONTAL;
		
		var calendar:Calendar = new Calendar(Lib.current, 400, 350);
		
		var panel:Panel = new Panel(Lib.current, 100, 350);
		
		var accordion:Accordion = new Accordion(Lib.current);
		accordion.setSize(panel.width, panel.height);
		panel.addChild(accordion);
		
		var window2:Window = new Window(Lib.current, 200, 200);
		//window2.addChild(list);
		window2.setSize(list.width, list.height);
		window2.hasMinimizeButton = true;
		
		list.removeItem("1");
		*/
	}
	
	public function onHSlider(e:Event):Void 
	{
		hBox.spacing = hSlider.value;
	}
	
	public function onVSlider(e:Event):Void 
	{
		vBox.spacing = vSlider.value;
	}
	
	public function onClick(e:MouseEvent):Void 
	{
		trace("click");
	}
	
	private function initialize():Void {
		
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		
	}
	
	
	// Entry point
	
	
	
	
	public static function main() {
		
		Lib.current.addChild (new Minimalcompshx ());
		
	}
	
	
}