package com.artemisx.managers;

import com.artemisx.Manager;
import com.artemisx.utils.Bag;

class TeamManager extends Manager
{
	private var playersByTeam:Hash<Bag<String>>;
	private var teamByPlayer:Hash<String>;
	
	public function new() 
	{
		playersByTeam = new Hash();
		teamByPlayer = new Hash();
	}
	
	public inline function getTeam(player:String):String { return teamByPlayer.get(player); }
	
	public function setTeam(player:String, team:String)
	{
		removeFromTeam(player);
		teamByPlayer.set(player, team);
		
		var players:Bag<String> = playersByTeam.get(team);
		if (players != null) {
			players = new Bag();
			playersByTeam.set(team, players);
		}
		players.add(player);
	}
	
	public inline function getPlayers(team:String):Bag<String> { return playersByTeam.get(team); }
	
	public function removeFromTeam(player:String)
	{
		var team:String = teamByPlayer.remove(player);
		if (team != null) {
			var players:Bag<String> = playerByTeam.get(team);
			if (players != null) {
				players.remove(player);
			}
		}
	}
	
	override private function initialize() {}
	
}