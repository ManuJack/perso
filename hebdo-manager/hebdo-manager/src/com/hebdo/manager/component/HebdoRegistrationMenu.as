package com.hebdo.manager.component
{
	import com.hebdo.manager.component.busy.BusyIndicator;
	import com.hebdo.manager.component.renderer.RegistrationListItemRenderer;
	import com.hebdo.manager.model.RegistrationModel;
	import com.hebdo.manager.screen.RegistrationScreen;
	import com.hebdo.manager.utils.SessionData;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TextInput;
	import feathers.events.FeathersEventType;
	import feathers.layout.VerticalLayout;
	import feathers.themes.HebdoManagerTheme;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	public class HebdoRegistrationMenu extends ScrollContainer
	{
		private var _lblSynch:Label;
		
		private var _btnSynch:Button;
		private var _btnReset:Button;
		
		private var _session:SessionData;
		
		private var _registrationModel:RegistrationModel;
		
		private var _lblTitle:Label;
		
		private var _lblDefaultElo:Label;
		private var _tiDefaultElo:TextInput;
		
		public function HebdoRegistrationMenu()
		{
			super();
		}
		
		public function get registrationModel():RegistrationModel
		{
			return _registrationModel;
		}

		public function set registrationModel(value:RegistrationModel):void
		{
			_registrationModel = value;
		}

		public function get session():SessionData
		{
			return _session;
		}

		public function set session(value:SessionData):void
		{
			_session = value;
		}

		override protected function initialize():void
		{
			_lblTitle = new Label();
			_lblTitle.text = "Settings";
			_lblTitle.includeInLayout = false;
			addChild(_lblTitle);
			
			const containerLayout:VerticalLayout = new VerticalLayout();
			containerLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			containerLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			containerLayout.paddingTop = 40 * HebdoManagerTheme.THEME_SCALE;
			containerLayout.paddingLeft = 10 * HebdoManagerTheme.THEME_SCALE;
			containerLayout.paddingRight = 10 * HebdoManagerTheme.THEME_SCALE;
			containerLayout.gap = 15 * HebdoManagerTheme.THEME_SCALE;
			layout = containerLayout;
			
			_lblSynch = new Label();
			//addChild(_lblSynch);
			
			_btnSynch = new Button();
			_btnSynch.label = "Synchronize";
			_btnSynch.addEventListener(Event.TRIGGERED, onSynchronize);
			//addChild(_btnSynch);
			
			_lblDefaultElo = new Label();
			_lblDefaultElo.text = "New Player ELO:";
			addChild(_lblDefaultElo);
			
			_tiDefaultElo = new TextInput();
			_tiDefaultElo.text = RegistrationListItemRenderer.DEFAULT_ELO.toString();
			_tiDefaultElo.restrict = "0-9";
			_tiDefaultElo.addEventListener(FeathersEventType.ENTER, onTiDefaultEloEnter);
			_tiDefaultElo.addEventListener(Event.CHANGE, onDefaultEloChange);
			addChild(_tiDefaultElo);
			
			_btnReset = new Button();
			_btnReset.label = "Reset Changes";
			_btnReset.addEventListener(Event.TRIGGERED, onReset);
			addChild(_btnReset);
		}
		
		private function onDefaultEloChange():void
		{
			var newDefaultElo:Number = parseInt(_tiDefaultElo.text);
			if (isNaN(newDefaultElo))
				return;
			
			trace("onDefaultEloChange() :: newElo", newDefaultElo);
			RegistrationListItemRenderer.DEFAULT_ELO = newDefaultElo;
		}
		
		private function onTiDefaultEloEnter():void
		{
			Starling.current.nativeStage.stage.focus = null;
		}
		
		private function onReset():void
		{
			_registrationModel.reset();
			dispatchEventWith(RegistrationScreen.OPEN_MENU);
		}
		
		private function onSynchronize():void
		{
			
		}
		
		override protected function draw():void
		{
			super.draw();
			
			const isDataInvalid:Boolean = isInvalid(INVALIDATION_FLAG_DATA);
			if (isDataInvalid)
				commitData();
			
			_lblTitle.validate();
			_lblTitle.x = (actualWidth * 0.5) - (_lblTitle.width * 0.5);
			_lblTitle.y = actualHeight * 0.01;
		}
		
		protected function commitData():void
		{
			_lblSynch.text = "Last Synchronization :\n" + new Date();
		}
	}
}