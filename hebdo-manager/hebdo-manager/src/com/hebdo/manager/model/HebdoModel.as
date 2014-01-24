package com.hebdo.manager.model
{
	import com.hebdo.manager.event.HebdoEvent;
	import com.hebdo.manager.utils.Config;
	import com.hebdo.manager.vo.Hebdo;

	[Event(name="hebdoListReceived", type="starling.events.Event")]
	public class HebdoModel extends BaseModel
	{
		public function HebdoModel(config:Config)
		{
			super(config);
		}
		
		public function retreiveList():void
		{
			const event:HebdoEvent = new HebdoEvent(HebdoEvent.HEBDO_LIST_RECEIVED, getHebdoList());
			dispatchEvent(event);
		}
		
		private function getHebdoList():Vector.<Hebdo>
		{
			return _config.hebdosList;
		}
	}
}