# TileMaps

`TileMaps` is a package that makes it simple to create 2D tile maps in Julia. It is designed to be lightweight and fast, and have minimal dependencies.

**Note:** This package does not export any symbols. The examples below that demonstrate the use of this package assume that it has been loaded via `import TileMaps as TM`.

**Acknowledgements:** Big thanks to [Jun Tian](https://github.com/findmyway) (@findmyway) for initially introducing the core ideas of this package in [`GridWorlds`](https://github.com/JuliaReinforcementLearning/GridWorlds.jl).

### Index

1. [TileMap](#tilemap)
1. [Objects](#objects)
1. [Constructing a TileMap](#constructing-a-tilemap)
1. [Indexing a TileMap](#indexing-a-tilemap)
1. [Visualizing a TileMap](#visualizing-a-tilemap)

### TileMap

```
struct TileMap{O} <: AbstractArray{Bool, 3}
    grid::BitArray{3}
    objects::O
end
```

We'll refer to an instance of `TileMap` as `tile_map`. A `tile_map` contains a field called `grid` of type `BitArray{3}` and size `(num_objects, height, width)`, which efficiently stores the objects present in the `tile_map`. Each tile can contain multiple objects, which is captured by a multi-hot encoding along the first dimension (`num_objects` dimension) of the `grid`.

### Objects

Objects are [singletons](https://docs.julialang.org/en/v1/manual/types/#man-singleton-types) (structs with no fields). Here is how objects are created inside this package:

```
abstract type AbstractObject end

struct ExampleObject1 <: AbstractObject end
const EXAMPLE_OBJECT_1 = ExampleObject1()

struct ExampleObject2 <: AbstractObject end
const EXAMPLE_OBJECT_2 = ExampleObject2()

struct ExampleObject3 <: AbstractObject end
const EXAMPLE_OBJECT_3 = ExampleObject3()
```

You can crate your own objects like this:

```
julia> struct MyObject <: TM.AbstractObject end

julia>
```

### Constructing a `TileMap`

You can instantiate a `TileMap` using a constructor that is provided by this package. The following creates an empty tile map using a tuple of objects along with the desired height and width:

```
julia> tile_map = TM.TileMap((TM.EXAMPLE_OBJECT_1, TM.EXAMPLE_OBJECT_2, TM.EXAMPLE_OBJECT_3), 8, 16);

julia>
```

Or you could directly use the default constructor as well:

```
julia> tile_map = TM.TileMap(rand(Bool, 3, 8, 16) |> BitArray, (TM.EXAMPLE_OBJECT_1, TM.EXAMPLE_OBJECT_2, TM.EXAMPLE_OBJECT_3));

julia>
```

### Indexing a `TileMap`

In addition to the normal ways of indexing an array, you can also use an object to index the first dimension of a `tile_map`. For example, something like this:

```
julia> tile_map[TM.EXAMPLE_OBJECT_3, 4, 6];

julia>
```

This is only supported for one object at a time. You can use other forms of indexing for the `height` and `width` dimensions, for example:

```
julia> tile_map[TM.EXAMPLE_OBJECT_3, 4:7, :];

julia>
```

### Visualizing a `TileMap`

Using the [`Crayons`](https://github.com/KristofferC/Crayons.jl) package, each object can be displayed as a colored Unicode character:

<img src="https://github.com/Sid-Bhatia-0/TileMaps.jl/blob/master/assets/example_object_1.png">

When you create your own object like this, for example,

<img src="https://github.com/Sid-Bhatia-0/TileMaps.jl/blob/master/assets/my_object.png">

you should also consider implementing the `get_char(::MyObject)` and `get_color(::MyObject)` methods corresponding to it. If you don't do so, it will be displayed based on the following default methods defined in this package:

```
get_char(object::Any) = '?'
get_color(object::Any) = :white
```

A `tile_map` is displayed as a 2D grid of colored Unicode characters, with one character displayed per tile. Only the first object present at a tile (along the first dimension of the `grid`) is displayed for that tile, even though there may be multiple objects present at that tile. If there are no objects present at a tile, then the `⋅` character is displayed for that tile (with white color).

<img src="https://github.com/Sid-Bhatia-0/TileMaps.jl/blob/master/assets/tile_map.png">

Note here that the `get_char` and `get_color` methods have purposefully not been defined for the `TM.ExampleObject3` type explictly in order to demonstrate the fallback to the default character and color, which is why `TM.EXAMPLE_OBJECT_3` is displayed using a white colored `?`.

We can also inspect each kind of object in the `tile_map` separately using the `show_layers` method. This is very handy for debugging:

<img src="https://github.com/Sid-Bhatia-0/TileMaps.jl/blob/master/assets/show_layers.png">
