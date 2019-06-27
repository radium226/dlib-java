pkgver="19.17"
pkgrel="1"

pkgname=("dlib-java")

arch=("any")

makedepends=(
  "java-runtime"
  "maven"
)

source=(
  "dlib-19.17.jar"
  "dlib-models-19.17.jar"
)

package() {
  install -m755 -d "${pkgdir}/usr/share/java/dlib"
  install -m644 "dlib-19.17.jar" "${pkgdir}/usr/share/java/dlib/$( echo "dlib-19.17.jar" | tr -d '.' )"
  install -m644 "dlib-models-19.17.jar" "${pkgdir}/usr/share/java/dlib/$( echo "dlib-models-19.17.jar" | tr -d '.' )"
}
