package com.hebdo.manager.screen
{
	import com.hebdo.manager.vo.Team;
	
	import feathers.controls.List;
	import feathers.data.ListCollection;

	public class PoolScreen extends BaseScreen
	{
		private var _list1:List;
		private var _list2:List;
		
		public function PoolScreen()
		{
			super();
			
			_showBtnNext = false;
			_title = "Pool";
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			_list1 = new List();
			_list1.dataProvider = getPoolDataProvider(Team.POOL_A);
			addChild(_list1);
			
			_list2 = new List();
			_list2.dataProvider = getPoolDataProvider(Team.POOL_B);
			addChild(_list2);
		}
		
		private function getPoolDataProvider(poolId:String):ListCollection
		{
			var i:int;
			const teams:Vector.<Team> = new Vector.<Team>();
			var team:Team;
			for (i; i<drawModel.teams.length; ++i)
			{
				team = drawModel.teams[i] as Team;
				if (team.poolId == poolId)
					teams.push(team);
			}
			return new ListCollection(teams);
		}
		
		override protected function layoutContent():void
		{
			_list1.width = actualWidth / 2;
			_list1.height = actualHeight - header.height;
			
			_list2.x = _list1.x + _list1.width;
			_list2.width = actualWidth / 2;
			_list2.height = actualHeight - header.height;
		}
	}
}