# Commands

## `@bg`

Shows/hide a background.

|Parameter | Required | Type | Value |
|--|--|--|--|
|id| Yes| String| Id for the background, or **HIDE** if you want to hide the background|
|effect|No| String |Name of the effect. Default: null|


### Syntax

	@bg id|HIDE [effect:effect_name]

### Command examples

Show a background with id "city".

	@bg city

Show a background with id "park", and use an effect named "gray".

	@bg park effect:gray

Hide background.

	@bg HIDE


### Signal emitted example

	SDS.background_parsed({"id": "city", "effect": "gray"})

## `@bgm`

Plays/stop background music.

|Parameter | Required | Type | Value |
|--|--|--|--|
|id| Yes| String | Id for the background music, or **STOP** if you want to stop the background music


### Syntax

	@bgm id|STOP

### Command examples

Play a background music with id "city".

	@bgm city

Stop the background music

	@bgm STOP


### Signal emitted example

	SDS.bgm_parsed({"id": "city"})

## `@char`

Shows/hides a character. Use **id.expression** for a character and its expression , or **HIDE** to hide it. Use **position** for the character position. You can use **effect** also. The wait parameter is used to wait until the effect animation is completed.

If you want to use an effect, use effect:name ([color=green]effect:fade_in[/color]). The wait parameter is used to wait until effect animation is completed, or ignore it ([color=green]wait:true[/color]).

|Parameter | Required | Type | Value |
|--|--|--|--|
|id.expression| Yes| String | Id and an expression for a character (saralice.smile) or **HIDE** to hide a character
|position|Yes|String | Position of the character (left/center/right).Default: left.
|effect|No|String|Effect name to apply to the character. Default: null
|wait|No|Bool|Skip / Wait until effect animation is completed. Default: true


### Syntax

	@char id.expression|HIDE [position:position_name] [effect:effect_name] [wait:true]

### Command examples

Show character **saralice** with expression **smug** at position **left**

	@char saralice.smug position:left

Show character with id **saralice** and expression **smile** at position **right** with effect **fade_in** and wait until the effect animation is finished.

	@char saralice.smile position:right effect:fade_in wait:true

Hide character at position **left**

	@char HIDE position:left

### Signal emitted example

	SDS.char_parsed({"id": "saralice", "expression": "smile", "position":"left", "effect":"fade_in", "wait": true})

## `@choice`

Show choices. You can use multiple choices (one per line). When you select a choice, you can jump to the corresponding label.

|Parameter | Required | Type | Value |
|--|--|--|--|
|text| Yes| String | Choice text
|jump|Yes|String | Label to jump to when the choice is selected


### Syntax

	@choice text jump:label_name

### Command examples

Show 2 choices: "First choice" and "Second choice". If the first one is selected, jump to label_A. If the second is selected, jump to label_B.

	@choice First choice jump:label_A
	@choice Second choice jump:label_B


### Signal emitted example

	SDS.choice_parsed({"choices": [{"choice": "A", "jump": "labelA"}, {"choice": "B", "jump": "labelB"}...]})

## `dialogue`

Shows dialogue. For writing dialogue, you don't need a command, you just type it. If a line is not a command or comment, is assumed to be a dialogue.

### Syntax

	text

### Command examples

Show text

	This is a text
	This is also a text

### Signal emitted example

	SDS.dialogue_parsed({"text": "Hello world", "autofetch": false})

The autofetch in the signal is true if the next command is a choice, false otherwise. You can use this flag to show the choices automatically when the dialogue ends.


## `@dialogue_hide`

Hides the dialogue window.

### Syntax

	@dialogue_hide

### Command examples

Hide the dialogue window

	@dialogue_hide

### Signal emitted example

	SDS.dialogue_hide_parsed()

## `@effect`

Applies an effect. Wait is used to wait for the animation finished signal.

|Parameter | Required | Type | Value |
|--|--|--|--|
|id| Yes| String| Id for the effect|
|wait|No| Bool |Skip/Wait for animation to finish. Default: true|


### Syntax

	@effect id [wait:true]

### Command examples

Show the effect **fade_out**.Don't wait  for the animation to finish.

	@effect fade_out wait:false

Show the effect **fade_in**

	@effect fade_in

### Signal emitted example

	SDS.effect_parsed({"id":"fade_in", "wait":true})

## `@end`

Indicates that the script has finished its execution.

### Syntax

	@end

### Command examples

End the script

	@end


### Signal emitted example

	SDS.end_parsed()

## `@function_async`

Executes an asynchronous function (It doesn't wait for the function to complete).

|Parameter | Required | Type | Value |
|--|--|--|--|
|autoload.name| Yes| String| Autoload and name of the function to execute|
|arg1...arg8|No| String | Up to 8 arguments to use in the function, each one separated by a space.|


### Syntax

	@function_async autoload_name.function_name [arg1 arg2 ... arg8]

### Command examples

Execute a function name **hello_async** in autoload **Test** with one argument with value **player**

	@function_async Test.hello_async player


### Signal emitted example

	No signal emitted. It will be handled automatically.

## `@function_sync`

Executes a synchronous function. It waits until it finishes.

|Parameter | Required | Type | Value |
|--|--|--|--|
|name| Yes| String| Name of the function to execute|
|arg1...arg8|No| String | Up to 8 arguments to use in the function, each one separated by a space.|


### Syntax

	@function_sync autoload_name.function_name [arg1 arg2 ... arg8]

### Command examples

Execute a function name **hello_sync** in autoload **Test** with one argument with value **player**

	@function_sync Test.hello_sync player


### Signal emitted example

	No signal emitted. It will be handled automatically.

## `@if,@else,@endif`

These commands don't emit a signal. A condition is evaluated, and depending on the result, executes the "if" or the "else" block. If you want nested conditions, put another if block inside the else.The variables must exist in an autoload to detect them.

### Syntax

	@if left_operand operator right_operand
		code
	[@else
			code]
	@endif

### Command examples

If we have an autoload called **State** with 2 bool values, **a=true**, **b=false**, and we have the following code:

	  @if State.a == true
		  A is true
		  @if State.b == true
				B is true
		  @else
				B is false
		  @endif
	  @else
		  A is false
	  @endif

Then the dialogue will be "A is true, B is false".

### Signal emitted example

	No signal emitted. It will be handled automatically.

## `@img`

Shows/hide an image.

|Parameter | Required | Type | Value |
|--|--|--|--|
|id| Yes| String| Id for the image, or HIDE to hide it|
|effect|No| String | Effect name for the image. Default: null|


### Syntax

	@img id|HIDE [effect:name]

### Command examples

Show the image with id **rubber_duck** with effect **gray**.

	@img rubber_duck effect:gray

Hide the image

	@img HIDE

### Signal emitted example

	SDS.img_parsed({"id":"rubber_duck", "effect": null})

## `@jump`

"Jumps" to the specified label, ignoring other commands.

|Parameter | Required | Type | Value |
|--|--|--|--|
|name| Yes| String| Label name|


### Syntax

	@jump label_name

### Command examples

Jump to a label named menu_6

	@jump menu_6

### Signal emitted example

	No signal emitted. You can emit a signal when you want to jump to an specific label.



## `@label`

It defines a section. You can use it to start the dialogue in a specific point, or to jump to an specific label.

|Parameter | Required | Type | Value |
|--|--|--|--|
|name| Yes| String| Label name|


### Syntax

	@label name

### Command examples

Define a section named **start**

	@label start

### Signal emitted example

	No signal emitted. It will be handled automatically.

## `@name`

Sets the character name.

|Parameter | Required | Type | Value |
|--|--|--|--|
|name| Yes| String| Character name|

### Syntax

	@name name

### Command examples

Set the character name to **Jenny**

	@name Jenny

### Signal emitted example

	SDS.name_parsed({"name":"Saralice"})


## `@set`

Sets a value to a variable. The variable must exist in the autoload.

|Parameter | Required | Type | Value |
|--|--|--|--|
|variable| Yes| String| Autoload variable to set value to|
|operator| Yes| String| Operator to use, like =, +=, -=|
|value| Yes| String| Value to use|


### Syntax

	@set variable operator value

### Command examples

Set variable **a** of autoload **State** to **false**

	@set State.a = false

### Signal emitted example

	No signal emitted. It will be handled automatically.

## `@sfx`

Plays a sound effect.

|Parameter | Required | Type | Value |
|--|--|--|--|
|id| Yes| String | Id for the sound effect|
|wait| No| Bool | Wait for the sound effect to finish. Default: false|


### Syntax

	@sfx id [wait:false]

### Command examples

Play a sound effect with id **cellphone_ring**. **Wait** until it finishes playing.

	@sfx cellphone_ring wait:true

Play a sound effect with id **beep**.

	@sfx STOP


### Signal emitted example

	SDS.sfx_parsed({"id": "name", "wait": false})

## `@signal`

Searches if an autoload has a signal with the specified name, and if found, it emits the signal.

|Parameter | Required | Type | Value |
|--|--|--|--|
|name| Yes| String | Signal name|
|arg1...arg8|No| String | Up to 8 arguments to use in the signal, each one separated by a space.|


### Syntax

	@signal name [arg1 arg2 ... arg8]

### Command examples

Emit a signal named **sds_test** with an argument **hello**.

	@signal sds_test hello

## `@wait`

It pauses execution for the specified amount of seconds.

|Parameter | Required | Type | Value |
|--|--|--|--|
|seconds| Yes| Float| Number of seconds to wait|


### Syntax

	@wait seconds

### Command examples

Pause execution for 3 seconds.

	@wait 3.0

### Signal emitted example

	No signal emitted. It will be handled automatically.
