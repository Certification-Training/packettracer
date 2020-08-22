#!/bin/bash
#
#Baixando e desempacotando o arquivo .deb
#
echo "Downloading: PacketTracer_731_amd64.deb..." && curl --progress-bar --remote-name --location "http://cs3.calstatela.edu/~egean/cs4471/software/Cisco%20Packet%20Tracer%207.3.1/PacketTracer_731_amd64.deb"
DIR="/tmp/PacketTracer/"
if [ -d "$DIR" ]; then
	rm -rf "$DIR"
else
	mkdir /tmp/PacketTracer/
fi
cp PacketTracer_731_amd64.deb /tmp/PacketTracer/
cd /tmp/PacketTracer/
ar -xv PacketTracer_731_amd64.deb
mkdir control
tar -C control -Jxf control.tar.xz
mkdir data
tar -C data -Jxf data.tar.xz
cd data
#
#Remove a instalação atual do PacketTracer (geralmente instalado em /opt/pt)
#
rm -rf /opt/pt
rm -rf /usr/share/applications/cisco-pt7.desktop
rm -rf /usr/share/applications/cisco-ptsa7.desktop
rm -rf /usr/share/icons/hicolor/48x48/apps/pt7.png
#
#Copia arquivos do PacketTracer
#
cp -r usr /
cp -r opt /
#
#Link simbólico para uma biblioteca necessária
#
ln -s /usr/lib64/libdouble-conversion.so.3.1.5 /usr/lib64/libdouble-conversion.so.1
#
#Atualiza o ícone e a associação de arquivos
#
xdg-desktop-menu install /usr/share/applications/cisco-pt7.desktop
xdg-desktop-menu install /usr/share/applications/cisco-ptsa7.desktop
update-mime-database /usr/share/mime
gtk-update-icon-cache --force --ignore-theme-index /usr/share/icons/gnome
xdg-mime default cisco-ptsa7.desktop x-scheme-handler/pttp
#
#Link simbólico para PacketTracer
#
ln -sf /opt/pt/packettracer /usr/local/bin/packettracer
#
#Configura variáveis de ambiente
#
cat << "EOF">> /etc/profile.local
PT7HOME=/opt/pt
export PT7HOME
QT_DEVICE_PIXEL_RATIO=auto
export QT_DEVICE_PIXEL_RATIO
EOF
#
#Remove arquivos utilizados durante a instalação
#
rm -rf /tmp/PacketTracerInst/
#
#Sai do script
echo ""
echo "Aperte <ENTER> para continuar..."
echo ""
read 
echo "Bye!Bye!"
echo ""
echo ""
