
# Commands

## `@bg`

Shows/hide a background.

|Parameter | Required | Type | Value |
|--|--|--|--|
|id| Yes| String| Id for the background, or **HIDE** if you want to hide the background|
|effect|No| String |Name of the effect|


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
|effect|No|String|Effect name to apply to the character
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

Show choices. You can use multiple choices (one per line). When you select a choice, it will jump to the corresponding label.

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
|name| Yes| String| Name of the function to execute|
|arg1...arg8|No| String | Up to 8 arguments to use in the function, each one separated by a space.|


### Syntax

	@function_async name [arg1 arg2 ... arg8]

### Command examples

Execute a function name **hello_async** with one argument with value **player**

	@function_async hello_async player


### Signal emitted example

	SDS.function_async_parsed({"function":"hello", "args":["Saralice"]})

## `@function_sync`

Executes a synchronous function. It waits until it finishes.

|Parameter | Required | Type | Value |
|--|--|--|--|
|name| Yes| String| Name of the function to execute|
|arg1...arg8|No| String | Up to 8 arguments to use in the function, each one separated by a space.|


### Syntax

	@function_sync name [arg1 arg2 ... arg8]

### Command examples

Execute a function name **hello_sync** with one argument with value **player**

	@function_sync hello_sync player


### Signal emitted example

	SDS.function_sync_parsed({"function":"hello", "args":["Saralice"]})


