# vim: ft=yaml
machine:
  install:
    disk: /dev/sda
    image: ${installer_image}
  network:
    interfaces:
      - interface: eth0
        addresses:
          - ${node_ip}/${node_prefix}
        routes:
          - network: 0.0.0.0/0
            gateway: ${gateway_ip}
  kubelet:
    nodeIP:
      validSubnets:
        - ${node_subnet}
