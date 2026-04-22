# OpenCode Planning Hooks

Attention hooks for Prometheus/Sisyphus plans that keep your active plan visible throughout the session.

## What It Does

These hooks inject active plan context during execution without polluting your context window:

- **UserPromptSubmit**: Shows active plan and task progress on each user message
- **PreToolUse**: Displays plan context before editing/writing tools
- **PostToolUse**: Reminds to update task status after writes
- **Stop**: Verifies completion before session ends

## Installation

### Global Installation (all OpenCode projects)

```bash
mkdir -p ~/.config/opencode/skills && cd ~/.config/opencode/skills && git clone https://github.com/ProDrifterDK/opencode-planning-hooks.git
```

### Project Installation (single project)

```bash
mkdir -p .opencode/skills && cd .opencode/skills && git clone https://github.com/ProDrifterDK/opencode-planning-hooks.git
```

## How It Works

The hooks automatically find the most recently modified plan in `.sisyphus/plans/*.md`. If no plan exists, hooks produce no output (silent skip).

### Hook Details

| Hook | Trigger | Output |
|------|---------|--------|
| UserPromptSubmit | Every user message | `Active plan: {name} \| Tasks: {done}/{total}` |
| PreToolUse | Write, Edit, Bash, Read, Glob, Grep | First 5 lines of active plan |
| PostToolUse | Write, Edit | Reminder to update task status |
| Stop | Session end | Runs completion check script |

## Requirements

- OpenCode
- Prometheus/Sisyphus planning system with `.sisyphus/plans/` directory

## License

MIT License

## Acknowledgments

Based on [planning-with-files](https://github.com/OthmanAdi/planning-with-files) by [@OthmanAdi](https://github.com/OthmanAdi).