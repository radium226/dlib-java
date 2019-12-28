#FIXME: We may use asp instead, but there is a bug in the last DLib release with OpenCV
$(TARGET)/dlib/dlib-git.tar.gz:
	mkdir -p "$(TARGET)/dlib"
	wget "https://aur.archlinux.org/cgit/aur.git/snapshot/dlib-git.tar.gz" -O "$(TARGET)/dlib/dlib-git.tar.gz"

$(TARGET)/dlib/dlib-git/PKGBUILD: $(TARGET)/dlib/dlib-git.tar.gz
	tar xzf "$(TARGET)/dlib/dlib-git.tar.gz" -C "$(TARGET)/dlib"

$(TARGET)/dlib/dlib-git/dlib-git-VERSION-x86_64.pkg.tar.xz: $(TARGET)/dlib/dlib-git/PKGBUILD
	cd "$(TARGET)/dlib/dlib-git"
	makepkg \
		--syncdeps \
		--rmdeps \
		--noconfirm || true
	find "." -name "dlib-git-*-x86_64.pkg.tar.xz" -exec cp "{}" "dlib-git-VERSION-x86_64.pkg.tar.xz" \;

$(TARGET)/dlib-git-VERSION-x86_64.pkg.tar.xz: $(TARGET)/dlib/dlib-git/dlib-git-VERSION-x86_64.pkg.tar.xz
	cp "$(TARGET)/dlib/dlib-git/dlib-git-VERSION-x86_64.pkg.tar.xz" "$(TARGET)/dlib-git-VERSION-x86_64.pkg.tar.xz"

/usr/lib/libdlib.so: $(TARGET)/dlib-git-VERSION-x86_64.pkg.tar.xz
	pacman -U "$(TARGET)/dlib-git-VERSION-x86_64.pkg.tar.xz" --noconfirm