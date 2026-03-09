# vim: ft=yaml
machine:
  install:
    disk: /dev/sda
    image: ${installer_image}
  kubelet:
    nodeIP:
      validSubnets:
        - ${node_subnet}
    extraMounts:
      - destination: /var/mnt/longhorn
        type: bind
        source: /var/mnt/longhorn
        options:
          - bind
          - rshared
          - rw
---
apiVersion: v1alpha1
kind: UserVolumeConfig
name: longhorn
provisioning:
  diskSelector:
    match: disk.size >= 100u * GiB && !system_disk
  grow: false
