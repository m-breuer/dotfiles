# Install Cask Packages

apps=(
    notion
    miro
    zoom
    microsoft-teams
    google-chrome
    visual-studio-code
    iterm2
    docker
    postman
    chatgpt
    meetingbar
    slack
    alfred
    battery
    monitorcontrol
    ollama
)

brew install "${apps[@]}" --cask