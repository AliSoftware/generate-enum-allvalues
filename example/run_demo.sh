#!/bin/sh

INPUT_FILE="$(dirname $0)"/model.swift                 # File to parse
BIN_PATH="$(dirname $0)"/../generate-enum-allValues    # Path to the script
GEN_FILE="$(dirname $0)"/allValues.generated.swift     # Output file to generate
MAIN_FILE="$(dirname $0)"/main.swift                   # Swift source that will use the `allValues` properties



# Remove old generated source file if present
[ -f "$GEN_FILE" ] && rm "$GEN_FILE"

# Analyze input swift file and generate the corresponding allValues implementations in output file
sourcekitten structure --file "$INPUT_FILE" | "$BIN_PATH" >"$GEN_FILE"

# Run all (input + generated + main) as one Swift script to see the usage result
cat "$INPUT_FILE" "$GEN_FILE" "$MAIN_FILE" | swift -
