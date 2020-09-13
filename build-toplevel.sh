#! /usr/bin/env bash

set -x

echo Building toplevel...
nix-build \
  -A toplevel \
  --no-out-link \
  --argstr nix-notes-version todo-nix-notes-version \
