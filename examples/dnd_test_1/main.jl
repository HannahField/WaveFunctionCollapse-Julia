include("../../src/main.jl")
using Pkg
using Images
using FileIO
tiles = [
    WFC.Tile(0, 0, 0, 0, 1),
    WFC.Tile(0, 0, 1, 1, 2),
    WFC.Tile(0, 1, 1, 0, 3),
    WFC.Tile(1, 0, 0, 1, 4),
    WFC.Tile(1, 1, 0, 0, 5),
    WFC.Tile(0, 1, 0, 1, 6),
    WFC.Tile(1, 0, 1, 0, 7),
]

image = WFC.wave_function_collapse(Set(tiles),(16,16))

image_map = Dict(map(x -> (x.tile_ID, FileIO.load(string(@__DIR__,"/tiles/", x.tile_ID, ".png"))), tiles))

image_data = WFC.create_image(image,image_map)

FileIO.save(string(@__DIR__,"/test.png"),image_data)
