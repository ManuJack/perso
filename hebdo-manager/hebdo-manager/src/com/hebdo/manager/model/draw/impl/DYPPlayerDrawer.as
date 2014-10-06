package com.hebdo.manager.model.draw.impl
{
	import com.hebdo.manager.event.DrawEvent;
	import com.hebdo.manager.model.draw.IPlayerDrawer;
	import com.hebdo.manager.utils.Config;
	import com.hebdo.manager.utils.SessionData;
	import com.hebdo.manager.vo.PlayerRegistration;
	import com.hebdo.manager.vo.Team;
	
	import starling.events.EventDispatcher;

	public class DYPPlayerDrawer extends EventDispatcher implements IPlayerDrawer
	{
		private var _players1:Vector.<PlayerRegistration>;
		private var _players2:Vector.<PlayerRegistration>;
		
		private var _teams:Vector.<Team>;
		
		public function DYPPlayerDrawer()
		{
			super();
		}
		
		public function get teams():Vector.<Team>
		{
			return _teams;
		}

		public function drawPool(sessionData:SessionData):void
		{
			const players:Vector.<PlayerRegistration> = sessionData.players;
			
			//Not even, we have a problem here...
			if (players.length % 2 != 0)
			{
				throw new Error("The number of players must be even!");
				return;
			}
			
			trace("Drawing DYP pool of", players.length, "players");
			
			//sort players if using median
			if (sessionData.useMedian)
				players.sort(playerSortFunction);
			else //shuffle player, so that team arent matched depending on registration time
				shuffleVector(players);
			
			separatePlayers(players);
			
			pickTeams();
			
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
				else if (team.seed == 4)
				{
					team.poolId = Team.POOL_A;
				}
				else
				{
					if (team.seed % 2 == 0)
						team.poolId = Team.POOL_A;
					else
						team.poolId = Team.POOL_B;
				}
			}
		}
		
		private function pickTeams():void
		{
			var randomIndex:int;
			var i:int;
			var teamLen:uint = _players1.length;
			
			var player1:PlayerRegistration;
			var player2:PlayerRegistration;
			
			_teams = new Vector.<Team>();
			var team:Team;
			
			for (i; i<teamLen; ++i)
			{
				randomIndex = Math.floor(Math.random() * _players1.length);
				player1 = _players1[randomIndex] as PlayerRegistration;
				_players1.splice(randomIndex, 1);
				
				randomIndex = Math.floor(Math.random() * _players2.length);
				player2 = _players2[randomIndex] as PlayerRegistration;
				_players2.splice(randomIndex, 1);
				
				team = new Team(player1, player2);
				_teams.push(team);
			}
			
			trace("Teams picked!");
		}
		
		private function separatePlayers(players:Vector.<PlayerRegistration>):void
		{
			const nbPlayers:uint = players.length;
			const halfPlayers:uint = nbPlayers / 2;
			_players1 = players.slice(0, halfPlayers);
			_players2 = players.slice(halfPlayers, players.length);
		}
		
		private final function playerSortFunction(player1:PlayerRegistration, player2:PlayerRegistration):Number
		{
			if (player1.elo < player2.elo)
				return 1;
			else if (player1.elo > player2.elo)
				return -1;
			else 
				return 0;
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
		
		private function shuffleVector(vec:Vector.<PlayerRegistration>):void
		{
			if (vec.length > 1)
			{
				var i:int = vec.length - 1;
				while (i > 0) 
				{
					var s:Number = Math.round(Math.random()*(vec.length));
					var temp:* = vec[s];
					vec[s] = vec[i];
					vec[i] = temp;
					i--;
				}
			}
		}
	}
}