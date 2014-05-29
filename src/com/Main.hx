package com;

import com.artemisx.Aspect;
import com.artemisx.Component;
import com.artemisx.ComponentMapper;
import com.artemisx.ComponentType;
import com.artemisx.Entity;
import com.artemisx.EntityManager;
import com.artemisx.EntitySystem;
import com.artemisx.managers.GroupManager;
import com.artemisx.managers.PlayerManager;
import com.artemisx.managers.TagManager;
import com.artemisx.managers.PlayerManager;
import com.artemisx.systems.DelayedEntityProcessingSystem;
import com.artemisx.systems.EntityProcessingSystem;
import com.artemisx.systems.IntervalEntityProcessingSystem;
import com.artemisx.systems.VoidEntitySystem;
import com.artemisx.World;
import com.artemisx.utils.Bag;
import com.artemisx.utils.Bitset;
import com.artemisx.utils.ClassHash;
import com.artemisx.utils.TArray;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

using com.artemisx.utils.TArrayHelper;

@:access(com.artemisx)
class Main 
{	
	static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		
		opt();
	}
	
	static function opt()
	{
		var g = new PlayerManager();
		var t = new DelayedEntityProcessingSystem(new Aspect());
	}
	
	static function testComponentMapper()
	{
	}
	
	
	static function testBag()
	{
		var b:Bag<Int> = new Bag();
		b.add(5);
		b.add(5);
		b.add(5);
		b.add(7);
		b.set(10, 6);
		b.remove(2);
		b.toString();
		
		var b1:Bag<Int> = new Bag();
		b1.add(7);
		b1.add(6);
		
		b.removeAllIn(b1);
		
		b.toString();
	}
}

class TestComp implements Component
{
	public function new() {}
}

private class TestComp2 implements Component
{
	
}
