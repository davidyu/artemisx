artemisx
========

HaXe port of Gamadu's Artemis Entity Systems. [API Documentation here](http://davidyu.github.io/artemisx/doc). This is no longer being actively maintained.

## Design and  architecture

The original Artemis framework is a rather straightforward implementation of the standard entity component framework. There are entities, which are stateless except they own components (data), and systems, which operate on and mutate components. Components in Artemis are intended to hold only state/data. Systems are intended to hold only logic. Of course, this is not strictly enforced. :)

### Update loop

The world class will invoke `processEntities()` on all registered systems, which serves as the update hook for systems. However, the user program is responsible for calling `world.process()`---this way the user program has full control over the rate of system ticks.

### Creating entities

### Aspects

Each system only cares about a subset of entities, because it usually only cares about a subset of components. In its `processEntities()` method, a `Bag<Entity>` is passed in as a parameter, which is the collection of entities that the system cares about. Systems tells the world which entities they cares about through Aspects.

Aspects can be thought of as a description of a set of components. By providing useful set operations (`exclude, one, all`), Aspects allow you to define any set of components in the world.

### Passive systems

### Rendering systems

## Other implementation notes

Bitsets and UUIDs
