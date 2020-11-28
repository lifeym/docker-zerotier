ZEROTIER_VERSION = 1.6.1
CACHE_BUST = $(shell date -u +"%Y-%m-%dT00:00:00Z")

define build_image
  docker build . --pull \
    --tag lifeym/zerotier:$(1) \
		--tag lifeym/zerotier:$(ZEROTIER_VERSION)-$(1) \
		--build-arg ZEROTIER_VERSION=$(ZEROTIER_VERSION) \
		--build-arg BUILD_DATE=$(CACHE_BUST) \
		--build-arg TARGET_ARCH=$(1)
endef

amd64:
	$(call build_image,amd64)

x86:
	$(call build_image,386)

arm64:
	$(call build_image,arm64v8)

armhf:
	$(call build_image,arm32v7)

armel:
	$(call build_image,arm32v6)

ppc64le:
	$(call build_image,ppc64le)

publish:
	docker push lifeym/zerotier:amd64
	docker push lifeym/zerotier:386
	docker push lifeym/zerotier:arm32v6
	docker push lifeym/zerotier:arm32v7
	docker push lifeym/zerotier:arm64v8
	docker push lifeym/zerotier:ppc64le

	docker push lifeym/zerotier:$(ZEROTIER_VERSION)-amd64
	docker push lifeym/zerotier:$(ZEROTIER_VERSION)-386
	docker push lifeym/zerotier:$(ZEROTIER_VERSION)-arm32v6
	docker push lifeym/zerotier:$(ZEROTIER_VERSION)-arm32v7
	docker push lifeym/zerotier:$(ZEROTIER_VERSION)-arm64v8
	docker push lifeym/zerotier:$(ZEROTIER_VERSION)-ppc64le

manifest:
	docker manifest create \
	  lifeym/zerotier:$(ZEROTIER_VERSION) \
	  lifeym/zerotier:$(ZEROTIER_VERSION)-amd64 \
	  lifeym/zerotier:$(ZEROTIER_VERSION)-i386 \
	  lifeym/zerotier:$(ZEROTIER_VERSION)-arm32v6 \
	  lifeym/zerotier:$(ZEROTIER_VERSION)-arm32v7 \
	  lifeym/zerotier:$(ZEROTIER_VERSION)-arm64v8 \
	  lifeym/zerotier:$(ZEROTIER_VERSION)-ppc64le

	docker manifest annotate lifeym/zerotier:$(ZEROTIER_VERSION) \
	  lifeym/zerotier:$(ZEROTIER_VERSION)-amd64 --os linux \
	  --arch amd64

	docker manifest annotate lifeym/zerotier:$(ZEROTIER_VERSION) \
	  lifeym/zerotier:$(ZEROTIER_VERSION)-i386 --os linux \
	  --arch 386

	 docker manifest annotate lifeym/zerotier:$(ZEROTIER_VERSION) \
	  lifeym/zerotier:$(ZEROTIER_VERSION)-arm32v6 --os linux \
	  --arch arm --variant v6

	docker manifest annotate lifeym/zerotier:$(ZEROTIER_VERSION) \
	  lifeym/zerotier:$(ZEROTIER_VERSION)-arm32v7 --os linux \
	  --arch arm --variant v7

	docker manifest annotate lifeym/zerotier:$(ZEROTIER_VERSION) \
	  lifeym/zerotier:$(ZEROTIER_VERSION)-arm64v8 --os linux \
	  --arch arm64

	docker manifest annotate lifeym/zerotier:$(ZEROTIER_VERSION) \
	  lifeym/zerotier:$(ZEROTIER_VERSION)-ppc64le --os linux \
	  --arch ppc64le

	docker manifest push --purge lifeym/zerotier:$(ZEROTIER_VERSION)

	docker manifest create \
	  lifeym/zerotier:latest \
	  lifeym/zerotier:amd64 \
	  lifeym/zerotier:i386 \
	  lifeym/zerotier:arm32v6 \
	  lifeym/zerotier:arm32v7 \
	  lifeym/zerotier:arm64v8 \
	  lifeym/zerotier:ppc64le

	docker manifest annotate lifeym/zerotier:latest \
	  lifeym/zerotier:amd64 --os linux \
	  --arch amd64

	docker manifest annotate lifeym/zerotier:latest \
	  lifeym/zerotier:i386 --os linux \
	  --arch 386

	docker manifest annotate lifeym/zerotier:latest \
	  lifeym/zerotier:arm32v5 --os linux \
	  --arch arm --variant v6

	docker manifest annotate lifeym/zerotier:latest \
	  lifeym/zerotier:arm32v7 --os linux \
	  --arch arm --variant v7

	docker manifest annotate lifeym/zerotier:latest \
	  lifeym/zerotier:arm64v8 --os linux \
	  --arch arm64

	docker manifest annotate lifeym/zerotier:latest \
	  lifeym/zerotier:ppc64le --os linux \
	  --arch ppc64le

	docker manifest push --purge lifeym/zerotier:latest

all: amd64 x86 arm64 armel armhf ppc64le

.PHONY: all arm64 armel armhf amd64 x86 ppc64le publish manifest