BUILD:=build
JDK:=jdk8-openjdk

.PHONY: clean
clean:
	rm -Rf "$(BUILD)"

.PHONY: builder-docker-image
builder-docker-image:
	docker \
		build \
			--file "docker/Dockerfile" \
			--tag "dlib-java-builder" \
			--build-arg USER_ID="$(shell id -u)" \
			--build-arg GROUP_ID="$(shell id -g)" \
			--build-arg JDK="$(JDK)" \
			"docker"

.PHONY: build-opencv
build-opencv: $(BUILD)/opencv/trunk/opencv-4.2.0-1-x86_64.pkg.tar.xz

$(BUILD)/opencv/trunk/opencv-4.2.0-1-x86_64.pkg.tar.xz: builder-docker-image
	mkdir -p "$(BUILD)"
	docker \
		run \
			--user "$(shell id -u):$(shell id -g)" \
			--mount type="bind",source="$(shell pwd)/$(BUILD)",target="/mnt/build" \
			--rm \
			"dlib-java-builder" \
			"build-opencv"
