inputs: {
  imports = [
    (import ../../configs/stylix { inherit inputs; })
    (import ../../configs/matugen { inherit inputs; })
  ];
}
