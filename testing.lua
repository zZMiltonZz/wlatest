local pui = require("neverlose/pui")

local groups = {
    login = pui.create("Key login", 1)
}

login_info = {
    key_input = groups.login:input(""),
    key_info = groups.login:label("Enter the key of your bought version."),
}
