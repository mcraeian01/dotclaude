# CLAUDE.md
This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Environment
- **OS:** Arch Linux on a Mini-PC homelab server
- **Shell:** Bash with Omarchy desktop framework
- **Node.js:** v25.2.1 (managed via mise)
- **Terminals:** Alacritty, Kitty, Ghostty
- **Local IP:** 192.168.1.165

## User Voodostix (Ian)
Ian is a Senior Technical Product Manager in AWS. He is on a learning journey with the goal of becoming an AI Developer. He will mostly use this setup to work on projects that help him learn the fundementals of traditional computer engineering such as containers, coding, tool usage, cloud services, networking and security as well as AI and how AI has changed all these. He wants to know why things are done, not just what to do. 

## Technical Growth & Memory
- I record my personal knowledge as .md in Obsidian here: </home/voodoostix/Documents/Obsidian/homelab>
- Refer to the global `~/.claude/concepts.md` file before explaining commands or architectural patterns.
    - Known Concepts: If a command or concept is listed under `known`, execute it without basic explanation.
    - Learning Concepts: If it is listed under `learning` or is missing from the file entirely, provide a technical breakdown of the command and the "Why" behind the action (e.g., explaining why a directory change is necessary for a specific tool's context).
    - Evolution: Suggest moving items from `learning` to `known` once I demonstrate consistent proficiency.

## User Projects
Projects live in `~/projects/`:
- **homelab-infra/** — Docker Compose service definitions (Calibre e-book stack on :8080/:8083, Homepage dashboard on :3000). One compose file per service subdirectory.
- **my-scripts/** — Bash scripts for Docker management (`lab-start`/`lab-stop`, aliased as `up`/`down` in .bashrc).
- **blog/** — Empty, not yet started.
- **other...** In future more will be added

## Conventions

