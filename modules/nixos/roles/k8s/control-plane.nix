{ ... }:

{
  services.kubernetes = {
    roles = [ "master" ];

    apiserver.securePort = 6443;
  };
}
