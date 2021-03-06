#!/bin/bash

readonly BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE}/helpers.sh"
source "${BASE}/squeak/run.sh"

test_prepare_build() {
  $(squeak::prepare_build "GemStone" 2>/dev/null) \
      && fail "Should not be successful."
}

test_get_vm_details() {
  local vm_details
  local vm_filename
  local vm_path

  vm_details="$(squeak::get_vm_details "Linux" 1)"
  set_vars vm_filename vm_path "${vm_details}"
  assertEquals "cogspurlinux-15.33.3427.tgz" "${vm_filename}"
  assertEquals "${SMALLTALK_CI_VMS}/cogspurlinux/squeak" "${vm_path}"

  vm_details="$(squeak::get_vm_details "Linux" 0)"
  set_vars vm_filename vm_path "${vm_details}"
  assertEquals "coglinux-15.33.3427.tgz" "${vm_filename}"
  assertEquals "${SMALLTALK_CI_VMS}/coglinux/squeak" "${vm_path}"

  vm_details="$(squeak::get_vm_details "Darwin" 1)"
  set_vars vm_filename vm_path "${vm_details}"
  assertEquals "CogSpur.app-15.33.3427.tgz" "${vm_filename}"
  assertEquals "${SMALLTALK_CI_VMS}/CogSpur.app/Contents/MacOS/Squeak" \
      "${vm_path}"

  vm_details="$(squeak::get_vm_details "Darwin" 0)"
  set_vars vm_filename vm_path "${vm_details}"
  assertEquals "Cog.app-15.33.3427.tgz" "${vm_filename}"
  assertEquals "${SMALLTALK_CI_VMS}/Cog.app/Contents/MacOS/Squeak" "${vm_path}"

  set +e
  $(filename="$(squeak::get_vm_details "Linux" 2>/dev/null)") \
      || fail "Should be successful."
  $(filename="$(squeak::get_vm_details "" 2>/dev/null)") \
      && fail "Should not be successful."
  $(filename="$(squeak::get_vm_details "Windows" 2>/dev/null)") \
      && fail "Should not be successful."
  set -e
}

source "${BASE}/lib/shunit2"
