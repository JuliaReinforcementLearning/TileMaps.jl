# TileMaps

`TileMaps` is a package that makes it simple to create 2D tile maps (and higher dimensional equivalents) in Julia. It is designed to be lightweight and fast, and have minimal dependencies.

**Note:** This package does not export any names. The examples below that demonstrate the use of this package assume that it has been loaded via `import TileMaps as TM`.

**Acknowledgements:** Big thanks to [Jun Tian](https://github.com/findmyway) (@findmyway) for initially introducing the core ideas of this package in [`GridWorlds`](https://github.com/JuliaReinforcementLearning/GridWorlds.jl).

### Index

1. [ObjectIndexableArray](#objectindexablearray)
1. [Objects](#objects)
1. [TileMap](#tilemap)
1. [Constructing a TileMap](#constructing-a-tilemap)
1. [Indexing a TileMap](#indexing-a-tilemap)
1. [Visualizing a TileMap](#visualizing-a-tilemap)


### `ObjectIndexableArray`

```
struct ObjectIndexableArray{T, N, A, O} <: AbstractArray{T, N}
    array::A
end
```

An instance of `ObjectIndexableArray`, referred to as `object_indexable_array` here, simply wraps an `array` (whose type is captured by the type parameter `A` above) and allows us to index its first dimension using a [singleton](https://docs.julialang.org/en/v1/manual/types/#man-singleton-types) object or an array of singleton objects (in addition to all the other ways of indexing the wrapped `array`). Information about the objects is stored in the type parameter `O` above which is essentially the type of tuple of objects along the `num_objects` dimension. Note that `size(object_indexable_array, 1)` should be equal to the number of elements in the type parameter `O`.

`size(object_indexable_array, 1)` should be equal to the number of elements in the type parameter `O`.

### Objects

Object types are [singletons](https://docs.julialang.org/en/v1/manual/types/#man-singleton-types) (structs with no fields). Here are the example objects that are provided in this package:

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

For an `object_indexable_array`, you can get the type of tuple of objects in it using `TM.get_objects_type(object_indexable_array)`, or you can get the tuple of objects itself, using `TM.get_objects(object_indexable_array)`.

### `TileMap`

```
const TileMap{O} = ObjectIndexableArray{Bool, 3, BitArray{3}, O}
```

An instance of `TileMap`, referred to as `tile_map` here, wraps an `array` of type `BitArray{3}` and is of size `(num_objects, height, width)`, which encodes information about the presence or absence of objects across the tiles using Boolean values. Each tile can contain multiple objects, which is captured by a multi-hot encoding along the first dimension (`num_objects` dimension) of the `array`.

### Constructing a `TileMap`

You can instantiate a `TileMap` using the following constructor that are provided by this package:

1. Create an empty `tile_map` using a tuple of objects and the desired height (8) and width(16):

    ```
    julia> tile_map = TM.TileMap((TM.EXAMPLE_OBJECT_1, TM.EXAMPLE_OBJECT_2, TM.EXAMPLE_OBJECT_3), 8, 16);

    julia>
    ```

1. Create a `tile_map` using a tuple of objects and an existing `array`:

    ```
    julia> tile_map = TM.TileMap((TM.EXAMPLE_OBJECT_1, TM.EXAMPLE_OBJECT_2, TM.EXAMPLE_OBJECT_3), rand(Bool, 3, 8, 16) |> BitArray);

    julia>
    ```

### Indexing a `TileMap`

Because of `TileMap <: ObjectIndexableArray`, we can index the first dimension of a `tile_map` in a variety of ways. For example, like this:

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

Using the [`Crayons`](https://github.com/KristofferC/Crayons.jl) package, each object can be displayed as a colored Unicode character. For example, like this:

<img src="https://github.com/Sid-Bhatia-0/TileMaps.jl/blob/master/assets/example_object_1.png">

When you create your custom object like this, for example,

<img src="https://github.com/Sid-Bhatia-0/TileMaps.jl/blob/master/assets/my_object.png">

you may also want to implement the following methods: `get_char(::MyObject)` (especially this one), `get_foreground_color(::MyObject)`, and `get_backround_color(::MyObject)`. If you don't do so, `MY_OBJECT` will be displayed based on the following default methods as defined in this package:

```
get_char(object::Any) = '?'
get_foreground_color(object::Any) = :white
get_backround_color(object::Any) = :nothing
```

A `tile_map` is displayed as a 2D grid of colored Unicode characters, with one character displayed per tile. Only the first object present (along the first dimension (`num_objects` dimension) of the `array`) at a tile is displayed for that tile, even though there may be multiple objects present at that tile.

If there are no objects present at a tile, then the `⋅` character is displayed for that tile (with white color and no background). This behaviour can be customized by overriding the following methods:

```
get_char(::Nothing) = '⋅'
get_foreground_color(::Nothing) = :white
get_background_color(::Nothing) = :nothing
```

<img src="https://github.com/Sid-Bhatia-0/TileMaps.jl/blob/master/assets/tile_map.png">

Note that the `get_char`, `get_foreground_color`, and `get_background_color` methods have purposefully not been explictly defined for the `TM.ExampleObject3` type in order to demonstrate the fallback to the default character and colors, which is why `TM.EXAMPLE_OBJECT_3` is displayed using a white colored `?` with no background.

We can also inspect each kind of object in the `tile_map` separately using the `show_layers` method. This is very handy for debugging:

<img src="https://github.com/Sid-Bhatia-0/TileMaps.jl/blob/master/assets/show_layers.png">

Here we have utilized only a limited number of features from the `Crayons` package in order to show an an example of how one may want to display a `tile_map`. `Crayons` has other features that you can play with to suit your needs.
