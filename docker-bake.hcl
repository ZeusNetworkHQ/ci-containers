variable "TAG" {
  default = "develop"
}

variable "CONTAINER_REGISTRY" {
  default = "ghcr.io/zeusnetworkhq/ci-containers"
}

group "default" {
  targets = [
    "anchor",
    "btc-rpc-explorer",
    "electrs",
    "sccache",
  ]
}

target "anchor" {
  dockerfile = "anchor/Containerfile"
  target     = "anchor"
  contexts = {
    sccache = "target:sccache"
    solana  = "docker-image://docker.io/solanalabs/solana:v1.18.12"
  }
  args = {
    RUST_STABLE_TOOLCHAIN = "1.75.0"
    ANCHOR_VERSION        = "0.30.0"
  }
  tags      = ["${CONTAINER_REGISTRY}/anchor:0.30.0"]
  platforms = ["linux/amd64"]
}

target "electrs" {
  dockerfile = "electrs/Containerfile"
  target     = "electrs"
  contexts = {
    debian = "docker-image://docker.io/library/debian:bookworm-slim"
    rust   = "docker-image://docker.io/library/rust:1-slim-bookworm"
  }
  tags      = ["${CONTAINER_REGISTRY}/electrs:blockstream-nightly"]
  platforms = ["linux/amd64", "linux/arm64"]
}

target "btc-rpc-explorer" {
  dockerfile = "btc-rpc-explorer/Containerfile"
  target     = "btc-rpc-explorer"
  contexts = {
    node        = "docker-image://docker.io/library/node:20"
    node-alpine = "docker-image://docker.io/library/node:20-alpine"
  }
  tags      = ["${CONTAINER_REGISTRY}/btc-rpc-explorer:nightly"]
  platforms = ["linux/amd64", "linux/arm64"]
}

target "sccache" {
  dockerfile = "sccache/Containerfile"
  target     = "sccache"
  contexts = {
    alpine     = "docker-image://docker.io/library/alpine:3.19"
    distroless = "docker-image://gcr.io/distroless/cc-debian11:latest"
  }
  args = {
    SCCACHE_VERSION = "0.8.0"
  }
  tags      = ["${CONTAINER_REGISTRY}/sccache:0.8.0"]
  platforms = ["linux/amd64", "linux/arm64"]
}
