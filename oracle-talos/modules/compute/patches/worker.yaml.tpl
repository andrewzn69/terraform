# vim: ft=yaml
machine:
  certSANs:
    - ${load_balancer_ip}
  install:
    image: ${installer_image_url}
  kubelet:
    nodeIP:
      validSubnets:
        - ${subnet_cidr}
