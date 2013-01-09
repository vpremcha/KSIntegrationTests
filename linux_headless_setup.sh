#!/bin/bash

######### start firefox install
#GTK+ and Firefox for Amazon Linux
#Written by Joseph Lawson 2012-06-03
#http://joekiller.com
#Free to use but please credit
TARGET=/usr/local

function init()
{
export installroot=$TARGET/src
export workpath=$TARGET

# -------these libs must already exist...
#yum --assumeyes install make libjpeg-devel libpng-devel \
#libtiff-devel gcc libffi-devel gettext-devel libmpc-devel \
#libstdc++46-devel xauth gcc-c++ libtool libX11-devel \
#libXext-devel libXinerama-devel libXi-devel libxml2-devel \
#libXrender-devel libXrandr-devel libXt

mkdir -p $workpath
mkdir -p $installroot
cd $installroot
PKG_CONFIG_PATH="$workpath/lib/pkgconfig"
PATH=$workpath/bin:$PATH
export PKG_CONFIG_PATH PATH

bash -c "
cat << EOF > /etc/ld.so.conf.d/firefox.conf
$workpath/lib
$workpath/firefox
EOF
ldconfig
"
}

function finish()
{
     cd $workpath
     wget -r --no-parent --reject "index.html*" -nH --cut-dirs=7 http://releases.mozilla.org/pub/mozilla.org/firefox/releases/latest/linux-x86_64/en-US/
     tar xvf firefox*
     cd bin
     ln -s ../firefox/firefox
     ldconfig
}

function install()
{
     wget $1
     FILE=`basename $1`
     if [ ${FILE: -3} == ".xz" ]
        then tar xvfJ $FILE
        else tar xvf $FILE
     fi
SHORT=${FILE:0:4}*
     cd $SHORT
     ./configure --prefix=$workpath
     make
     make install
     ldconfig
     cd ..
}

init
install ftp://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.xz
install http://download.savannah.gnu.org/releases/freetype/freetype-2.4.9.tar.gz
install http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.9.0.tar.gz
install http://ftp.gnome.org/pub/gnome/sources/glib/2.32/glib-2.32.3.tar.xz
install http://cairographics.org/releases/pixman-0.26.0.tar.gz
install http://cairographics.org/releases/cairo-1.12.2.tar.xz
install http://ftp.gnome.org/pub/gnome/sources/pango/1.30/pango-1.30.0.tar.xz
install http://ftp.gnome.org/pub/gnome/sources/atk/2.4/atk-2.4.0.tar.xz
install http://ftp.gnome.org/pub/GNOME/sources/gdk-pixbuf/2.26/gdk-pixbuf-2.26.1.tar.xz
install http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.10.tar.xz
finish

######### end firefox install

######### install ruby

apt-get --yes update
 
apt-get --yes install ruby1.9.1 ruby1.9.1-dev \
  rubygems1.9.1 irb1.9.1 ri1.9.1 rdoc1.9.1 \
  build-essential libopenssl-ruby1.9.1 libssl-dev zlib1g-dev
 
#ln /usr/bin/gem1.9.1 /usr/bin/gem

######## end install ruby

gem install cucumber
gem install watir-webdriver
gem install headless
gem install rspec
apt-get --yes install git-core 
cd 
mkdir sambal_automation
cd sambal_automation
git clone git://github.com/rSmart/sambal.git







