extends Control
@onready var h_box_container: HBoxContainer = $Panel/HBoxContainer

var items = [
	{
		"name": "Fly!",
		"desc": "Gain the ability to fly for 20 seconds",
		"on_buy": Callable(Global, "set_fly").bind(true, 20),
		"price": 30,
		"icon": preload("res://assets/Fly.png")
	},
	{
		"name": "Jump Potion",
		"desc": "Jump higher for 30 seconds!",
		"price": 67,
		"on_buy": Callable(Global, "set_norm_jump_boost").bind(true, 30),
		"icon": preload("res://assets/speed_potion.png")
	},
	{
		"name": "Dash (limited)",
		"desc": "Gain the ability to dash for 1 minute",
		"price": 60,
		"on_buy": Callable(Global, "set_dashing").bind(true, 60),
		"icon": preload("res://assets/speed_running_man.png")
	},
	{
		"name": "Dash (permanent)",

		"desc": "Gain the ability to dash forever",
		"price": 100,

		"on_buy": Callable(Global, "set_dashing").bind(true),
		"icon": preload("res://assets/speed_running_man.png")
	},
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in h_box_container.get_children():
		if child is VBoxContainer:
			assign_item_to_slot(child)
	

func assign_item_to_slot(slot: VBoxContainer):
	var item = items.pick_random()
	
	slot.get_node("Title").text = item["name"]
	slot.get_node("Desc").text = item["desc"]
	slot.get_node("Price").text = str(item["price"])
	
	var tex_rect: TextureRect = slot.get_node("TextureRect")
	tex_rect.texture = item["icon"]
	tex_rect.custom_minimum_size = Vector2(128,128)
	tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tex_rect.expand = true
	
	# connect button
	var buy_button = slot.get_node("Button")
	var callable = Callable(self, "_on_buy_pressed").bind(slot, item)
	
	if buy_button.is_connected("pressed", callable):
		buy_button.disconnect("pressed", callable) 
	buy_button.connect("pressed", callable)
	
func _on_buy_pressed(slot: VBoxContainer, item: Dictionary) -> void:
	var seconds = GlobalTime.get_time()
	
	var price = item["price"]
	if seconds >= price:
		GlobalTime.subtract_time(price)
		print("Bought %s" % item["name"])
		
		var anim_player: AnimationPlayer = slot.get_node("AnimationPlayer")
		anim_player.play("fade_out")
		anim_player.animation_finished.connect(_on_slide_finished.bind(slot), CONNECT_ONE_SHOT)
		
		if item.has("on_buy"):
			item["on_buy"].call()
		
	else:
		print("not enough %s" % seconds)
		slot.get_node("Price").text = "Not enough time"
		await get_tree().create_timer(1.0).timeout
		slot.get_node("Price").text = str(price)
		
func _on_slide_finished(anim_name: String, slot: VBoxContainer):
	if anim_name != "fade_out":
		return
	
	assign_item_to_slot(slot)
	
	var anim_player: AnimationPlayer = slot.get_node("AnimationPlayer")
	anim_player.play("fade_in")
