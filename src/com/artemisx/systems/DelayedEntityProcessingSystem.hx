package com.artemisx.systems;
import com.artemisx.Aspect;
import com.artemisx.Entity;
import com.artemisx.EntitySystem;
import com.artemisx.utils.ImmutableBag;

/**
 *
 *  DelayedEntityProcessingSystem
 *  originally written by Arni Arent
 *  ported to HaXe by Team Yu
 *
 */

class DelayedEntityProcessingSystem extends EntitySystem
{
    @:isVar public var delay (getInitialTimeDelay, null):Float;
    @:isVar public var running (isRunning, null):Bool;
    private var acc:Float;

    public function new(aspect:Aspect) 
    {
        super(aspect);
    }

    override private function processEntities(entities:ImmutableBag<Entity>):Void
    {
        for (i in 0...entities.size) {
            var e:Entity = entities.get(i);
            var remaining:Float = getRemainingDelay(e);

            processDelta(e, acc);
            if (remaining <= 0) {
                processExpired(e);
            } else {
                offerDelay(remaining);
            }
        }
        stop();
    }

    override private inline function onInserted(e:Entity):Void {
        var delay:Float = getRemainingDelay(e);
        if (delay > 0) {
            offerDelay(delay);
        }
    }

    private inline function getRemainingDelay(e:Entity) { return 0; }

    override private inline function checkProcessing():Bool
    {
        if (running) {
            acc += world.getDelta();
            if (acc >= delay) {
                return true;
            }
        }
        return false;
    }

    private inline function processDelta(e:Entity, accumulatedDelta:Float):Void { }

    private inline function processExpired(e:Entity):Void { }

    public function restart(delay:Float)
    {
        this.delay = delay;
        this.acc = 0;
        running = true;
    }

    public inline function offerDelay(delay:Float):Void
    {
        if (!running || delay < getRemainingTimeUntilProcessing()) {
            restart(delay);
        }
    }

    public inline function getInitialTimeDelay():Float { return delay; }

    public inline function getRemainingTimeUntilProcessing():Float
    {
        if (running) {
            return delay - acc;
        }
        return 0;
    }

    public inline function isRunning():Bool { return running; }

    public function stop():Void
    {
        this.running = false;
        this.acc = 0;
    }
}
