P = function(v)
    print(vim.inspect(v))
    return v
end

-- Returns either 'edit', 'open', 'none'
ChooseFileAction = function(file)
    local common_text = require("config.common_types").list_text
    local common_nontext = require("config.common_types").list_nontext
    local common_block = require("config.common_types").list_block
    local ext = GetFileExt(file)
    if Contains(common_text, ext) == true then
        return "edit"
    elseif Contains(common_nontext, ext) == true then
        return "open"
    elseif Contains(common_block, ext) == true then
        vim.notify("Extension " .. ext .. " is blocked for open.", "warn", { title = "File action chooser." })
        return "none"
    end

    local handle = io.popen("file -b --mime-type " .. file .. " | sed 's|/.*||'")
    if handle == nil then
        vim.notify("Could not check file mimetype.", "warn", { title = "File action chooser." })
        return "none"
    end
    local output = handle:read("*a")
    local mimetype = string.gsub(output, "%s+", "")
    handle:close()
    if mimetype == "text" or mimetype == "inode" then
        -- vim.notify("Don't forget to add '" .. ext .. "' to common text types.", "warn", { title = "File action chooser." })
        return "edit"
    elseif mimetype == "image" then
        return "open"
    else
        vim.notify("not opening mimetype: " .. mimetype, "warn", { title = "File picker" })
        return "none"
    end
end

NotifySend = function(title, msg)
    require("plenary.job")
        :new({
            command = "notify-send",
            args = { "-a", title, msg },
            cwd = vim.fn.getcwd(),
        })
        :start()
end

SmartCommit = function()
    vim.cmd(":mark A")
    require("plenary.job")
        :new({
            command = "git",
            args = { "smart-prep" },
            cwd = vim.fn.getcwd(),
            on_exit = function(j, return_val)
                if return_val == 111 then
                elseif return_val ~= 0 then
                    vim.defer_fn(function()
                        NotifySend("git", "Failed preparing smart commit")
                    end, 20)
                else
                    vim.defer_fn(function()
                        vim.cmd(":Git commit -q --status")
                    end, 50)
                end
            end,
        })
        :start()
end

GitPushAsyncNotify = function()
    require("plenary.job")
        :new({
            command = "gitx",
            args = { "rapid-push" },
            cwd = vim.fn.getcwd(),
        })
        :start()
end

GitFetchMainBranch = function()
    require("plenary.job")
        :new({
            command = "git",
            args = { "fetch-main-safe" },
            cwd = vim.fn.getcwd(),
            on_exit = function(j, return_val)
                if return_val ~= 0 then
                    vim.defer_fn(function()
                        NotifySend("git", "Failed fetching default branch!")
                    end, 0)
                end
            end,
        })
        :start()
end

function FileExists(name)
    local stat = vim.loop.fs_stat(name)
    return stat and stat.type == "file"
end

function DeleteBuffersWithoutFile()
    local bufnrs = vim.tbl_filter(function(bufnr)
        if 1 ~= vim.fn.buflisted(bufnr) then
            return false
        end

        local bufname = vim.api.nvim_buf_get_name(bufnr)

        return true
    end, vim.api.nvim_list_bufs())

    if not next(bufnrs) then
        return
    end

    local buffers = {}
    local default_selection_idx = 1
    for _, bufnr in ipairs(bufnrs) do
        local flag = bufnr == vim.fn.bufnr("") and "%" or (bufnr == vim.fn.bufnr("#") and "#" or " ")

        local element = {
            bufnr = bufnr,
            flag = flag,
            info = vim.fn.getbufinfo(bufnr)[1],
        }

        local idx = ((buffers[1] ~= nil and buffers[1].flag == "%") and 2 or 1)
        table.insert(buffers, idx, element)
    end

    -- P(buffers)

    for k, v in pairs(buffers) do
        if not FileExists(v.info.name) then
            NotifySend("nvim: deleted buffer", v.info.name)
            require("bufdelete").bufdelete(v.bufnr)
        end
    end
end
