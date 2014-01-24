package com.hebdo.manager.screen
{
	import com.hebdo.manager.event.HebdoEvent;
	import com.hebdo.manager.vo.Hebdo;
	
	import feathers.controls.List;
	import feathers.data.ListCollection;
	
	import starling.events.Event;
	
	public class HomeScreen extends BaseScreen
	{
		private var _list:List;
		
		public function HomeScreen()
		{
			super();
			
			_showBtnBack = false;
			_showBtnNext = false;
			_title = "Choose an Hebdo";
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			_list = new List();
			_list.itemRendererProperties.labelField = "label";
			_list.addEventListener(Event.CHANGE, onListChange);
			addChild(_list);
			
			hebdoModel.addEventListener(HebdoEvent.HEBDO_LIST_RECEIVED, onListReceived);
			hebdoModel.retreiveList();
		}
		
		private function onListChange():void
		{
			if (_list.selectedIndex == -1)
				return;
			
			const selectedHebdo:Hebdo = Hebdo(_list.selectedItem);
			sessionData.hebdo = selectedHebdo;
			
			//ATM clear player list cache when selecting hebdo
			playerModel.reset();
			
			dispatchEventWith(NEXT);
		}
		
		private function onListReceived(event:HebdoEvent):void
		{
			_list.dataProvider = new ListCollection(event.hebdos);
		}
		
		override protected function commitData():void
		{
			
		}
		
		override protected function layoutContent():void
		{
			_list.width = actualWidth;
			_list.height = actualHeight - header.height;
		}
	}
}