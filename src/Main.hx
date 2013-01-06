package ;

import com.utils.Bitset;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

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
		// entry point
		var bit = new Bitset(32);
		bit.set(0);
		bit.set(2);
		bit.set(30);
		trace(bit.get(0));
		trace(bit.get(1));
		trace(bit.get(2));
		trace(bit.get(30));
		trace(bit.get(31));
		bit.trace();
	}
	
}