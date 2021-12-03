ZEROTIER_VERSION_SRC = 1.8.3
ZEROTIER_VERSION = 1.8.3
SYS_DATE = $(shell date -u +"%Y-%m-%dT00:00:00Z")

IMAGE_NAME=lifeym/zerotier

define build_image
	docker build . -f Dockerfile.$(1) --pull \
		--tag $(IMAGE_NAME):$(3) \
		--tag $(IMAGE_NAME):$(ZEROTIER_VERSION)-$(3) \
		--build-arg ZEROTIER_VERSION=$(4) \
		--build-arg BUILD_DATE=$(SYS_DATE) \
		--build-arg BUILD_ARCH=$(2)
endef

define push_image
	docker push $(IMAGE_NAME):$(1)
	docker push $(IMAGE_NAME):$(ZEROTIER_VERSION)-$(1)
endef

build-alpine:
	$(call build_image,alpine,i386,alpine-i386,$(ZEROTIER_VERSION_SRC))
	$(call build_image,alpine,amd64,alpine-amd64,$(ZEROTIER_VERSION_SRC))
	$(call build_image,alpine,arm32v6,alpine-arm32v6,$(ZEROTIER_VERSION_SRC))
	$(call build_image,alpine,arm32v7,alpine-arm32v7,$(ZEROTIER_VERSION_SRC))
	$(call build_image,alpine,arm64v8,alpine-arm64v8,$(ZEROTIER_VERSION_SRC))
	$(call build_image,alpine,ppc64le,alpine-ppc64le,$(ZEROTIER_VERSION_SRC))
	$(call build_image,alpine,s390x,alpine-s390x,$(ZEROTIER_VERSION_SRC))

push-alpine:
	$(call push_image,alpine-i386)
	$(call push_image,alpine-amd64)
	$(call push_image,alpine-arm32v6)
	$(call push_image,alpine-arm32v7)
	$(call push_image,alpine-arm64v8)
	$(call push_image,alpine-ppc64le)
	$(call push_image,alpine-s390x)

manifest-alpine:
# tag: version-alpine
	MFLAG=$(shell docker manifest inspect $(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine && if [ $? -eq 1]; then echo '-a'; else echo ''; fi)
	docker manifest create $(MFLAG) \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine-i386 \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine-amd64 \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine-arm32v6 \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine-arm32v7 \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine-arm64v8 \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine-ppc64le \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine-s390x

	docker manifest annotate $(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine-i386 --os linux \
		--arch 386

	docker manifest annotate $(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine-amd64 --os linux \
		--arch amd64

	docker manifest annotate $(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine-arm32v6 --os linux \
		--arch arm --variant v6

	docker manifest annotate $(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine-arm32v7 --os linux \
		--arch arm --variant v7

	docker manifest annotate $(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine-arm64v8 --os linux \
		--arch arm64 --variant v8

	docker manifest annotate $(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine-ppc64le --os linux \
		--arch ppc64le

	docker manifest annotate $(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine-s390x --os linux \
		--arch s390x

	docker manifest push --purge $(IMAGE_NAME):$(ZEROTIER_VERSION)-alpine

# tag: alpine
	docker manifest create \
		$(IMAGE_NAME):alpine \
		$(IMAGE_NAME):alpine-i386 \
		$(IMAGE_NAME):alpine-amd64 \
		$(IMAGE_NAME):alpine-arm32v6 \
		$(IMAGE_NAME):alpine-arm32v7 \
		$(IMAGE_NAME):alpine-arm64v8 \
		$(IMAGE_NAME):alpine-ppc64le \
		$(IMAGE_NAME):alpine-s390x

	docker manifest annotate $(IMAGE_NAME):alpine \
		$(IMAGE_NAME):alpine-i386 --os linux \
		--arch 386

	docker manifest annotate $(IMAGE_NAME):alpine \
		$(IMAGE_NAME):alpine-amd64 --os linux \
		--arch amd64

	docker manifest annotate $(IMAGE_NAME):alpine \
		$(IMAGE_NAME):alpine-arm32v6 --os linux \
		--arch arm --variant v6

	docker manifest annotate $(IMAGE_NAME):alpine \
		$(IMAGE_NAME):alpine-arm32v7 --os linux \
		--arch arm --variant v7

	docker manifest annotate $(IMAGE_NAME):alpine \
		$(IMAGE_NAME):alpine-arm64v8 --os linux \
		--arch arm64 --variant v8

	docker manifest annotate $(IMAGE_NAME):alpine \
		$(IMAGE_NAME):alpine-ppc64le --os linux \
		--arch ppc64le

	docker manifest annotate $(IMAGE_NAME):alpine \
		$(IMAGE_NAME):alpine-s390x --os linux \
		--arch s390x

	docker manifest push --purge $(IMAGE_NAME):alpine

build-debian:
	$(call build_image,debian,i386,i386,$(ZEROTIER_VERSION))
	$(call build_image,debian,amd64,amd64,$(ZEROTIER_VERSION))
	$(call build_image,debian,arm32v5,arm32v5,$(ZEROTIER_VERSION))
	$(call build_image,debian,arm32v7,arm32v7,$(ZEROTIER_VERSION))
	$(call build_image,debian,arm64v8,arm64v8,$(ZEROTIER_VERSION))
	$(call build_image,debian,mips64le,mips64le,$(ZEROTIER_VERSION))
	$(call build_image,debian,ppc64le,ppc64le,$(ZEROTIER_VERSION))
	$(call build_image,debian,s390x,s390x,$(ZEROTIER_VERSION))

push-debian:
	$(call push_image,i386)
	$(call push_image,amd64)
	$(call push_image,arm32v5)
	$(call push_image,arm32v7)
	$(call push_image,arm64v8)
	$(call push_image,mips64le)
	$(call push_image,ppc64le)
	$(call push_image,s390x)

manifest-debian:
# tag: version
	docker manifest create \
		$(IMAGE_NAME):$(ZEROTIER_VERSION) \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-i386 \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-amd64 \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-arm32v5 \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-arm32v7 \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-arm64v8 \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-mips64le \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-ppc64le \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-s390x

	docker manifest annotate $(IMAGE_NAME):$(ZEROTIER_VERSION) \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-i386 --os linux \
		--arch 386

	docker manifest annotate $(IMAGE_NAME):$(ZEROTIER_VERSION) \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-amd64 --os linux \
		--arch amd64

	docker manifest annotate $(IMAGE_NAME):$(ZEROTIER_VERSION) \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-arm32v5 --os linux \
		--arch arm --variant v5

	docker manifest annotate $(IMAGE_NAME):$(ZEROTIER_VERSION) \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-arm32v7 --os linux \
		--arch arm --variant v7

	docker manifest annotate $(IMAGE_NAME):$(ZEROTIER_VERSION) \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-arm64v8 --os linux \
		--arch arm64 --variant v8

	docker manifest annotate $(IMAGE_NAME):$(ZEROTIER_VERSION) \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-mips64le --os linux \
		--arch mips64le

	docker manifest annotate $(IMAGE_NAME):$(ZEROTIER_VERSION) \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-ppc64le --os linux \
		--arch ppc64le

	docker manifest annotate $(IMAGE_NAME):$(ZEROTIER_VERSION) \
		$(IMAGE_NAME):$(ZEROTIER_VERSION)-s390x --os linux \
		--arch s390x

	docker manifest push --purge $(IMAGE_NAME):$(ZEROTIER_VERSION)

# tag: latest
	docker manifest create \
		$(IMAGE_NAME):latest \
		$(IMAGE_NAME):i386 \
		$(IMAGE_NAME):amd64 \
		$(IMAGE_NAME):arm32v5 \
		$(IMAGE_NAME):arm32v7 \
		$(IMAGE_NAME):arm64v8 \
		$(IMAGE_NAME):mips64le \
		$(IMAGE_NAME):ppc64le \
		$(IMAGE_NAME):s390x

	docker manifest annotate $(IMAGE_NAME):latest \
		$(IMAGE_NAME):i386 --os linux \
		--arch 386

	docker manifest annotate $(IMAGE_NAME):latest \
		$(IMAGE_NAME):amd64 --os linux \
		--arch amd64

	docker manifest annotate $(IMAGE_NAME):latest \
		$(IMAGE_NAME):arm32v5 --os linux \
		--arch arm --variant v5

	docker manifest annotate $(IMAGE_NAME):latest \
		$(IMAGE_NAME):arm32v7 --os linux \
		--arch arm --variant v7

	docker manifest annotate $(IMAGE_NAME):latest \
		$(IMAGE_NAME):arm64v8 --os linux \
		--arch arm64 --variant v8

	docker manifest annotate $(IMAGE_NAME):latest \
		$(IMAGE_NAME):ppc64le --os linux \
		--arch mips64le

	docker manifest annotate $(IMAGE_NAME):latest \
		$(IMAGE_NAME):ppc64le --os linux \
		--arch ppc64le

	docker manifest annotate $(IMAGE_NAME):latest \
		$(IMAGE_NAME):s390x --os linux \
		--arch s390x

	docker manifest push --purge $(IMAGE_NAME):latest

build: build-alpine build-debian
push: push-alpine push-debian
manifest: manifest-alpine manifest-debian
all: build push manifest

.PHONY: all build build-alpine build-debian push push-alpine push-debian manifest manifest-alpine manifest-debian
