package com.hebdo.manager.component
{
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.LayoutGroup;
	import feathers.layout.VerticalLayout;
	import feathers.themes.HebdoManagerTheme;
	
	import starling.events.Event;
	
	public class PlayerRegistrationActionButton extends Button
	{
		public static const SET_DEFAULT_ELO		:String = "setDefaultElo";
		public static const SELECT_PLAYER		:String = "selectPlayer";
		
		private var _menu:LayoutGroup;
		
		public function PlayerRegistrationActionButton()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			label = "No ELO !";
			addEventListener(Event.TRIGGERED, onTriggered);
		}
		
		private function onTriggered():void
		{
			if (!_menu)
			{
				_menu = new LayoutGroup();
				const menuLayout:VerticalLayout = new VerticalLayout();
				menuLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
				menuLayout.gap = 15 * HebdoManagerTheme.THEME_SCALE;
				_menu.layout = menuLayout;
				
				const btnSelectPlayer:Button = new Button();
				btnSelectPlayer.label = "Choose existing player";
				btnSelectPlayer.addEventListener(Event.TRIGGERED, onSelectPlayer);
				_menu.addChild(btnSelectPlayer);
				
				const btnDefaultElo:Button = new Button();
				btnDefaultElo.label = "Set New Player ELO";
				btnDefaultElo.addEventListener(Event.TRIGGERED, onSetDefaultElo);
				_menu.addChild(btnDefaultElo);
			}
			
			const callout:Callout = Callout.show(_menu, this, Callout.DIRECTION_LEFT);
			callout.disposeContent = false;
		}
		
		private function onSelectPlayer():void
		{
			dispatchEventWith(SELECT_PLAYER);
		}
		
		private function onSetDefaultElo():void
		{
			dispatchEventWith(SET_DEFAULT_ELO);
		}
		
		override public function dispose():void
		{
			if (_menu)
				_menu.dispose();
			
			_menu = null;
			
			super.dispose();
		}
	}
}