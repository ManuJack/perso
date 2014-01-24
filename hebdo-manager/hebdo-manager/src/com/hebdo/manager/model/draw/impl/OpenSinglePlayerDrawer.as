package com.hebdo.manager.model.draw.impl
{
	import com.hebdo.manager.event.DrawEvent;
	import com.hebdo.manager.model.draw.IPlayerDrawer;
	import com.hebdo.manager.utils.SessionData;
	import com.hebdo.manager.vo.PlayerRegistration;
	import com.hebdo.manager.vo.Team;
	
	import starling.events.EventDispatcher;
	
	public class OpenSinglePlayerDrawer extends EventDispatcher implements IPlayerDrawer
	{
		private var _teams:Vector.<Team>;
		
		public function OpenSinglePlayerDrawer()
		{
			super();
		}
		
		public function drawPool(sessionData:SessionData):void
		{
			_teams = new Vector.<Team>();
			
			const players:Vector.<PlayerRegistration> = sessionData.players;
			
			for (var i:int; i<players.length; ++i)
			{
				_teams.push(new Team(players[i], null));
			}
			
			attributePool();
			dispatchEvent(new DrawEvent(DrawEvent.DRAW_COMPLETE));
		}
		
		private function attributePool():void
		{
			_teams.sort(teamSortFunction);
			
			const len:uint = _teams.length;
			var team:Team;
			var i:int;
			for (i; i<len; ++i)
			{
				team = _teams[i] as Team;
				team.seed = i + 1;
				
				if (team.seed == 1)
				{
					team.poolId = Team.POOL_A;
				}
				else if (team.seed == 2 || team.seed == 3)
				{
					team.poolId = Team.POOL_B;
				}
				else if (team.seed == 4 || team.seed == 5)
				{
					team.poolId = Team.POOL_A;
				}
				else
				{
					if (team.seed % 2 == 0)
						team.poolId = Team.POOL_B;
					else
						team.poolId = Team.POOL_A;
				}
			}
		}
		
		public function get teams():Vector.<Team>
		{
			return _teams;
		}
		
		private final function teamSortFunction(team1:Team, team2:Team):Number
		{
			if (team1.totalElo < team2.totalElo)
				return 1;
			else if (team1.totalElo > team2.totalElo)
				return -1;
			else 
				return 0;
		}
	}
}