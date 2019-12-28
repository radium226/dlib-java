TARGET:=target
JDK:=jdk8-openjdk

.PHONY: clean
clean: docker-image-make
	docker \
		run \
			--user "$(shell id -u):$(shell id -g)" \
			--mount type="bind",source="$(shell pwd)",target="/mnt/dlib-java" \
			--workdir="/mnt/dlib-java" \
			--rm \
			"dlib-java-make" \
			"--makefile=make/make.mk" \
			"clean"
	rm -Rf "$(TARGET)"

.PHONY: docker-image-make
docker-image-make:
	# We can skip sending the context using this trick
	cat "Dockerfile" | docker \
		build \
			--tag "dlib-java-make" \
			--build-arg USER_ID="$(shell id -u)" \
			--build-arg GROUP_ID="$(shell id -g)" \
			--build-arg JDK="$(JDK)" \
			"-"

.PHONY: package
package: docker-image-make
	mkdir -p "$(TARGET)"
	docker \
		run \
			--user "$(shell id -u):$(shell id -g)" \
			--mount type="bind",source="$(shell pwd)",target="/mnt/dlib-java" \
			--workdir="/mnt/dlib-java" \
			--rm \
			"dlib-java-make" \
			"--makefile=make/make.mk" \
			"package"

.PHONY: install
install: package
	mvn \
		install \
		-DskipTests