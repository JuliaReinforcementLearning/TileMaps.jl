"""
    TileMap{O} <: AbstractArray{Bool, 3}
The first dimension uses multi-hot encoding to encode objects in a tile.
The second and third dimensions correspond to the height and width of the tile map respectively.
"""
struct TileMap{O} <: AbstractArray{Bool, 3}
    grid::BitArray{3}
    objects::O
end

function TileMap(objects::Tuple{Vararg{AbstractObject}}, height::Integer, width::Integer)
    grid = falses(length(objects), height, width)
    return TileMap(grid, objects)
end

Base.size(tile_map::TileMap, args...; kwargs...) = Base.size(tile_map.grid, args..., kwargs...)
Base.getindex(tile_map::TileMap, args...; kwargs...) = Base.getindex(tile_map.grid, args..., kwargs...)
Base.setindex!(tile_map::TileMap, args...; kwargs...) = Base.setindex!(tile_map.grid, args..., kwargs...)

get_num_objects(tile_map::TileMap) = size(grid, 1)
get_height(tile_map::TileMap) = size(grid, 2)
get_width(tile_map::TileMap) = size(grid, 3)
