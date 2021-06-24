ssh_loc := "/home/$USER/.ssh/id_rsa"
n_cpu   := "$(($(grep -c ^processor /proc/cpuinfo)-2))"

all: base vim

base: 
    sudo apt-get install -qy git cmake build-essential gdebi gthumb apt-transport-https xclip gcc

vim: base
    sudo apt-get install -qy vim
    git clone https://github.com/contagon/.vim ~/.vim
    vim +'PlugInstall --sync' +qa

launcher: base
    curl -fLO https://glare.now.sh/TheAssassin/AppImageLauncher/amd64.deb
    sudo gdebi -n amd64.deb
    rm amd64.deb    
    mkdir -p ~/Applications

obsidian: launcher 
    curl -fLO https://glare.now.sh/obsidianmd/obsidian-releases/.AppImage
    mv .AppImage ~/Applications/Obsidian.AppImage

slack:
    wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.17.0-amd64.deb
    sudo gdebi -n slack*.deb
    rm slack*.deb

zoom:
    wget https://zoom.us/client/latest/zoom_amd64.deb
    sudo gdebi -n zoom*.deb
    rm zoom*.deb

zotero:
    wget -qO- https://github.com/retorquere/zotero-deb/releases/download/apt-get/install.sh | sudo bash
    sudo apt update
    sudo apt install -qy zotero

chrome:
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo gdebi -n google-chrome*.deb
    rm google-chrome*.deb

# From here: https://code.visualstudio.com/docs/setup/linux
vscode: base
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt update
    sudo apt install -qy code

# See here: https://stackoverflow.com/questions/38080407/how-can-i-install-the-latest-anaconda-with-wget
conda:
    #!/usr/bin/env bash
    wget -O - https://www.anaconda.com/distribution/ 2>/dev/null | sed -ne 's@.*\(https:\/\/repo\.anaconda\.com\/archive\/Anaconda3-.*-Linux-x86_64\.sh\)\">64-Bit (x86) Installer.*@\1@p' | xargs wget
    bash Anaconda3*.sh -b
    rm Anaconda3*.sh
    source ~/anaconda3/bin/activate
    conda init

syncthing: base
    curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
    echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
    sudo apt-get update
    sudo apt-get install syncthing
    sudo systemctl enable syncthing@$(whoami).service
    sudo systemctl start syncthing@$(whoami).service

docker: base
    sudo apt-get install ca-certificates gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -qy docker-ce docker-ce-cli containerd.io
    sudo usermod -aG docker $USER

drone:
    curl -L https://github.com/drone/drone-cli/releases/latest/download/drone_linux_amd64.tar.gz | tar zx
    sudo install -t /usr/local/bin drone
    rm drone

ssh: base
    #!/usr/bin/env bash
    ssh-keygen -t rsa -N "" -f {{ssh_loc}}
    eval `ssh-agent`
    ssh-add {{ssh_loc}}
    xclip -selection clipboard < {{ssh_loc}}.pub

### Optional ones that aren't ran by default

clone folder list:
    #!/usr/bin/env bash
    readarray array <<< $( cat {{list}} )
    mkdir -p {{folder}} && cd {{folder}}
    for element in ${array[@]}; do \
        echo "clonning $element"; \
        git clone $element; \
    done

unreal version folder="~/UnrealEngine":
    #!/usr/bin/env bash
    git clone --depth 1 git@github.com:EpicGames/UnrealEngine.git -b {{version}} {{folder}}.{{version}}
    cd {{folder}}.{{version}}
    bash Setup.sh
    bash GenerateProjectFiles.sh
    make -j{{n_cpu}}

code-server:
	curl -fsSL https://code-server.dev/install.sh | sh
	sudo systemctl enable --now code-server@$USER

font myfont="DejaVuSansMono":
    #!/usr/bin/env bash
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/{{myfont}}.zip 
    unzip {{myfont}}.zip -d ~/.fonts
    fc-cache -fv
    rm {{myfont}}.zip
