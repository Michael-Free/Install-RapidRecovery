
## file name of deb
agent_pkg = "rapidrecovery-repo-6.7.0.387-debian8-x86_64.deb"
# Username for protected user
user_to_check="myuser"
# Ports for the RapidRecovery Agent
rr_ports = ("8006" "8009")

# Checking to see if this script is running as root.
if [[ $(id -u) -ne 0 ]]; then
    echo "Warning: You do not have admin privileges. Exiting."
    exit 1
fi

# Checking to see if the protected user exists.
if ! id -u "$user_to_check" &>/dev/null; then
    echo "User '$user_to_check' does not exist. Exiting."
    exit 1
fi

if ! dpkg-query -W -f='${Status}' rapidrecovery-agent 2>/dev/null | grep -q "ok installed"; then
    echo "Rapid Recovery Agent not installed. Checking APT repository."
    
    if apt-cache show rapidrecovery-agent &>/dev/null; then
        echo "Package found in APT repository. Installing."
        apt-get update
        apt-get install -y rapidrecovery-agent
    elif [[ -f "$agent_pkg" && "$agent_pkg" == *.deb ]]; then
        echo "Installing .deb package: $agent_pkg"
        dpkg -i "$agent_pkg"
        apt-get update
        apt-get install -y rapidrecovery-agent
    else
        echo "Error: rapidrecovery-agent package not found in APT repository or as a .deb file. Exiting."
        exit 1
    fi

    echo "Rapid Recovery Agent installed successfully."
else
    echo "Rapid Recovery Agent is already installed."
fi

# Check to see if UFW is installed (Requirement for RapidRecovery Agent)
if ! command -v ufw &> /dev/null; then
    echo "UFW not found. Installing UFW."
    
    if command -v apt-get &> /dev/null; then
        apt-get update
        apt-get install -y ufw
        ufw enable
    else
        echo "Error: Package manager not supported. Exiting."
        exit 1
    fi

    echo "UFW installed successfully."
else
    echo "UFW is already installed."
fi

# Check to see if the ports are open on the firewall. If not, open them.
for port in "${rr_ports[@]}"; do
    ufw_status=$(ufw status numbered | grep -w "$port")

    if [[ -z "$ufw_status" ]]; then
        echo "Port $port is not open. Opening port $port."
        ufw allow "$port"
    else
        echo "Port $port is already open."
    fi
done

# Add user to Recovery Group
rapidrecovery-config -u $user_to_check &&

# Install all kernel modules
rapidrecovery-config -m all &&

# start agent
rapidrecovery-config -s
