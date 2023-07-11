
# Implementation

This plugin will add an autoload called SDS (Saralice Dialogue System).

For the dialogues, you will write files with an specific syntax:
`@command` for commands.
`#comment` (you can use comments, they will be ignored when parsing).
You can also use blank lines. They will be ignored.

After you have a dialogue file, you can initiate it in your code emmiting the following signal: `SDS.start_invoked.emit(path_to_file, label)`, where **path_to_file** refers to the dialogue file, and **label** is the label name where the script will start.

The dialogue system will parse the commands and execute them in order. Some of them will be handled automatically, and for others it will emit a signal. You must listen that signal, do something, and notify the dialogue system to execute the next command with `SDS.next_command_invoked.emit()`

For simplicity, most of the dialogue system use "ids". For example **@bg city**, or **@sfx beep**. You will need to have a catalog with those ids and their related resource path. For example:

	var images:Dictionary = {
		"city": "res://img/pictures/city.png"
	}

[Commands](https://github.com/saralice/saralice-dialogue-system/blob/main/docs/commands.md)

[Signals](https://github.com/saralice/saralice-dialogue-system/blob/main/docs/signals.md)


## Demo

Online demo

Sample dialogue

Demo code
