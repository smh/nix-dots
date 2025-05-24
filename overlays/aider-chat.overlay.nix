final: prev:
prev.aider-chat.overrideAttrs (oldAttrs: {
  version = "0.65.1";
  src = prev.fetchFromGitHub {
    owner = "paul-gauthier";
    repo = "aider";
    rev = "refs/tags/v0.65.0";
    hash = "sha256-crQnkTOujflBcAAOY8rjgSEioM/9Vxud3UfgipJ07uA=";
  };
})
