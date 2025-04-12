-- Insert Week Number Plugin
-- This plugin inserts the current week number (Week-X) when pressing alt+w

local M = {}

-- Calculate the week number of the current date
local function get_week_number()
    local current_date = os.date("*t")
    local first_day = os.time({
        year = current_date.year,
        month = 1,
        day = 1
    })
    local first_date = os.date("*t", first_day)

    -- Adjust for the first week
    local adjustment = (first_date.wday - 1)
    local days_since_year_start = os.difftime(os.time(current_date), first_day) / (24 * 60 * 60)
    local week_number = math.floor((days_since_year_start + adjustment) / 7) + 1

    return string.format("Week-%d", week_number)
end

-- Function to insert the week number at cursor position
function M.insert_week_number()
    local week_text = get_week_number()
    local cmd = string.format("normal! a%s", week_text)
    vim.cmd(cmd)
end

-- Setup keymapping
function M.setup()
    -- Map Alt+w to insert week number in insert and normal mode
    vim.keymap.set('n', '<A-w>', M.insert_week_number, { noremap = true, silent = true })
    vim.keymap.set('i', '<A-w>', function()
        M.insert_week_number()
        -- Return to insert mode
        vim.cmd('startinsert!')
    end, { noremap = true, silent = true })
end

return M
