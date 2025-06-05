{ ... }: {

    sops = {
      defaultSopsFile = ./secrets.yaml;
      age.sshKeyPaths = [ "/home/kyren/.ssh/sops_id_ed25519" ];
    };

}
