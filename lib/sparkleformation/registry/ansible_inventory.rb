SfnRegistry.register(:ansible_inventory) do |_name|
join!(
"#!/usr/bin/python\n",
"# Meant to replace the /etc/ansible/hosts script on hosts and allow for\n",
"# local environment & role based ansible runs.\n",
"# Looks for variables in /etc/empire/seed by default\n\n",

"import sys\n",
"import os\n",
"import json\n\n",

"def main():\n",
"    inventory = {\"_meta\": {\"hostvars\": {}}}\n\n",

"    # Puts this host in the given HOSTGROUP\n",
"    try:\n",
"        host_group = os.environ.get(\"HOSTGROUP\", 'default')\n",
"        inventory[host_group] = [\"127.0.0.1\"]\n",
"    except KeyError:\n",
"        pass\n\n",

"    print json.dumps(inventory)\n\n",

"if __name__ == '__main__':\n",
"    sys.exit(main())\n",
)
end
