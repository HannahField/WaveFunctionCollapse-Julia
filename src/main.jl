struct Tile
    northSocketID::UInt8
    eastSocketID::UInt8
    southSocketID::UInt8
    westSocketID::UInt8
    tileID::UInt8
end

mutable struct Cell
    currentTiles::Vector{Tile}
    northCompatible::Vector{Tile}
    eastCompatible::Vector{Tile}
    southCompatible::Vector{Tile}
    westCompatible::Vector{Tile}
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

struct TileCompatibility
    tile::Tile
    northNeighbors::Vector{Tile}
    eastNeighbors::Vector{Tile}
    southNeighbors::Vector{Tile}
    westNeighbors::Vector{Tile}
end

function findCompatibility(tile, tiles)
    northCompatibility = filter(x -> x.southSocketID == tile.northSocketID, tiles)
    eastCompatibility = filter(x -> x.westSocketID == tile.eastSocketID, tiles)
    southCompatibility = filter(x -> x.northSocketID == tile.southSocketID, tiles)
    westCompatibility = filter(x -> x.eastSocketID == tile.westSocketID, tiles)
    return TileCompatibility(tile, northCompatibility, eastCompatibility, southCompatibility, westCompatibility)
end

tileCompatibility = Dict(map(x -> (x, findCompatibility(x, tiles)), tiles))


gridSize = (4, 4)

baseCell() = Cell(tiles, tiles, tiles, tiles, tiles, false)

grid = Grid(map(_ -> baseCell(), ones(gridSize)))

function propagate!(grid, index)
    neighborsIndeces = findNeighborsIndex(index,size(grid.cells))
    nonCollapsedNeighbors = filter(x -> !grid.cells[x...].collapsed, neighborsIndeces)

end

function collapse!(grid)
    index = findLeastEntropy(grid)

    leastEntropyCell = grid.cells[index]

    possibleOutcomes = leastEntropyCell.currentTiles
    outcome = rand(possibleOutcomes)
    grid.cells[index].currentTiles = [outcome]
    propagate!(grid, index)
end

function findLeastEntropy(grid)
    _, index = findmin(map(x -> length(x.currentTiles)+(!x.collapsed ? 0 : 10),grid.cells))
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
collapse!(grid)