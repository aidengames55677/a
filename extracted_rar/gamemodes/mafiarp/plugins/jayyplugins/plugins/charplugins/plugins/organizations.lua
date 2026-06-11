local PLUGIN = PLUGIN

PLUGIN.name = "Organizations"
PLUGIN.author = "JayyKashtaCodes"
PLUGIN.desc = "Adds Organizations that players can create, join and manage."

-- Define the ranks
ranks = {"Associate", "Soldier", "Enforcer", "Captain", "Underboss"}

if SERVER then
    util.AddNetworkString("OrganizationMenu")

    -- Load organizations from file on server start
    organizations = {}
    if file.Exists("organizations.txt", "DATA") then
        organizations = util.JSONToTable(file.Read("organizations.txt", "DATA"))
    end

    -- Function to save organizations to file
    local function saveOrganizations()
        file.Write("organizations.txt", util.TableToJSON(organizations))
    end

    -- Function to create an organization
    function PLUGIN:createOrganization(name, leader)
        -- Check if the organization already exists
        if organizations[name] then
            return false, "An organization with this name already exists."
        end

        -- Create the new organization
        organizations[name] = {
            leader = leader,
            members = {},
            funds = 0
        }

        -- Save organizations after creating a new one
        saveOrganizations()

        return true
    end

    -- Function to join an organization
    function PLUGIN:joinOrganization(name, player)
        -- Check if the organization exists
        if not organizations[name] then
            return false, "The organization does not exist."
        end

        -- Add the player to the organization
        table.insert(organizations[name].members, player)

        -- Save organizations after a player joins
        saveOrganizations()

        return true
    end

    -- Function to leave an organization
    function PLUGIN:leaveOrganization(name, player)
        -- Check if the organization exists
        if not organizations[name] then
            return false, "The organization does not exist."
        end

        -- Remove the player from the organization
        for i, member in ipairs(organizations[name].members) do
            if member == player then
                table.remove(organizations[name].members, i)

                -- Save organizations after a player leaves
                saveOrganizations()

                return true
            end
        end

        return false, "The player is not a member of the organization."
    end

    -- Function to manage an organization (promote/demote members, etc.)
    function PLUGIN:manageOrganization(name, player, action, target)
        -- Check if the organization exists
        if not organizations[name] and action != "create" then
            return false, "The organization does not exist."
        end

        -- Check if the player is the leader of the organization
        if organizations[name] and organizations[name].leader != player and action != "create" then
            return false, "Only the leader can manage the organization."
        end

        -- Perform the requested action
        if action == "create" then
            -- Create a new organization
            local success, err = self:createOrganization(name, target) -- Use 'target' as the leader's name
            if not success then
                return false, err
            end
        end
        if action == "promote" then
            -- Promote the target player
            for i, rank in ipairs(ranks) do
                if organizations[name].members[target] == rank and i < #ranks then
                    organizations[name].members[target] = ranks[i + 1]
                    break
                end
            end
        elseif action == "demote" then
            -- Demote the target player
            for i, rank in ipairs(ranks) do
                if organizations[name].members[target] == rank and i > 1 then
                    organizations[name].members[target] = ranks[i - 1]
                    break
                end
            end
        elseif action == "appoint" then
            -- Appoint the target player as the new leader
            organizations[name].leader = target
        else
            return false, "Invalid action."
        end
        
        -- Save organizations after managing
        saveOrganizations()

        return true
    end

    -- Receive messages from the client
    net.Receive("OrganizationMenu", function(len, ply)
        local action = net.ReadString()
        local name = net.ReadString()
        local target = net.ReadString()

        PLUGIN:manageOrganization(name, ply, action, target)
    end)

end

if CLIENT then
    -- This function is called when the F1 menu is opened
    function PLUGIN:CreateMenuButtons(tabs)
        -- Add a new tab to the F1 menu
        tabs["Organizations"] = function(panel)
            -- Create a panel for the organization menu
            local orgPanel = vgui.Create("DPanel", panel)
            orgPanel:SetSize(500, 500)
            orgPanel:Dock(FILL) -- This will make the panel fill the parent

            -- Create a list view to display the organizations
            local orgList = vgui.Create("DListView", orgPanel)
            orgList:SetPos(50, 20)
            orgList:SetSize(400, 400)
            orgList:AddColumn("Organization")
            orgList:AddColumn("Members")
            orgList:AddColumn("Funds")

            -- Add each organization to the list view
            organizations = organizations or {}
            for _, org in pairs(organizations) do
                orgList:AddLine(org.name, #org.members, org.funds)
            end

            -- Add a line for creating an organization
            local createLine = orgList:AddLine("Create Organization")
            createLine.OnSelect = function()
                -- Open a new frame (popup) for creating an organization
                local createFrame = vgui.Create("DFrame")
                createFrame:SetSize(300, 300)
                createFrame:Center()
                createFrame:SetTitle("Create Organization")
                createFrame:MakePopup()
                
                -- Create a text entry for entering the organization's name
                local orgNameEntry = vgui.Create("DTextEntry", createFrame)
                orgNameEntry:SetPos(50, 50)
                orgNameEntry:SetSize(200, 20)
                orgNameEntry:SetText("Enter organization's name")

                -- Create a button for creating the organization
                local confirmButton = vgui.Create("DButton", createFrame)
                confirmButton:SetPos(50, 80)
                confirmButton:SetSize(200, 50)
                confirmButton:SetText("Create")
                confirmButton.DoClick = function()
                    -- Get the entered organization's name
                    local orgName = orgNameEntry:GetValue()

                    -- Send a message to the server with the organization's name
                    net.Start("OrganizationMenu")
                    net.WriteString("create")
                    net.WriteString(orgName)
                    net.WriteString(LocalPlayer():GetName()) -- Send the player's name as the leader
                    net.SendToServer()
                end
            end

            -- Create a button for managing the organization
            local manageButton = vgui.Create("DButton", orgPanel)
            manageButton:SetPos(50, 430)
            manageButton:SetSize(200, 50)
            manageButton:SetText("Manage Organization")
            manageButton.DoClick = function()
                -- Open a new frame (popup) for managing the organization
                local manageFrame = vgui.Create("DFrame")
                manageFrame:SetSize(300, 300)
                manageFrame:Center()
                manageFrame:SetTitle("Manage Organization")
                manageFrame:MakePopup()
                
                -- Create a combo box for selecting an action
                local actionComboBox = vgui.Create("DComboBox", manageFrame)
                actionComboBox:SetPos(50, 50)
                actionComboBox:SetSize(200, 20)
                actionComboBox:SetValue("Select an action")
                actionComboBox:AddChoice("Promote")
                actionComboBox:AddChoice("Demote")
                actionComboBox:AddChoice("Appoint")

                -- Create a text entry for entering the target player's name
                local targetEntry = vgui.Create("DTextEntry", manageFrame)
                targetEntry:SetPos(50, 80)
                targetEntry:SetSize(200, 20)
                targetEntry:SetText("Enter target player's name")

                -- Create a button for performing the action
                local performButton = vgui.Create("DButton", manageFrame)
                performButton:SetPos(50, 110)
                performButton:SetSize(200, 50)
                performButton:SetText("Perform Action")
                performButton.DoClick = function()
                    -- Get the selected action and target player's name
                    local action = actionComboBox:GetSelected()
                    local target = targetEntry:GetValue()

                    -- Send a message to the server with the action and target player's name
                    net.Start("OrganizationMenu")
                    net.WriteString(action)
                    net.WriteString(target)
                    net.SendToServer()
                end
            end
        end
    end
end
