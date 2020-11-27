# docker-zerotier

ZeroTier的docker版本，方便使用

**Architectures: amd64 x86 arm64 armel armhf ppc64le**

```sh
 docker run --rm mplatform/mquery bltavares/zerotier
Image: bltavares/zerotier
 * Manifest List: Yes
 * Supported platforms:
   - linux/amd64
   - linux/arm/v5
   - linux/arm/v6
   - linux/arm64
   - linux/arm/v7
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
    -v /var/lib/zerotier-one:/var/lib/zerotier-one \
    -n zerotier-one \
    -d bltavares/zerotier
```
# Note for upgrade to 1.6.0
The zerotier executable requires an extra capability on seccomp profile to work. If you got Segmentation Fault when starting the container, add --cap-add=CAP_SYS_RAWIO to the docker run command.