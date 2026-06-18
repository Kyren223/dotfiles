#!/bin/bash

SOURCE="$HOME"
TARGET="/iron-wolf/fedora-home"

# Desktop maybe
# repositories maybe
# data maybe
# .zen maybe

rsync -a --delete --info=progress2 \
  --exclude='.config/vesktop/sessionData/Cache/' \
  --exclude='.config/vesktop/sessionData/Code Cache/' \
  --exclude='.config/vesktop/sessionData/GPUCache/' \
  --exclude='.config/r2modman/Cache/' \
  --include='.config/***' \
  --include='.gnupg/***' \
  --include='.icons/***' \
  --include='.local/' \
  --include='.local/share/' \
  --include='.local/state/' \
  --include='.local/share/color-schemes/***' \
  --include='.local/share/containers/' \
  --include='.local/share/containers/storage/' \
  --include='.local/share/containers/storage/volumes/' \
  --include='.local/share/containers/storage/volumes/local-ai_open-webui/' \
  --exclude='.local/share/containers/storage/volumes/local-ai_open-webui/_data/cache/' \
  --include='.local/share/containers/storage/volumes/local-ai_open-webui/***' \
  --include='.local/share/eden/nand/user/save/***' \
  --include='.local/share/fonts/***' \
  --include='.local/share/imhex/***' \
  --include='.local/share/jellyfin/***' \
  --include='.local/share/k/***' \
  --include='.local/share/mime/***' \
  --include='.local/share/nvim/***' \
  --include='.local/share/osu/***' \
  --exclude='.local/share/PrismLauncher/cache/' \
  --include='.local/share/PrismLauncher/***' \
  --include='.local/share/StardewValley/***' \
  --exclude='.local/share/vicinae/clipboard-data/' \
  --exclude='.local/share/vicinae/file-indexer.db' \
  --include='.local/share/vicinae/***' \
  --include='.local/share/wallpapers/***' \
  --include='.local/share/zed/***' \
  --include='.local/share/zinit/***' \
  --include='.local/share/zoxide/***' \
  --include='.local/state/nvim/***' \
  --include='.nnd/***' \
  --include='.ssh/***' \
  --include='.var/' \
  --include='.var/app/' \
  --include='.var/app/com.hypixel.HytaleLauncher/' \
  --include='.var/app/com.hypixel.HytaleLauncher/data/' \
  --include='.var/app/com.hypixel.HytaleLauncher/data/Hytale/' \
  --include='.var/app/com.hypixel.HytaleLauncher/data/Hytale/UserData/' \
  --include='.var/app/com.hypixel.HytaleLauncher/data/Hytale/UserData/Saves/***' \
  --include='.var/app/org.jellyfin.JellyfinDesktop/***' \
  --include='.var/app/com.actualbudget.actual/***' \
  --include='.var/app/it.mijorus.gearlever/***' \
  --include='.var/app/io.github.diegopvlk.Cine/***' \
  --include='.var/app/com.vysp3r.ProtonPlus/***' \
  --include='.var/app/com.infinipaint.infinipaint/***' \
  --include='.wakatime/***' \
  --include='Ark-Vcs/***' \
  --include='Design/***' \
  --include='Games/' \
  --include='Games/Heroic/' \
  --include='Games/Heroic/Prefixes/' \
  --include='Games/Heroic/Prefixes/Slime Rancher/' \
  --include='Games/Heroic/Prefixes/Slime Rancher/drive_c/' \
  --include='Games/Heroic/Prefixes/Slime Rancher/drive_c/users/' \
  --include='Games/Heroic/Prefixes/Slime Rancher/drive_c/users/kyren/' \
  --include='Games/Heroic/Prefixes/Slime Rancher/drive_c/users/kyren/AppData/' \
  --include='Games/Heroic/Prefixes/Slime Rancher/drive_c/users/kyren/AppData/LocalLow/' \
  --include='Games/Heroic/Prefixes/Slime Rancher/drive_c/users/kyren/AppData/LocalLow/Monomi Park/' \
  --include='Games/Heroic/Prefixes/Slime Rancher/drive_c/users/kyren/AppData/LocalLow/Monomi Park/Slime Rancher/***' \
  --include='Games/minecraft-dungeons/' \
  --include='Games/minecraft-dungeons/drive_c/' \
  --include='Games/minecraft-dungeons/drive_c/users/' \
  --include='Games/minecraft-dungeons/drive_c/users/steamuser/' \
  --include='Games/minecraft-dungeons/drive_c/users/steamuser/Saved Games/' \
  --include='Games/minecraft-dungeons/drive_c/users/steamuser/Saved Games/Mojang Studios/' \
  --include='Games/minecraft-dungeons/drive_c/users/steamuser/Saved Games/Mojang Studios/Dungeons/***' \
  --exclude='personal/grimoire/' \
  --include='personal/***' \
  --include='.wakatime.cfg' \
  --include='.zsh_history' \
  --exclude='*' "$SOURCE"/ "$TARGET"/
