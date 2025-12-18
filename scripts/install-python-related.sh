#!/bin/bash

curl -fsSL https://pyenv.run | bash

eval "$(pyenv init -bash)"
eval "$(pyenv virtualenv-init -bash)"