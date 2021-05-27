"""
The first dimension uses multi-hot encoding to encode objects in a tile.
The second and third dimensions correspond to the height and width of the tile map respectively.
"""
const TileMap{O} = ObjectIndexableArray{Bool, 3, BitArray{3}, O}

TileMap(objects::Tuple{Vararg{AbstractObject}}, grid::BitArray{3}) = TileMap{typeof(objects)}(grid)

TileMap(objects::Tuple{Vararg{AbstractObject}}, height::Integer, width::Integer) = TileMap(objects, falses(length(objects), height, width))

get_num_objects(tile_map::TileMap) = size(tile_map, 1)
get_height(tile_map::TileMap) = size(tile_map, 2)
get_width(tile_map::TileMap) = size(tile_map, 3)
