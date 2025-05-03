-- ~/.config/nvim/lua/core/utils.lua
-- Utility functions for AstraVim

-- Log errors to a file with timestamps
local function log_error(msg)
  local log_file = vim.fn.stdpath("cache") .. "/logs/astra_errors.log"
  local timestamp = os.date("%Y-%m-%d %H:%M:%S")
  local stack_trace = debug.traceback("", 2)
  local log_msg = string.format("[%s] %s\n%s\n", timestamp, msg, stack_trace)
  local file = io.open(log_file, "a")
  if file then
    file:write(log_msg)
    file:close()
  end
 end
  
  -- Get system stats (CPU and memory usage)
  local function get_system_stats()
    local stats = { cpu = "N/A", mem = "N/A" }
    local is_windows = vim.loop.os_uname().sysname:match("Windows")
    local ok, result = pcall(function()
      if is_windows then
        local wmic_cpu = vim.fn.systemlist("wmic cpu get loadpercentage")
        for _, line in ipairs(wmic_cpu) do
          local percent = line:match("^%d+$")
          if percent then
            stats.cpu = percent .. "%"
            break
          end
        end
        local wmic_mem = vim.fn.systemlist("wmic os get freephysicalmemory,totalvisiblememorysize")
        local free, total
        for _, line in ipairs(wmic_mem) do
          if line:match("^%d+$") then
            if not free then
              free = tonumber(line) / 1024
            else
              total = tonumber(line) / 1024
            end
          end
        end
        if free and total then
          stats.mem = string.format("%.1f/%.1f GB", total - free, total)
        end
      else
        local cpu = vim.fn.systemlist("top -bn1 2>/dev/null")
        for _, line in ipairs(cpu) do
          if line:match("%%Cpu") then
            local cpu_idle = line:match("(%d+%.%d+)%s+id")
            stats.cpu = cpu_idle and string.format("%.1f%%", 100 - tonumber(cpu_idle)) or "N/A"
            break
          end
        end
        local mem = vim.fn.systemlist("free -h 2>/dev/null")
        for _, line in ipairs(mem) do
          if line:match("Mem:") then
            stats.mem = line:match("Mem:%s+%S+%s+(%S+)") or "N/A"
            break
          end
        end
      end
    end)
    if not ok then
      log_error("Failed to get system stats: " .. result)
    end
    return stats
  end
  
  -- Expose functions to global scope
  _G.log_error = log_error
  _G.get_system_stats = get_system_stats