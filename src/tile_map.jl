"""

    const TileMap{O} = ObjectIndexableArray{Bool, 3, BitArray{3}, O}

An instance of `TileMap`, referred to as `tile_map` here, wraps an `array` of type `BitArray{3}` and is of size `(num_objects, height, width)`, which encodes information about the presence or absence of objects across the tiles using Boolean values. Each tile can contain multiple objects, which is captured by a multi-hot encoding along the first dimension (`num_objects` dimension) of the `array`.

"""
const TileMap{O} = ObjectIndexableArray{Bool, 3, BitArray{3}, O}

TileMap(objects::Tuple{Vararg{AbstractObject}}, grid::BitArray{3}) = TileMap{typeof(objects)}(grid)

TileMap(objects::Tuple{Vararg{AbstractObject}}, height::Integer, width::Integer) = TileMap(objects, falses(length(objects), height, width))

get_num_objects(tile_map::TileMap) = size(tile_map, 1)
get_height(tile_map::TileMap) = size(tile_map, 2)
get_width(tile_map::TileMap) = size(tile_map, 3)
