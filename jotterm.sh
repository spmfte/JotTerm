#!/usr/bin/env bash

# Set up the config and themes directories
config_file="$HOME/.config/jotterm/config"
theme_dir="$HOME/.config/jotterm/themes"
mkdir -p "$(dirname "$config_file")"
mkdir -p "$theme_dir"

# Load the theme from the config file, or use the default theme
if [ -f "$config_file" ]; then
  source "$config_file"
else
  RED="\033[0;31m"
  GREEN="\033[0;32m"
  YELLOW="\033[0;33m"
  BLUE="\033[0;34m"
  MAGENTA="\033[0;35m"
  CYAN="\033[0;36m"
  RESET="\033[0m"
fi

notes_dir="$HOME/notes"
mkdir -p "$notes_dir"

# Function to list notes
list_notes() {
  echo -e "${CYAN}Your notes:${RESET}"
  for note in "$notes_dir"/*; do
    echo -e "${YELLOW}$(basename "$note")${RESET}"
    echo -e "$(cat "$note")"
    echo -e "------------------"
  done
}

display_help() {
  echo -e "${YELLOW}Commands:${RESET}"
  echo -e "  ${GREEN}n${RESET} ${CYAN}- 󰷫 Create new note${RESET}"
  echo -e "  ${GREEN}l${RESET} ${CYAN}-  List notes${RESET}"
  echo -e "  ${GREEN}e${RESET} ${CYAN}-  Edit note${RESET}"
  echo -e "  ${GREEN}d${RESET} ${CYAN}- 󰆴 Delete a note${RESET}"
  echo -e "  ${GREEN}q${RESET} ${CYAN}-  Quit${RESET}"
  echo -e "  ${GREEN}?${RESET} ${CYAN}- 󰋗 Show help menu${RESET}"
}
display_dashboard() {
  clear
  echo -e "${MAGENTA}$(toilet -f future -F border -t "JotTerm")${RESET}"
  echo ""
  display_help
}

# Main TUI loop
while true; do
  display_dashboard
  
  echo -en "${YELLOW}Enter command:${RESET} "
  read -e command

  case "$command" in
    n)
      echo -en "${MAGENTA}Enter the title of your note (optional):${RESET} "
      read -e note_title
      timestamp=$(date +"%Y-%m-%d_%H-%M")

      if [[ -n "$note_title" ]]; then
        note_file="$notes_dir/${note_title}.txt"
      else
        note_file="$notes_dir/${timestamp}.txt"
      fi

      echo -e "${YELLOW}Enter your note (Press Ctrl+D to save):${RESET}"
      cat > "$note_file"

      if [[ -n "$note_title" ]]; then
        echo -e "${GREEN}Note saved as: $note_title in $notes_dir${RESET}"
      else
        echo -e "${GREEN}Note saved with timestamp: $timestamp in $notes_dir${RESET}"
      fi
      ;;
    l)
      list_notes
      echo -e "${YELLOW}Press Enter to continue...${RESET}"
      read
      ;;
    e)
      echo -en "${YELLOW}Enter the title of the note you want to edit:${RESET} "
      read -e edit_title
      edit_file="$notes_dir/${edit_title}.txt"
      if [[ -f "$edit_file" ]]; then
        ${EDITOR:-vi} "$
        ${edit_file}"
echo -e "${GREEN}Note updated.${RESET}"
else
echo -e "${RED}Note not found.${RESET}"
fi
;;
d)
echo -en "${YELLOW}Enter the title of the note you want to delete:${RESET} "
read -e delete_title
delete_file="$notes_dir/${delete_title}.txt"
if [[ -f "$delete_file" ]]; then
rm "$delete_file"
echo -e "${RED}Note deleted.${RESET}"
else
echo -e "${RED}Note not found.${RESET}"
fi
;;
q)
echo -e "${YELLOW}Goodbye!${RESET}"
exit 0
;;
?)
;;
*)
echo -e "${RED}Invalid command.${RESET}"
;;
esac
echo -e "${YELLOW}Press Enter to continue...${RESET}"
read
done

