package com.hebdo.manager.screen
{
	import com.hebdo.manager.event.PlayerEvent;
	import com.hebdo.manager.vo.Player;
	import com.hebdo.manager.vo.PlayerRegistration;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.TabBar;
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
		private var _searchedText:String;
		
		private var _searchBar:TabBar;

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
			_tiSearch.nameList.add(TextInput.ALTERNATE_NAME_SEARCH_TEXT_INPUT);
			_tiSearch.prompt = "Search...";
			_tiSearch.addEventListener(Event.CHANGE, onTiSearchChange);
			return new <DisplayObject>[_tiSearch];
		}
		
		private function onTiSearchChange():void
		{
			filterPlayerList(_tiSearch.text);
		}
		
		private function filterPlayerList(text:String):void
		{
			_searchedText = text;
			_tiSearch.text = _searchedText;
			if (text == "" || text == null)
			{
				_list.dataProvider = new ListCollection(playerModel.players);
			}
			else
			{
				_list.dataProvider = new ListCollection(playerModel.players.filter(playerSearch));
				if (_list.dataProvider.length == 0)
					_list.dataProvider.addItem(new Player({prenom:"No result for search '" + _searchedText + "'", classement:""}));
			}
		}
		
		private function playerSearch(item:Player, index:int, vector:Vector.<Player>):Boolean 
		{
			return item.toString().toLowerCase().indexOf(_searchedText.toLowerCase()) > -1;
		}
		
		protected function createFooterItems():void
		{
			_btnAdd = new Button();
			_btnAdd.label = "OK";
			_btnAdd.nameList.add(Button.ALTERNATE_NAME_CALL_TO_ACTION_BUTTON);
			_btnAdd.addEventListener(Event.TRIGGERED, onAddPlayer);
			_btnAdd.isEnabled = false;
			
			_lblSelection = new Label();
			
			_searchBar = new TabBar();
			_searchBar.addEventListener(Event.CHANGE, onSearchBarChange);
			
			footerProperties.rightItems = new <DisplayObject>[_lblSelection, _btnAdd];
			footerProperties.leftItems = new <DisplayObject>[_searchBar];
		}
		
		private function onSearchBarChange():void
		{
			if (_searchBar.selectedIndex > -1)
				filterPlayerList(_searchBar.selectedItem.label);
			else
				filterPlayerList(null);
		}
		
		private function onAddPlayer():void
		{
			if (!_list.selectedItem)
				return;
			
			const player:Player = Player(_list.selectedItem);
			if (playerModel.replacePlayerRegistration)
				registrationModel.replacePlayer(playerModel.replacePlayerRegistration, player);
			else
				registrationModel.addPlayer(player.toString(), parseInt(player.elo));
			
			dispatchEventWith(PLAYER_ADDED);
		}
		
		private function onListChange():void
		{
			if (_list.selectedIndex == -1)
			{
				_btnAdd.isEnabled = false;
				_lblSelection.text = "";
				return;
			}
			
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
				const searchedPlayerName:String = playerModel.replacePlayerRegistration.name;
				headerProperties.title = searchedPlayerName;
				
				const splittedName:Array = searchedPlayerName.split(" ");
				
				if (splittedName.length > 1)
					_searchBar.dataProvider = new ListCollection([{label:""}, {label:splittedName[0]}, {label:splittedName[1]}]);
				else if (splittedName.length > 0)
					_searchBar.dataProvider = new ListCollection([{label:""}, {label:splittedName[0]}]);
				else
					_searchBar.dataProvider = new ListCollection();	
				
			}
			else
			{
				headerProperties.title = "Players";
				_searchBar.dataProvider = new ListCollection();	
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