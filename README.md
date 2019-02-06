# Boring Stuff

#### Requirement:
  * Erlang/OTP 21.2.5
  * Elixir 1.7.3

#### Install Extendable version manager asdf
    $ git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.6.3
    # Bash on linux
    $ echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
    $ echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
    # OR for Mac OSX
    $ echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bash_profile
    $ echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bash_profile

#### Install wxWidgets (start observer or debugger!)
    OS X:
    $ brew install wxmac
    Linux:
    $ apt-get -y install libwxgtk3.0-dev libgl1-mesa-dev libglu1-mesa-dev libpng3

#### Install Erlang
    $ asdf plugin-add erlang
    $ asdf install erlang 21.2.5

#### Install Elixir
    $ asdf plugin-add elixir
    $ asdf install elixir 1.7.3

#### Install Hex
    $ mix local.hex

#### Running test 
    $ mix test
    $ mix test --stale --listen-on-stdin --trace --seed 0
    $ mix test.watch
    $ mix test.watch --stale --trace --seed 0
    $ mix cmd --app some_app mix test.watch 