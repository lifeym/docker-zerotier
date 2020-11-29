# docker-zerotier

Docker Containerized ZeroTier One for use on Linux hosts.

```sh
docker run --rm mplatform/mquery lifeym/zerotier
Image: lifeym/zerotier
 * Manifest List: Yes
 * Supported platforms:
   - linux/arm/v6
   - linux/arm/v7
   - linux/arm64/v8
   - linux/386
   - linux/amd64
   - linux/ppc64le
```
---
This images has a manifest defined. So either on a x86 or RPi the command will be the same and Docker will figure out how to download the correct image for your architecture
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
