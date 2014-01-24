package com.hebdo.manager.screen
{
	import com.hebdo.manager.event.PlayerEvent;
	import com.hebdo.manager.vo.Player;
	
	import feathers.controls.List;
	import feathers.data.ListCollection;
	
	import starling.events.Event;

	public class PlayerScreen extends BaseScreen
	{
		private var _list:List;
		private var _players:Vector.<Player>;
		
		public function PlayerScreen()
		{
			super();
			
			_title = "List of subscribed Players";
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			_list = new List();
			_list.itemRendererProperties.labelField = "name";
			_list.itemRendererProperties.accessoryLabelField = "elo";
			_list.addEventListener(Event.CHANGE, onListChange);
			addChild(_list);
			
			playerModel.addEventListener(PlayerEvent.PLAYER_LIST_RECEIVED, onListReceived);
			playerModel.retreiveList();
		}
		
		override protected function onNext():void
		{
			sessionData.players = _players;
			
			super.onNext();
		}
		
		
		private function onListReceived(event:PlayerEvent):void
		{
			_players = event.players;
			_list.dataProvider = new ListCollection(_players);
		}
		
		private function onListChange():void
		{
			if (_list.selectedIndex == -1)
				return;
			
			const selectedPlayer:Player = Player(_list.selectedItem);
		}
		
		override protected function layoutContent():void
		{
			_list.width = actualWidth;
			_list.height = actualHeight - header.height;
		}
	}
}