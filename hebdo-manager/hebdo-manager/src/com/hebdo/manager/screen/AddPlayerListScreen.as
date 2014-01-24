package com.hebdo.manager.screen
{
	import com.hebdo.manager.event.PlayerEvent;
	import com.hebdo.manager.vo.Player;
	import com.hebdo.manager.vo.PlayerRegistration;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.TextInput;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class AddPlayerListScreen extends BaseScreen
	{
		public static const PLAYER_ADDED:String = "playerAdded";
		
		private var _list:List;
		private var _lblSelection:Label;
		private var _btnAdd:Button;
		
		private var _tiSearch:TextInput;

		public function AddPlayerListScreen()
		{
			super();
			
			_showBtnNext = false;
			
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
			_list.itemRendererProperties.labelField = "name";
			_list.itemRendererProperties.accessoryLabelField = "elo";
			_list.isSelectable = true;
			_list.addEventListener(Event.CHANGE, onListChange);
			_list.visible = false;
			
			addChild(_list);
			
			createFooterItems();
			
			playerModel.addEventListener(PlayerEvent.LIST_RECEIVED, onListReceived);
			playerModel.retreiveList(sessionData);
		}
		
		private function onListReceived(event:PlayerEvent):void
		{
			invalidate(INVALIDATION_FLAG_DATA);
			_list.visible = true;
		}
		
		override protected function createHeaderRightItems():Vector.<DisplayObject>
		{
			_tiSearch = new TextInput();
			_tiSearch.prompt = "Search...";
			_tiSearch.addEventListener(Event.CHANGE, onTiSearchChange);
			return new <DisplayObject>[_tiSearch];
		}
		
		private function onTiSearchChange():void
		{
			if (_tiSearch.text == "" || _tiSearch.text == null)
				_list.dataProvider = new ListCollection(playerModel.players);
			else
				_list.dataProvider = new ListCollection(playerModel.players.filter(playerSearch));
		}
		
		private function playerSearch(item:Player, index:int, vector:Vector.<Player>):Boolean 
		{
			return item.toString().toLowerCase().indexOf(_tiSearch.text.toLowerCase()) > -1;
		}
		
		protected function createFooterItems():void
		{
			_btnAdd = new Button();
			_btnAdd.label = "OK";
			_btnAdd.nameList.add(Button.ALTERNATE_NAME_CALL_TO_ACTION_BUTTON);
			_btnAdd.addEventListener(Event.TRIGGERED, onAddPlayer);
			_btnAdd.isEnabled = false;
			
			_lblSelection = new Label();
			
			footerProperties.rightItems = new <DisplayObject>[_lblSelection, _btnAdd];
		}
		
		private function onAddPlayer():void
		{
			const player:Player = Player(_list.selectedItem);
			if (playerModel.replacePlayerRegistration)
				registrationModel.replacePlayer(playerModel.replacePlayerRegistration, player);
			else
				registrationModel.addPlayer(player.toString(), player.elo);
			
			dispatchEventWith(PLAYER_ADDED);
		}
		
		private function onListChange():void
		{
			const player:Player = Player(_list.selectedItem);
			_lblSelection.text = "Selected : " + player.toString();
			
			FeathersControl(footer).invalidate();
			_btnAdd.isEnabled = true;
		}
		
		override protected function commitData():void
		{
			if (!_list.dataProvider || _list.dataProvider != playerModel.playersCollection)
				_list.dataProvider = playerModel.playersCollection;
			
			if (playerModel.replacePlayerRegistration)
			{
				headerProperties.title = "Select " + playerModel.replacePlayerRegistration.name;
			}
			else
			{
				headerProperties.title = "Players";
			}
		}
		
		override protected function layoutContent():void
		{
			_list.width = actualWidth;
			_list.height = actualHeight - header.height - footer.height;
		}
		
		override protected function onBack():void
		{
			//go to registartion list if we where replacing a player registration
			if (playerModel.replacePlayerRegistration)
				dispatchEventWith(PLAYER_ADDED);
			else
				super.onBack();
		}
		
	}
}