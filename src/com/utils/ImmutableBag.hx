package com.utils;


interface ImmutableBag<E>
{
	var size(default, null):Int;
	
	function get(index:Int):E;
	function isEmpty():Bool;
	function contains(e:E):Bool;
}