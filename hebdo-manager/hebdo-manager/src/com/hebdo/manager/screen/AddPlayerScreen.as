package com.hebdo.manager.screen
{
	import com.hebdo.manager.component.renderer.RegistrationListItemRenderer;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.TextInput;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;

	public class AddPlayerScreen extends BaseScreen
	{
		public static const GOTO_ADD_PLAYER_LIST:String = "gotoAddPlayerList";
		
		private var _list:List;
		
		private var _tiName:TextInput;
		private var _tiElo:TextInput;
		private var _btnAdd:Button;
		private var _btnExistingPlayer:Button;
		
		public function AddPlayerScreen()
		{
			super();
			
			_title = "Add a player";
			_showBtnNext = false;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			_list = new List();
			_list.itemRendererProperties.labelField = "name";
			_list.itemRendererProperties.accessoryField = "accessory";
			_list.isSelectable = false;
			
			addChild(_list);
			
			const listProvider:Array = [];
			
			//listProvider.push({name:"Add a new player"});
			
			_tiName = new TextInput();
			listProvider.push({name:"Player Name:", accessory:_tiName});
			
			_tiElo = new TextInput();
			listProvider.push({name:"ELO:", accessory:_tiElo});
			
			_btnAdd = new Button();
			_btnAdd.label = "Add";
			_btnAdd.addEventListener(Event.TRIGGERED, onBtnAddTriggered);
			listProvider.push({name:" ", accessory:_btnAdd});
			
			listProvider.push({name:"Or"});

			_btnExistingPlayer = new Button();
			_btnExistingPlayer.label = "Choose an existing player";
			_btnExistingPlayer.addEventListener(Event.TRIGGERED, onAddExistingPlayer);
			
			listProvider.push({name:" ", accessory:_btnExistingPlayer});
			
			_list.dataProvider = new ListCollection(listProvider);
		}
		
		private function onAddExistingPlayer():void
		{
			dispatchEventWith(GOTO_ADD_PLAYER_LIST);
		}
		
		private function onBtnAddTriggered():void
		{
			if (!_tiName.text || _tiName.text == "")
				return;
			
			if (!_tiElo.text || _tiElo.text == "")
				return;
			
			registrationModel.addPlayer(_tiName.text, parseInt(_tiElo.text));
			onBack();
		}
		
		override protected function layoutContent():void
		{
			_list.width = actualWidth;
			_list.height = actualHeight - header.height;
		}
		
		override protected function onBack():void
		{
			super.onBack();
		}
		
	}
}