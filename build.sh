#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[BUILD]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Default versions if none provided
if [ $# -eq 0 ]; then
    # All supported Racket versions (from your repository)
    VERSIONS=(
        "9.2" "9.1" "9.0"
        "8.17" "8.16" "8.15" "8.14" "8.13" "8.12" "8.11" "8.10"
        "8.9" "8.8" "8.7" "8.6" "8.5" "8.4" "8.3" "8.2" "8.1" "8.0"
        "7.9" "7.8" "7.7" "7.6" "7.5" "7.4"
        "7.3" "7.2" "7.1" "7.0"
        "6.12" "6.11" "6.10" "6.9" "6.8" "6.7" "6.6" "6.5" "6.4" "6.3" "6.2" "6.1"
    )
else
    VERSIONS=("$@")
fi

print_status "Building Racket versions: ${VERSIONS[*]}"
echo "----------------------------------------"

# Function to build a single image
build_image() {
    local version=$1
    local variant=$2
    local tag_suffix=$3
    local dockerfile=${4:-"racket.Dockerfile"}
    
    local image_name="racket/racket:$version$tag_suffix"
    
    print_status "Building $image_name..."
    
    # Check if Dockerfile exists
    if [ ! -f "$dockerfile" ]; then
        print_error "Dockerfile $dockerfile not found!"
        return 1
    fi
    
    # Compute a sensible installer URL for this Racket version and pass it to the Docker build
    INSTALLER_URL="https://download.racket-lang.org/installers/racket-${version}-x86_64-linux.sh"

    # Build the image (NO PUSH)
    docker build \
        --build-arg RACKET_VERSION="$version" \
        --build-arg VARIANT="$variant" \
        --build-arg RACKET_INSTALLER_URL="$INSTALLER_URL" \
        -t "$image_name" \
        -f "$dockerfile" \
        . || {
            print_error "Failed to build $image_name"
            return 1
        }
    
    print_status "✅ Successfully built $image_name"
    echo ""
}

# Main build loop
for version in "${VERSIONS[@]}"; do
    print_status "Processing Racket version $version"
    echo "----------------------------------------"
    
    # Build minimal variant (this is the default)
    build_image "$version" "minimal" "-minimal"
    
    # Build full variant
    build_image "$version" "full" "-full"
    
    # For versions >= 7.4, build CS variants
    if [[ $(echo "$version >= 7.4" | bc 2>/dev/null || echo "0") -eq 1 ]]; then
        print_status "Building CS variants for version $version"
        build_image "$version" "cs" "-cs"
        build_image "$version" "cs-full" "-cs-full"
    fi
    
    # For versions < 8.0, build BC variants
    if [[ $(echo "$version < 8.0" | bc 2>/dev/null || echo "0") -eq 1 ]]; then
        print_status "Building BC variants for version $version"
        build_image "$version" "bc" "-bc"
        build_image "$version" "bc-full" "-bc-full"
    fi
    
    echo "----------------------------------------"
    echo ""
done

print_status "✅ Build complete for versions: ${VERSIONS[*]}"

# List all built images
echo ""
print_status "Built images:"
docker images --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}" | grep "racket/racket" | sort
