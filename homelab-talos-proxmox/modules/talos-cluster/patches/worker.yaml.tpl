# vim: ft=yaml
machine:
  install:
    disk: /dev/sda
    image: ${installer_image}
  kubelet:
    nodeIP:
      validSubnets:
        - ${node_subnet}
