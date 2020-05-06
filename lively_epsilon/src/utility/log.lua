local f = string.format

local function useAnsi()
    return (LivelyEpsilonConfig or {}).useAnsi or false
end

local function showDeprecations()
    return (LivelyEpsilonConfig or {}).logDeprecation or true
end

local function logLevel()
    local logLvl = (LivelyEpsilonConfig or {}).logLevel
    if isString(logLvl) then logLvl = logLvl:upper() end
    return logLvl
end

local function timestamp()
    if (LivelyEpsilonConfig or {}).logTime == true then
        return string.format("[%7.1f]", Cron.now())
    else
        return ""
    end
end

local red = "\u{001b}[41m\u{001b}[37m"
local yellow = "\u{001b}[33m"
local cyan = "\u{001b}[36m"
local grey = "\u{001b}[90;1m"
local magenta = "\u{001b}[95m"
local reset = "\u{001b}[0m"

logError = function (message)
    local logLvl = logLevel()
    if logLvl == nil or logLvl == "DEBUG" or logLvl == "INFO" or logLvl == "WARNING" or logLvl == "ERROR" then
        print(f("%s%s[ERROR] %s%s", timestamp(), useAnsi() and red or "", message, useAnsi() and reset or ""))
    end
end

logWarning = function (message)
    local logLvl = logLevel()
    if logLvl == nil or logLvl == "DEBUG" or logLvl == "INFO" or logLvl == "WARNING" then
        print(f("%s%s[WARN]  %s%s", timestamp(), useAnsi() and yellow or "", message, useAnsi() and reset or ""))
    end
end

logInfo = function (message)
    local logLvl = logLevel()
    if logLvl == nil or logLvl == "DEBUG" or logLvl == "INFO" then
        print(f("%s%s[INFO]  %s%s", timestamp(), useAnsi() and cyan or "", message, useAnsi() and reset or ""))
    end
end

logDebug = function (message)
    local logLvl = logLevel()
    if logLvl == nil or logLvl == "DEBUG" then
        print(f("%s%s[DEBUG] %s%s", timestamp(), useAnsi() and grey or "", message, useAnsi() and reset or ""))
    end
end

logDeprecation = function(message)
    if showDeprecations() then
        print(f("%s%s[DEPRECATION] %s%s", timestamp(), useAnsi() and magenta or "", message, useAnsi() and reset or ""))
    end
end
