#!/bin/sh

# Remove old generated source file
[ -f allValues.generated.swift ] && rm allValues.generated.swift

# Analyze model.swift and generate the corresponding allValues implementations
sourcekitten structure --file model.swift | ../generate-enum-allValues >allValues.generated.swift

# Run all as one script
cat model.swift allValues.generated.swift main.swift | swift -
