include("../../src/main.jl")
using Pkg
using Images
using FileIO
# GREEN 1; RED 2; GREEN BLACK RED 3; RED BLACK GREEN 4;
tiles = [
    WFC.Tile(3, 2, 3, 1, 1),
    WFC.Tile(4, 1, 4, 2, 2),
    WFC.Tile(2, 4, 1, 4, 3),
    WFC.Tile(1, 3, 2, 3, 4),
    WFC.Tile(4, 3, 2, 2, 5), 
    WFC.Tile(2, 4, 4, 2, 6),
    WFC.Tile(4, 1, 1, 4, 7),
    WFC.Tile(3, 4, 1, 1, 8),
    WFC.Tile(1, 3, 3, 1, 9),
    WFC.Tile(1, 1, 4, 3, 10),
    WFC.Tile(2, 2, 3, 4, 11),
    WFC.Tile(3, 2, 2, 3, 12),
    WFC.Tile(1, 1, 1, 1, 13),
    WFC.Tile(2, 2, 2, 2, 14),
]

image = WFC.wave_function_collapse(Set(tiles),(16,16))

image_map = Dict(map(x -> (x.tile_ID, FileIO.load(string(@__DIR__,"/tiles/", x.tile_ID, ".png"))), tiles))

image_data = WFC.create_image(image,image_map)
FileIO.save(string(@__DIR__,"/example",".png"),image_data)
