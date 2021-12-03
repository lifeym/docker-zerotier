# Docker Containerized ZeroTier One for use on Linux hosts.
- Start from zerotier-one 1.6.1
- See https://github.com/lifeym/docker-zerotier for more informations.

## About 1.8.1
There's no 1.8.1 for debian.
Since the official armel(arm32v5) deb package of v1.8.1 has not been released yet, and
I cannot find any notice mentioned armel is supported or not from v1.81.

## Supports multi-arch
Simply depends on base os image.
### alpine:
x86, amd64, arm32v6, arm32v7, arm64v8, ppc64le, s390x

### debian
x86, amd64, arm32v5, arm32v7, arm64v8, mips64le, ppc64le, s390x

## Tags
debian means debian-slim.
- 1.8.3, 1.8.3-debian, 1.8.3-alpine, alpine, latest
- 1.8.2, 1.8.2-debian, 1.8.2-alpine
- 1.8.1-alpine, alpine
- 1.6.6, 1.6.6-debian, 1.6.6-alpine
- 1.6.5, 1.6.5-debian, 1.6.5-alpine
- 1.6.4, 1.6.4-debian, 1.6.4-alpine
- 1.6.3, 1.6.3-debian, 1.6.3-alpine
- 1.6.2, 1.6.2-debian, 1.6.2-alpine
- 1.6.1, 1.6.1-debian, 1.6.1-alpine

## Difference between alpine and debian image
- The zerotier-one binary in debian are from the official website. Which based on official [Dockerfile](https://github.com/zerotier/ZeroTierOne/blob/master/ext/installfiles/linux/zerotier-containerized/Dockerfile) 
- Alpine's one was compiled natively from the official source with clang.
Also, alpine has a smaller size.

## How to use
### Exsample to run a new container:
```sh
docker run --device=/dev/net/tun \
    --net=host \
    --cap-add=NET_ADMIN \
    -v /path/to/my-zerotier-one:/var/lib/zerotier-one \
    --name myzerotier \
    -d lifeym/zerotier
```
- zerotier-one stores configuration under /var/lib/zerotier-one, to retain configuration; mount a Docker volume, or use a bind-mount, on /var/lib/zerotier-one


### Join a network:
```sh
docker exec myzerotier zerotier-cli join xxx
```
Where 'xxx' is your network id.
