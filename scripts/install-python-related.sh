#!/bin/bash

curl -fsSL https://pyenv.run | bash

echo 'eval "$(pyenv init -bash)"' >> ~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc