extends MeshInstance3D


@export var startNode : Node3D
@export var endNode : Node3D
@export var startPointOffset : Vector3 = Vector3.ZERO 

@export var endPointOffset : Vector3 = Vector3.ZERO 

var m_color : Color = Color.GREEN

var m_material : ORMMaterial3D = ORMMaterial3D.new()

func _ready():
	mesh = ImmediateMesh.new()
	m_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	
func _process(delta):
	draw()


func draw():
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, m_material)
	mesh.surface_add_vertex(startNode.global_position + startPointOffset)
	mesh.surface_add_vertex(endNode.global_position + endPointOffset)
	mesh.surface_end()