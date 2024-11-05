PS3='Please enter your choice to install Docker (3 to exit): ' # Prompt for the menu
options=("Debian" "Ubuntu" "Cancel") # Menu options

select opt in "${options[@]}"; do
    case $opt in
        "Debian")
            echo "You chose Debian. Running Debian-specific docker install"
            # Remove old versions
                        for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
                        # Add Docker's official GPG key:
                        sudo apt-get update
                        sudo apt-get install ca-certificates curl
                        sudo install -m 0755 -d /etc/apt/keyrings
                        sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
                        sudo chmod a+r /etc/apt/keyrings/docker.asc
                        # Add the repository to Apt sources:
                        echo \
                        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
                        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
                        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                        sudo apt-get update
                        # install latest version
                        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
                        docker -v
                        docker compose version
            break
            ;;
        "Ubuntu")
            echo "You chose Ubuntu. Running Ubuntu-specific docker install"
                        # Remove old versions
            for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
                        # Add Docker's official GPG key:
                        sudo apt-get update
                        sudo apt-get install ca-certificates curl
                        sudo install -m 0755 -d /etc/apt/keyrings
                        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
                        sudo chmod a+r /etc/apt/keyrings/docker.asc
                        # Add the repository to Apt sources:
                        echo \
                        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
                        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
                        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                        sudo apt-get update
                        # install latest version
                        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
                        docker -v
                        docker compose version
            break
            ;;
        "Cancel")
            echo "Exiting the script."
            break
            ;;
        *)
            echo "Invalid option. Please choose 1 for Debian, 2 for Ubuntu, or 3 to cancel."
            ;;
    esac
done
