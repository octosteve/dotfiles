local function gbrowse_commit(branch)
    -- Default to the current branch if none is provided
    if branch == nil or branch == "" then
        branch = vim.fn.system('git rev-parse --abbrev-ref HEAD'):gsub('%s+', '')
    end

    -- Get the latest commit hash on the specified branch
    local commit = vim.fn.system('git rev-parse ' .. branch):gsub('%s+', '')

    -- Get the current file path
    local file = vim.fn.expand('%')

    -- Get the starting and ending line numbers for range selection
    local start_line, end_line
    local mode = vim.fn.mode()
    if mode == 'v' or mode == 'V' or mode == '' then
        start_line = vim.fn.line('v')
        end_line = vim.fn.line('.')
        if start_line > end_line then
            start_line, end_line = end_line, start_line
        end
    else
        start_line = vim.fn.line("'<")
        end_line = vim.fn.line("'>")
        if start_line == 0 or end_line == 0 then
            start_line = vim.fn.line('.')
            end_line = start_line
        end
    end

    -- Get the GitHub repository URL
    local repo = vim.fn.system('git config --get remote.origin.url')
    repo = repo:gsub('git@github.com:', 'https://github.com/')
    repo = repo:gsub('%.git', ''):gsub('%s+', '')

    -- Construct the GitHub URL
    local url
    if start_line == end_line then
        url = string.format('%s/blob/%s/%s#L%d', repo, commit, file, start_line)
    else
        url = string.format('%s/blob/%s/%s#L%d-L%d', repo, commit, file, start_line, end_line)
    end

    -- Copy the URL to the clipboard
    vim.fn.setreg('+', url)
    print('Copied to clipboard: ' .. url)
end

-- Create a command to call the function
vim.api.nvim_create_user_command('GBrowseCommit', function(opts)
    gbrowse_commit(opts.args)
end, { nargs = '?', range = true })
