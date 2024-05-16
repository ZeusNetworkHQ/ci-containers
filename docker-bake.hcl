variable "TAG" {
  default = "develop"
}

variable "CONTAINER_REGISTRY" {
  default = "ghcr.io/zeusnetworkhq/ci-containers"
}

group "default" {
  targets = [
    "anchor",
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
    alpine = "docker-image://docker.io/library/alpine:3.19"
  }
  tags      = ["${CONTAINER_REGISTRY}/electrs:0.10"]
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
