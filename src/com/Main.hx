package com;

import com.artemisx.Aspect;
import com.artemisx.Component;
import com.artemisx.ComponentMapper;
import com.artemisx.ComponentType;
import com.artemisx.Entity;
import com.artemisx.EntityManager;
import com.artemisx.EntitySystem;
import com.artemisx.World;
import com.utils.Bag;
import com.utils.Bitset;
import com.utils.ClassHash;
import com.utils.TArray;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

using com.utils.TArrayHelper;

@:access(com.artemisx)
@:access(com.artemisx.Aspect)
class Main 
{
	
	static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		
		testSystem();
	}
	
	static function testSystem()
	{
		var w = new World();
		var s = new EntitySystem(new Aspect());
		//s.onAdded(m.	}
	}
	static function testWorld()
	{
		var w = new World();
	}
	static function testComponentMapper()
	{
		ComponentMapper.getFor(TestComp, new World());
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
	
	static function testArray()
	{
		var t:TArray<Int> = new TArray();
		t.insertAt(10, 5);
		trace(t);
	}
	
	static function testClassHash()
	{
		var t:ClassHash<Entity,Int> = new ClassHash();
		//t.set(TestComp, 5);
		//t.set(TestComp2, 3);
		trace(t.get(Entity));
		//trace(t.get(TestComp2));
		for (i in t.keys()) {
			trace("hello" + i);
		}
	}
	
	static function testBitset()
	{
		// entry point
		var bit = new Bitset(1);
		var bit2 = new Bitset();
		bit.set(33);
		bit2.set(33);
		bit2.set(1);

		trace(bit.intersects(bit2));
		trace(bit2.intersects(bit));
		bit.toString();
	}
	
	static function testClass(type:Class<Component>)
	{
		var t:Class<Component> = type;
		trace(t);
		trace(type);
	}
	
}

private class TestComp implements Component
{
	
}

private class TestComp2 implements Component
{
	
}