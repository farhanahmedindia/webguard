# Copyright 2025 Farhan Ahmed
# Licensed under the Apache License, Version 2.0
# See LICENSE file for details

ip_info() {
  whois "$1" | grep -Ei "OrgName|Country|origin"
}
