This Ansible project contains all the configuration needed to run my public VPS server, running Ubuntu stable.

This playbook will be ran only on one SSH host, which should be defined in Ansible "hosts" file.

The main file "playbook.yml" should always include all the roles defined in "roles" folder.

When writing tasks, do not use fully qualified task names, in other words, skip "ansible.builtin" and other such prefixes. Never run any Ansible commands, only write files. When writing YAML files, do not add extra indentation to lists - keep them at the same level.
