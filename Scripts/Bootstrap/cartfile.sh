#!/bin/sh

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --update) should_update=true; ;;
    --cache) cache_mode="${2}"; shift ;;
    *) echo "Unknown parameter passed: $1"; exit 1 ;;
  esac
  shift
done

readonly no_cache=0
readonly storage_cache=1
readonly aggressive_cache=2

if [ -z "${cache_mode}" ]; then
  cache_mode="${no_cache}"
fi

readonly script_path="$( cd "$( dirname "$0" )" && pwd )"

source "${script_path}/common.sh"
source "${helpers_path}/script-run.sh"

if [[ "$(uname -m)" == "arm64" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

eval "$(rbenv init -)"

readonly root_carthage_path="${root_path}/Carthage"
readonly root_cartfile_path="${root_path}/Cartfile"
readonly root_resolved_path="${root_path}/Cartfile.resolved"

readonly xcode_version=($(bundle exec xcversion selected 2> /dev/null | sed -n 's/Xcode \(.*\)/\1/p'))
readonly cache_version=($(sed -n 's/^# cache-version: //p' "${root_cartfile_path}"))

readonly cache_path="${HOME}/Library/Caches/ru.hh.ios/carthage-${xcode_version}-${cache_version}"
readonly cache_carthage_path="${cache_path}/Carthage"
readonly cache_cartfile_path="${cache_path}/Cartfile"
readonly cache_resolved_path="${cache_path}/Cartfile.resolved"

perform() {
  local command=$1

  assert_failure 'run carthage "${command}" --platform iOS --cache-builds --use-xcframeworks'
}

store_in_cache() {
  echo "Saving data in the cache..."

  if [ "${cache_mode}" -eq "${no_cache}" ];then
    rm -rf "${cache_path}"
  fi

  mkdir -p "${cache_path}"

  rsync -arW --compress-level=0 "${root_carthage_path}/" "${cache_carthage_path}" --delete
  rsync -arW --compress-level=0 "${root_cartfile_path}" "${cache_cartfile_path}"
  rsync -arW --compress-level=0 "${root_resolved_path}" "${cache_resolved_path}"

  echo "Finished."
}

restore_from_cache() {
  if [ "${cache_mode}" -eq "${no_cache}" ];then
    return
  fi

  if [ -d "${cache_carthage_path}" ]; then
    echo "Restoring frameworks from cache..."
    rsync -arW --compress-level=0 "${cache_carthage_path}/" "${root_carthage_path}"
  else
    echo "No suitable cache found."
  fi
}

install_if_needed() {
  cmp -s "${root_cartfile_path}" "${cache_cartfile_path}"
  local cartfile_result=$?

  cmp -s "${root_resolved_path}" "${cache_resolved_path}"
  local resolved_result=$?

  if [ ${cartfile_result} -eq 0 -a ${resolved_result} -eq 0 ]; then
    echo "    Frameworks already installed."
  else
    echo "    Executing 'carthage bootstrap', please wait..."

    assert_failure 'perform bootstrap'
    assert_warning 'store_in_cache'
  fi
}

if [ "${should_update}" ]; then
  echo "Updating ${carthage_style}Carthage frameworks${default_style} specified in Cartfile..."

  assert_warning 'restore_from_cache'

  echo "    Executing 'carthage update', please wait..."

  assert_failure 'perform update'
  assert_warning 'store_in_cache'
else
  echo "Installing ${carthage_style}Carthage frameworks${default_style} specified in Cartfile..."

  assert_warning 'restore_from_cache'

  if [ "${cache_mode}" -eq "${aggressive_cache}" ];then
    install_if_needed
  else
    echo "    Executing 'carthage bootstrap', please wait..."

    assert_failure 'perform bootstrap'
    assert_warning 'store_in_cache'
  fi
fi

echo ""
