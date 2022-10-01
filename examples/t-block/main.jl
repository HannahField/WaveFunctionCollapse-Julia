include("../../src/main.jl")
using Pkg
using Images
using FileIO
tiles = [
    WFC.Tile(0, 0, 0, 0, 1),
    WFC.Tile(1, 0, 1, 1, 2),
    WFC.Tile(1, 1, 0, 1, 3),
    WFC.Tile(1, 1, 1, 0, 4),
    WFC.Tile(0, 1, 1, 1, 5), 
]

image = WFC.wave_function_collapse(Set(tiles),(8,8))

image_map = Dict(map(x -> (x.tile_ID, FileIO.load(string(@__DIR__,"/tiles/Tile", x.tile_ID, ".png"))), tiles))

image_data = WFC.create_image(image,image_map)

FileIO.save(string(@__DIR__,"/example.png"),image_data)