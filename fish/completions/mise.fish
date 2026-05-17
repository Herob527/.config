# Simple mise completions without usage CLI to avoid environment size issues
# Basic command completions
complete -c mise -f -a "activate deactivate shell" -d "Environment commands"
complete -c mise -f -a "install uninstall use" -d "Tool management"
complete -c mise -f -a "ls list" -d "List tools"
complete -c mise -f -a "current latest" -d "Version info"
complete -c mise -f -a "config settings" -d "Configuration"
complete -c mise -f -a "doctor env exec" -d "Utility commands"
complete -c mise -f -a "cache clean help" -d "Maintenance"
complete -c mise -f -a "plugins prune run" -d "Plugin/task management"
complete -c mise -f -a "upgrade version which" -d "Mise info"

# For 'mise use', suggest common tools
complete -c mise -n "__fish_seen_subcommand_from use" -f -a "node python ruby go rust java dotnet bun deno"
