# Docker Containerized ZeroTier One for use on Linux hosts.
- Start from zerotier-one 1.6.1

# Supports multi-arch
Simply depends on base os image.
## alpine:
- x86
- amd64
- arm32v6
- arm32v7
- arm64v8
- ppc64le
- s390x

## debian
- x86
- amd64
- arm32v5
- arm32v7
- arm64v8
- mips64le
- ppc64le
- s390x

# Tags
- 1.6.2, 1.6.2-debian, latest
- 1.6.2-alpine, alpine
- 1.6.1, 1.6.1-debian
- 1.6.1-alpine

# Difference between alpine and debian image
- The zerotier-one binary in debian are from the official website.
- Alpine's one was compiled natively from the official source with clang.
Also, alpine has a smaller size.

# How to use
## Exsample to run a new container:
```sh
docker run --device=/dev/net/tun \
    --net=host \
    --cap-add=NET_ADMIN \
    --cap-add=SYS_ADMIN \
    --cap-add=CAP_SYS_RAWIO \
    -v /path/to/my-zerotier-one:/var/lib/zerotier-one \
    --name zerotier-one \
    -d lifeym/zerotier
```
- zerotier-one stores configuration under /var/lib/zerotier-one, to retain configuration; mount a Docker volume, or use a bind-mount, on /var/lib/zerotier-one


## Join a network:
```sh
docker exec zerotier-one zerotier-cli join xxx
```
Where 'xxx' is your network id.