# Socket

Socket is a duo of Ansible playbooks which, together with multiple Ruby scripts, gather and save data relating to the working state of all WordPress plugins.

![Socket](socket.webp)

## Prerequisites

Variables declared in a defaults/main.yaml file:

- PRODPATH: Path to the wordpress production server installation.
- TESTPATH: Path to the wordpress test server installation.
- PROD: WordPress production server root domain.
- TEST: WordPress test server root domain.
- GIT: Local path to the git repository.

```console
- name: Create a list of WordPress plugins
  hosts: chimera
  vars_files: ../defaults/main.yaml
  gather_facts: false
  ignore_errors: true
  tasks:
    - name: Build a complete list of plugins organzied by site
      tags: granular
      block:
        - name: Compile the per site plugin list
          ansible.builtin.script:
            cmd: "{{ GIT }}plugins/report.rb {{ TESTPATH }} active"

        - name: Fix empty Plugin field at bcgov-opengraph
          ansible.builtin.replace:
            path: site-active-plugins.yaml
            regexp: '  - Plugin: bcgov-opengraph\n    Version: '
            replace: '  - Plugin: bcgov-opengraph\n    Version: 1.8.0'
            mode: '0644'

        - name: Download the site-active-plugins.yaml file
          ansible.builtin.fetch:
            src: plugins/site-active-plugins.yaml
            dest: "{{ GIT }}results/"
            flat: true
            mode: '0644'
```

## Run

Navigate to the folder containing the yaml file *active.yaml* and (dependent on the location of your inventory file) run:

```console
ansible-playbook -i ~/inventory.yaml active.yaml
```

## Output

Output will produce three files. A simple text list of all active plugins (*active-plugins-list.txt*), a yaml file (*domain-active-plugins.yaml*) which will include both the name and current version of all active plugins, and a final yaml file (*site-active-plugins.yaml*). This last file will sort the active plugins by site, showing a detailed breakdown of who is using what plugins.

## License

Code is distributed under [The Unlicense](https://github.com/nausicaan/free/blob/main/LICENSE.md) and is part of the Public Domain.