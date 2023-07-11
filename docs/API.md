
# API

## `SDS`

### Signals

-   `[background_parsed(params: Dictionary)](https://github.com/saralice/saralice-dialogue-system/main/blob/docs/signals.md#background_parsed)` - emitted when a background tag is parsed (@bg).
-   `bgm_parsed(params: Dictionary)` - emitted when a bgm tag is parsed (@bgm).
-   `character_parsed(params: Dictionary)` - emitted when a character tag is parsed (@char).
-   `choices_parsed(params: Dictionary)` - emitted when a choice tag is parsed (@choice).
-   `dialogue_parsed(params: Dictionary)` - emitted when a dialogue is parsed.
-   `dialogue_hide_parsed(params: Dictionary)` - emitted when a dialogue hide tag is parsed (@dialogue_hide).
-   `effect_parsed(params: Dictionary)` - emitted when an effect tag is parsed (@effect).
-   `end_parsed(params: Dictionary)` - emitted when an end tag is parsed (@end).
-   `function_async_parsed(params: Dictionary)` - emitted when a function_async tag is parsed (@function_async).
-   `function_sync_parsed(params: Dictionary)` - emitted when a function_sync tag is parsed (@function_sync).
-   `image_parsed(params: Dictionary)` - emitted when an image tag is parsed (@img).
-   `jump_parsed(params: Dictionary)` - emitted when an jump tag is parsed (@jump).
-   `name_parsed(params: Dictionary)` - emitted when an name tag is parsed (@name).
-   `next_command_invoked()` - use this to process the next command.
-   `sfx_parsed(params: Dictionary)` - emitted when an sfx tag is parsed (@sfx).
-   `start_invoked(script_path: String, label: String)` - use this to start a dialogue.

