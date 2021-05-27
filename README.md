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

In addition to the normal ways of indexing an array, you can also use an object or an array of objects to index the first dimension of a `tile_map`. For example, something like this:

```
julia> tile_map[TM.EXAMPLE_OBJECT_3, 4, 6]
true

julia> tile_map[TM.EXAMPLE_OBJECT_3, 2:4, 6:7]
3×2 BitMatrix:
 1  1
 0  1
 1  1

julia> tile_map[[TM.EXAMPLE_OBJECT_3, TM.EXAMPLE_OBJECT_1], 5, 8]
2-element BitVector:
 0
 1

julia>
```

### Visualizing a `TileMap`

Using the [`Crayons`](https://github.com/KristofferC/Crayons.jl) package, each object can be displayed as a colored Unicode character:

<img src="https://github.com/Sid-Bhatia-0/TileMaps.jl/blob/master/assets/example_object_1.png">

When you create your custom object like this, for example,

<img src="https://github.com/Sid-Bhatia-0/TileMaps.jl/blob/master/assets/my_object.png">

you may also want to implement the following methods: `get_char(::MyObject)` (especially this one), `get_foreground_color(::MyObject)`, and `get_backround_color(::MyObject)`. If you don't do so, it will be displayed based on the following default methods defined in this package:

```
get_char(object::Any) = '?'
get_foreground_color(object::Any) = :white
get_backround_color(object::Any) = :nothing
```

A `tile_map` is displayed as a 2D grid of colored Unicode characters, with one character displayed per tile. Only the first object present at a tile (along the first dimension (`num_objects` dimension) of the `grid`) is displayed for that tile, even though there may be multiple objects present at that tile. If there are no objects present at a tile, then the `⋅` character is displayed for that tile (with white color). This behaviour can be customized by overriding the following methods:

```
get_char(::Nothing) = '⋅'
get_foreground_color(::Nothing) = :white
get_background_color(::Nothing) = :nothing
```

<img src="https://github.com/Sid-Bhatia-0/TileMaps.jl/blob/master/assets/tile_map.png">

Note that the `get_char`, `get_foreground_color`, and `get_background_color` methods have purposefully not been defined for the `TM.ExampleObject3` type in order to demonstrate the fallback to the default character and colors, which is why `TM.EXAMPLE_OBJECT_3` is displayed using a white colored `?` with no background.

We can also inspect each kind of object in the `tile_map` separately using the `show_layers` method. This is very handy for debugging:

<img src="https://github.com/Sid-Bhatia-0/TileMaps.jl/blob/master/assets/show_layers.png">

Here we have used only a limited number of features (foreground and background colors) from the [`Crayons`](https://github.com/KristofferC/Crayons.jl) package for showing an example of how one may want to display a `tile_map`. It has several other features that you can play with to suit your needs.
