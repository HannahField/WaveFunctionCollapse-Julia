include("../../src/main.jl")
using Pkg
using Images
using FileIO
tiles = [
    WFC.new_tiles(0, 0, 0, 0, 1, [WFC.nothing_strategy()])...,
    WFC.new_tiles(1, 0, 1, 1, 2, [WFC.fully_rotated_strategies()...])...
]

image = WFC.wave_function_collapse(Set(tiles),(8,8))

image_map = Dict(map(x -> (x.tile_id.id, FileIO.load(string(@__DIR__,"/tiles/Tile", x.tile_id.id, ".png"))), tiles))

image_data = WFC.create_image(image,image_map)

FileIO.save(string(@__DIR__,"/example.png"),image_data)
