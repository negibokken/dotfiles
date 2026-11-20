return {
  "f-person/git-blame.nvim",
  event = "LazyFile",
  opts = {
    enabled = true,
    schedule_event = "CursorHold",
    message_template = " <summary> • <date> • <author> • <<sha>>",
    date_format = "%m-%d-%Y %H:%M:%S",
    virtual_text_column = 1,
    ignored_filetypes = { "bigfile", "oil" },
  },
}
