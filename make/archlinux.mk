.PHONY: archlinux-clean
archlinux-clean:
	sudo rm -Rf "work/package/chroot"

.PHONY: archlinux-package
archlinux-package: work/package/chroot/root/.package-archlinux

work/package/chroot/root/.package:
	mkdir -p "work/package/chroot"
	mkarchroot "work/package/chroot/root" \
		"base-devel"
	sudo touch "work/package/chroot/root/.package"


.PHONY: archinux-
makechrootpkg -c -r
