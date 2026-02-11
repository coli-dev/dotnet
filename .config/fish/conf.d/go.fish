# Go environment (fish)
set -gx GOPATH $HOME/.go

# Add GOPATH/bin to PATH if missing
if not contains -- "$GOPATH/bin" $PATH
    set -gx PATH $PATH $GOPATH/bin
end

set -gx GOMODCACHE $GOPATH/pkg/mod
set -gx GOCACHE $HOME/.cache/go-build
