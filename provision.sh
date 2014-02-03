#!/usr/bin/env bash
# Onorio Catenacci 31 January 2014
# Provision VM for Elixir

#Install Erlang
echo "Installing Erlang . . ."
readonly esl_package=erlang-solutions_1.0_all.deb
readonly home_dir=/home/vagrant 

curl -O "http://packages.erlang-solutions.com/$esl_package" >/dev/null 2>&1
dpkg -i "$esl_package" >/dev/null 2>&1

apt-get update >/dev/null 2>&1
apt-get install -y erlang >/dev/null 2>&1

#Install git
echo "Installing git . . . "
apt-get install -y git-core >/dev/null 2>&1

#Install vim
echo "Installing vim . . . "
apt-get install -y vim >/dev/null 2>&1

#Get and build the elixir source
echo "Getting elixir source and building it . . ."
readonly base_user_dir="/usr/bin"
readonly elixir_source_dir="$base_user_dir/elixir_0.12.2"
cd "$base_user_dir"
git clone https://github.com/elixir-lang/elixir.git >/dev/null 2>&1
mv elixir "$elixir_source_dir"
cd "$elixir_source_dir"
make clean test >/dev/null 2>&1

#Move the elixir command to the user bin dir
echo "Creating symbolic links for elixir scripts . . ."
for script in iex mix elixirc elixir
do
   ln -s "$elixir_source_dir"/bin/$script $base_user_dir/$script	
done

#Create the vim dirs for the elixir lang bindings and grab the binding files
readonly base_vim="$home_dir/.vim"
echo "Setting up VIM for syntax highlighting . . . "

#Create directories for vim syntax highlighting then fetch the files from github
#Credit where credit's due, one liner is from blog posting by Bruce Snyder
#http://bsnyderblog.blogspot.com/2012/12/vim-syntax-highlighting-for-scala-bash.html
mkdir "$base_vim" >/dev/null 2>&1
mkdir -p "$base_vim"/{ftdetect,indent,syntax} >/dev/null 2>&1

for d in ftdetect indent syntax ; do wget --no-check-certificate -O "$base_vim"/$d/elixir.vim https://raw.github.com/elixir-lang/vim-elixir/master/$d/elixir.vim; done >/dev/null 2>&1

rm "$home_dir"/"$esl_package"
