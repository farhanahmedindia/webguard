# Copyright 2025 Farhan Ahmed
# Licensed under the Apache License, Version 2.0
# See LICENSE file for details

ip_info() {
  whois "$1" | grep -Ei "OrgName|Country|origin"
}

intel_lookup() {
  IP="$1"
  echo "IP Intelligence for $IP"
  whois "$IP" | grep -Ei 'country|org|netname|descr|origin' | head -n 15
}
