ip_info() {
  whois "$1" | grep -Ei "OrgName|Country|origin"
}
