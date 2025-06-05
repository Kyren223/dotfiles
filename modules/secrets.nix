{ ... }: {

    sops = {
      defaultSopsFile = ./secrets.yaml;
      age.sshKeyPaths = [ "/home/kyren/.ssh/id_ed25519" ];
    };

}
