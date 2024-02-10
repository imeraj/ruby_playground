X_SIZE = 5
Y_SIZE = 5

grid = [
             [1, 1, 0, 0, 0],
             [1, 1, 0, 0, 1],
             [1, 0, 0, 1, 1],
             [0, 0, 0, 0, 0],
             [1, 0, 1, 0, 1]
           ]


def bfs(grid, i, j) 
  queue = Queue.new
  queue = [[i, j]]

  while cur = queue.shift 
    x = cur[0]
    y = cur[1]
    
    grid[x][y] = 0
      
    if x-1 >= 0 and grid[x-1][y] == 1
      queue.push([x-1, y])      
    end
    
    if x+1 < X_SIZE and grid[x+1][y] == 1
      queue.push([x+1, y])      
    end
    
    if y - 1 >= 0 and grid[x][y-1] == 1
      queue.push([x, y-1])      
    end
    
    if y + 1 < Y_SIZE and grid[x][y+1] == 1
      queue.push([x, y+1])      
    end
  end
end

def num_of_islands(grid)
  island_count = 0
  
  (0..X_SIZE-1).each do |i|
    (0..Y_SIZE-1).each do |j|
      next if grid[i][j] != 1
      island_count += 1
      bfs(grid, i, j)
    end
  end
  
  island_count
end

p num_of_islands(grid)
