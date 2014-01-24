package com.hebdo.manager.model.draw
{
	import com.hebdo.manager.event.DrawEvent;
	import com.hebdo.manager.model.BaseModel;
	import com.hebdo.manager.model.draw.impl.DYPPlayerDrawer;
	import com.hebdo.manager.model.draw.impl.OpenDoublePlayerDrawer;
	import com.hebdo.manager.model.draw.impl.OpenSinglePlayerDrawer;
	import com.hebdo.manager.utils.Config;
	import com.hebdo.manager.utils.HebdoType;
	import com.hebdo.manager.utils.SessionData;
	import com.hebdo.manager.vo.Team;
	
	import feathers.controls.Alert;
	import feathers.data.ListCollection;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	public class DrawModel extends BaseModel
	{
		private var _teams:Vector.<Team>;
		
		public function DrawModel(config:Config)
		{
			super(config);
		}
		
		public function get teams():Vector.<Team>
		{
			return _teams;
		}
		
		public function drawPool(sessionData:SessionData):void
		{
			var hebdoType:String = sessionData.hebdoType;
			var drawer:IPlayerDrawer = getPlayerDrawer(hebdoType);
			trace("DrawModel:: drawPool with impl:", drawer);
			EventDispatcher(drawer).addEventListener(DrawEvent.DRAW_COMPLETE, onDrawComplete);
			
			try 
			{
				drawer.drawPool(sessionData);
			}
			catch(error:Error)
			{
				Alert.show(error.message, "Pool Draw Error", new ListCollection([{label:"OK"}]));
			}
		}
		
		private function onDrawComplete(event:Event):void
		{
			var drawer:IPlayerDrawer = IPlayerDrawer(event.target);
			EventDispatcher(drawer).removeEventListener(DrawEvent.DRAW_COMPLETE, onDrawComplete);
			
			_teams = drawer.teams;
			dispatchEvent(new DrawEvent(DrawEvent.DRAW_COMPLETE));
		}
		
		private function getPlayerDrawer(hebdoType:String):IPlayerDrawer
		{
			switch (hebdoType)
			{
				case HebdoType.DYP: 
					return new DYPPlayerDrawer();
					break;
				
				case HebdoType.OPEN_DOUBLE:
					return new OpenDoublePlayerDrawer();
					break;
				
				case HebdoType.OPEN_SINGLE:
					return new OpenSinglePlayerDrawer();
			}
			return null;
		}
	}
}