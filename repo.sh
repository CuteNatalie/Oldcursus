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
gpg -abs -u 33C75BD6053B7AB3A9F0D61012FE7355E0EC5805 -o Release.gpg Release
gpg -abs -u 33C75BD6053B7AB3A9F0D61012FE7355E0EC5805 --clearsign -o InRelease Release
