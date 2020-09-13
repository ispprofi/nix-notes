{ pkgs,
  nix-notes-version,
  additional-locations,
  ... }:
let
  gitcraft-version = "96bc18ade14dca67da208b0a739f955f611cc2d5";
  git-notes-version = "3475e6532ec9c967584183fec7d9aafb2151bd50";
  noteed-com-version = "ad49a825994be98f4cf2ad4c02bfa546027265df";
  gitcraft = pkgs.fetchFromGitHub {
    owner = "noteed";
    repo = "gitcraft";
    rev = gitcraft-version;
    sha256 = "17lggp9kf4j288zi71pp0rqbrjzhaqx56x4hbzx8hn04m982riag";
  };
  noteed-com = pkgs.fetchFromGitHub {
    owner = "noteed";
    repo = "noteed.com";
    rev = noteed-com-version;
    sha256 = "1yfkwzrchc8dhzzi8pxx7rsk8l72hv84p6n40rxam5hm8x5pn22q";
  };
  git-notes = pkgs.fetchFromGitHub {
    owner = "noteed";
    repo = "git-notes";
    rev = git-notes-version;
    sha256 = "1mx297l6q353934p1rqp8yc60yjhzd6kca5pjwv9m3hq18gbny7r";
  };
  nix-notes = import ../site {
    inherit
      nix-notes-version gitcraft-version git-notes-version
      noteed-com-version;
  };

in
rec {
  site = nix-notes.html.all;
  locations = {
    "/add".proxyPass = "http://127.0.0.1:8000";
    "/gitcraft/".alias = (import gitcraft {}).html.all + "/";
    "/git-notes/".alias = (import git-notes).site + "/";
    "/nix-notes/".alias = nix-notes.html.all + "/";
    "~ ^/version$" = {
      alias = nix-notes.html.version;
      extraConfig = ''default_type "text/html";'';
    };
    "/static/".alias = nix-notes.static + "/";
    "/".alias = (import ../../noteed.com {}).site + "/";
  } // additional-locations;
}
