const BACKGROUND_COLOR = :black

get_char(object::Any) = '?'
get_color(object::Any) = :white

get_char(::Nothing) = '⋅'
get_color(::Nothing) = :white

# purposefully not defining `get_char(::Object3)` and `get_color(::Object3)` in order to test `get_char(::Any)` and `get_color(::Any)`

get_char(::Object1) = '∘'
get_color(::Object1) = :green

get_char(::Object2) = '✖'
get_color(::Object2) = :red

function Base.show(io::IO, ::MIME"text/plain", object::AbstractObject)
    print(io,
          typeof(object),
          "() displayed as <",
          Crayons.Crayon(background = BACKGROUND_COLOR, foreground = get_color(object), bold = true, reset = true),
          get_char(object),
          Crayons.Crayon(reset = true),
          ">"
         )
    return nothing
end

function get_first_object(tile_map::TileMap, height::Integer, width::Integer)
    idx = findfirst(tile_map[:, height, width])
    if isnothing(idx)
        return nothing
    else
        return tile_map.objects[idx]
    end
end

function Base.show(io::IO, ::MIME"text/plain", tile_map::TileMap)
    for i in 1:get_height(tile_map)
        for j in 1:get_width(tile_map)
            object = get_first_object(tile_map, i, j)
            print(io, Crayons.Crayon(background = BACKGROUND_COLOR, foreground = get_color(object), bold = true, reset = true), get_char(object))
        end
        println(io, Crayons.Crayon(reset = true))
    end

    return nothing
end

function show_layers(io::IO, ::MIME"text/plain", tile_map::TileMap)
    for (layer, object) in enumerate(tile_map.objects)
        println("layer = $layer, object = $object")
        for i in 1:get_height(tile_map)
            for j in 1:get_width(tile_map)
                object = get_first_object(tile_map, i, j)
                print(io, Crayons.Crayon(background = BACKGROUND_COLOR, foreground = get_color(object), bold = true, reset = true), get_char(object))
            end
            println(io, Crayons.Crayon(reset = true))
        end
    end

    return nothing
end
