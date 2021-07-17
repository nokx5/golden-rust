{ rustPlatform, src }:


rustPlatform.buildRustPackage rec {
  pname = "golden-rust";
  version = "0.0.0";
  inherit src;

  cargoSha256 = "03wf9r2csi6jpa7v5sw5lpxkrk4wfzwmzx7k3991q3bdjzcwnnwp";
}
