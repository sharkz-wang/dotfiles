function Invoke-BukuFzf {
    while ($true) {
        # buku -p -f 10 outputs tab-delimited format: index, url, title, tags, comment
        $selection = buku -p -f 40 | fzf `
            --delimiter="`t" `
            --preview="buku -p {1}" `
            --preview-window="down:4:wrap" `
            --header="[Esc] Exit | [Enter] Open in Default Browser" `
            --accept-nth 1 `
            --prompt="Buku> "

        # Exit loop if user presses Esc
        if (-not $selection) {
            break
        }

        # Extract URL (column 2)
        $url = ($selection -split "`t")[0]

        # Open in default Windows browser
        if ($url) {
            Start-Process chrome "--new-window $url"
        }
    }
}

Invoke-BukuFzf
