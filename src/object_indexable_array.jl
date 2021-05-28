"""

    ObjectIndexableArray{T, N, A, O} <: AbstractArray{T, N}

An instance of `ObjectIndexableArray`, referred to as `object_indexable_array` here, simply wraps an `array` (whose type is captured by the type parameter `A` above) and allows us to index its first dimension using a [singleton](https://docs.julialang.org/en/v1/manual/types/#man-singleton-types) object or an array of singleton objects (in addition to all the other ways of indexing the wrapped `array`). Information about the objects is stored in the type parameter `O` above which is essentially the type of tuple of objects along the `num_objects` dimension. Note that `size(object_indexable_array, 1)` should be equal to the number of elements in the type parameter `O`.

"""
struct ObjectIndexableArray{T, N, A, O} <: AbstractArray{T, N}
    array::A
end

get_objects_type(::ObjectIndexableArray{T, N, A, O}) where {T, N, A, O} = O
get_objects(object_indexable_array::ObjectIndexableArray) = Tuple(object_type() for object_type in get_objects_type(object_indexable_array).parameters)

Base.size(object_indexable_array::ObjectIndexableArray, args...; kwargs...) = Base.size(object_indexable_array.array, args..., kwargs...)

# regular indexing (indexing without using objects)
Base.getindex(object_indexable_array::ObjectIndexableArray, args...; kwargs...) = Base.getindex(object_indexable_array.array, args..., kwargs...)
Base.setindex!(object_indexable_array::ObjectIndexableArray, args...; kwargs...) = Base.setindex!(object_indexable_array.array, args..., kwargs...)

# indexing using a single object
@generated function Base.to_index(object_indexable_array::ObjectIndexableArray{T, N, A, O}, object::X) where {T, N, A, O, X <: AbstractObject}
    i = findfirst(X .=== O.parameters)
    isnothing(i) && error("Object $object is not present in $object_indexable_array")
    return :($i)
end

Base.getindex(object_indexable_array::ObjectIndexableArray, object::AbstractObject, args...; kwargs...) = getindex(object_indexable_array.array, Base.to_index(object_indexable_array, object), args..., kwargs...)
Base.setindex!(object_indexable_array::ObjectIndexableArray, value::Bool, object::AbstractObject, args...; kwargs...) = setindex!(object_indexable_array.array, value, Base.to_index(object_indexable_array, object), args..., kwargs...)

# indexing using an array of objects
Base.to_index(object_indexable_array::ObjectIndexableArray, objects::AbstractArray{<:AbstractObject}) = map(object -> Base.to_index(object_indexable_array, object), objects)
Base.getindex(object_indexable_array::ObjectIndexableArray, objects::AbstractArray{<:AbstractObject}, args...; kwargs...) = getindex(object_indexable_array.array, map(object -> Base.to_index(object_indexable_array, object), objects), args..., kwargs...)
