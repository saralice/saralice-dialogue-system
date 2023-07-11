# Signals

Some commands emit a signal when parsed. This is the list:

-   `SDS.background_parsed(params: Dictionary)` - emitted when a background command is parsed ([@bg](https://github.com/saralice/saralice-dialogue-system/blob/main/docs/commands.md#bg)).
-   `SDS.bgm_parsed(params: Dictionary)` - emitted when a bgm command is parsed ([@bgm](https://github.com/saralice/saralice-dialogue-system/blob/main/docs/commands.md#bgm)).
-   `SDS.character_parsed(params: Dictionary)` - emitted when a character command is parsed ([@char](https://github.com/saralice/saralice-dialogue-system/blob/main/docs/commands.md#char)).
-   `SDS.choices_parsed(params: Dictionary)` - emitted when a choice command is parsed ([@choice](https://github.com/saralice/saralice-dialogue-system/blob/main/docs/commands.md#choice)).
-   `SDS.dialogue_parsed(params: Dictionary)` - emitted when a [dialogue](https://github.com/saralice/saralice-dialogue-system/blob/main/docs/commands.md#dialogue) is parsed.
-   `SDS.dialogue_hide_parsed(params: Dictionary)` - emitted when a dialogue hide command is parsed ([@dialogue_hide](https://github.com/saralice/saralice-dialogue-system/blob/main/docs/commands.md#dialogue_hide)).
-   `SDS.effect_parsed(params: Dictionary)` - emitted when an effect command is parsed ([@effect](https://github.com/saralice/saralice-dialogue-system/blob/main/docs/commands.md#effect)).
-   `SDS.end_parsed(params: Dictionary)` - emitted when an end command is parsed ([@end](https://github.com/saralice/saralice-dialogue-system/blob/main/docs/commands.md#end)).
-   `SDS.image_parsed(params: Dictionary)` - emitted when an image command is parsed ([@img](https://github.com/saralice/saralice-dialogue-system/blob/main/docs/commands.md#img)).
-   `SDS.name_parsed(params: Dictionary)` - emitted when a name command is parsed ([@name](https://github.com/saralice/saralice-dialogue-system/blob/main/docs/commands.md#name)).
-   `SDS.sfx_parsed(params: Dictionary)` - emitted when an sfx command is parsed ([@sfx](https://github.com/saralice/saralice-dialogue-system/blob/main/docs/commands.md#sfx)).

There are some signals that you can emit. This is the list:
-   `SDS.start_invoked(script_path: String, label: String)` - use this to start a dialogue.
-   `SDS.next_command_invoked()` - use this to process the next command.
-   `SDS.jump_parsed(params: Dictionary)` - use this to jump to an specific label. It can be used when the player selects a choice ([@jump](https://github.com/saralice/saralice-dialogue-system/blob/main/docs/commands.md#jump)).
