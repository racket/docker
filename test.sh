#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[TEST]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# If versions provided as arguments, test only those
if [ $# -eq 0 ]; then
    # Get all built racket images
    IMAGES=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep "^racket/racket:" | sort -u)
else
    # Build image names from version arguments
    IMAGES=""
    for version in "$@"; do
        for suffix in "" "-minimal" "-full" "-cs" "-cs-full" "-bc" "-bc-full"; do
            IMAGES="$IMAGES racket/racket:$version$suffix"
        done
    done
fi

print_status "Testing images:"
echo "$IMAGES" | tr ' ' '\n' | head -5
if [ $(echo "$IMAGES" | wc -w) -gt 5 ]; then
    echo "... and $(($(echo "$IMAGES" | wc -w) - 5)) more"
fi
echo "----------------------------------------"

# Function to test a single image
test_image() {
    local image=$1
    
    print_status "Testing $image..."
    
    # Test 1: Check if image runs and returns Racket version
    if docker run --rm "$image" racket --version > /dev/null 2>&1; then
        local version_output=$(docker run --rm "$image" racket --version 2>/dev/null | head -1)
        print_status "✅ $image - Version check passed: $version_output"
    else
        print_error "❌ $image - Failed to run racket --version"
        return 1
    fi
    
    # Test 2: Check if Racket REPL works (basic evaluation)
    if docker run --rm "$image" racket -e "(displayln 'hello-world)" | grep -q "hello-world"; then
        print_status "✅ $image - REPL evaluation passed"
    else
        print_error "❌ $image - REPL evaluation failed"
        return 1
    fi
    
    # Test 3: Check for specific features based on variant
    if [[ "$image" == *"-full"* ]] || [[ "$image" != *"-minimal"* && "$image" != *"-cs"* && "$image" != *"-bc"* ]]; then
        # Full variant should have raco
        if docker run --rm "$image" which raco > /dev/null 2>&1; then
            print_status "✅ $image - raco found (full variant)"
        else
            print_warning "⚠️  $image - raco not found (expected in full variant)"
        fi
    fi
    
    # Test 4: Check image size (warning if > 1GB)
    local size=$(docker images --format "{{.Size}}" "$image")
    if [[ "$size" == *"GB"* ]]; then
        print_warning "⚠️  $image - Large image size: $size"
    fi
    
    echo ""
    return 0
}

# Test each image
FAILED=0
for image in $IMAGES; do
    if ! test_image "$image"; then
        FAILED=$((FAILED + 1))
    fi
done

echo "----------------------------------------"
if [ $FAILED -eq 0 ]; then
    print_status "✅ All tests passed!"
    exit 0
else
    print_error "❌ $FAILED image(s) failed testing"
    exit 1
fi