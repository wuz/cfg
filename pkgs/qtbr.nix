pkgs: with pkgs; with mylib;
let root =
  if isDarwin
  then unpack qutebrowser.originalPackage.src
  else "${qutebrowser}/share/qutebrowser";
in
runBin name ''
  cat ${root}/scripts/open_url_in_instance.sh |
    sed 's/_url="$1"/_url="$\{1-about:blank}"/' |
    ${optionalString isDarwin "sed 's:_ipc_socket=.*:_ipc_socket=/tmp/qutebrowser-socket:' |"}
    sed 's/"$_qute_bin"/exec "$_qute_bin"/' |
    sed 's:^_qute_bin=.*:_qute_bin=${qutebrowser}/bin/qutebrowser:'
''
