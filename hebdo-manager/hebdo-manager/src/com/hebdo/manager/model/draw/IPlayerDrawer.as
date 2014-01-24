package com.hebdo.manager.model.draw
{
	import com.hebdo.manager.utils.SessionData;
	import com.hebdo.manager.vo.Team;

	public interface IPlayerDrawer
	{
		function drawPool(sessionData:SessionData):void;
		function get teams():Vector.<Team>;
	}
}