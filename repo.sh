# Wrap up
printf "[Repo] (Step 1/5) Deleting temporary directories\n"
cd ..
rm -rf temp
git add *.deb
cd ..
printf "[Repo] (Step 2/5) Deleting existing APT Packages files\n"
rm -rf Packages*
printf "[Repo] (Step 3/5) Writing new Packages files\n"
dpkg-scanpackages --multiversion debs > Packages 2> /dev/null
gzip -c9 Packages > Packages.gz
xz -c9 Packages > Packages.xz
xz -5fkev --format=lzma Packages > Packages.lzma 2> /dev/null
zstd -c19 Packages > Packages.zst
bzip2 -c9 Packages > Packages.bz2
printf "[Repo] (Step 4/5) Calculating hashes and sizes\n"
packages_size=$(ls -l Packages | awk '{print $5,$9}')
packages_md5=$(md5sum Packages | awk '{print $1}')
packages_sha256=$(sha256sum Packages | awk '{print $1}')
packagesgz_size=$(ls -l Packages.gz | awk '{print $5,$9}')
packagesgz_md5=$(md5sum Packages.gz | awk '{print $1}')
packagesgz_sha256=$(sha256sum Packages.gz | awk '{print $1}')
packagesbz2_size=$(ls -l Packages.bz2 | awk '{print $5,$9}')
packagesbz2_md5=$(md5sum Packages.bz2 | awk '{print $1}')
packagesbz2_sha256=$(sha256sum Packages.bz2 | awk '{print $1}')
packagesxz_size=$(ls -l Packages.xz | awk '{print $5,$9}')
packagesxz_md5=$(md5sum Packages.xz | awk '{print $1}')
packagesxz_sha256=$(sha256sum Packages.xz | awk '{print $1}')
packageszst_size=$(ls -l Packages.zst | awk '{print $5,$9}')
packageszst_md5=$(md5sum Packages.zst | awk '{print $1}')
packageszst_sha256=$(sha256sum Packages.zst | awk '{print $1}')
date=$(date -R -u)
printf "[Repo] (Step 5/5) Replacing Release file\n"
echo "MD5Sum:" >> Release
echo " $packages_md5 $packages_size" >> Release
echo " $packagesgz_md5 $packagesgz_size" >> Release
echo " $packagesbz2_md5 $packagesbz2_size" >> Release
echo " $packagesxz_md5 $packagesxz_size" >> Release
echo " $packageszst_md5 $packageszst_size" >> Release
echo "SHA256:" >> Release
echo " $packages_sha256 $packages_size" >> Release
echo " $packagesgz_sha256 $packagesgz_size" >> Release
echo " $packagesbz2_sha256 $packagesbz2_size" >> Release
echo " $packagesxz_sha256 $packagesxz_size" >> Release
echo " $packageszst_sha256 $packageszst_size" >> Release
echo "$1" | gpg --batch --yes --pinentry-mode=loopback --passphrase-fd 0 -abs -u 3E2F176CBEFAA412AA1010CFDDA94DD278B5C270 -o Release.gpg Release
printf "[Repo] Action complete. You should see updates within the next 10 minutes.\n\n"
