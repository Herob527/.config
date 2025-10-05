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
        # Flutter or dart
    else if test -f "pubspec.yaml"
        if grep -q "flutter:" pubspec.yaml
            echo flutter
        else
            echo dart
        end
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
            echo "  - ni          : Install dependencies (bun install) or add package with args (bun add [package])"
            echo "  - nr [script] : Run a script (bun run [script])"
            echo "  - no          : Check outdated packages (bun outdated)"
            echo "  - nu [package]: Update packages (bun update [package])"
            echo "  - nst         : Start project (bun run start, fallback to dev)"
        case pnpm
            echo "Commands to use:"
            echo "  - ni          : Install dependencies (pnpm install) or add package with args (pnpm add [package])"
            echo "  - nr [script] : Run a script (pnpm [script])"
            echo "  - no          : Check outdated packages (pnpm outdated)"
            echo "  - nu [package]: Update packages (pnpm update [package])"
            echo "  - nst         : Start project (pnpm start, fallback to dev)"
        case yarn
            echo "Commands to use:"
            echo "  - ni          : Install dependencies (yarn) or add package with args (yarn add [package])"
            echo "  - nr [script] : Run a script (yarn [script])"
            echo "  - no          : Check outdated packages (yarn outdated)"
            echo "  - nu [package]: Update packages (yarn upgrade [package])"
            echo "  - nst         : Start project (yarn start, fallback to dev)"
        case npm
            echo "Commands to use:"
            echo "  - ni          : Install dependencies (npm install) or add package with args (npm install [package])"
            echo "  - nr [script] : Run a script (npm run [script])"
            echo "  - no          : Check outdated packages (npm outdated)"
            echo "  - nu [package]: Update packages (npm update [package])"
            echo "  - nst         : Start project (npm start, fallback to dev)"
        case flutter
            echo "Commands to use:"
            echo "  - ni          : Install dependencies (flutter pub get) or add package with args (flutter pub add [package])"
            echo "  - nr          : Run the app (flutter run)"
            echo "  - no          : Check outdated packages (flutter pub outdated)"
            echo "  - nu [package]: Update packages (flutter pub upgrade [package])"
            echo "  - nst         : Start/run the app (flutter run)"
        case dart
            echo "Commands to use:"
            echo "  - ni          : Install dependencies (dart pub get) or add package with args (dart pub add [package])"
            echo "  - nr [script] : Run a script (dart run [script])"
            echo "  - no          : Check outdated packages (dart pub outdated)"
            echo "  - nu [package]: Update packages (dart pub upgrade [package])"
            echo "  - nst         : Start/run project (dart run)"
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
            case flutter
                flutter pub get
            case dart
                dart pub get
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
            case flutter
                flutter pub add $argv
            case dart
                dart pub add $argv
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
        case flutter
            flutter run $argv
        case dart
            dart run $argv
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
        case flutter
            flutter pub outdated $argv
        case dart
            dart pub outdated $argv
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
        case flutter
            flutter pub upgrade $argv
        case dart
            dart pub upgrade $argv
    end
end

# Function to start the project (start script or fallback to dev)
function nst
    set -l pm (detect_package_manager)

    switch $pm
        case flutter
            flutter run $argv
        case dart
            dart run $argv
        case bun pnpm yarn npm
            set -l has_start (test -f "package.json"; and jq -e '.scripts.start' package.json >/dev/null 2>&1; and echo true; or echo false)

            if test "$has_start" = true
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
    end
end
# Register the function as commands
alias which-pm="which_pm"
