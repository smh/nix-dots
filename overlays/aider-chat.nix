final: prev: {
  aider-chat = prev.aider-chat.overrideAttrs (oldAttrs: {
    version = "0.65.0";
    src = prev.fetchFromGitHub (oldAttrs.src // {
      rev = "refs/tags/v0.65.0";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    });
  });
}
