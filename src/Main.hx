package ;

import com.artemis.Component;
import com.artemis.ComponentMapper;
import com.artemis.ComponentType;
import com.artemis.Entity;
import com.artemis.World;
import com.utils.Bag;
import com.utils.Bitset;
import com.utils.ClassHash;
import com.utils.TArray;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

using com.utils.TArrayHelper;

/**
 * ...
 * @author 
 */

class Main 
{
	
	static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		
		//testArray();
		testComponentMapper();
	}
	
	static function testComponentMapper()
	{
		ComponentMapper.getFor(TestComp, new World());
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
		bit.set(0);
		bit.set(2);
		bit.set(3);
		trace(bit.get(0));
		trace(bit.get(1));
		trace(bit.get(32));
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