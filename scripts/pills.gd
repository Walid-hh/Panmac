class_name pills extends TileMapLayer
var astar : AStar2D = AStar2D.new()



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	astar_start()

func astar_start() :
	var tilemap_size = self.get_used_rect().size
	astar.reserve_space(tilemap_size.x*tilemap_size.y)
	#the loop traverse the cells in the tilemap and add an Astar point to each cell
	for i in tilemap_size.x:
		for j in tilemap_size.y:
			var idx = get_astar_cell_id(Vector2(i,j))
			astar.add_point(idx , self.map_to_local(Vector2(i,j)))
	#traverse the tilemap while checking if the cells are valid
	#checks if there are any valid neighbor cells
	#connects the neghborcell to the current cell using astar
	for i in tilemap_size.x:
		for j in tilemap_size.y:
			if self.get_cell_tile_data(Vector2(i,j)) != null :
				var idx = get_astar_cell_id(Vector2(i,j))
				for v_neighbor_cell in [Vector2(i,j-1),Vector2(i,j+1),Vector2(i-1,j),Vector2(i+1,j)]:
					var neighbor_cell_idx = get_astar_cell_id(v_neighbor_cell)
					if astar.has_point(neighbor_cell_idx):
						astar.connect_points(idx , neighbor_cell_idx , false)
func get_astar_cell_id(cell:Vector2)->int:
	return int(cell.y+cell.x*self.get_used_rect().size.y)

func get_astar_path(enemy_position : Vector2 , player_position : Vector2) -> Array :
	var enemy_cell = local_to_map(enemy_position)
	var enemy_idx = get_astar_cell_id(enemy_cell)
	var player_cell = local_to_map(player_position)
	var player_idx = get_astar_cell_id(player_cell)
	if astar.has_point(enemy_idx) and astar.has_point(player_idx) :
		return Array(astar.get_point_path(enemy_idx,player_idx))
	return []
