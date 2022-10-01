using Pkg
Pkg.activate(".")
using Match
using Images
using FileIO

struct Tile
    northSocketID::UInt8
    eastSocketID::UInt8
    southSocketID::UInt8
    westSocketID::UInt8
    tileID::UInt8
end

mutable struct Cell
    currentTiles::Set{Tile}
    northCompatible::Set{Tile}
    eastCompatible::Set{Tile}
    southCompatible::Set{Tile}
    westCompatible::Set{Tile}
    collapsed::Bool
end

struct Grid
    cells::Matrix{Cell}
end


tiles = [
    Tile(1, 0, 1, 1, 1),
    Tile(1, 1, 0, 1, 2),
    Tile(1, 1, 1, 0, 3),
    Tile(0, 1, 1, 1, 4),
    Tile(0, 0, 0, 0, 5)
]

tile_set = Set(tiles)

struct TileCompatibility
    tile::Tile
    northNeighbors::Set{Tile}
    eastNeighbors::Set{Tile}
    southNeighbors::Set{Tile}
    westNeighbors::Set{Tile}
end

function findCompatibility(tile, tiles)
    northCompatibility = Set(filter(x -> x.southSocketID == tile.northSocketID, tiles))
    eastCompatibility = Set(filter(x -> x.westSocketID == tile.eastSocketID, tiles))
    southCompatibility = Set(filter(x -> x.northSocketID == tile.southSocketID, tiles))
    westCompatibility = Set(filter(x -> x.eastSocketID == tile.westSocketID, tiles))
    return TileCompatibility(tile, northCompatibility, eastCompatibility, southCompatibility, westCompatibility)
end

tileCompatibility = Dict(map(x -> (x, findCompatibility(x, tiles)), tiles))



gridSize = (8, 8)

baseCell() = Cell(tile_set, tile_set, tile_set, tile_set, tile_set, false)

grid = Grid(map(_ -> baseCell(), ones(gridSize)))

function propagate!(grid, index)
    neighborsIndeces = findNeighborsIndex(index, size(grid.cells))
    nonCollapsedNeighbors = filter(x -> !grid.cells[x...].collapsed, neighborsIndeces)
    currentCell = grid.cells[index...]
    for i in nonCollapsedNeighbors
        dir = index .- i
        directionCompatibility = @match dir begin
            (1,0) => currentCell.northCompatible
            (0,-1) => currentCell.eastCompatible
            (-1,0) => currentCell.southCompatible
            (0,1) => currentCell.westCompatible
        end
        newCurrentTiles = intersect(grid.cells[i...].currentTiles, directionCompatibility)
        if !(newCurrentTiles == grid.cells[i...].currentTiles)
            grid.cells[i...].currentTiles = newCurrentTiles
            unionCompatibilities!(grid,i)
            propagate!(grid,i)
        end
    end
end

function collapse!(grid)
    index = findLeastEntropy(grid)

    leastEntropyCell = grid.cells[index...]

    possibleOutcomes = leastEntropyCell.currentTiles
    outcome = rand(possibleOutcomes)

    grid.cells[index...].currentTiles = Set([outcome])
    grid.cells[index...].collapsed = true
    unionCompatibilities!(grid,index)

    propagate!(grid, index)
end

function unionCompatibilities!(grid,index)
    superpositionOfTileCompatibilities = map(x-> tileCompatibility[x],collect(grid.cells[index...].currentTiles))
    grid.cells[index...].northCompatible = Set(union(map(x -> x.northNeighbors,superpositionOfTileCompatibilities)...))
    grid.cells[index...].eastCompatible = Set(union(map(x -> x.eastNeighbors,superpositionOfTileCompatibilities)...))
    grid.cells[index...].southCompatible = Set(union(map(x -> x.southNeighbors,superpositionOfTileCompatibilities)...))
    grid.cells[index...].westCompatible = Set(union(map(x -> x.westNeighbors,superpositionOfTileCompatibilities)...))
end

function findLeastEntropy(grid)
    _, index = findmin(map(x -> length(x.currentTiles) + (!x.collapsed ? 0 : 10), grid.cells))
    index = Tuple(index)
    return index
end

function findNeighborsIndex(index, size)

    indeces = [
        (index[1] - 1, index[2])
        (index[1], index[2] + 1)
        (index[1] + 1, index[2])
        (index[1], index[2] - 1)
    ]
    filter!(x -> x[1] in 1:size[1] && x[2] in 1:size[2], indeces)
    return indeces
end


while !all(map(x -> x.collapsed, grid.cells))
    collapse!(grid)
end

imageGrid = map(x -> collect(x.currentTiles)[1].tileID,grid.cells)

println(imageGrid)
function createImage(imageGrid,tiles)
    imageMap = Dict(map(x -> (x.tileID,FileIO.load(string("Tile",x.tileID,".png"))), tiles))
    imageSize = size(imageMap[1])

    gridSize = size(imageGrid)

    image = zeros(RGB,gridSize.*imageSize)
    for j in 1:gridSize[2]
        for i in 1:gridSize[1]
            image[((i-1)*imageSize[1]+1):i*imageSize[1],((j-1)*imageSize[2]+1):j*imageSize[2]] = imageMap[imageGrid[i,j]]
        end
    end
    FileIO.save("Test.png",image)
    #image[map(x -> (0:x-1).*imageSize+1,gridSize)] = 
end

createImage(imageGrid,tiles)


