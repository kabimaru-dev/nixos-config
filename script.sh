# prepare
cd ~/nixos-config/ && git log --oneline -5

echo "Write your number of generation: "
read number_generation

# main command
sudo cp ~/nixos-config/configuration.nix /etc/nixos/ && sudo nixos-rebuild switch --show-trace && \
cd ~/nixos-config/ && git add . && git commit -m "NixOS - Generation #$number_generation" && git push --force-with-lease && \
git log --oneline -5