#! /bin/bash

cd {{ yt_dlp_output_path }}
yt-dlp {{ yt_dlp_extra_args | default('') }} --proxy=socks5://localhost:{{ autossh_socks_port}} $@
