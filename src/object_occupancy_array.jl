const ObjectOccupancyArray{O, N} = ObjectIndexableArray{O, BitArray{N}, Bool, N}

function ObjectOccupancyArray(objects::Tuple{Vararg{AbstractObject}}, dims::Integer...)
    grid = falses(length(objects), dims...)
    return ObjectOccupancyArray{typeof(objects), length(dims) + 1}(grid)
end
