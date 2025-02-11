--------------------------------------  CORE  ---------------------------------------

ui.sidebar("Venture Loader")
local clipboard = require('neverlose/clipboard')
local pui = require("neverlose/pui")
local http = require("neverlose/http")
local key_user_map = {}
local blacklist_map = {}
local loader_funcs = {}


db.saved_login = type(db.saved_login) == "table" and db.saved_login or {
    LIVE = false,
    BETA = false,
    VIP = false,
    SECRET = false
}

-- Ensure all fields exist (for backward compatibility)
db.saved_login.LIVE = db.saved_login.LIVE or false
db.saved_login.BETA = db.saved_login.BETA or false
db.saved_login.VIP = db.saved_login.VIP or false
db.saved_login.SECRET = db.saved_login.SECRET or false

-- Now safely access the values
local LOGGED_IN_LIVE = db.saved_login.LIVE
local LOGGED_IN_BETA = db.saved_login.BETA
local LOGGED_IN_VIP = db.saved_login.VIP
local LOGGED_IN_SECRET = db.saved_login.SECRET

local groups = {
    login = pui.create("Key login", 1),
    info = pui.create("Info", 1),
    live = pui.create("Live Features", 2),
    beta = pui.create("Beta Features", 2),
    vip = pui.create("VIP Features", 2),
    secret = pui.create("Secret Features", 2)
}

function table.count(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end


LOGGED_IN_LIVE = false
LOGGED_IN_BETA = false
LOGGED_IN_VIP = false
LOGGED_IN_SECRET = false


--------------------------------------  BLACKLIST CHECKER  ---------------------------------------

local blacklisted = false
http.get("https://raw.githubusercontent.com/zZMiltonZz/Loader-data/refs/heads/main/blacklist.lua", function(success, response)
    if success and response.status == 200 then
        local body = response.body
        local currentUsername = common.get_username()


        for key, username in body:gmatch('%s*["\']?([%w_]+)["\']?%s*=%s*{%s*user%s*=%s*["\']([%w%.]+)["\']%s*}') do
            blacklist_map[key] = {
                user = username
            }
        end

        -- Kontrollera om currentUsername finns i blacklist_map
        for key, data in pairs(blacklist_map) do
            if data.user == currentUsername then
                blacklisted = true
                -- Gör ytterligare åtgärder om så önskas
            end
        end

        if not blacklisted then
            blacklisted = false
        end
    else
        print("Failed to load keys:", response and response.status or "no response")
    end
    
end)




--------------------------------------  KEY VERSION LIST  ---------------------------------------

http.get(
    "https://raw.githubusercontent.com/zZMiltonZz/Loader-data/main/Loader.lua",
    function(success, response)
        if success and response.status == 200 then
            for key, user, tier in response.body:gmatch('%s*["\']?([%w_]+)["\']?%s*=%s*{%s*user%s*=%s*["\']([%w%.]+)["\']%s*,%s*tier%s*=%s*["\'](%u+)["\']%s*}') do
                key_user_map[key] = {
                    user = user,
                    tier = tier
                }
            end
            print("Loaded", table.count(key_user_map), "keys from GitHub")
        else
            print("Failed to load keys:", response and response.status or "no response")
        end
    end
)




--------------------------------------  ENCRYPT & DECRYPT  ---------------------------------------


local function convert( chars, dist, inv )
  return string.char( ( string.byte( chars ) - 32 + ( inv and -dist or dist ) ) % 95 + 32 )
end
local function crypt(str,k,inv)
    local enc= "";
    for i=1,#str do
      if (#str-k[5] >= i or not inv) then
        for inc=0,3 do
          if (i%4 == inc) then
          enc = enc..convert(string.sub(str,i,i),k[inc+1],inv);
          break;
        end
      end
    end
  end
  if (not inv) then
    for i=1,k[5] do
      enc = enc..string.char(math.random(32,126));
    end
  end
  return enc;
end
local encryption_key = {29, 58, 93, 28, 27};
local str = ""
local stringtbl = {
  cutstring = "",
  enc_str = "",
  dec_str = ""
}
local crypted = crypt(str,encryption_key)
utils.execute_after(1, function()
print("")
print("Welcome To Venture Encryption & Decryption")
print("Write \"!encrypt [text]\" to encrypt text")
print("Write \"!decrypt [encryption]\" to decrypt text")
print("Write \"!imp_encrypt [text]\" to import the encrypted text to your clipboard")
print("Write \"!imp_decrypt [encryption]\" to import the decrypted text to your clipboard")
print("")
print("For Bigger Encryptions And Decryptions Use The Following Commands:")
print("[Note]: They Will Encrypt / Decrypt Your Clipboard")
print("!enc_huge")
print("!dec_huge")
end)
events.console_input:set(function(str)
  if string.find(str, "!encrypt") then cutstring = (string.sub(str, 10, 999)) enc_str = crypt(cutstring, encryption_key) print("Encryption Successfull! -> "..enc_str) end
  if string.find(str, "!decrypt") then cutstring = (string.sub(str, 10, 999)) dec_str = crypt(cutstring, encryption_key, true) print("Decryption Successfull! -> "..dec_str) end
  if string.find(str, "!imp_encrypt") then cutstring = (string.sub(str, 14, 999)) enc_str = crypt(cutstring, encryption_key) print("Encryption Imported!") clipboard.set(enc_str) end
  if string.find(str, "!imp_decrypt") then cutstring = (string.sub(str, 14, 999)) dec_str = crypt(cutstring, encryption_key, true) print("Decryption Imported!") clipboard.set(dec_str) end
  if string.find(str, "!enc_huge") then cutstring = clipboard.get() enc_str = crypt(cutstring, encryption_key) print("Encryption Imported!") clipboard.set(enc_str) end
  if string.find(str, "!dec_huge") then cutstring = clipboard.get() dec_str = crypt(cutstring, encryption_key, true) print("Decryption Imported!") clipboard.set(dec_str) end
end)





--------------------------------------  UI INTERFERANCE  ---------------------------------------

login_info = {
    key_input = groups.login:input(""),
    key_info = groups.login:label("Enter the key of your bought version."),
}

menu_items = {
    welcome = groups.info:label("User"),
    user_info = groups.info:button(common.get_username(), function() end, true),
    tier_info = groups.info:label("Build"),
    build_info = groups.info:button("", function() end, true),
    log_out = groups.info:button("Logout", function() end, true),
    preset_list = groups.info:list("", "<None>", "Live", "Beta", "Vip", "Secret"),
}


--------------------------------------  BLACKLIST CALLBACK  ---------------------------------------

loader_funcs.blacklist = function()
    if blacklisted then
        print("YOU ARE BLACKLISTED")
        common.unload_script()
    else
        return
    end
end



--------------------------------------  LOG-IN CALLBACK  ---------------------------------------

loader_funcs.register_key = function()
    
    local user_input = login_info.key_input:get()
    local decrypted_input = crypt(user_input, encryption_key, true)
    local current_user = common.get_username()
    local key_data = key_user_map[decrypted_input]
    if key_data and key_data.user == current_user then
        local tier = key_data.tier
        if tier == "LIVE" then
            LOGGED_IN_LIVE = true
            groups.live:visibility(true)
            menu_items.build_info:name("Live")
            ui.sidebar("Venture Live")
        elseif tier == "BETA" then
            LOGGED_IN_BETA = true
            groups.beta:visibility(true)
            menu_items.build_info:name("Beta")
            ui.sidebar("Venture Beta")
        elseif tier == "VIP" then
            LOGGED_IN_VIP = true
            groups.vip:visibility(true)
            menu_items.build_info:name("VIP")
            ui.sidebar("Venture VIP")
        elseif tier == "SECRET" then
            LOGGED_IN_SECRET = true
            groups.secret:visibility(true)
            menu_items.build_info:name("Secret")
            ui.sidebar("Venture Secret")
        end
    end

    -- Update visibility based on login state
    menu_items.preset_list:visibility(LOGGED_IN_LIVE or LOGGED_IN_BETA or LOGGED_IN_VIP or LOGGED_IN_SECRET)
    menu_items.log_out:visibility(LOGGED_IN_LIVE or LOGGED_IN_BETA or LOGGED_IN_VIP or LOGGED_IN_SECRET)
    menu_items.user_info:visibility(LOGGED_IN_LIVE or LOGGED_IN_BETA or LOGGED_IN_VIP or LOGGED_IN_SECRET)
    menu_items.tier_info:visibility(LOGGED_IN_LIVE or LOGGED_IN_BETA or LOGGED_IN_VIP or LOGGED_IN_SECRET)
    menu_items.build_info:visibility(LOGGED_IN_LIVE or LOGGED_IN_BETA or LOGGED_IN_VIP or LOGGED_IN_SECRET)
    menu_items.welcome:visibility(LOGGED_IN_LIVE or LOGGED_IN_BETA or LOGGED_IN_VIP or LOGGED_IN_SECRET)
    login_info.key_input:visibility(not (LOGGED_IN_LIVE or LOGGED_IN_BETA or LOGGED_IN_VIP or LOGGED_IN_SECRET))
    login_info.key_info:visibility(not (LOGGED_IN_LIVE or LOGGED_IN_BETA or LOGGED_IN_VIP or LOGGED_IN_SECRET))

    -- Update database states
    db.saved_login.LIVE = LOGGED_IN_LIVE
    db.saved_login.BETA = LOGGED_IN_BETA
    db.saved_login.VIP = LOGGED_IN_VIP
    db.saved_login.SECRET = LOGGED_IN_SECRET

end


--------------------------------------  LOG-OUT  ---------------------------------------

menu_items.log_out:set_callback(function()
    -- Nollställ login-status
    LOGGED_IN_LIVE = false
    LOGGED_IN_BETA = false
    LOGGED_IN_VIP = false
    LOGGED_IN_SECRET = false

    groups.live:visibility(false)
    groups.beta:visibility(false)
    groups.vip:visibility(false)
    groups.secret:visibility(false)
    groups.info:visibility(false)

    login_info.key_input:set("") 

    print("User has logged ut.")
    common.unload_script()
end)

--------------------------------------  PRESET - LIST  ---------------------------------------
events.render(function()
    if LOGGED_IN_LIVE then
    if menu_items.preset_list:get() == 2 then
        else
            menu_items.preset_list:set(1)
        end
    end
    if LOGGED_IN_BETA then
        if menu_items.preset_list:get() == 2 then
        elseif menu_items.preset_list:get() == 3 then
        elseif (menu_items.preset_list:get() == 4 or menu_items.preset_list:get() == 5) then
            menu_items.preset_list:set(1)
        end
    end
    if LOGGED_IN_VIP then
            if menu_items.preset_list:get() == 2 then
            elseif menu_items.preset_list:get() == 3 then
            elseif menu_items.preset_list:get() == 4 then
            elseif menu_items.preset_list:get() == 5 then
                menu_items.preset_list:set(1)
            end
    end
        if LOGGED_IN_SECRET then
            if menu_items.preset_list:get() == 2 then
            elseif menu_items.preset_list:get() == 3 then
            elseif menu_items.preset_list:get() == 4 then
            elseif menu_items.preset_list:get() == 5 then
            end
    end
end)

--------------------------------------  EVENT-HANDLERS  ---------------------------------------

events.render(function()
    loader_funcs.register_key()
    loader_funcs.blacklist()
end)
events.shutdown(function()
    db.saved_login.LIVE = LOGGED_IN_LIVE
    db.saved_login.BETA = LOGGED_IN_BETA
    db.saved_login.VIP = LOGGED_IN_VIP
    db.saved_login.SECRET = LOGGED_IN_SECRET
end)
