package com.hebdo.manager.screen
{
	import com.hebdo.manager.component.busy.BusyIndicator;
	import com.hebdo.manager.event.BusyEvent;
	import com.hebdo.manager.model.BaseModel;
	import com.hebdo.manager.model.DrawModel;
	import com.hebdo.manager.model.HebdoModel;
	import com.hebdo.manager.model.PlayerModel;
	import com.hebdo.manager.model.RegistrationModel;
	import com.hebdo.manager.utils.SessionData;
	
	import flash.desktop.NativeApplication;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.layout.AnchorLayout;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class BaseScreen extends PanelScreen
	{
		public static const BACK:String = "back";
		public static const NEXT:String = "next";
		
		protected var _title:String;
		protected var _showBtnBack:Boolean = true;
		protected var _showBtnNext:Boolean = true;
		
		protected var _btnBack:Button;
		protected var _btnNext:Button;
		
		private var _sessionData:SessionData;
		
		private var _hebdoModel:HebdoModel;
		private var _registrationModel:RegistrationModel;
		private var _drawModel:DrawModel;
		private var _playerModel:PlayerModel;
		
		private var _models:Vector.<BaseModel>;
		
		protected var _busyIndicator:BusyIndicator;
		
		public function BaseScreen()
		{
			super();
			
			backButtonHandler = hardwareBackButton;
		}
		
		public function get playerModel():PlayerModel
		{
			return _playerModel;
		}

		public function set playerModel(value:PlayerModel):void
		{
			_playerModel = value;
		}

		public function get drawModel():DrawModel
		{
			return _drawModel;
		}

		public function set drawModel(value:DrawModel):void
		{
			_drawModel = value;
		}

		public function get registrationModel():RegistrationModel
		{
			return _registrationModel;
		}

		public function set registrationModel(value:RegistrationModel):void
		{
			_registrationModel = value;
		}

		public function get hebdoModel():HebdoModel
		{
			return _hebdoModel;
		}

		public function set hebdoModel(value:HebdoModel):void
		{
			_hebdoModel = value;
		}

		public function get sessionData():SessionData
		{
			return _sessionData;
		}

		public function set sessionData(value:SessionData):void
		{
			_sessionData = value;
		}

		override protected function initialize():void
		{
			_models = new <BaseModel>[_hebdoModel, _registrationModel, _drawModel, _playerModel];
			addModelsListeners();
			
			if (!layout)
				layout = new AnchorLayout();
			
			headerProperties.title = _title;
			headerProperties.leftItems = createHeaderLeftItems();
			headerProperties.rightItems = createHeaderRightItems();
		}
		
		protected function createHeaderLeftItems():Vector.<DisplayObject>
		{
			const items:Vector.<DisplayObject> = new <DisplayObject>[];
			if (_showBtnBack)
			{
				_btnBack = new Button();
				_btnBack.label = "Back"
				_btnBack.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
				_btnBack.addEventListener(Event.TRIGGERED, onBack);
				items.push(_btnBack);
			}
			return items;
		}
		
		protected function createHeaderRightItems():Vector.<DisplayObject>
		{
			const items:Vector.<DisplayObject> = new <DisplayObject>[];
			if (_showBtnNext)
			{
				_btnNext = new Button();
				_btnNext.nameList.add(Button.ALTERNATE_NAME_FORWARD_BUTTON);
				_btnNext.addEventListener(Event.TRIGGERED, onNext);
				_btnNext.label = "Next";
				items.push(_btnNext);
			}
			return items;
		}
		
		protected function onBack():void
		{
			dispatchEventWith(BACK);
		}
		
		protected function onNext():void
		{
			dispatchEventWith(NEXT);
		}
		
		override protected function draw():void
		{
			super.draw();
			
			const dataInvalid:Boolean = isInvalid(INVALIDATION_FLAG_DATA);
			if (dataInvalid)
				commitData();
			
			layoutContent();
			
			if (_busyIndicator)
				layoutBusyIndicator();
		}
		
		protected function commitData():void
		{
			
		}
		
		protected function layoutContent():void
		{
			
		}
		
		protected function hardwareBackButton():void
		{
			if (this is HomeScreen)
				NativeApplication.nativeApplication.exit();
			else
				onBack();
		}
		
		protected function addModelsListeners():void
		{
			if (!_models)
				return;
			
			var i:int;
			for (i; i<_models.length; ++i)
			{
				_models[i].addEventListener(BusyEvent.BUSY, onBusy);
				_models[i].addEventListener(BusyEvent.NOT_BUSY_ANYMORE, onNotBusyAnymore);
			}
		}
		
		private function onNotBusyAnymore():void
		{
			if (!_busyIndicator || !_busyIndicator.stage)
				return;
			
			removeChild(_busyIndicator, true);
			_busyIndicator = null;
		}
		
		private function onBusy():void
		{
			if (_busyIndicator && _busyIndicator.stage)
				return;
			
			if (!_busyIndicator)
				_busyIndicator = new BusyIndicator();
			
			addChild(_busyIndicator);
			layoutBusyIndicator();
		}
		
		protected function layoutBusyIndicator():void
		{
			_busyIndicator.validate();
			_busyIndicator.x = (actualWidth * 0.5) - (_busyIndicator.width * 0.5);
			_busyIndicator.y = (actualHeight * 0.5) - (_busyIndicator.height);
			
			//trace("BaseScreen :: layoutBusyIndicator()", actualHeight, _busyIndicator.height);
		}
		
		protected function removeModelsListeners():void
		{
			if (!_models)
				return;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			removeModelsListeners();
			
			if (_busyIndicator)
				_busyIndicator.dispose();
		}
	}
}