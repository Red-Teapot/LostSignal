extends KinematicBody2D

const U = 0
const L = 1
const D = 2
const R = 3

var moveState = {}

var inputMap = {
	KEY_W: U,
	KEY_A: L,
	KEY_S: D,
	KEY_D: R,
}

var walls: TileMap = null

func resetMovements():
	moveState = {
		U: false,
		L: false,
		D: false,
		R: false,
	}

func _enter_tree():
	resetMovements()
	walls = get_parent().get_node("Walls")

func _input(event):
	resetMovements()
	
	if event is InputEventKey:
		if event.scancode in inputMap:
			var dir = inputMap[event.scancode]
			moveState[dir] = true

func _physics_process(delta):
	var mvmt = Vector2(0, 0)
	
	if moveState[U]:
		mvmt.y -= 1
	if moveState[L]:
		mvmt.x -= 1
	if moveState[D]:
		mvmt.y += 1
	if moveState[R]:
		mvmt.x += 1
	
	mvmt = mvmt.normalized() * 300 * delta
	

func _process(delta):
	var tilePos = Vector2(
		floor(position.x / 64),
		floor(position.y / 64)
	)
	
	var cell = walls.get_cellv(tilePos)
	print(cell)
