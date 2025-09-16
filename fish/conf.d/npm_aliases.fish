#!/usr/bin/env fish

# Function to detect the appropriate package manager based on lock files
function detect_package_manager
    if test -f "bun.lockb"; or test -f "bun.lock"
        echo bun
    else if test -f "pnpm-lock.yaml"
        echo pnpm
    else if test -f "yarn.lock"
        echo yarn
    else if test -f "package-lock.json"; or test -f "package.json"
        echo npm
    else
        echo npm # Default to npm if no lock file is found
    end
end

# Function to recommend what package manager to use
function which_pm
    set -l pm (detect_package_manager)

    echo "Detected package manager: $pm"

    switch $pm
        case bun
            echo "Commands to use:"
            echo "  - Install dependencies: bun install"
            echo "  - Add a package: bun add [package]"
            echo "  - Run a script: bun run [script]"
        case pnpm
            echo "Commands to use:"
            echo "  - Install dependencies: pnpm install"
            echo "  - Add a package: pnpm add [package]"
            echo "  - Run a script: pnpm [script]"
        case yarn
            echo "Commands to use:"
            echo "  - Install dependencies: yarn"
            echo "  - Add a package: yarn add [package]"
            echo "  - Run a script: yarn [script]"
        case npm
            echo "Commands to use:"
            echo "  - Install dependencies: npm install"
            echo "  - Add a package: npm install [package]"
            echo "  - Run a script: npm run [script]"
    end
end

# Function to handle both install and add commands
function ni
    set -l pm (detect_package_manager)

    # If no arguments, run the install command
    if test (count $argv) -eq 0
        switch $pm
            case bun
                bun install
            case pnpm
                pnpm install
            case yarn
                yarn
            case npm
                npm install
        end
        # Otherwise, run the add command with arguments
    else
        switch $pm
            case bun
                bun add $argv
            case pnpm
                pnpm add $argv
            case yarn
                yarn add $argv
            case npm
                npm install $argv
        end
    end
end

# Function to run the appropriate run command
function nr
    set -l pm (detect_package_manager)

    switch $pm
        case bun
            bun run $argv
        case pnpm
            pnpm $argv[1] $argv[2..-1]
        case yarn
            yarn $argv[1] $argv[2..-1]
        case npm
            npm run $argv
    end
end

function no
    set -l pm (detect_package_manager)

    switch $pm
        case bun
            bun outdated $argv
        case pnpm
            pnpm outdated $argv
        case yarn
            yarn outdated $argv
        case npm
            npm outdated $argv
    end
end

function nu
    set -l pm (detect_package_manager)

    switch $pm
        case bun
            bun update $argv
        case pnpm
            pnpm update $argv
        case yarn
            yarn upgrade $argv
        case npm
            npm update $argv
    end
end

# Function to start the project (start script or fallback to dev)
function nst
    set -l pm (detect_package_manager)

    # Check if package.json exists and has a start script
    if test -f "package.json"
        set -l has_start (jq -r '.scripts.start // empty' package.json 2>/dev/null)
        if test -n "$has_start"
            # Start script exists, use it
            switch $pm
                case bun
                    bun run start
                case pnpm
                    pnpm start
                case yarn
                    yarn start
                case npm
                    npm start
            end
        else
            # No start script, fallback to dev
            echo "No 'start' script found, running 'dev' instead..."
            switch $pm
                case bun
                    bun run dev
                case pnpm
                    pnpm dev
                case yarn
                    yarn dev
                case npm
                    npm run dev
            end
        end
    else
        echo "No package.json found"
        return 1
    end
end
# Register the function as commands
alias which-pm="which_pm"
