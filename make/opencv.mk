OPENCV_VERSION:=4.2.0
OPENCV_ARCH_PGKVER:=$(OPENCV_VERSION)
OPENCV_ARCH_PKGREL:=1

$(TARGET)/opencv/trunk/PKGBUILD:
	mkdir -p "$(TARGET)"
	cd "$(TARGET)"
	asp checkout "opencv"

$(TARGET)/opencv/trunk/opencv-$(OPENCV_ARCH_PGKVER)-$(OPENCV_ARCH_PKGREL)-x86_64.pkg.tar.xz: $(TARGET)/opencv/trunk/PKGBUILD
	cd "$(TARGET)/opencv/trunk"
	makepkg \
		--syncdeps \
		--rmdeps \
		--noconfirm

$(TARGET)/opencv-$(OPENCV_ARCH_PGKVER)-$(OPENCV_ARCH_PKGREL)-x86_64.pkg.tar.xz: $(TARGET)/opencv/trunk/opencv-$(OPENCV_ARCH_PGKVER)-$(OPENCV_ARCH_PKGREL)-x86_64.pkg.tar.xz
	cp "$(TARGET)/opencv/trunk/opencv-$(OPENCV_ARCH_PGKVER)-$(OPENCV_ARCH_PKGREL)-x86_64.pkg.tar.xz" "$(TARGET)/opencv-$(OPENCV_ARCH_PGKVER)-$(OPENCV_ARCH_PKGREL)-x86_64.pkg.tar.xz"

/usr/share/java/opencv4/opencv-$(shell echo '$(OPENCV_VERSION)' | tr -d '.').jar /usr/lib/libopencv_java$(shell echo '$(OPENCV_VERSION)' | tr -d '.').so: $(TARGET)/opencv-$(OPENCV_VERSION)-1-x86_64.pkg.tar.xz
	sudo mkdir -p "$(TARGET)/pacman"
	sudo pacman \
		--cachedir="$(shell pwd)/$(TARGET)/pacman" \
		-U "$(TARGET)/opencv-$(OPENCV_VERSION)-1-x86_64.pkg.tar.xz" \
		--noconfirm

$(TARGET)/.m2/repository/opencv/opencv/$(OPENCV_VERSION)/opencv-$(OPENCV_VERSION).jar: /usr/share/java/opencv4/opencv-$(shell echo '$(OPENCV_VERSION)' | tr -d '.').jar
	# We should get rid of the current pom.xml, so let's jump into $(TARGET)
	cd "$(TARGET)"
	mvn install:install-file \
		-Dmaven.repo.local="$(shell pwd)/$(TARGET)/.m2/repository" \
		-Dfile="/usr/share/java/opencv4/opencv-$(shell echo '$(OPENCV_VERSION)' | tr -d '.').jar" \
		-DgroupId="opencv" \
		-DartifactId="opencv" \
		-Dversion="$(OPENCV_VERSION)" \
		-Dpackaging="jar"

.PHONY: opencv
opencv: $(TARGET)/opencv/trunk/opencv-$(OPENCV_ARCH_PGKVER)-$(OPENCV_ARCH_PKGREL)-x86_64.pkg.tar.xz
