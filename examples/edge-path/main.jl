include("../../src/main.jl")
using Pkg
using Images
using FileIO
tiles = [
    WFC.Tile(0, 0, 0, 0, 0),
    WFC.Tile(1, 0, 0, 0, 1),
    WFC.Tile(0, 1, 0, 0, 2),
    WFC.Tile(1, 1, 0, 0, 3),
    WFC.Tile(0, 0, 1, 0, 4),
    WFC.Tile(1, 0, 1, 0, 5), 
    WFC.Tile(0, 1, 1, 0, 6),
    WFC.Tile(1, 1, 1, 0, 7),
    WFC.Tile(0, 0, 0, 1, 8),
    WFC.Tile(1, 0, 0, 1, 9),
    WFC.Tile(0, 1, 0, 1, 10),
    WFC.Tile(1, 1, 0, 1, 11),
    WFC.Tile(0, 0, 1, 1, 12),
    WFC.Tile(1, 0, 1, 1, 13),
    WFC.Tile(0, 1, 1, 1, 14),
    WFC.Tile(1, 1, 1, 1, 15)
]

image = WFC.wave_function_collapse(Set(tiles),(8,8))

image_map = Dict(map(x -> (x.tile_ID, FileIO.load(string(@__DIR__,"/tiles/", x.tile_ID, ".png"))), tiles))

image_data = WFC.create_image(image,image_map)

FileIO.save(string(@__DIR__,"/test.png"),image_data)