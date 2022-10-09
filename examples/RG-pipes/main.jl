include("../../src/main.jl")
using Pkg
using Images
using FileIO
# GREEN 1; RED 2; GREEN BLACK RED 3; RED BLACK GREEN 4;


tile_set = Set([
    #WFC.create_tile_set(WFC.Sockets(3, 2, 3, 1), 1, 4, false)...,
    WFC.create_tile_set(WFC.Sockets(4, 3, 2, 2), 2, 2, true)...,
    #WFC.create_tile_set(WFC.Sockets(3, 4, 1, 1), 3, 4, false)...,
    #WFC.create_tile_set(WFC.Sockets(1, 1, 1, 1), 4, 1, false)...,
    #WFC.create_tile_set(WFC.Sockets(2, 2, 2, 2), 5, 1, false)...,
    ])



tile_ids = Set(map(x -> x.tile_id.id, collect(tile_set)))

image_grid = WFC.wave_function_collapse(tile_set, (2, 2), callback=x -> println(round(Int, x * 100)))



basic_image_data = Dict(map(x -> (x, FileIO.load(string(@__DIR__, "/tiles/", x, ".png"))), collect(tile_ids)))


image_map = WFC.create_image_map(tile_set, basic_image_data)


image_data = WFC.create_image(image_grid, image_map)

FileIO.save(string(@__DIR__, "/test.png"), image_data)
