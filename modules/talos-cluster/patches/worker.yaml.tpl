# vim: ft=yaml

machine:
  install:
    disk: ${install_disk}
    image: ${installer_image}
  kubelet:
    nodeIP:
      validSubnets:
        - ${node_subnet}
