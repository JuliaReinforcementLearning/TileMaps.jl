import TileMaps as TM
import Test

Test.@testset "TileMaps.jl" begin
    objects = (TM.EXAMPLE_OBJECT_1, TM.EXAMPLE_OBJECT_2, TM.EXAMPLE_OBJECT_3)

    layer_1 = BitArray([0 1 0 0 0
                        0 1 0 0 0
                        0 1 0 0 0
                        0 1 0 0 0])

    layer_2 = BitArray([0 0 0 0 0
                        0 0 0 0 0
                        1 1 0 0 0
                        1 1 0 0 0])

    layer_3 = BitArray([0 0 0 0 0
                        1 1 0 0 0
                        0 0 0 0 0
                        1 1 0 0 0])

    grid = BitArray(undef, 3, 4, 5)

    grid[1, :, :] .= layer_1
    grid[2, :, :] .= layer_2
    grid[3, :, :] .= layer_3

    tile_map = TM.TileMap(objects, grid)

    Test.@test TM.get_objects_type(tile_map) == typeof(objects)
    Test.@test TM.get_objects(tile_map) == objects

    Test.@test TM.get_num_objects(tile_map) = 3
    Test.@test TM.get_height(tile_map) = 4
    Test.@test TM.get_width(tile_map) = 5

    # regular indexing (indexing without using objects)
    Test.@test tile_map[1, 2, 3] == false
    Test.@test tile_map[1:3, 2, 2] == BitArray([1, 0, 1])
    Test.@test tile_map[[1, 3], 2, 2] == BitArray([1, 1])

    # indexing using one object
    Test.@test tile_map[TM.EXAMPLE_OBJECT_2, 1, 1] == tile_map[2, 1, 1] == false
    Test.@test tile_map[TM.EXAMPLE_OBJECT_2, end, end] == tile_map[2, end, end] == false
    Test.@test tile_map[TM.EXAMPLE_OBJECT_2, :, 1] == tile_map[2, :, 1] == BitArray([0, 0, 1, 1])
    Test.@test tile_map[TM.EXAMPLE_OBJECT_2, end, :] == tile_map[2, end, :] == BitArray([1, 1, 0, 0, 0])
    Test.@test tile_map[TM.EXAMPLE_OBJECT_2, 2:3, 2:4] == tile_map[2, 2:3, 2:4] == BitArray([0 0 0
                                                                                             1 0 0])

    # indexing using more than one object
    Test.@test tile_map[[TM.EXAMPLE_OBJECT_2], 1, 1] == tile_map[[2], 1, 1] == BitArray([0])
    Test.@test tile_map[[TM.EXAMPLE_OBJECT_3, TM.EXAMPLE_OBJECT_1], 2, 1] == tile_map[[3, 1], 2, 1] == BitArray([1, 0])
end
