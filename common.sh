apt-get update
apt-get upgrade -y
apt-get install vim git curl ssh cowsay -y
PATH="$PATH:/usr/games"
export PATH
ln -s  /usr/share/cowsay/cows/default.cow  /usr/share/cowsay/cows/small.cow
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl