extends Node
## Saralice Dialogue System
##
## A basic dialogue system using signals.

signal background_parsed(params)
signal bgm_parsed(params)
signal character_parsed(params)
signal choices_parsed(params)
signal dialogue_parsed(params)
signal dialogue_hide_parsed()
signal effect_parsed(params)
signal end_parsed()
signal image_parsed(params)
signal jump_parsed(params)
signal name_parsed(params)
signal next_command_invoked()
signal sfx_parsed(params)
signal start_invoked(script_path, label)

var parsed_commands:Array = [] #list of parsed commands
var jumps:Dictionary = {} #dictionary of kumps indexes
var command_index = 0 #current command index
var conditions_relationships:Array = [] #determines if/else/endif indexes
var states: Dictionary = {} #used to store autoloads

func _ready():
	start_invoked.connect(_on_start_invoked)
	next_command_invoked.connect(_on_next_command_invoked)
	jump_parsed.connect(_on_jump_parsed)

	# add autoloads
	var autoloads: Dictionary = {}
	for child in get_tree().root.get_children():
		if child.name == StringName("SDS"):
			continue

		if get_tree().current_scene and child.name == get_tree().current_scene.name:
			continue

		states[child.name] = child


#parse dialogue script
func parse_dialogue_script(script: String) -> Array:
	var lines = script.split("\n")
	var commands = []

	for line in lines:
		line = line.strip_edges()

		if line.is_empty():
			continue

		if line.begins_with("@"): #command
			commands.append(line)
			#if line is label, store it for jumps
			if line.begins_with("@label"):
				var command = command_parser(line)
				jumps[command.payload] = commands.size() - 1
		elif line.begins_with("#"): #comment, ignore
			pass
		else: # Assume it's a dialogue line
			commands.append("@dialogue " + line)

	return commands


#dialogue system start
func dialogue_system_start():
	execute_command(command_index)


#evaluate expression, like State.a == true
func evaluate_expression(expression) -> bool:
	var chunks = expression.split(" ")
	var left_operand = chunks[0].strip_edges()
	var operator = chunks[1].strip_edges()
	var right_operand = chunks[2].strip_edges()

	#get operand values
	left_operand = get_operand_value(left_operand)
	right_operand = get_operand_value(right_operand)

	match operator:
		"==":
			return left_operand == right_operand
		"!=":
			return left_operand != right_operand
		">":
			return left_operand > right_operand
		"<":
			return left_operand < right_operand
		">=":
			return left_operand >= right_operand
		"<=":
			return left_operand <= right_operand

	assert(false, "Cant evaluate expression " + expression)
	return false

#runs command at index position
func execute_command(index: int):
	var command = command_parser(parsed_commands[index])
	var params:Dictionary = {}

	#DEBUG
	#print(parsed_commands[index])

	match command.name:
		"@bg":
			var chunks = command.payload.split(" ")

			params = {
				"id": chunks[0],
				"effect": null
			}

			if chunks.size() > 1:
				for i in range(1, chunks.size()):
					var arg_chunks = chunks[i].split(":")
					params[arg_chunks[0]] = get_operand_value(arg_chunks[1])

			background_parsed.emit(params)
		"@bgm":
			params.id = command.payload
			bgm_parsed.emit(params)
		"@char":
			var chunks = command.payload.split(" ")
			var character_chunks = chunks[0].split(".")
			var character_id = character_chunks[0]
			var character_expression = null

			if character_chunks.size() == 2:
				character_expression = character_chunks[1]

			params = {
				"id": character_id,
				"expression": character_expression,
				"position": "left",
				"effect": null,
				"wait": true
			}

			if chunks.size() > 1:
				for i in range(1, chunks.size()):
					var arg_chunks = chunks[i].split(":")
					params[arg_chunks[0]] = get_operand_value(arg_chunks[1])

			character_parsed.emit(params)
		"@choice":
			#fetch all related choices
			var fetch:bool = true
			params = {
				"choices": []
			}

			var choice = choice_parser(command.payload)
			params.choices.append(choice)

			while fetch:
				var next_command = command_parser(parsed_commands[command_index + 1])
				if next_command.name == "@choice":
					command_index += 1
					command = command_parser(parsed_commands[command_index])

					choice = choice_parser(command.payload)
					params.choices.append(choice)
				else:
					fetch = false

			choices_parsed.emit(params)
		"@dialogue":
			params = {
				"text" : command.payload,
				"autofetch": false
			}

			if not is_last_command():
				var next_command = command_parser(parsed_commands[command_index + 1])
				if next_command.name == "@choice":
					params.autofetch = true

			dialogue_parsed.emit(params)
		"@dialogue_hide":
			dialogue_hide_parsed.emit()
		"@effect":
			var chunks = command.payload.split(" ")

			params = {
				"id": chunks[0],
				"wait": true
			}

			if chunks.size() > 1:
				for i in range(1, chunks.size()):
					var arg_chunks = chunks[i].split(":")
					params[arg_chunks[0]] = get_operand_value(arg_chunks[1])

			effect_parsed.emit(params)
		"@else":
			var condition_relationship = conditions_relationships[conditions_relationships.size() - 1]

			if not condition_relationship["result"]:
				get_next_command()
			else:
				command_index = condition_relationship["endif"] - 1
				get_next_command()
		"@end":
			end_parsed.emit()
		"@endif":
			conditions_relationships.pop_back()
			get_next_command()
		"@function_sync", "@function_async":
			if command.name == "@function_sync":
				await function_parser(command.payload, true)
			else:
				function_parser(command.payload, false)

			get_next_command()
		"@if":
			detect_condition_relationship(command_index)

			var condition_relationship = conditions_relationships[conditions_relationships.size() - 1]

			if condition_relationship.result:
				get_next_command()
			else:
				if condition_relationship["else"] != null:
					command_index = condition_relationship["else"] - 1
				else:
					command_index = condition_relationship["endif"] - 1
				get_next_command()
		"@img":
			var chunks = command.payload.split(" ")

			params = {
				"id": chunks[0],
				"effect": null
			}

			if chunks.size() > 1:
				for i in range(1, chunks.size()):
					var arg_chunks = chunks[i].split(":")
					params[arg_chunks[0]] = get_operand_value(arg_chunks[1])

			image_parsed.emit(params)
		"@jump":
			jump_parser(command.payload)
			get_next_command()
		"@label":
			get_next_command()
		"@name":
			params.name = command.payload
			name_parsed.emit(params)
		"@set":
			set_parser(command.payload)
			get_next_command()
		"@sfx":
			var chunks = command.payload.split(" ")

			params = {
				"id": chunks[0],
				"wait": false
			}

			if chunks.size() > 1:
				for i in range(1, chunks.size()):
					var arg_chunks = chunks[i].split(":")
					params[arg_chunks[0]] = get_operand_value(arg_chunks[1])

			sfx_parsed.emit(params)
		"@signal":
			signal_parser(command.payload)
			get_next_command()
		"@wait":
			var wait_time = command.payload.to_float()
			await get_tree().create_timer(wait_time).timeout
			get_next_command()


#check if current command_index is last or not
func is_last_command():
	if command_index == parsed_commands.size() - 1:
		return true

	return false


#get next command if available
func get_next_command():
	if not is_last_command():
		command_index += 1
		execute_command(command_index)


#determines what is the value of an operand
func get_operand_value(operand):
	var result = null

	#check if is boolean
	if operand == "true":
		return true

	if operand == "false":
		return false

	#check if is number
	if operand.is_valid_int():
		return int(operand)

	if operand.is_valid_float():
		return float(operand)

	#check if is string
	if not operand.contains("."):
		return operand

	#is variable
	assert("." in operand, "Cant parse operand value " + operand)

	var blocks = operand.split(".")
	return states[blocks[0]][blocks[1]]


#jumps to an specified positin, and executes command
func jump_to(label:String):
	jump_parser(label)
	execute_command(command_index)


#detects the if/else/endif relationship, and the condition result
func detect_condition_relationship(index:int):
	var relationship:Dictionary = {
		"if": index,
		"else": null,
		"endif": null,
		"result": false
	}

	#evaluate condition
	var command = command_parser(parsed_commands[index])
	var condition = if_parser(command.payload)
	relationship["result"] = condition.result

	#get if/else/endif relationship for current level
	var fetch:bool = true
	var nested_level:int = 0
	var comparison_level:int = 0

	while fetch:
		assert(index < parsed_commands.size() - 1, "Reached end of commands. check @if, @else, @endif tags")

		index += 1
		var next_command = command_parser(parsed_commands[index])
		if next_command.name == "@if":
			nested_level += 1
		elif next_command.name == "@else":
			if comparison_level == nested_level:
				relationship["else"] = index
		elif next_command.name == "@endif":
			if comparison_level == nested_level:
				relationship["endif"] = index
				fetch = false
			else:
				nested_level -= 1

	conditions_relationships.append(relationship)


#parsers
func choice_parser(payload: String):
	var last_space_index = payload.rfind(" ")
	var jump_param = payload.substr(last_space_index)
	var jump_chunks = jump_param.split(":")

	var params = {}
	params.choice = payload.substr(0, last_space_index).strip_edges()
	params.jump = jump_chunks[1]

	return params


func command_parser(command:String):
	var first_space_index = command.find(" ")
	var command_name = command.substr(0, first_space_index)
	var payload = command.substr(first_space_index + 1).strip_edges()

	var response = {
		"name": command_name,
		"payload": payload
	}

	return response


func function_parser(payload:String, wait:bool):
	var chunks = payload.split(" ")

	assert("." in chunks[0], "Function must have the syntax Autoload.function")
	assert(chunks.size() >= 1, "Invalid payload " + payload)

	var function_chunks = chunks[0].split(".")
	var state = function_chunks[0]
	var function_name = function_chunks[1]
	chunks.remove_at(0)
	var args = chunks

	assert(args.size() <= 8, "Function limited to 8 parameters: " + payload)

	assert(state in states, "Autoload not found " + state)

	assert(states[state].has_method(function_name), "Function not found in autoload " + function_name)

	if args.size() == 0:
		if wait:
			await states[state].call(function_name)
		else:
			states[state].call(function_name)
	else:
		if wait:
			await states[state].callv(function_name, args)
		else:
			states[state].callv(function_name, args)


func if_parser(payload: String):
	var params = {}
	params.result = evaluate_expression(payload)

	return params


func jump_parser(payload: String):
	var label = payload
	command_index = jumps[label]


func set_parser(payload:String):
	var chunks = payload.split(" ")

	assert(chunks.size() == 3, "Invalid set payload: " + payload)

	var left_operand = chunks[0].strip_edges()
	var operator = chunks[1].strip_edges()
	var right_operand = chunks[2].strip_edges()

	var left_operand_chunks = left_operand.split(".")

	assert(left_operand_chunks.size() == 2, "Invalid left operand: " + left_operand)
	assert(left_operand_chunks[0] in states, "Autoload name not found in states: " + left_operand_chunks[0])
	assert(left_operand_chunks[1] in states[left_operand_chunks[0]], "Variable not found: " + left_operand_chunks[0] + "." + left_operand_chunks[1])

	match operator:
		"=":
			states[left_operand_chunks[0]][left_operand_chunks[1]] = get_operand_value(right_operand)
		"+=":
			states[left_operand_chunks[0]][left_operand_chunks[1]] += get_operand_value(right_operand)
		"-=":
			states[left_operand_chunks[0]][left_operand_chunks[1]] -= get_operand_value(right_operand)

func signal_parser(payload:String):
	var chunks = payload.split(" ")
	var signal_name = chunks[0]
	chunks.remove_at(0)
	var args = chunks

	assert(args.size() <= 8, "Signal limited to 8 parameters: " + payload)

	for state in states.keys():
		if states[state].has_signal(signal_name):
			match args.size():
				0:
					states[state].emit_signal(signal_name)
				1:
					states[state].emit_signal(signal_name, args[0])
				2:
					states[state].emit_signal(signal_name, args[0], args[1])
				3:
					states[state].emit_signal(signal_name, args[0], args[1], args[2])
				4:
					states[state].emit_signal(signal_name, args[0], args[1], args[2], args[3])
				5:
					states[state].emit_signal(signal_name, args[0], args[1], args[2], args[3], args[4])
				6:
					states[state].emit_signal(signal_name, args[0], args[1], args[2], args[3], args[4], args[5])
				7:
					states[state].emit_signal(signal_name, args[0], args[1], args[2], args[3], args[4], args[5], args[6])
				8:
					states[state].emit_signal(signal_name, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7])


#listeners
func _on_start_invoked(script_path, label):
	assert(FileAccess.file_exists(script_path), "Script " + script_path + " not found")

	var file = FileAccess.open(script_path, FileAccess.READ)
	var script_text = file.get_as_text()
	parsed_commands = parse_dialogue_script(script_text)

	command_index = jumps[label]

	if command_index >= 0:
		dialogue_system_start()


func _on_next_command_invoked():
	get_next_command()


func _on_jump_parsed(label:String):
	jump_to(label)
