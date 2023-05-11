# Rapid Recovery Agent Installation Script

This script is used to install and configure the Rapid Recovery Agent on a Debian-based system. It ensures that the necessary dependencies and firewall settings are in place for the agent to function correctly.
## Prerequisites

- The script must be run with administrative privileges (root).
- The user specified as user_to_check must already exist on the system.

## Usage

- Ensure that the agent_pkg variable is set to the correct file name of the Rapid Recovery Agent package in the deb format.
- Set the user_to_check variable to the username of the protected user.
- Specify the desired ports for the Rapid Recovery Agent in the rr_ports array.
- Run the script with administrative privileges.

```
sudo ./install_agent.sh
```

## Installation Steps

1. The script checks if it is running as root. If not, it displays a warning and exits.
2. It verifies if the protected user specified by user_to_check exists. If not, it displays an error message and exits.
3. If the Rapid Recovery Agent is not already installed, the script checks if it is available in the APT repository. If found, it installs the package using apt-get. If not found, it checks if the specified agent_pkg file exists and is in the deb format. If so, it installs the package using dpkg. If neither option is available, it displays an error message and exits.
4. If UFW (Uncomplicated Firewall) is not installed, the script installs it using the system's package manager (apt-get). If the package manager is not supported, it displays an error message and exits.
5. The script checks if the specified rr_ports are open in the firewall. If any port is not open, it opens it using ufw.
6. The script adds the specified user_to_check to the Recovery Group using the rapidrecovery-config command.
7. It installs all necessary kernel modules using the rapidrecovery-config command.
8. The script starts the Rapid Recovery Agent using the rapidrecovery-config command.

Please note that this script assumes a Debian-based system and may require modifications for other distributions.

Note: Make sure to review and modify the script according to your specific requirements before running it.
