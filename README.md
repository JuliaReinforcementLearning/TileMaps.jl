# TileMaps

A package for creating **lightweight** and **simple** 2D tile maps in Julia.

### TileMap

```
struct TileMap{O} <: AbstractArray{Bool, 3}
    grid::BitArray{3}
    objects::O
end
```

We'll refer to an instance of `TileMap` as `tile_map`. A `tile_map` contains a field called `grid` of type `BitArray{3}` of size `(num_objects, height, width)` that efficiently stores the locations of objects on the `tile_map`. Each tile can contain multiple objects, which is captured by a multi-hot encoding along the first dimension (`num_objects`) of the `grid`.

### Objects

Objects are [singletons](https://docs.julialang.org/en/v1/manual/types/#man-singleton-types) (have no fields). Here is how you can create objects:

```
abstract type AbstractObject end

struct Object1 <: AbstractObject end
const OBJECT_1 = Object1()

struct Object2 <: AbstractObject end
const OBJECT_2 = Object2()

struct Object3 <: AbstractObject end
const OBJECT_3 = Object3()
```

### Constructors

You can instantiate a `TileMap` using a constructor that is provided to initialize an empty tile map:

```
tile_map = TM.TileMap((TM.OBJECT_1, TM.OBJECT_2, TM.OBJECT_3), 8, 16)
```

Or you can use directly use the default constructor:

```
tile_map = TM.TileMap(rand(Bool, 3, 8, 16) |> BitArray, (TM.OBJECT_1, TM.OBJECT_2, TM.OBJECT_3))
```

### Indexing

You can directly use an object instance to index a `TileMap`. For example, like this:

```
tile_map[OBJECT_3, 4, 6]
```

### Visualization

Using the [`Crayons`](https://github.com/KristofferC/Crayons.jl) package, each object is represented using a colored Unicode character

```
julia> TM.OBJECT_1
TileMaps.Object1() represented as <∘>

```

When you create your own object like this:

```
struct MyObject <: AbstractObject end
const MY_OBJECT = MyObject()
```

You should also consider implementing the `get_char(::MyObject)` and `get_color(::MyObject)` methods corresponding to it. If you don't do so, it will default to the default methods that are defined as follows:

```
get_char(object::Any) = '?'
get_color(object::Any) = :white
```

A `tile_map` is displayed as a 2D grid of colored Unicode characters, with one character per tile. Only the first object present at a tile (along the `num_objects` dimension of the `tile_map`) is displayed for that tile, even though there may be multiple objects present at that tile. If there are no objects present at a tile, then the `⋅` character (`:white` color) is displayed for that tile.

```
julia> tile_map = TM.TileMap(rand(Bool, 3, 8, 16) |> BitArray, (TM.OBJECT_1, TM.OBJECT_2, TM.OBJECT_3)) # using the default constructor
∘✖✖∘⋅⋅✖∘✖∘∘∘✖∘∘⋅
?✖∘✖∘??⋅?✖∘∘?∘∘∘
∘⋅∘∘∘∘✖∘✖∘✖∘∘∘✖?
∘✖∘✖∘⋅∘?✖∘∘✖∘∘✖∘
∘✖⋅⋅∘??∘✖⋅∘✖?∘∘∘
∘∘∘⋅∘✖?∘∘⋅⋅∘✖∘∘∘
∘?⋅?∘✖∘✖∘✖∘✖∘⋅⋅✖
?⋅✖∘∘∘∘✖✖∘✖∘∘∘⋅∘

```

Here the `TM.Object3` does not have a `get_char` or `get_color` method implemented explicitly. So, `get_char(TM.OBJECT_3)` falls back to the default method `get_char(object::Any)` that returns `?` and `get_color(object::Any)` that returns `:white`.
