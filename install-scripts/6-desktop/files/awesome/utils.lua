function debug_table(t)
    local str = ""
    for k, v in pairs(t) do
        str = str .. tostring(k) .. " " .. tostring(v) .. "\n"
    end
    naughty.notify({ text = str })
end