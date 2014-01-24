package com.hebdo.manager.screen
{
	import com.hebdo.manager.component.HebdoRegistrationMenu;
	import com.hebdo.manager.component.PlayerRegistrationActionButton;
	import com.hebdo.manager.component.renderer.RegistrationListItemRenderer;
	import com.hebdo.manager.event.RegistrationEvent;
	import com.hebdo.manager.model.RegistrationModel;
	import com.hebdo.manager.utils.Styles;
	import com.hebdo.manager.vo.PlayerRegistration;
	
	import feathers.controls.Button;
	import feathers.controls.Drawers;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.ScreenNavigator;
	
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class RegistrationScreen extends BaseScreen
	{
		public static const OPEN_MENU		:String = "openMenu";
		public static const ADD_PLAYER		:String = "addPlayer";
		
		private var _list:List;
		private var _btnAdd:Button;
		private var _lblDeleteInfo:Label;
		
		private var _btnMenu:Button;
		
		public function RegistrationScreen()
		{
			super();
			footerFactory = footerFactoryFunction;
		}
		
		private function footerFactoryFunction():Header
		{
			return new Header();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			_list = new List();
			_list.itemRendererType = RegistrationListItemRenderer;
			_list.itemRendererProperties.labelField = "name";
			_list.itemRendererProperties.accessoryLabelField = "elo";
			_list.isSelectable = false;
			_list.addEventListener("delete", onDeletePlayer);
			_list.addEventListener(PlayerRegistrationActionButton.SELECT_PLAYER, onSelectPlayer);
			_list.addEventListener(PlayerRegistrationActionButton.SET_DEFAULT_ELO, onSetDefaultElo);
			addChild(_list);
			
			createFooterItems();
			
			registrationModel.addEventListener(RegistrationModel.INVALIDATE_DATA, onInvalidateData);
			registrationModel.addEventListener(RegistrationEvent.PLAYER_LIST_RECEIVED, onListReceived);
			registrationModel.retreiveList(sessionData);
		}
		
		private function onInvalidateData():void
		{
			invalidate(INVALIDATION_FLAG_DATA);
		}
		
		protected function createFooterItems():void
		{
			_btnAdd = new Button();
			_btnAdd.label = "Add player"
			_btnAdd.nameList.add(Button.ALTERNATE_NAME_CALL_TO_ACTION_BUTTON);
			_btnAdd.addEventListener(Event.TRIGGERED, onAddPlayer);
			
			_lblDeleteInfo = new Label();
			_lblDeleteInfo.text = "Swipe to delete a player";
			
			_btnMenu = new Button();
			_btnMenu.nameList.add(Styles.BUTTON_SETTTINGS);
			_btnMenu.addEventListener(Event.TRIGGERED, onBtnMenuTriggered);
			
			footerProperties.leftItems = new <DisplayObject>[_btnMenu, _lblDeleteInfo];
			footerProperties.rightItems = new <DisplayObject>[_btnAdd];
		}
		
		override protected function createHeaderLeftItems():Vector.<DisplayObject>
		{
			const items:Vector.<DisplayObject> = super.createHeaderLeftItems();
			return items;
		}
		
		private function onBtnMenuTriggered():void
		{
			dispatchEventWith(OPEN_MENU);
		}
		
		private function onAddPlayer():void
		{
			playerModel.replacePlayerRegistration = null;
			dispatchEventWith(ADD_PLAYER);
		}
		
		private function onDeletePlayer(event:Event):void
		{
			event.stopPropagation();
			
			const player:PlayerRegistration = PlayerRegistration(event.data);
			registrationModel.deletePlayer(player);
			
			invalidate(INVALIDATION_FLAG_DATA);
		}
		
		private function onSelectPlayer(event:Event):void
		{
			event.stopPropagation();
			
			const playerRegistration:PlayerRegistration = PlayerRegistration(event.data);
			playerModel.replacePlayerRegistration = playerRegistration;
			
			dispatchEventWith(AddPlayerScreen.GOTO_ADD_PLAYER_LIST);
		}
		
		private function onSetDefaultElo(event:Event):void
		{
			event.stopPropagation();
			
			const registration:PlayerRegistration = PlayerRegistration(event.data.registration);
			const elo:int = parseInt(event.data.elo);
			registrationModel.setPlayerElo(registration, elo);
			
			invalidate(INVALIDATION_FLAG_DATA);
		}
		
		override protected function onNext():void
		{
			if (registrationModel.playersCollection)
				sessionData.players = registrationModel.playersCollection.data as Vector.<PlayerRegistration>;
			
			super.onNext();
		}
		
		private function onListReceived(event:RegistrationEvent):void
		{
			invalidate(INVALIDATION_FLAG_DATA);
		}
		
		override protected function commitData():void
		{
			if (!_list.dataProvider || _list.dataProvider != registrationModel.playersCollection)
				_list.dataProvider = registrationModel.playersCollection;
			
			//_btnNext.isEnabled = registrationModel.validateRegistrations();
			
			if (_list.dataProvider)
				headerProperties.title = "Registred Players (" + _list.dataProvider.length + ")";
		}
		
		override protected function layoutContent():void
		{
			_list.width = actualWidth;
			_list.height = actualHeight - header.height - footer.height;
		}
		
		override protected function layoutBusyIndicator():void
		{
			_busyIndicator.validate();
			_busyIndicator.x = (actualWidth * 0.5) - (_busyIndicator.width * 0.5);
			_busyIndicator.y = _list.y + (_list.height * 0.5) - (_busyIndicator.height * 0.5);
			
			//trace("BaseScreen :: layoutBusyIndicator()", actualHeight, _busyIndicator.height);
		}
	}
}