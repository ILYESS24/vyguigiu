#!/bin/sh
set -eux

# This script is written to be as POSIX as possible
# so it works fine for all Unix-like operating systems

test_cmd() {
  command -v "$1" >/dev/null
}

# proxy version
aurion_ide_new_ver="${1}"
# proxy directory
# eval to resolve '~' into proper user dir
eval aurion_ide_dir="'${2}'"

case "${aurion_ide_new_ver}" in
  v*)
    aurion_ide_new_version=$(echo "${aurion_ide_new_ver}" | cut -d'v' -f2)
    aurion_ide_new_ver_tag="${aurion_ide_new_ver}"
  ;;
  nightly*)
    aurion_ide_new_version="${aurion_ide_new_ver}"
    aurion_ide_new_ver_tag=$(echo ${aurion_ide_new_ver} | cut -d '-' -f1)
  ;;
  *)
    printf 'Unknown version\n'
    exit 1
  ;;
esac

if [ -e "${aurion_ide_dir}/aurion-proxy" ]; then
  aurion_ide_installed_ver=$("${aurion_ide_dir}/aurion-proxy" --version | cut -d' ' -f2)

  printf '[DEBUG]: Current proxy version: %s\n' "${aurion_ide_installed_ver}"
  printf '[DEBUG]: New proxy version: %s\n' "${aurion_ide_new_version}"
  if [ "${aurion_ide_installed_ver}" = "${aurion_ide_new_version}" ]; then
    printf 'Proxy already exists\n'
    exit 0
  else
    printf 'Proxy outdated. Replacing proxy\n'
    rm "${aurion_ide_dir}/aurion-proxy"
  fi
fi

for _cmd in tar gzip uname; do
  if ! test_cmd "${_cmd}"; then
    printf 'Missing required command: %s\n' "${_cmd}"
    exit 1
  fi
done

# Currently only linux/darwin are supported
case $(uname -s) in
  Linux) os_name=linux ;;
  Darwin) os_name=darwin ;;
  *)
    printf '[ERROR] unsupported os\n'
    exit 1
  ;;
esac

# Currently only amd64/arm64 are supported
case $(uname -m) in
  x86_64|amd64|x64) arch_name=x86_64 ;;
  arm64|aarch64) arch_name=aarch64 ;;
  # riscv64) arch_name=riscv64 ;;
  *)
    printf '[ERROR] unsupported arch\n'
    exit 1
  ;;
esac

aurion_ide_download_url="https://github.com/aurion-ide/aurion-ide/releases/download/${aurion_ide_new_ver_tag}/aurion-proxy-${os_name}-${arch_name}.gz"

printf 'Creating "%s"\n' "${aurion_ide_dir}"
mkdir -p "${aurion_ide_dir}"
cd "${aurion_ide_dir}"

if test_cmd 'curl'; then
  # How old curl has these options? we'll find out
  printf 'Downloading using curl\n'
  curl --proto '=https' --tlsv1.2 -LfS -O "${aurion_ide_download_url}"
  # curl --proto '=https' --tlsv1.2 -LZfS -o "${tmp_dir}/aurion-proxy-${os_name}-${arch_name}.gz" "${aurion_ide_download_url}"
elif test_cmd 'wget'; then
  printf 'Downloading using wget\n'
  wget "${aurion_ide_download_url}"
else
  printf 'curl/wget not found, failed to download proxy\n'
  exit 1
fi

printf 'Decompressing gzip\n'
gzip -df "${aurion_ide_dir}/aurion-proxy-${os_name}-${arch_name}.gz"

printf 'Renaming proxy \n'
mv -v "${aurion_ide_dir}/aurion-proxy-${os_name}-${arch_name}" "${aurion_ide_dir}/aurion-proxy"

printf 'Making it executable\n'
chmod +x "${aurion_ide_dir}/aurion-proxy"

printf 'aurion-proxy installed\n'

exit 0



