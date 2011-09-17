package;

import com.bit101.charts.BarChart;
import com.bit101.charts.Chart;
import com.bit101.charts.LineChart;
import com.bit101.charts.PieChart;
import com.bit101.components.Accordion;
import com.bit101.components.Calendar;
import com.bit101.components.CheckBox;
import com.bit101.components.ColorChooser;
import com.bit101.components.ComboBox;
import com.bit101.components.Component;
import com.bit101.components.FPSMeter;
import com.bit101.components.HBox;
import com.bit101.components.HRangeSlider;
import com.bit101.components.HSlider;
import com.bit101.components.HUISlider;
import com.bit101.components.IndicatorLight;
import com.bit101.components.InputText;
import com.bit101.components.Knob;
import com.bit101.components.Label;
import com.bit101.components.ListItem;
import com.bit101.components.List;
import com.bit101.components.Meter;
import com.bit101.components.NumericStepper;
import com.bit101.components.Panel;
import com.bit101.components.ProgressBar;
import com.bit101.components.PushButton;
import com.bit101.components.RadioButton;
import com.bit101.components.RangeSlider;
import com.bit101.components.WheelMenu;
import com.bit101.components.RotarySelector;
import com.bit101.components.ScrollBar;
import com.bit101.components.ScrollPane;
import com.bit101.components.Slider;
import com.bit101.components.Style;
import com.bit101.components.Text;
import com.bit101.components.TextArea;
import com.bit101.components.VBox;
import com.bit101.components.VRangeSlider;
import com.bit101.components.VSlider;
import com.bit101.components.VUISlider;
import com.bit101.components.Window;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.Lib;
import haxe.Timer;

import flash.display.StageAlign;
import flash.display.StageScaleMode;

/**
 * @author Zaphod
 */
class Minimalcompshx extends Sprite {
	
	
	static private var indicator:IndicatorLight;
	
	public function new () {
		
		super ();
		
		initialize ();
		
		Style.setStyle(Style.LIGHT);
		
		var btn:PushButton = new PushButton(Lib.current, 200, 0, "Button", btnHandler);
		
		var input:InputText = new InputText(Lib.current);
		input.enabled = true;
		
		var text:Text = new Text();
		text.editable = true;
		
		var label:Label = new Label(Lib.current.stage);
		label.text = "Label";
		
		var window:Window = new Window(Lib.current);
		window.hasMinimizeButton = true;
		window.hasCloseButton = true;
		
		var selector:RotarySelector = new RotarySelector(Lib.current, 500, 50);
		var stepper:NumericStepper = new NumericStepper(Lib.current, 300, 450);
		selector.numChoices = 4;
		stepper.minimum = 0;
		stepper.maximum = 100;
		
		var knob:Knob = new Knob(window, 20);
		knob.mode = Knob.HORIZONTAL;
		
		var radio1:RadioButton = new RadioButton(Lib.current, 0, 350, "RadioButtons");
		var radio2:RadioButton = new RadioButton(Lib.current, 0, 380, "RadioButtons");
		
		var check:CheckBox = new CheckBox(Lib.current, 5, 50, "CheckBox");
		
		var calendar:Calendar = new Calendar(Lib.current, 400, 350);
		
		var panel:Panel = new Panel(Lib.current, 100, 350);
		
		var accordion:Accordion = new Accordion(Lib.current);
		accordion.setSize(panel.width, panel.height);
		panel.addChild(accordion);
		
		var window2:Window = new Window(Lib.current, 200, 200);
		
		var colorChooser:ColorChooser = new ColorChooser(Lib.current, 0, 100);
		colorChooser.usePopup = true;
		
		var list:List = new List(Lib.current, 0, 0, ["1", "2", "3"]);
		
		for (i in 3...50)
		{
			list.addItem(Std.string(i));
		}
		list.numItemsToShow = 6;
		
		list.scrollToSelection();
		
		
		list.addToDisplay(Lib.current);
		list.move( 200, 50);
		
		//window2.addChild(list);
		window2.setSize(list.width, list.height);
		window2.hasMinimizeButton = true;
		
		list.removeItem("1");
		
		var comboBox:ComboBox = new ComboBox(Lib.current, 500, 200, "label", ["1", "2", "3", "4"/*, "5", "6", "7"*/]);
		comboBox.addItem("5");
		comboBox.addItem("6");
		comboBox.addItem("7");
		comboBox.removeItem("2");
		comboBox.removeItem("7");
		
		var pieChart:PieChart = new PieChart(Lib.current, 300, 300, [1, 2, 3]);
		//pieChart.addToDisplay(Lib.current);
		
		Lib.current.stage.addEventListener(MouseEvent.CLICK, onStageClick);
		
		indicator = new IndicatorLight(Lib.current, 600, 100, 0xff0000, "indicator");
		indicator.flash();
		
		/*var spr:Sprite = new Sprite();
		spr.graphics.beginFill(0xff0000);
		spr.graphics.drawRect(0, 0, 200, 200);
		spr.graphics.endFill();
		var spr2:Sprite = new Sprite();
		spr2.graphics.beginFill(0x00ff00);
		spr2.graphics.drawCircle(100, 100, 50);
		spr2.graphics.endFill();
		spr.addChild(spr2);
		Lib.current.addChild(spr);
		spr.x = 100;*/
		
		var panel:Panel = new Panel(Lib.current, 100, 0);
	}
	
	public function btnHandler(e:MouseEvent):Void 
	{
		var btn:PushButton = new PushButton(Lib.current, 200, 30, "Button", btnHandler);
	}
	
	static private function onStageClick(e:MouseEvent):Void 
	{
		if (indicator.isFlashing)
		{
			indicator.isLit = false;
		}
		else
		{
			indicator.flash();
		}
	}
	
	private function initialize ():Void {
		
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		
	}
	
	
	// Entry point
	
	
	
	
	public static function main () {
		
		Lib.current.addChild (new Minimalcompshx ());
		
	}
	
	
}