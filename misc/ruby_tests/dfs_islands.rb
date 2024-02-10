X_SIZE = 5.freeze
Y_SIZE = 5.freeze

grid = [
             [1, 1, 0, 0, 0],
             [0, 1, 0, 0, 1],
             [1, 0, 0, 1, 1],
             [0, 0, 0, 0, 0],
             [1, 0, 1, 0, 1]
            ]


def dfs(grid, i, j)
  return if i < 0 or i >= X_SIZE or j < 0 or j >= Y_SIZE or grid[i][j] == 0
    
  grid[i][j] = 0
  
  dfs(grid, i-1, j)
  dfs(grid, i+1, j)
  dfs(grid, i, j-1)
  dfs(grid, i, j+1)
end

def num_of_islands(grid)
  island_count = 0
  
  (0..X_SIZE-1).each do |i|
    (0..Y_SIZE-1).each do |j|
      next if grid[i][j] != 1
      island_count += 1
      dfs(grid, i, j)
    end
  end
  
  island_count
end

p num_of_islands(grid)

