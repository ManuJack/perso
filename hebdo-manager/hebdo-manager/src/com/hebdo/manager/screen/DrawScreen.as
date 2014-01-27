package com.hebdo.manager.screen
{
	import com.hebdo.manager.event.DrawEvent;
	import com.hebdo.manager.utils.HebdoType;
	
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.Radio;
	import feathers.controls.ToggleSwitch;
	import feathers.core.FeathersControl;
	import feathers.core.ToggleGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.themes.HebdoManagerTheme;
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.events.Event;

	public class DrawScreen extends BaseScreen
	{
		private var _lblPlayers:Label;
		private var _chkMedian:ToggleSwitch;
		
		private var _radioDyp:Radio;
		private var _radioSingle:Radio;
		private var _radioDouble:Radio;
		private var _radioGroup:ToggleGroup;
		
		private var _btnDraw:Button;
		
		public function DrawScreen()
		{
			super();
			
			_showBtnNext = false;
			
			_title = "Pool Draw Confirmation";
		}
		
		override protected function initialize():void
		{
			const verticalLayout:VerticalLayout = new VerticalLayout();
			verticalLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			verticalLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			
			verticalLayout.paddingLeft = 50 * HebdoManagerTheme.THEME_SCALE;
			verticalLayout.paddingRight = 50 * HebdoManagerTheme.THEME_SCALE;
			verticalLayout.gap = 20 * HebdoManagerTheme.THEME_SCALE;
			
			layout = verticalLayout;
			
			super.initialize();
			
			_lblPlayers = new Label();
			addChild(_lblPlayers);
			
			var radioContainer:LayoutGroup = new LayoutGroup();
			radioContainer.layout = new HorizontalLayout();
			HorizontalLayout(radioContainer.layout).gap = 10 * HebdoManagerTheme.THEME_SCALE;
			radioContainer.layoutData = new AnchorLayoutData(NaN, 10 * HebdoManagerTheme.THEME_SCALE);
			
			_radioGroup = new ToggleGroup();
			_radioGroup.isSelectionRequired = true;
			
			_radioDyp = new Radio();
			_radioDyp.name = HebdoType.DYP;
			_radioDyp.label = " DYP ";
			_radioDyp.toggleGroup = _radioGroup;
			radioContainer.addChild(_radioDyp);
			
			_radioDouble = new Radio();
			_radioDouble.name = HebdoType.OPEN_DOUBLE;
			_radioDouble.label = "Open Double";
			_radioDouble.toggleGroup = _radioGroup;
			radioContainer.addChild(_radioDouble);
			
			_radioSingle = new Radio();
			_radioSingle.name = HebdoType.OPEN_SINGLE;
			_radioSingle.label = "Open Single";
			_radioSingle.toggleGroup = _radioGroup;
			radioContainer.addChild(_radioSingle);
			
			var formatContainer:LayoutGroup = new LayoutGroup();
			formatContainer.layout = new AnchorLayout();
			
			var lblFormat:Label = new Label();
			lblFormat.text = "Format:";
			lblFormat.layoutData = new AnchorLayoutData(NaN, NaN, NaN, 0, NaN, 0);
			
			//formatContainer.addChild(lblFormat);
			formatContainer.addChild(radioContainer);
			addChild(formatContainer);
			
			var medianContainer:LayoutGroup = new LayoutGroup();
			medianContainer.layout = new AnchorLayout();

			_chkMedian = new ToggleSwitch();
			var lblMedian:Label = new Label()
			lblMedian.text = "Use median:";
			lblMedian.layoutData = new AnchorLayoutData(NaN, NaN, NaN, 0, NaN, 0);
			medianContainer.addChild(lblMedian);
			_chkMedian.isSelected = true;
			_chkMedian.layoutData = new AnchorLayoutData(NaN, 0);
			medianContainer.addChild(_chkMedian);
			
			addChild(medianContainer);
			
			_btnDraw = new Button();
			_btnDraw.label = "Draw Pool";
			_btnDraw.nameList.add(Button.ALTERNATE_NAME_DANGER_BUTTON);
			_btnDraw.addEventListener(Event.TRIGGERED, onBtnDrawTriggered);
			_btnDraw.height = 100 * HebdoManagerTheme.THEME_SCALE;
			addChild(_btnDraw);
		}
		
		private function onBtnDrawTriggered():void
		{
			sessionData.useMedian = _chkMedian.isSelected;
			sessionData.hebdoType = FeathersControl(_radioGroup.selectedItem).name;
			
			drawModel.addEventListener(DrawEvent.DRAW_COMPLETE, onDrawComplete);
			drawModel.drawPool(sessionData);
		}
		
		private function onDrawComplete():void
		{
			drawModel.removeEventListener(DrawEvent.DRAW_COMPLETE, onDrawComplete);
			
			onNext();
		}
		
		override protected function commitData():void
		{
			if (_lblPlayers && sessionData.players)
				_lblPlayers.text = "Total players : " + sessionData.players.length;
		}
		
	}
}