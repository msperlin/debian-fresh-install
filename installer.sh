name_repo="debian-fresh-install"

sudo apt install git

cd "/home/$USER/Downloads"
rm -r -f $name_repo

git clone "git@github.com:msperlin/$name_repo.git"

cd debian-fresh-install

bash debian-setup-with-whiptail.sh

