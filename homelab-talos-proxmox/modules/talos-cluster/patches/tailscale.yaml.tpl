# vim: ft=yaml
apiVersion: v1alpha1
kind: ExtensionServiceConfig
name: tailscale
environment:
  - TS_AUTHKEY=${auth_key}
  - TS_ROUTES=${node_subnet}
