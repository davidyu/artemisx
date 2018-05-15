artemisx
========

HaXe port of Gamadu's Artemis Entity Systems. [API Documentation here](http://davidyu.github.io/artemisx/doc). This is no longer being actively maintained.

## Design and  architecture

The original Artemis framework is a rather straightforward implementation of the standard entity component framework. There are entities, which are stateless except they own components (data), and systems, which operate on and mutate components. Components in Artemis are intended to hold only state/data. Systems are intended to hold only logic. Of course, this is not strictly enforced. :) Entities, components, and systems belong to a higher-order module called World. Multiple worlds can co-exist with their separate entities, components and systems.

### Update loop

The world class will invoke `processEntities()` on all registered systems, which serves as the update hook for systems. However, the user program is responsible for calling `world.process()`—this way the user program has full control over the rate of system ticks.

### Creating entities

Entities should not be explicitly new'd, they should be acquired through `world.createEntity()`. This way, the entities are assigned a unique ID and the IDs can be recycled when the entities are destroyed. Arguably, we could have allowed idiomatically calling new on entities, so long as we provide some sort of mechanism to connect the entity to the world. Adding components to entities is as simple as calling `entity.addComponent( Component )`.

### Aspects

Each system only cares about a subset of entities, because it usually only cares about a subset of components. In its `processEntities()` method, a `Bag<Entity>` is passed in as a parameter, which is the collection of entities that the system cares about. Systems tells the world which entities they cares about through Aspects.

Aspects can be thought of as a description of a components set. By providing standard set operations (`exclude, one, all`), Aspects allow you to define any set of components in the world:

```
// will return entities with both UICmp and PosCmp
Aspect.getAspectForAll( [UICmp, PosCmp] ); 

// will return entities with either a ClientCmp or a SyncCmp
Aspect.getAspectForOne( [ClientCmp, SyncCmp] );

// will return entities with a PosCmp, but none of CameraCmp or a UICmp
Aspect.getAspectForAll( [PosCmp] ).exclude( [CameraCmp, UICmp] );
```

## Other implementation notes

### Passive systems

A system can be made passive to turn off its processing. It can be made back active by setting `system.passive = false`.

### UUIDs


