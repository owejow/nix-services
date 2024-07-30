{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "stripe-mock";
  version = "0.182.0";

  src = fetchFromGitHub {
    owner = "stripe";
    repo = "stripe-mock";
    rev = "v${version}";
    hash = "sha256-L91iGdhTennOn3a6OIwYOJ+yfUpwb8GB3DhlLpQfe9o=";
  };

  vendorHash = null;

  meta = with lib; {
    description =
      "stripe-mock is a mock HTTP server that responds like the real Stripe API.";
    homepage = "https://github.com/stripe/stripe-mock";
    license = licenses.mit;
    maintainers = [ ];
  };
}
