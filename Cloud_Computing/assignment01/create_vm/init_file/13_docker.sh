#### Set up Docker's apt repository.
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


# To install the latest version, run:
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify that the installation is successful by running the hello-world image:
# sudo docker run hello-world


########################
# generate a dockerfile for generating docker image used for executing the benchmark.sh
##########################

# Define the dockerfile name
SCRIPT_NAME="/tmp/Dockerfile"

# Write the benchmark script to the file
cat << 'EOF' > $SCRIPT_NAME
# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set environment variable to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install essential tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    coreutils \
    time \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /benchmark

# Copy the benchmark script into the container
COPY benchmark.sh /benchmark/benchmark.sh

# Ensure the script is executable
RUN chmod +x /benchmark/benchmark.sh

# Set the script as the default command
CMD ["/benchmark/benchmark.sh"]
EOF

# Make the script executable
sudo chmod +x $SCRIPT_NAME
echo "Script '$SCRIPT_NAME' has been created and made executable."

# Build the Docker image:
sudo docker build -t benchmark-container /tmp/.

#Run the container
sudo docker run --rm benchmark-container