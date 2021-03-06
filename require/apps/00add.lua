--添加词条

--去除字符串开头的空格
local function kickSpace(s)
    if type(s) ~= "string" then return end
    while s:sub(1,1) == " " do
        s = s:sub(2)
    end
    return s
end

return {--!add
check = function (data)--检查函数，拦截则返回true
    return (data.msg:find("！ *add *.+：.+") == 1 or data.msg:find("! *add *.+:.+") == 1)
    and not (data.msg:find("！ *addadmin *.+") == 1 or data.msg:find("! *addadmin *.+") == 1)
end,
run = function (data,sendMessage)--匹配后进行运行的函数
    if (XmlApi.Get("adminList",tostring(data.qq)) ~= "admin" or LuaEnvName == "private")
        and data.qq ~= Utils.setting.AdminQQ then
        sendMessage(Utils.CQCode_At(data.qq).."你不是狗管理，想成为狗管理请找我的主人呢")
        return true
    end
    local keyWord,answer = data.msg:match("！ *add *(.+)：(.+)")
    if not keyWord then keyWord,answer = data.msg:match("! *add *(.-):(.+)") end
    keyWord = kickSpace(keyWord)
    answer = kickSpace(answer)
    if not keyWord or not answer or keyWord:len() == 0 or answer:len() == 0 then
        sendMessage(Utils.CQCode_At(data.qq).."格式错误，请检查") return true
    end
    XmlApi.Add(tostring(LuaEnvName == "private" and "common" or data.group),keyWord,answer)
    sendMessage(Utils.CQCode_At(data.qq).."\r\n[CQ:emoji,id=9989]添加完成！\r\n"..
    "词条："..keyWord.."\r\n"..
    "回答："..answer)
    return true--返回true表示已被处理
end,
explain = function ()--功能解释，返回为字符串，若无需显示解释，返回nil即可
    return "[CQ:emoji,id=128227] !add关键词:回答"
end
}
