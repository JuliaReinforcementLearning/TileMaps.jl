get_char(object::Any) = '?'
get_foreground_color(::Any) = :white
get_background_color(::Any) = :nothing

get_char(::Nothing) = '⋅'
get_foreground_color(::Nothing) = :white
get_background_color(::Nothing) = :nothing

# purposefully not defining `get_char(::ExampleObject3)`, `get_foreground_color(::ExampleObject3)`, and `get_background_color(::ExampleObject3)` in order to test fallback to default methods

get_char(::ExampleObject1) = '∘'
get_foreground_color(::ExampleObject1) = :light_green
get_background_color(::ExampleObject1) = :nothing

get_char(::ExampleObject2) = '✖'
get_foreground_color(::ExampleObject2) = :light_red
get_background_color(::ExampleObject2) = :nothing

function Base.show(io::IO, ::MIME"text/plain", object::AbstractObject)
    print(io,
          typeof(object),
          "() displayed as <",
          Crayons.Crayon(foreground = get_foreground_color(object), background = get_background_color(object), reset = true),
          get_char(object),
          Crayons.Crayon(reset = true),
          ">",
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
            print(io,
                  Crayons.Crayon(foreground = get_foreground_color(object), background = get_background_color(object), reset = true),
                  get_char(object),
                  Crayons.Crayon(reset = true),
                 )
        end

        if i < get_height(tile_map)
            println(io)
        else
            print(io)
        end
    end

    return nothing
end

function show_layers(io::IO, ::MIME"text/plain", tile_map::TileMap)
    for (layer, object) in enumerate(tile_map.objects)
        println("layer = $layer, object = $object")
        for i in 1:get_height(tile_map)
            for j in 1:get_width(tile_map)
                if tile_map[object, i, j]
                    displayed_object = object
                else
                    displayed_object = nothing
                end

                print(io,
                      Crayons.Crayon(foreground = get_foreground_color(displayed_object), background = get_background_color(displayed_object), reset = true),
                      get_char(displayed_object),
                      Crayons.Crayon(reset = true),
                     )
            end

            println(io)
        end
    end

    return nothing
end
