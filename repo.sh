 #!/bin/sh

rm -f Packages Packages.xz Packages.zst
rm -f Contents-iphoneos-arm Contents-iphoneos-arm.xz Contents-iphoneos-arm.zst
rm -f Release Release.gpg InRelease

apt-ftparchive -c release.conf packages debs > Packages
xz -9c Packages > Packages.xz
zstd -9c Packages > Packages.zst

apt-ftparchive -c release.conf contents debs > Contents-iphoneos-arm
xz -9c Contents-iphoneos-arm > Contents-iphoneos-arm.xz
zstd -9c Contents-iphoneos-arm > Contents-iphoneos-arm.zst

tmp=$(mktemp)
apt-ftparchive -c release.conf release . > $tmp
sed '/debian/d' $tmp > Release
gpg -abs -u 3E2F176CBEFAA412AA1010CFDDA94DD278B5C270 -o Release.gpg Release
gpg -abs -u 3E2F176CBEFAA412AA1010CFDDA94DD278B5C270 --clearsign -o InRelease Release
